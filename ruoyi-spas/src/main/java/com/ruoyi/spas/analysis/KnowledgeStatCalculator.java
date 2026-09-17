package com.ruoyi.spas.analysis;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.spas.domain.SpasAnalysisScoreRow;
import com.ruoyi.spas.domain.SpasStudentKnowledgeStat;
import com.ruoyi.spas.mapper.SpasAnalysisMapper;

/**
 * Multi-knowledge weighted rate calculator and snapshot writer.
 * sample_w = knowledge_weight × difficulty_w × recency_decay
 */
@Component
public class KnowledgeStatCalculator
{
    private static final ZoneId ZONE = ZoneId.of("Asia/Shanghai");

    @Autowired
    private SpasAnalysisMapper analysisMapper;

    @Value("${spas.analysis.difficulty-weight.easy:1.0}")
    private double difficultyEasy;

    @Value("${spas.analysis.difficulty-weight.medium:1.2}")
    private double difficultyMedium;

    @Value("${spas.analysis.difficulty-weight.hard:1.5}")
    private double difficultyHard;

    @Value("${spas.analysis.weak-thresholds.watch:0.75}")
    private double watchThreshold;

    @Value("${spas.analysis.weak-thresholds.weak:0.60}")
    private double weakThreshold;

    @Value("${spas.analysis.weak-thresholds.severe:0.45}")
    private double severeThreshold;

    @Value("${spas.analysis.weak-thresholds.min-attempts:3}")
    private int minAttempts;

    @Value("${spas.analysis.weak-thresholds.severe-min-attempts:3}")
    private int severeMinAttempts;

    @Value("${spas.analysis.recency-half-life-days:60}")
    private int recencyHalfLifeDays;

    @Value("${spas.analysis.rate-scale:6}")
    private int rateScale;

    @Transactional
    public int recalculateByPaper(Long paperId)
    {
        if (paperId == null)
        {
            return 0;
        }
        List<Long> studentIds = analysisMapper.selectStudentIdsByPaperId(paperId);
        return recalculateByStudents(studentIds, null);
    }

    @Transactional
    public int recalculateByStudent(Long studentId)
    {
        if (studentId == null)
        {
            return 0;
        }
        return recalculateByStudents(java.util.Collections.singletonList(studentId), null);
    }

    /**
     * Rebuild full knowledge snapshot per student.
     * paperId is ignored for load scope (always full history) to avoid wiping cross-paper stats.
     */
    @Transactional
    public int recalculateByStudents(Collection<Long> studentIds, Long paperId)
    {
        if (studentIds == null || studentIds.isEmpty())
        {
            return 0;
        }
        int upserted = 0;
        for (Long studentId : studentIds)
        {
            if (studentId == null)
            {
                continue;
            }
            analysisMapper.deleteStatByStudent(studentId);
            // Always full history — paperId filter would orphan other papers' knowledge stats
            List<SpasAnalysisScoreRow> rows = analysisMapper.selectScoreRowsForRecalc(studentId, null);
            Map<Long, Agg> aggMap = aggregate(rows);
            for (Agg agg : aggMap.values())
            {
                SpasStudentKnowledgeStat stat = toStat(agg);
                analysisMapper.upsertStat(stat);
                upserted++;
            }
        }
        return upserted;
    }

    private Map<Long, Agg> aggregate(List<SpasAnalysisScoreRow> rows)
    {
        Map<Long, Agg> map = new HashMap<Long, Agg>();
        if (rows == null)
        {
            return map;
        }
        LocalDate today = LocalDate.now(ZONE);
        for (SpasAnalysisScoreRow row : rows)
        {
            if (row.getKnowledgeId() == null || row.getStudentId() == null)
            {
                continue;
            }
            Agg agg = map.get(row.getKnowledgeId());
            if (agg == null)
            {
                agg = new Agg();
                agg.studentId = row.getStudentId();
                agg.knowledgeId = row.getKnowledgeId();
                agg.subjectId = row.getSubjectId();
                map.put(row.getKnowledgeId(), agg);
            }
            BigDecimal weight = row.getWeight() == null ? BigDecimal.ONE : row.getWeight();
            BigDecimal rate = row.getRate() == null ? BigDecimal.ZERO : row.getRate();
            double dw = difficultyWeight(row.getDifficulty());
            double recency = recencyFactor(row.getExamDate(), today);
            BigDecimal sampleW = weight.multiply(BigDecimal.valueOf(dw)).multiply(BigDecimal.valueOf(recency));
            agg.sumWeightedRate = agg.sumWeightedRate.add(rate.multiply(sampleW));
            agg.sumSampleW = agg.sumSampleW.add(sampleW);
            agg.sumRate = agg.sumRate.add(rate);
            agg.rateCount++;
            if (row.getQuestionId() != null)
            {
                agg.questionIds.add(row.getQuestionId());
            }
            if (row.getExamDate() != null
                && (agg.lastExamDate == null || row.getExamDate().after(agg.lastExamDate)))
            {
                agg.lastExamDate = row.getExamDate();
                agg.lastPaperId = row.getPaperId();
            }
            else if (agg.lastExamDate == null && row.getPaperId() != null)
            {
                agg.lastPaperId = row.getPaperId();
            }
        }
        return map;
    }

