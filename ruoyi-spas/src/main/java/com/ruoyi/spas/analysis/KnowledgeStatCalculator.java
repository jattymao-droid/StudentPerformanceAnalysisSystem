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

    @Value("${spas.analysis.difficulty-weight.empirical-enabled:true}")
    private boolean empiricalEnabled;

    @Value("${spas.analysis.difficulty-weight.empirical-min-students:8}")
    private int empiricalMinStudents;

    @Value("${spas.analysis.difficulty-weight.empirical-blend:0.5}")
    private double empiricalBlend;

    @Value("${spas.analysis.difficulty-weight.empirical-easy-rate:0.80}")
    private double empiricalEasyRate;

    @Value("${spas.analysis.difficulty-weight.empirical-hard-rate:0.40}")
    private double empiricalHardRate;

    /** questionId -> [avgRate, studentCount] */
    private volatile Map<Long, double[]> empiricalCache;

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

    /**
     * Recency as-of date strategy:
     * today = query day (may drift day-to-day);
     * max-exam = latest exam date in the row set (stable until new exam);
     * semester-end = current semester end date (stable within semester).
     */
    @Value("${spas.analysis.recency-anchor:today}")
    private String recencyAnchor;

    @Autowired(required = false)
    private com.ruoyi.spas.support.SpasAnalysisWindowHelper windowHelper;

    /** Request-scoped override: null=use config, 0=disable, >0=custom half-life days */
    private static final ThreadLocal<Integer> RECENCY_OVERRIDE = new ThreadLocal<>();

    public String getRecencyAnchor()
    {
        return recencyAnchor == null || recencyAnchor.trim().isEmpty() ? "today" : recencyAnchor.trim().toLowerCase();
    }

    public static void setRecencyOverride(Integer halfLifeDays)
    {
        if (halfLifeDays == null)
        {
            RECENCY_OVERRIDE.remove();
        }
        else
        {
            RECENCY_OVERRIDE.set(halfLifeDays);
        }
    }

    public static void clearRecencyOverride()
    {
        RECENCY_OVERRIDE.remove();
    }

    public int effectiveRecencyHalfLifeDays()
    {
        Integer ov = RECENCY_OVERRIDE.get();
        return ov != null ? ov.intValue() : recencyHalfLifeDays;
    }

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
        clearEmpiricalCache();
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
        LocalDate asOf = resolveRecencyAsOf(rows);
        for (SpasAnalysisScoreRow row : rows)
        {
            if (row.getKnowledgeId() == null || row.getStudentId() == null)
            {
                continue;
            }
            if (!com.ruoyi.spas.support.SpasScoreCellParser.countsTowardMastery(row.getScoreSource()))
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
                agg.knowledgeName = row.getKnowledgeName();
                map.put(row.getKnowledgeId(), agg);
            }
            if (agg.knowledgeName == null && row.getKnowledgeName() != null)
            {
                agg.knowledgeName = row.getKnowledgeName();
            }
            BigDecimal weight = row.getWeight() == null ? BigDecimal.ONE : row.getWeight();
            BigDecimal rate = row.getRate() == null ? BigDecimal.ZERO : row.getRate();
            double dw = difficultyWeight(row.getDifficulty(), row.getQuestionId());
            double recency = recencyFactor(row.getExamDate(), asOf);
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

    /** Public live aggregation for scoped queries (same formula as snapshot). */
    public Map<Long, AggView> aggregateViews(List<SpasAnalysisScoreRow> rows)
    {
        Map<Long, Agg> raw = aggregate(rows);
        Map<Long, AggView> views = new HashMap<Long, AggView>();
        for (Map.Entry<Long, Agg> e : raw.entrySet())
        {
            views.put(e.getKey(), AggView.from(e.getValue()));
        }
        return views;
    }

    public SpasStudentKnowledgeStat toStatView(AggView view)
    {
        Agg agg = new Agg();
        agg.studentId = view.studentId;
        agg.knowledgeId = view.knowledgeId;
        agg.subjectId = view.subjectId;
        agg.knowledgeName = view.knowledgeName;
        agg.sumWeightedRate = view.sumWeightedRate;
        agg.sumSampleW = view.sumSampleW;
        agg.sumRate = view.sumRate;
        agg.rateCount = view.rateCount;
        agg.questionIds = view.questionIds;
        agg.lastPaperId = view.lastPaperId;
        agg.lastExamDate = view.lastExamDate;
        return toStat(agg);
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

    public boolean belowWeakRate(BigDecimal rate)
    {
        double r = rate == null ? 0D : rate.doubleValue();
        return r < weakThreshold;
    }

    public boolean belowSevereRate(BigDecimal rate)
    {
        double r = rate == null ? 0D : rate.doubleValue();
        return r < severeThreshold;
    }

    /** Exposed for live weak-top evidence tagging (same threshold as snapshot). */
    public int resolveMinAttempts()
    {
        return Math.max(minAttempts, 1);
    }

    public double resolveWeakThreshold()
    {
        return weakThreshold;
    }

    public double resolveWatchThreshold()
    {
        return watchThreshold;
    }

    public double resolveSevereThreshold()
    {
        return severeThreshold;
    }

    /** Confidence 0~1 based on attempt volume relative to min-attempts. */
    public BigDecimal confidence(int attempts)
    {
        int base = Math.max(minAttempts, 1);
        double c = 1.0 - (1.0 / (1.0 + (double) attempts / base));
        return BigDecimal.valueOf(c).setScale(4, RoundingMode.HALF_UP);
    }

    public void clearEmpiricalCache()
    {
        empiricalCache = null;
    }

    private Map<Long, double[]> ensureEmpiricalCache()
    {
        Map<Long, double[]> cache = empiricalCache;
        if (cache != null)
        {
            return cache;
        }
        synchronized (this)
        {
            if (empiricalCache != null)
            {
                return empiricalCache;
            }
            Map<Long, double[]> map = new HashMap<Long, double[]>();
            List<Map<String, Object>> rows = analysisMapper.selectQuestionEmpiricalRates();
            if (rows != null)
            {
                for (Map<String, Object> row : rows)
                {
                    Object qid = row.get("questionId");
                    Object rate = row.get("avgRate");
                    Object cnt = row.get("studentCount");
                    if (qid == null || rate == null)
                    {
                        continue;
                    }
                    try
                    {
                        map.put(Long.valueOf(qid.toString()),
                            new double[] { Double.parseDouble(rate.toString()),
                                cnt == null ? 0.0 : Double.parseDouble(cnt.toString()) });
                    }
                    catch (Exception ignored)
                    {
                        // skip bad row
                    }
                }
            }
            empiricalCache = map;
            return map;
        }
    }

    private double difficultyWeight(String difficulty)
    {
        return difficultyWeight(difficulty, null);
    }

    private double difficultyWeight(String difficulty, Long questionId)
    {
        double tagged = taggedDifficultyWeight(difficulty);
        if (!empiricalEnabled || questionId == null || empiricalBlend <= 0)
        {
            return tagged;
        }
        double[] emp = ensureEmpiricalCache().get(questionId);
        if (emp == null || emp[1] < empiricalMinStudents)
        {
            return tagged;
        }
        double empirical = taggedDifficultyWeight(rateToDifficultyTier(emp[0]));
        double blend = Math.max(0.0, Math.min(1.0, empiricalBlend));
        return blend * empirical + (1.0 - blend) * tagged;
    }

    private String rateToDifficultyTier(double avgRate)
    {
        if (avgRate >= empiricalEasyRate)
        {
            return "1";
        }
        if (avgRate <= empiricalHardRate)
        {
            return "3";
        }
        return "2";
    }

    private double taggedDifficultyWeight(String difficulty)
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

    private LocalDate resolveRecencyAsOf(List<SpasAnalysisScoreRow> rows)
    {
        String mode = getRecencyAnchor();
        if ("semester-end".equals(mode) && windowHelper != null)
        {
            LocalDate end = windowHelper.resolveSemesterEnd(LocalDate.now(ZONE));
            if (end != null)
            {
                return end;
            }
        }
        if ("max-exam".equals(mode) || "semester-end".equals(mode))
        {
            Date max = null;
            if (rows != null)
            {
                for (SpasAnalysisScoreRow row : rows)
                {
                    if (row.getExamDate() != null && (max == null || row.getExamDate().after(max)))
                    {
                        max = row.getExamDate();
                    }
                }
            }
            if (max != null)
            {
                return Instant.ofEpochMilli(max.getTime()).atZone(ZONE).toLocalDate();
            }
        }
        return LocalDate.now(ZONE);
    }

    private double recencyFactor(Date examDate, LocalDate asOf)
    {
        int halfLife = effectiveRecencyHalfLifeDays();
        if (halfLife <= 0 || examDate == null)
        {
            return 1.0;
        }
        LocalDate exam = Instant.ofEpochMilli(examDate.getTime()).atZone(ZONE).toLocalDate();
        long days = ChronoUnit.DAYS.between(exam, asOf);
        if (days < 0)
        {
            days = 0;
        }
        return Math.pow(0.5, days / (double) halfLife);
    }

    private static class Agg
    {
        Long studentId;
        Long knowledgeId;
        Long subjectId;
        String knowledgeName;
        BigDecimal sumWeightedRate = BigDecimal.ZERO;
        BigDecimal sumSampleW = BigDecimal.ZERO;
        BigDecimal sumRate = BigDecimal.ZERO;
        int rateCount = 0;
        Set<Long> questionIds = new HashSet<Long>();
        Long lastPaperId;
        Date lastExamDate;
    }

    /** Read-only aggregate view for live query services. */
    public static class AggView
    {
        public Long studentId;
        public Long knowledgeId;
        public Long subjectId;
        public String knowledgeName;
        public BigDecimal sumWeightedRate = BigDecimal.ZERO;
        public BigDecimal sumSampleW = BigDecimal.ZERO;
        public BigDecimal sumRate = BigDecimal.ZERO;
        public int rateCount = 0;
        public Set<Long> questionIds = new HashSet<Long>();
        public Long lastPaperId;
        public Date lastExamDate;

        static AggView from(Agg agg)
        {
            AggView v = new AggView();
            v.studentId = agg.studentId;
            v.knowledgeId = agg.knowledgeId;
            v.subjectId = agg.subjectId;
            v.knowledgeName = agg.knowledgeName;
            v.sumWeightedRate = agg.sumWeightedRate;
            v.sumSampleW = agg.sumSampleW;
            v.sumRate = agg.sumRate;
            v.rateCount = agg.rateCount;
            v.questionIds = agg.questionIds;
            v.lastPaperId = agg.lastPaperId;
            v.lastExamDate = agg.lastExamDate;
            return v;
        }
    }
}
