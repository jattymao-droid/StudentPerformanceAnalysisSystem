package com.ruoyi.spas.analysis;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
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
import com.ruoyi.spas.config.SpasAnalysisTuningProperties;
import com.ruoyi.spas.domain.SpasAnalysisScoreRow;
import com.ruoyi.spas.domain.SpasStudentKnowledgeStat;
import com.ruoyi.spas.domain.SpasSubject;
import com.ruoyi.spas.mapper.SpasAnalysisMapper;
import com.ruoyi.spas.mapper.SpasSubjectMapper;

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

    @Autowired(required = false)
    private SpasAnalysisTuningProperties tuningProperties;

    @Autowired(required = false)
    private SpasSubjectMapper subjectMapper;

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
     * Loads score rows in chunks (batch query) instead of one round-trip per student.
     */
    @Transactional
    public int recalculateByStudents(Collection<Long> studentIds, Long paperId)
    {
        if (studentIds == null || studentIds.isEmpty())
        {
            return 0;
        }
        clearEmpiricalCache();
        List<Long> ids = new ArrayList<Long>();
        Set<Long> seen = new HashSet<Long>();
        for (Long studentId : studentIds)
        {
            if (studentId == null || !seen.add(studentId))
            {
                continue;
            }
            ids.add(studentId);
        }
        if (ids.isEmpty())
        {
            return 0;
        }
        int upserted = 0;
        final int chunkSize = 200;
        for (int from = 0; from < ids.size(); from += chunkSize)
        {
            List<Long> chunk = ids.subList(from, Math.min(from + chunkSize, ids.size()));
            analysisMapper.deleteStatByStudents(chunk);
            List<SpasAnalysisScoreRow> allRows = analysisMapper.selectScoreRowsForRecalcByStudents(chunk);
            Map<Long, List<SpasAnalysisScoreRow>> byStudent = new HashMap<Long, List<SpasAnalysisScoreRow>>();
            if (allRows != null)
            {
                for (SpasAnalysisScoreRow row : allRows)
                {
                    if (row == null || row.getStudentId() == null)
                    {
                        continue;
                    }
                    List<SpasAnalysisScoreRow> list = byStudent.get(row.getStudentId());
                    if (list == null)
                    {
                        list = new ArrayList<SpasAnalysisScoreRow>();
                        byStudent.put(row.getStudentId(), list);
                    }
                    list.add(row);
                }
            }
            for (Long studentId : chunk)
            {
                List<SpasAnalysisScoreRow> rows = byStudent.get(studentId);
                Map<Long, Agg> aggMap = aggregate(rows);
                for (Agg agg : aggMap.values())
                {
                    SpasStudentKnowledgeStat stat = toStat(agg);
                    analysisMapper.upsertStat(stat);
                    upserted++;
                }
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
        boolean primaryFull = tuningProperties != null && tuningProperties.isPrimaryFullMode();
        Set<String> primaryKeys = primaryFull ? resolvePrimaryKeys(rows) : null;
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
            // primary-full: secondary KP only counts exposure (attempt), not mastery rate
            if (primaryFull && !isPrimaryContribution(row, primaryKeys))
            {
                if (row.getQuestionId() != null)
                {
                    agg.questionIds.add(row.getQuestionId());
                    agg.exposureOnlyCount++;
                }
                touchLastExam(agg, row);
                continue;
            }
            BigDecimal weight = row.getWeight() == null ? BigDecimal.ONE : row.getWeight();
            if (primaryFull)
            {
                // Primary contributes full rate (ignore fractional weight for mastery)
                weight = BigDecimal.ONE;
            }
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
            touchLastExam(agg, row);
        }
        return map;
    }

    private void touchLastExam(Agg agg, SpasAnalysisScoreRow row)
    {
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

    /**
     * Per student+question, primary knowledge = is_primary=1, else max weight.
     * Key = studentId + ':' + questionId + ':' + knowledgeId
     */
    private Set<String> resolvePrimaryKeys(List<SpasAnalysisScoreRow> rows)
    {
        Map<String, SpasAnalysisScoreRow> best = new HashMap<String, SpasAnalysisScoreRow>();
        for (SpasAnalysisScoreRow row : rows)
        {
            if (row.getStudentId() == null || row.getQuestionId() == null || row.getKnowledgeId() == null)
            {
                continue;
            }
            String qk = row.getStudentId() + ":" + row.getQuestionId();
            SpasAnalysisScoreRow cur = best.get(qk);
            if (cur == null)
            {
                best.put(qk, row);
                continue;
            }
            boolean rowPrimary = "1".equals(row.getIsPrimary());
            boolean curPrimary = "1".equals(cur.getIsPrimary());
            if (rowPrimary && !curPrimary)
            {
                best.put(qk, row);
            }
            else if (rowPrimary == curPrimary)
            {
                BigDecimal rw = row.getWeight() == null ? BigDecimal.ZERO : row.getWeight();
                BigDecimal cw = cur.getWeight() == null ? BigDecimal.ZERO : cur.getWeight();
                if (rw.compareTo(cw) > 0)
                {
                    best.put(qk, row);
                }
            }
        }
        Set<String> keys = new HashSet<String>();
        for (SpasAnalysisScoreRow row : best.values())
        {
            keys.add(row.getStudentId() + ":" + row.getQuestionId() + ":" + row.getKnowledgeId());
        }
        return keys;
    }

    private boolean isPrimaryContribution(SpasAnalysisScoreRow row, Set<String> primaryKeys)
    {
        if (row.getStudentId() == null || row.getQuestionId() == null || row.getKnowledgeId() == null)
        {
            return "1".equals(row.getIsPrimary());
        }
        return primaryKeys != null
            && primaryKeys.contains(row.getStudentId() + ":" + row.getQuestionId() + ":" + row.getKnowledgeId());
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
        // Exposure-only (primary-full secondary) must not produce formal weak grades
        if (agg.rateCount <= 0)
        {
            stat.setWeakLevel("0");
        }
        else
        {
            stat.setWeakLevel(resolveWeakLevel(weightedRate, attempts, agg.subjectId));
        }
        return stat;
    }

    public String resolveWeakLevel(BigDecimal rate, int attempts)
    {
        return resolveWeakLevel(rate, attempts, null);
    }

    public String resolveWeakLevel(BigDecimal rate, int attempts, Long subjectId)
    {
        ThresholdBundle t = thresholdsFor(subjectId);
        double r = rate == null ? 0D : rate.doubleValue();
        int severeMin = t.severeMinAttempts > 0 ? t.severeMinAttempts : t.minAttempts;
        if (r < t.severe && attempts >= severeMin)
        {
            return "3";
        }
        if (r < t.weak && attempts >= t.minAttempts)
        {
            return "2";
        }
        if (r < t.watch && attempts >= t.minAttempts)
        {
            return "1";
        }
        return "0";
    }

    public boolean belowWeakRate(BigDecimal rate)
    {
        return belowWeakRate(rate, null);
    }

    public boolean belowWeakRate(BigDecimal rate, Long subjectId)
    {
        double r = rate == null ? 0D : rate.doubleValue();
        return r < thresholdsFor(subjectId).weak;
    }

    public boolean belowSevereRate(BigDecimal rate)
    {
        return belowSevereRate(rate, null);
    }

    public boolean belowSevereRate(BigDecimal rate, Long subjectId)
    {
        double r = rate == null ? 0D : rate.doubleValue();
        return r < thresholdsFor(subjectId).severe;
    }

    /** Exposed for live weak-top evidence tagging (same threshold as snapshot). */
    public int resolveMinAttempts()
    {
        return resolveMinAttempts(null);
    }

    public int resolveMinAttempts(Long subjectId)
    {
        return Math.max(thresholdsFor(subjectId).minAttempts, 1);
    }

    public double resolveWeakThreshold()
    {
        return resolveWeakThreshold(null);
    }

    public double resolveWeakThreshold(Long subjectId)
    {
        return thresholdsFor(subjectId).weak;
    }

    public double resolveWatchThreshold()
    {
        return resolveWatchThreshold(null);
    }

    public double resolveWatchThreshold(Long subjectId)
    {
        return thresholdsFor(subjectId).watch;
    }

    public double resolveSevereThreshold()
    {
        return resolveSevereThreshold(null);
    }

    public double resolveSevereThreshold(Long subjectId)
    {
        return thresholdsFor(subjectId).severe;
    }

    public String resolveAllocationMode()
    {
        if (tuningProperties == null || tuningProperties.getAllocationMode() == null
            || tuningProperties.getAllocationMode().trim().isEmpty())
        {
            return "proportional";
        }
        return tuningProperties.getAllocationMode().trim();
    }

    private ThresholdBundle thresholdsFor(Long subjectId)
    {
        ThresholdBundle t = new ThresholdBundle();
        t.watch = watchThreshold;
        t.weak = weakThreshold;
        t.severe = severeThreshold;
        t.minAttempts = minAttempts;
        t.severeMinAttempts = severeMinAttempts;
        if (subjectId == null || tuningProperties == null || subjectMapper == null)
        {
            return t;
        }
        try
        {
            SpasSubject subject = subjectMapper.selectSpasSubjectById(subjectId);
            if (subject == null || subject.getSubjectCode() == null)
            {
                return t;
            }
            SpasAnalysisTuningProperties.ThresholdOverride o = tuningProperties.overrideFor(subject.getSubjectCode());
            if (o == null)
            {
                return t;
            }
            if (o.getWatch() != null)
            {
                t.watch = o.getWatch().doubleValue();
            }
            if (o.getWeak() != null)
            {
                t.weak = o.getWeak().doubleValue();
            }
            if (o.getSevere() != null)
            {
                t.severe = o.getSevere().doubleValue();
            }
            if (o.getMinAttempts() != null && o.getMinAttempts().intValue() > 0)
            {
                t.minAttempts = o.getMinAttempts().intValue();
            }
            if (o.getSevereMinAttempts() != null && o.getSevereMinAttempts().intValue() > 0)
            {
                t.severeMinAttempts = o.getSevereMinAttempts().intValue();
            }
        }
        catch (Exception ignored)
        {
        }
        return t;
    }

    private static class ThresholdBundle
    {
        double watch;
        double weak;
        double severe;
        int minAttempts;
        int severeMinAttempts;
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
        /** Attempts counted only as secondary exposure under primary-full mode. */
        int exposureOnlyCount = 0;
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