    private SpasStudentKnowledgeStat toStat(Agg agg)
    {
        SpasStudentKnowledgeStat stat = new SpasStudentKnowledgeStat();
        stat.setStudentId(agg.studentId);
        stat.setKnowledgeId(agg.knowledgeId);
        stat.setSubjectId(agg.subjectId);
        int attempts = agg.questionIds.size();
        stat.setAttemptCount(attempts);

        int scale = rateScale > 0 ? rateScale : 6;
        BigDecimal weightedRate = BigDecimal.ZERO;
        if (agg.sumSampleW.compareTo(BigDecimal.ZERO) > 0)
        {
            weightedRate = agg.sumWeightedRate.divide(agg.sumSampleW, scale, RoundingMode.HALF_UP);
        }
        BigDecimal avgRate = BigDecimal.ZERO;
        if (agg.rateCount > 0)
        {
            avgRate = agg.sumRate.divide(BigDecimal.valueOf(agg.rateCount), scale, RoundingMode.HALF_UP);
        }
        stat.setWeightedRate(weightedRate);
        stat.setAvgRate(avgRate);
        stat.setLastPaperId(agg.lastPaperId);
        stat.setLastExamDate(agg.lastExamDate);
        stat.setWeakLevel(resolveWeakLevel(weightedRate, attempts));
        return stat;
    }

    public String resolveWeakLevel(BigDecimal rate, int attempts)
    {
        double r = rate == null ? 0D : rate.doubleValue();
        int severeMin = severeMinAttempts > 0 ? severeMinAttempts : minAttempts;
        if (r < severeThreshold && attempts >= severeMin)
        {
            return "3";
        }
        if (r < weakThreshold && attempts >= minAttempts)
        {
            return "2";
        }
        if (r < watchThreshold && attempts >= minAttempts)
        {
            return "1";
        }
        return "0";
    }

    /** Confidence 0~1 based on attempt volume relative to min-attempts. */
    public BigDecimal confidence(int attempts)
    {
        int base = Math.max(minAttempts, 1);
        double c = 1.0 - (1.0 / (1.0 + (double) attempts / base));
        return BigDecimal.valueOf(c).setScale(4, RoundingMode.HALF_UP);
    }

    private double difficultyWeight(String difficulty)
    {
        if ("1".equals(difficulty))
        {
            return difficultyEasy;
        }
        if ("3".equals(difficulty))
        {
            return difficultyHard;
        }
        return difficultyMedium;
    }

    private double recencyFactor(Date examDate, LocalDate today)
    {
        if (recencyHalfLifeDays <= 0 || examDate == null)
        {
            return 1.0;
        }
        LocalDate exam = Instant.ofEpochMilli(examDate.getTime()).atZone(ZONE).toLocalDate();
        long days = ChronoUnit.DAYS.between(exam, today);
        if (days < 0)
        {
            days = 0;
        }
        return Math.pow(0.5, days / (double) recencyHalfLifeDays);
    }

    private static class Agg
    {
        Long studentId;
        Long knowledgeId;
        Long subjectId;
        BigDecimal sumWeightedRate = BigDecimal.ZERO;
        BigDecimal sumSampleW = BigDecimal.ZERO;
        BigDecimal sumRate = BigDecimal.ZERO;
        int rateCount = 0;
        Set<Long> questionIds = new HashSet<Long>();
        Long lastPaperId;
        Date lastExamDate;
    }
}
