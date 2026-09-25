package com.ruoyi.spas.analysis;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import com.ruoyi.spas.config.SpasAnalysisTuningProperties;
import com.ruoyi.spas.domain.SpasAnalysisScoreRow;
import com.ruoyi.spas.domain.SpasKnowledge;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.domain.SpasStudentKnowledgeStat;
import com.ruoyi.spas.mapper.SpasAnalysisMapper;
import com.ruoyi.spas.mapper.SpasKnowledgeMapper;
import com.ruoyi.spas.mapper.SpasStudentMapper;

/**
 * Live weighted knowledge aggregation for time-window / paper-set scopes.
 * Uses the same formula as {@link KnowledgeStatCalculator} snapshot writes.
 */
@Service
public class KnowledgeStatQueryService
{
    private static final String TAG_INSUFFICIENT = "\u6837\u672c\u4e0d\u8db3";
    private static final String TAG_PERSISTENT = "\u53cd\u590d\u8584\u5f31";
    private static final String TAG_SINGLE_DIP = "\u5355\u6b21\u63a2\u5e95";
    private static final String TAG_VOLATILE = "\u6ce2\u52a8\u578b";
    private static final String TAG_STABLE = "\u7a33\u5b9a";

    @Autowired
    private SpasAnalysisMapper analysisMapper;

    @Autowired
    private SpasStudentMapper studentMapper;

    @Autowired
    private SpasKnowledgeMapper knowledgeMapper;

    @Autowired
    private KnowledgeStatCalculator calculator;

    @Autowired(required = false)
    private SpasAnalysisTuningProperties tuningProperties;

    @Value("${spas.analysis.persistent-weak.min-papers:3}")
    private int persistMinPapers;

    @Value("${spas.analysis.persistent-weak.rate-threshold:0.60}")
    private double persistRateThreshold;

    @Value("${spas.analysis.persistent-weak.persist-ratio:0.67}")
    private double persistRatio;

    @Value("${spas.analysis.scope-max-papers:30}")
    private int scopeMaxPapers;

    public int getScopeMaxPapers()
    {
        return scopeMaxPapers > 0 ? scopeMaxPapers : 30;
    }

    public int getPersistMinPapers()
    {
        return persistMinPapers > 0 ? persistMinPapers : 3;
    }

    public double getPersistRateThreshold()
    {
        return persistRateThreshold;
    }

    public double getPersistRatio()
    {
        return persistRatio;
    }

    /**
     * Aggregate student knowledge stats for a scope. Empty paperIds + null from = full history (not written).
     */
    public List<SpasStudentKnowledgeStat> computeStudentStats(Long studentId, Long subjectId, Date examDateFrom,
        List<Long> paperIds)
    {
        List<SpasAnalysisScoreRow> rows = analysisMapper.selectScoreRowsForScope(studentId, subjectId, examDateFrom,
            paperIds, null, null);
        Map<Long, KnowledgeStatCalculator.AggView> map = calculator.aggregateViews(rows);
        List<SpasStudentKnowledgeStat> list = new ArrayList<SpasStudentKnowledgeStat>();
        for (KnowledgeStatCalculator.AggView agg : map.values())
        {
            list.add(calculator.toStatView(agg));
        }
        return list;
    }

    public List<Map<String, Object>> studentRadar(Long studentId, Long subjectId, Date examDateFrom,
        List<Long> paperIds)
    {
        List<SpasAnalysisScoreRow> rows = analysisMapper.selectScoreRowsForScope(studentId, subjectId, examDateFrom,
            paperIds, null, null);
        Map<Long, KnowledgeStatCalculator.AggView> map = calculator.aggregateViews(rows);
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        for (KnowledgeStatCalculator.AggView agg : map.values())
        {
            SpasStudentKnowledgeStat stat = calculator.toStatView(agg);
            Map<String, Object> row = new HashMap<String, Object>();
            row.put("knowledgeId", stat.getKnowledgeId());
            row.put("name", agg.knowledgeName);
            row.put("knowledgeName", agg.knowledgeName);
            row.put("rate", stat.getWeightedRate());
            row.put("weightedRate", stat.getWeightedRate());
            row.put("attemptCount", stat.getAttemptCount());
            row.put("weakLevel", stat.getWeakLevel());
            row.put("lastExamDate", stat.getLastExamDate());
            row.put("confidence", calculator.confidence(stat.getAttemptCount()));
            list.add(row);
        }
        attachClassKnowledgeAvg(list, studentId, subjectId, examDateFrom, paperIds);
        list.sort(Comparator.comparing(m -> String.valueOf(m.get("name") == null ? "" : m.get("name"))));
        return list;
    }

    /** Attach classAvgRate / gap per knowledge (same dept, same scope). */
    private void attachClassKnowledgeAvg(List<Map<String, Object>> radar, Long studentId, Long subjectId,
        Date examDateFrom, List<Long> paperIds)
    {
        if (radar == null || radar.isEmpty() || studentId == null)
        {
            return;
        }
        SpasStudent student = studentMapper.selectSpasStudentById(studentId);
        if (student == null || student.getDeptId() == null)
        {
            return;
        }
        List<SpasAnalysisScoreRow> classRows = analysisMapper.selectScoreRowsForScope(null, subjectId, examDateFrom,
            paperIds, student.getDeptId(), null);
        Map<Long, List<SpasAnalysisScoreRow>> byStudent = groupRowsByStudent(classRows);
        Map<Long, List<Double>> ratesByKid = new HashMap<Long, List<Double>>();
        for (List<SpasAnalysisScoreRow> studentRows : byStudent.values())
        {
            Map<Long, KnowledgeStatCalculator.AggView> map = calculator.aggregateViews(studentRows);
            for (KnowledgeStatCalculator.AggView agg : map.values())
            {
                SpasStudentKnowledgeStat stat = calculator.toStatView(agg);
                if (stat.getKnowledgeId() == null || stat.getWeightedRate() == null)
                {
                    continue;
                }
                List<Double> rates = ratesByKid.get(stat.getKnowledgeId());
                if (rates == null)
                {
                    rates = new ArrayList<Double>();
                    ratesByKid.put(stat.getKnowledgeId(), rates);
                }
                rates.add(stat.getWeightedRate().doubleValue());
            }
        }
        for (Map<String, Object> row : radar)
        {
            Long kid = toLong(row.get("knowledgeId"));
            List<Double> rates = kid == null ? null : ratesByKid.get(kid);
            if (rates == null || rates.isEmpty())
            {
                continue;
            }
            double sum = 0;
            for (Double d : rates)
            {
                sum += d.doubleValue();
            }
            BigDecimal classAvg = BigDecimal.valueOf(sum / rates.size()).setScale(6, RoundingMode.HALF_UP);
            row.put("classAvgRate", classAvg);
            Object rateObj = row.get("rate");
            if (rateObj != null)
            {
                try
                {
                    BigDecimal mine = new BigDecimal(String.valueOf(rateObj));
                    BigDecimal gap = mine.subtract(classAvg);
                    row.put("gap", gap);
                    annotateRelativeWeak(row, gap);
                }
                catch (Exception ignored)
                {
                }
            }
        }
    }

    /** Flag relativeWeak when student rate is materially below class avg. */
    public void annotateRelativeWeak(Map<String, Object> row, BigDecimal gap)
    {
        if (row == null)
        {
            return;
        }
        boolean enabled = tuningProperties == null || tuningProperties.getRelativeWeak() == null
            || tuningProperties.getRelativeWeak().isEnabled();
        double delta = tuningProperties == null || tuningProperties.getRelativeWeak() == null
            ? 0.10 : tuningProperties.getRelativeWeak().getDelta();
        if (delta <= 0)
        {
            delta = 0.10;
        }
        boolean relative = enabled && gap != null && gap.doubleValue() < -delta;
        row.put("relativeWeak", Boolean.valueOf(relative));
        if (relative)
        {
            row.put("relativeWeakDelta", gap);
            row.put("relativeWeakLabel", "\u4f4e\u4e8e\u73ed\u5747");
        }
    }

    private static Map<Long, List<SpasAnalysisScoreRow>> groupRowsByStudent(List<SpasAnalysisScoreRow> rows)
    {
        Map<Long, List<SpasAnalysisScoreRow>> byStudent = new HashMap<Long, List<SpasAnalysisScoreRow>>();
        if (rows == null)
        {
            return byStudent;
        }
        for (SpasAnalysisScoreRow row : rows)
        {
            if (row.getStudentId() == null)
            {
                continue;
            }
            List<SpasAnalysisScoreRow> g = byStudent.get(row.getStudentId());
            if (g == null)
            {
                g = new ArrayList<SpasAnalysisScoreRow>();
                byStudent.put(row.getStudentId(), g);
            }
            g.add(row);
        }
        return byStudent;
    }

    /**
     * Attempt-weighted overall rate (align with snapshot selectStudentSummary).
     * Fallback to simple mean when all attempt counts are 0.
     */
    private BigDecimal attemptWeightedOverall(Iterable<SpasStudentKnowledgeStat> stats)
    {
        BigDecimal sumWeighted = BigDecimal.ZERO;
        int sumAttempts = 0;
        BigDecimal sumRate = BigDecimal.ZERO;
        int rateN = 0;
        if (stats == null)
        {
            return null;
        }
        for (SpasStudentKnowledgeStat s : stats)
        {
            if (s == null || s.getWeightedRate() == null)
            {
                continue;
            }
            sumRate = sumRate.add(s.getWeightedRate());
            rateN++;
            int att = s.getAttemptCount() == null ? 0 : s.getAttemptCount().intValue();
            if (att > 0)
            {
                sumWeighted = sumWeighted.add(s.getWeightedRate().multiply(BigDecimal.valueOf(att)));
                sumAttempts += att;
            }
        }
        if (sumAttempts > 0)
        {
            return sumWeighted.divide(BigDecimal.valueOf(sumAttempts), 6, RoundingMode.HALF_UP);
        }
        if (rateN > 0)
        {
            return sumRate.divide(BigDecimal.valueOf(rateN), 6, RoundingMode.HALF_UP);
        }
        return null;
    }

    private BigDecimal attemptWeightedOverallFromAggs(Map<Long, KnowledgeStatCalculator.AggView> map)
    {
        List<SpasStudentKnowledgeStat> stats = new ArrayList<SpasStudentKnowledgeStat>();
        if (map != null)
        {
            for (KnowledgeStatCalculator.AggView agg : map.values())
            {
                stats.add(calculator.toStatView(agg));
            }
        }
        return attemptWeightedOverall(stats);
    }

    public List<Map<String, Object>> studentWeakTop(Long studentId, Long subjectId, int limit, Date examDateFrom,
        List<Long> paperIds)
    {
        List<Map<String, Object>> radar = studentRadar(studentId, subjectId, examDateFrom, paperIds);
        List<Map<String, Object>> formal = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> lowEvidence = new ArrayList<Map<String, Object>>();
        for (Map<String, Object> row : radar)
        {
            annotateEvidence(row);
            if (Boolean.TRUE.equals(row.get("formalWeak")))
            {
                formal.add(row);
            }
            else if (Boolean.FALSE.equals(row.get("evidenceOk"))
                && calculator.belowWeakRate(toDecimalOrNull(row.get("rate"))))
            {
                // 样本不足仅作「证据不足」候选，不定正式薄弱
                lowEvidence.add(row);
            }
        }
        Comparator<Map<String, Object>> byRate = (a, b) -> Double.compare(toDouble(a.get("rate")), toDouble(b.get("rate")));
        Comparator<Map<String, Object>> byRelativeThenRate = (a, b) -> {
            boolean ar = Boolean.TRUE.equals(a.get("relativeWeak"));
            boolean br = Boolean.TRUE.equals(b.get("relativeWeak"));
            if (ar != br)
            {
                return ar ? -1 : 1;
            }
            return byRate.compare(a, b);
        };
        formal.sort(byRelativeThenRate);
        lowEvidence.sort(byRate);
        List<Map<String, Object>> out = new ArrayList<Map<String, Object>>();
        out.addAll(formal);
        for (Map<String, Object> row : lowEvidence)
        {
            if (out.size() >= limit)
            {
                break;
            }
            out.add(row);
        }
        if (out.size() > limit)
        {
            return new ArrayList<Map<String, Object>>(out.subList(0, limit));
        }
        return out;
    }

    /** Mark formalWeak / evidenceOk on a radar/weak row. */
    public void annotateEvidence(Map<String, Object> row)
    {
        if (row == null)
        {
            return;
        }
        String wl = row.get("weakLevel") == null ? "0" : String.valueOf(row.get("weakLevel"));
        boolean formal = "1".equals(wl) || "2".equals(wl) || "3".equals(wl);
        int attempts = 0;
        Object att = row.get("attemptCount");
        if (att != null)
        {
            try
            {
                attempts = Integer.parseInt(att.toString());
            }
            catch (Exception ignored)
            {
            }
        }
        int min = calculator.resolveMinAttempts();
        boolean evidenceOk = attempts >= min;
        row.put("formalWeak", formal);
        row.put("evidenceOk", evidenceOk);
        if (!evidenceOk)
        {
            row.put("confidenceLabel", TAG_INSUFFICIENT);
        }
    }

    public Map<String, Object> studentSummary(Long studentId, Long subjectId, Date examDateFrom, List<Long> paperIds)
    {
        List<SpasAnalysisScoreRow> rows = analysisMapper.selectScoreRowsForScope(studentId, subjectId, examDateFrom,
            paperIds, null, null);
        Map<Long, KnowledgeStatCalculator.AggView> map = calculator.aggregateViews(rows);
        List<SpasStudentKnowledgeStat> stats = new ArrayList<SpasStudentKnowledgeStat>();
        if (map != null)
        {
            for (KnowledgeStatCalculator.AggView agg : map.values())
            {
                stats.add(calculator.toStatView(agg));
            }
        }
        Map<String, Object> summary = new HashMap<String, Object>();
        int knowledgeCount = stats.size();
        Set<Long> questionIds = new HashSet<Long>();
        if (rows != null)
        {
            for (SpasAnalysisScoreRow row : rows)
            {
                if (row.getQuestionId() != null)
                {
                    questionIds.add(row.getQuestionId());
                }
            }
        }
        int totalAttempts = questionIds.size();
        int weakCount = 0;
        int severeCount = 0;
        int watchCount = 0;
        int lowRateCount = 0;
        int lowSevereCount = 0;
        int thinSampleCount = 0;
        int minAttempts = calculator.resolveMinAttempts();
        Date lastExam = null;
        for (SpasStudentKnowledgeStat s : stats)
        {
            if ("3".equals(s.getWeakLevel()))
            {
                severeCount++;
            }
            else if ("2".equals(s.getWeakLevel()))
            {
                weakCount++;
            }
            else if ("1".equals(s.getWeakLevel()))
            {
                watchCount++;
            }
            int attempts = s.getAttemptCount() == null ? 0 : s.getAttemptCount();
            if (calculator.belowWeakRate(s.getWeightedRate()))
            {
                lowRateCount++;
                if (attempts < minAttempts)
                {
                    thinSampleCount++;
                }
            }
            if (calculator.belowSevereRate(s.getWeightedRate()))
            {
                lowSevereCount++;
            }
            if (s.getLastExamDate() != null && (lastExam == null || s.getLastExamDate().after(lastExam)))
            {
                lastExam = s.getLastExamDate();
            }
        }
        summary.put("knowledgeCount", knowledgeCount);
        summary.put("totalAttempts", totalAttempts);
        summary.put("weakCount", weakCount);
        summary.put("severeCount", severeCount);
        summary.put("watchCount", watchCount);
        summary.put("lowRateCount", lowRateCount);
        summary.put("lowSevereCount", lowSevereCount);
        summary.put("thinSampleCount", thinSampleCount);
        summary.put("lastExamDate", lastExam);
        BigDecimal avg = attemptWeightedOverall(stats);
        summary.put("avgRate", avg);
        summary.put("overallRate", avg);
        summary.put("confidence", calculator.confidence(totalAttempts));
        fillClassComparison(summary, studentId, subjectId, examDateFrom, paperIds, avg);
        return summary;
    }

    /**
     * Fill classAvgRate / gap / rankNo / classSize / percentile for live (window/paper) summaries,
     * matching snapshot SQL semantics in selectStudentSummary.
     */
    private void fillClassComparison(Map<String, Object> summary, Long studentId, Long subjectId,
        Date examDateFrom, List<Long> paperIds, BigDecimal myRate)
    {
        if (studentId == null)
        {
            return;
        }
        SpasStudent student = studentMapper.selectSpasStudentById(studentId);
        if (student == null || student.getDeptId() == null)
        {
            return;
        }
        List<SpasAnalysisScoreRow> rows = analysisMapper.selectScoreRowsForScope(null, subjectId, examDateFrom,
            paperIds, student.getDeptId(), null);
        Map<Long, List<SpasAnalysisScoreRow>> byStudent = groupRowsByStudent(rows);
        List<Map<String, Object>> peers = new ArrayList<Map<String, Object>>();
        for (Map.Entry<Long, List<SpasAnalysisScoreRow>> e : byStudent.entrySet())
        {
            Map<Long, KnowledgeStatCalculator.AggView> map = calculator.aggregateViews(e.getValue());
            BigDecimal rate = attemptWeightedOverallFromAggs(map);
            if (rate == null)
            {
                continue;
            }
            Map<String, Object> peer = new HashMap<String, Object>();
            peer.put("studentId", e.getKey());
            peer.put("overallRate", rate);
            peers.add(peer);
        }
        if (peers.isEmpty())
        {
            return;
        }
        peers.sort((a, b) -> Double.compare(toDouble(b.get("overallRate")), toDouble(a.get("overallRate"))));
        int classSize = peers.size();
        BigDecimal peerSum = BigDecimal.ZERO;
        int peerN = 0;
        int rankNo = 0;
        double prevRate = Double.NaN;
        int seen = 0;
        for (Map<String, Object> peer : peers)
        {
            Long sid = toLong(peer.get("studentId"));
            double rate = toDouble(peer.get("overallRate"));
            seen++;
            if (Double.isNaN(prevRate) || Math.abs(rate - prevRate) > 1e-9)
            {
                rankNo = seen;
                prevRate = rate;
            }
            if (sid != null && !sid.equals(studentId))
            {
                peerSum = peerSum.add((BigDecimal) peer.get("overallRate"));
                peerN++;
            }
            if (sid != null && sid.equals(studentId))
            {
                summary.put("rankNo", rankNo);
            }
        }
        if (!summary.containsKey("rankNo") && myRate != null)
        {
            // Student may have rate but no rows under dept filter edge cases — place by rate
            int insertRank = 1;
            for (Map<String, Object> peer : peers)
            {
                if (toDouble(peer.get("overallRate")) > myRate.doubleValue() + 1e-9)
                {
                    insertRank++;
                }
            }
            summary.put("rankNo", insertRank);
            if (!byStudent.containsKey(studentId))
            {
                classSize = classSize + 1;
            }
        }
        summary.put("classSize", classSize);
        if (peerN > 0)
        {
            BigDecimal classAvg = peerSum.divide(BigDecimal.valueOf(peerN), 6, RoundingMode.HALF_UP);
            summary.put("classAvgRate", classAvg);
            if (myRate != null)
            {
                summary.put("gap", myRate.subtract(classAvg));
            }
        }
        Object rankObj = summary.get("rankNo");
        if (rankObj != null && classSize > 1)
        {
            int r = ((Number) rankObj).intValue();
            BigDecimal pct = BigDecimal.valueOf(100.0 * (classSize - r) / (classSize - 1))
                .setScale(1, RoundingMode.HALF_UP);
            summary.put("percentile", pct);
        }
    }

    /**
     * Class weak top via live weighted aggregation (window or paper set).
     */
    public List<Map<String, Object>> classWeakTop(Long deptId, Long subjectId, int limit, Date examDateFrom,
        List<Long> paperIds)
    {
        List<SpasAnalysisScoreRow> rows = analysisMapper.selectScoreRowsForScope(null, subjectId, examDateFrom,
            paperIds, deptId, null);
        Map<Long, List<SpasAnalysisScoreRow>> byStudent = new HashMap<Long, List<SpasAnalysisScoreRow>>();
        for (SpasAnalysisScoreRow row : rows)
        {
            if (row.getStudentId() == null)
            {
                continue;
            }
            List<SpasAnalysisScoreRow> g = byStudent.get(row.getStudentId());
            if (g == null)
            {
                g = new ArrayList<SpasAnalysisScoreRow>();
                byStudent.put(row.getStudentId(), g);
            }
            g.add(row);
        }
        Map<Long, List<Double>> rateBucket = new HashMap<Long, List<Double>>();
        Map<Long, List<Integer>> attemptBucket = new HashMap<Long, List<Integer>>();
        Map<Long, String> nameMap = new HashMap<Long, String>();
        for (List<SpasAnalysisScoreRow> studentRows : byStudent.values())
        {
            Map<Long, KnowledgeStatCalculator.AggView> map = calculator.aggregateViews(studentRows);
            for (KnowledgeStatCalculator.AggView agg : map.values())
            {
                SpasStudentKnowledgeStat stat = calculator.toStatView(agg);
                Long kid = stat.getKnowledgeId();
                if (kid == null || stat.getWeightedRate() == null)
                {
                    continue;
                }
                List<Double> rates = rateBucket.get(kid);
                if (rates == null)
                {
                    rates = new ArrayList<Double>();
                    rateBucket.put(kid, rates);
                }
                rates.add(stat.getWeightedRate().doubleValue());
                List<Integer> atts = attemptBucket.get(kid);
                if (atts == null)
                {
                    atts = new ArrayList<Integer>();
                    attemptBucket.put(kid, atts);
                }
                atts.add(stat.getAttemptCount() == null ? 0 : stat.getAttemptCount().intValue());
                if (!nameMap.containsKey(kid) && agg.knowledgeName != null)
                {
                    nameMap.put(kid, agg.knowledgeName);
                }
            }
        }
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        for (Map.Entry<Long, List<Double>> e : rateBucket.entrySet())
        {
            List<Double> rates = e.getValue();
            double sum = 0;
            for (Double d : rates)
            {
                sum += d.doubleValue();
            }
            double avgRate = sum / rates.size();
            List<Integer> atts = attemptBucket.get(e.getKey());
            double attSum = 0;
            if (atts != null)
            {
                for (Integer n : atts)
                {
                    attSum += n.intValue();
                }
            }
            Map<String, Object> row = new HashMap<String, Object>();
            row.put("knowledgeId", e.getKey());
            row.put("name", nameMap.get(e.getKey()));
            row.put("knowledgeName", nameMap.get(e.getKey()));
            row.put("rate", BigDecimal.valueOf(avgRate).setScale(6, RoundingMode.HALF_UP));
            row.put("attemptCount", atts == null || atts.isEmpty() ? 0
                : BigDecimal.valueOf(attSum / atts.size()).setScale(2, RoundingMode.HALF_UP));
            row.put("studentCount", rates.size());
            list.add(row);
        }
        list.sort((a, b) -> Double.compare(toDouble(a.get("rate")), toDouble(b.get("rate"))));
        if (list.size() > limit)
        {
            return new ArrayList<Map<String, Object>>(list.subList(0, limit));
        }
        return list;
    }

    /**
     * Class average weighted rate per knowledge (same aggregation as classWeakTop, no limit).
     * Used for D5 prerequisite hints outside the weak-top slice.
     */
    public Map<Long, BigDecimal> classKnowledgeAvgRates(Long deptId, Long subjectId, Date examDateFrom,
        List<Long> paperIds)
    {
        List<Map<String, Object>> all = classWeakTop(deptId, subjectId, Integer.MAX_VALUE, examDateFrom, paperIds);
        Map<Long, BigDecimal> map = new HashMap<Long, BigDecimal>();
        if (all == null)
        {
            return map;
        }
        for (Map<String, Object> row : all)
        {
            Long kid = toLong(row.get("knowledgeId"));
            if (kid == null)
            {
                continue;
            }
            Object rate = row.get("rate");
            if (rate instanceof BigDecimal)
            {
                map.put(kid, (BigDecimal) rate);
            }
            else if (rate instanceof Number)
            {
                map.put(kid, BigDecimal.valueOf(((Number) rate).doubleValue()));
            }
        }
        return map;
    }

    public List<Map<String, Object>> knowledgeExamTrend(Long studentId, Long knowledgeId, Long subjectId,
        List<Long> paperIds, Date examDateFrom)
    {
        List<SpasAnalysisScoreRow> rows = analysisMapper.selectScoreRowsForScope(studentId, subjectId, examDateFrom,
            paperIds, null, knowledgeId);
        Map<String, List<SpasAnalysisScoreRow>> groups = new LinkedHashMap<String, List<SpasAnalysisScoreRow>>();
        for (SpasAnalysisScoreRow row : rows)
        {
            if (row.getPaperId() == null || row.getKnowledgeId() == null)
            {
                continue;
            }
            String key = row.getPaperId() + ":" + row.getKnowledgeId();
            List<SpasAnalysisScoreRow> g = groups.get(key);
            if (g == null)
            {
                g = new ArrayList<SpasAnalysisScoreRow>();
                groups.put(key, g);
            }
            g.add(row);
        }
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        for (List<SpasAnalysisScoreRow> g : groups.values())
        {
            Map<Long, KnowledgeStatCalculator.AggView> map = calculator.aggregateViews(g);
            if (map.isEmpty())
            {
                continue;
            }
            KnowledgeStatCalculator.AggView agg = map.values().iterator().next();
            SpasStudentKnowledgeStat stat = calculator.toStatView(agg);
            SpasAnalysisScoreRow sample = g.get(0);
            Map<String, Object> row = new HashMap<String, Object>();
            row.put("paperId", sample.getPaperId());
            row.put("paperName", sample.getPaperName());
            row.put("examDate", sample.getExamDate());
            row.put("knowledgeId", stat.getKnowledgeId());
            row.put("knowledgeName", agg.knowledgeName);
            row.put("rate", stat.getWeightedRate());
            row.put("attemptCount", stat.getAttemptCount());
            row.put("weakLevel", stat.getWeakLevel());
            list.add(row);
        }
        list.sort((a, b) -> {
            Date da = (Date) a.get("examDate");
            Date db = (Date) b.get("examDate");
            if (da == null && db == null)
            {
                return 0;
            }
            if (da == null)
            {
                return 1;
            }
            if (db == null)
            {
                return -1;
            }
            return da.compareTo(db);
        });
        return list;
    }

    public List<Map<String, Object>> persistentWeak(Long studentId, Long subjectId, List<Long> paperIds,
        Date examDateFrom, Integer minPapers, Double rateThreshold, Double ratio)
    {
        int minP = minPapers != null && minPapers > 0 ? minPapers.intValue() : persistMinPapers;
        double thr = rateThreshold != null ? rateThreshold.doubleValue() : persistRateThreshold;
        double needRatio = ratio != null ? ratio.doubleValue() : persistRatio;

        List<Map<String, Object>> trend = knowledgeExamTrend(studentId, null, subjectId, paperIds, examDateFrom);
        Map<Long, List<Map<String, Object>>> byKid = new LinkedHashMap<Long, List<Map<String, Object>>>();
        for (Map<String, Object> t : trend)
        {
            Long kid = toLong(t.get("knowledgeId"));
            if (kid == null)
            {
                continue;
            }
            List<Map<String, Object>> g = byKid.get(kid);
            if (g == null)
            {
                g = new ArrayList<Map<String, Object>>();
                byKid.put(kid, g);
            }
            g.add(t);
        }

        List<SpasStudentKnowledgeStat> allStats = computeStudentStats(studentId, subjectId, examDateFrom, paperIds);
        Map<Long, SpasStudentKnowledgeStat> statIndex = new HashMap<Long, SpasStudentKnowledgeStat>();
        for (SpasStudentKnowledgeStat s : allStats)
        {
            if (s.getKnowledgeId() != null)
            {
                statIndex.put(s.getKnowledgeId(), s);
            }
        }

        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        for (Map.Entry<Long, List<Map<String, Object>>> e : byKid.entrySet())
        {
            List<Map<String, Object>> papers = e.getValue();
            int valid = 0;
            int low = 0;
            String name = null;
            for (Map<String, Object> p : papers)
            {
                int att = (int) Math.round(toDouble(p.get("attemptCount")));
                Double rate = toDoubleObj(p.get("rate"));
                if (att <= 0 || rate == null)
                {
                    continue;
                }
                valid++;
                if (rate.doubleValue() < thr)
                {
                    low++;
                }
                if (name == null)
                {
                    name = String.valueOf(p.get("knowledgeName"));
                }
            }
            String tag;
            if (valid < minP)
            {
                tag = TAG_INSUFFICIENT;
            }
            else if (valid > 0 && (low * 1.0 / valid) >= needRatio)
            {
                tag = TAG_PERSISTENT;
            }
            else if (low == 1 && valid >= 2)
            {
                tag = TAG_SINGLE_DIP;
            }
            else if (low >= 2)
            {
                tag = TAG_VOLATILE;
            }
            else
            {
                tag = TAG_STABLE;
            }
            SpasStudentKnowledgeStat match = statIndex.get(e.getKey());
            Map<String, Object> row = new HashMap<String, Object>();
            row.put("knowledgeId", e.getKey());
            row.put("knowledgeName", name);
            row.put("name", name);
            row.put("persistTag", tag);
            row.put("validPapers", valid);
            row.put("lowPapers", low);
            row.put("minPapers", minP);
            row.put("rateThreshold", thr);
            if (match != null)
            {
                row.put("rate", match.getWeightedRate());
                row.put("weightedRate", match.getWeightedRate());
                row.put("attemptCount", match.getAttemptCount());
                row.put("weakLevel", match.getWeakLevel());
                row.put("confidence", calculator.confidence(match.getAttemptCount()));
            }
            row.put("examPoints", papers);
            result.add(row);
        }
        result.sort((a, b) -> {
            int pa = TAG_PERSISTENT.equals(a.get("persistTag")) ? 0 : 1;
            int pb = TAG_PERSISTENT.equals(b.get("persistTag")) ? 0 : 1;
            if (pa != pb)
            {
                return Integer.compare(pa, pb);
            }
            return Double.compare(toDouble(a.get("rate")), toDouble(b.get("rate")));
        });
        return result;
    }

    /**
     * Count students tagged 反复薄弱 per knowledge using already-loaded score rows
     * (avoids N× knowledgeExamTrend DB round-trips inside classOverview).
     */
    private Map<Long, Integer> countPersistentWeakByKnowledge(Map<Long, List<SpasAnalysisScoreRow>> byStudent,
        Long subjectId)
    {
        Map<Long, Integer> persistByKid = new HashMap<Long, Integer>();
        if (byStudent == null || byStudent.isEmpty())
        {
            return persistByKid;
        }
        int minP = persistMinPapers;
        double thr = persistRateThreshold;
        double needRatio = persistRatio;
        for (List<SpasAnalysisScoreRow> studentRows : byStudent.values())
        {
            Map<Long, Map<Long, List<SpasAnalysisScoreRow>>> byKidPaper =
                new HashMap<Long, Map<Long, List<SpasAnalysisScoreRow>>>();
            for (SpasAnalysisScoreRow row : studentRows)
            {
                if (row.getKnowledgeId() == null || row.getPaperId() == null)
                {
                    continue;
                }
                if (subjectId != null && row.getSubjectId() != null && !subjectId.equals(row.getSubjectId()))
                {
                    continue;
                }
                Map<Long, List<SpasAnalysisScoreRow>> byPaper = byKidPaper.get(row.getKnowledgeId());
                if (byPaper == null)
                {
                    byPaper = new HashMap<Long, List<SpasAnalysisScoreRow>>();
                    byKidPaper.put(row.getKnowledgeId(), byPaper);
                }
                List<SpasAnalysisScoreRow> g = byPaper.get(row.getPaperId());
                if (g == null)
                {
                    g = new ArrayList<SpasAnalysisScoreRow>();
                    byPaper.put(row.getPaperId(), g);
                }
                g.add(row);
            }
            for (Map.Entry<Long, Map<Long, List<SpasAnalysisScoreRow>>> ke : byKidPaper.entrySet())
            {
                int valid = 0;
                int low = 0;
                for (List<SpasAnalysisScoreRow> paperRows : ke.getValue().values())
                {
                    Map<Long, KnowledgeStatCalculator.AggView> map = calculator.aggregateViews(paperRows);
                    KnowledgeStatCalculator.AggView agg = map.get(ke.getKey());
                    if (agg == null)
                    {
                        continue;
                    }
                    SpasStudentKnowledgeStat stat = calculator.toStatView(agg);
                    int att = stat.getAttemptCount() == null ? 0 : stat.getAttemptCount().intValue();
                    if (att <= 0 || stat.getWeightedRate() == null)
                    {
                        continue;
                    }
                    valid++;
                    if (stat.getWeightedRate().doubleValue() < thr)
                    {
                        low++;
                    }
                }
                if (valid >= minP && valid > 0 && (low * 1.0 / valid) >= needRatio)
                {
                    Integer c = persistByKid.get(ke.getKey());
                    persistByKid.put(ke.getKey(), c == null ? 1 : c.intValue() + 1);
                }
            }
        }
        return persistByKid;
    }

    /**
     * Live class heatmap matrix for window / paper-set scopes.
     */
    public Map<String, Object> classHeatmap(Long deptId, Long subjectId, Date examDateFrom, List<Long> paperIds)
    {
        List<Map<String, Object>> students = analysisMapper.selectClassHeatmapStudents(deptId);
        List<SpasAnalysisScoreRow> rows = analysisMapper.selectScoreRowsForScope(null, subjectId, examDateFrom,
            paperIds, deptId, null);
        Map<Long, List<SpasAnalysisScoreRow>> byStudent = new HashMap<Long, List<SpasAnalysisScoreRow>>();
        for (SpasAnalysisScoreRow row : rows)
        {
            if (row.getStudentId() == null)
            {
                continue;
            }
            List<SpasAnalysisScoreRow> g = byStudent.get(row.getStudentId());
            if (g == null)
            {
                g = new ArrayList<SpasAnalysisScoreRow>();
                byStudent.put(row.getStudentId(), g);
            }
            g.add(row);
        }
        Map<String, Object> rateIndex = new HashMap<String, Object>();
        Map<Long, String> knowledgeNames = new LinkedHashMap<Long, String>();
        for (Map.Entry<Long, List<SpasAnalysisScoreRow>> e : byStudent.entrySet())
        {
            Map<Long, KnowledgeStatCalculator.AggView> map = calculator.aggregateViews(e.getValue());
            for (KnowledgeStatCalculator.AggView agg : map.values())
            {
                SpasStudentKnowledgeStat stat = calculator.toStatView(agg);
                if (stat.getKnowledgeId() == null || stat.getWeightedRate() == null)
                {
                    continue;
                }
                rateIndex.put(e.getKey() + "_" + stat.getKnowledgeId(), stat.getWeightedRate());
                if (!knowledgeNames.containsKey(stat.getKnowledgeId()))
                {
                    knowledgeNames.put(stat.getKnowledgeId(), agg.knowledgeName);
                }
            }
        }
        List<Map<String, Object>> knowledges = new ArrayList<Map<String, Object>>();
        for (Map.Entry<Long, String> e : knowledgeNames.entrySet())
        {
            Map<String, Object> k = new HashMap<String, Object>();
            k.put("id", e.getKey());
            k.put("name", e.getValue());
            knowledges.add(k);
        }
        List<List<Object>> matrix = new ArrayList<List<Object>>();
        if (students != null)
        {
            for (Map<String, Object> student : students)
            {
                Object sid = student.get("id");
                List<Object> row = new ArrayList<Object>();
                for (Map<String, Object> knowledge : knowledges)
                {
                    Object kid = knowledge.get("id");
                    Object rate = null;
                    if (sid != null && kid != null)
                    {
                        rate = rateIndex.get(sid.toString() + "_" + kid.toString());
                    }
                    row.add(rate);
                }
                matrix.add(row);
            }
        }
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("students", students == null ? new ArrayList<Map<String, Object>>() : students);
        result.put("knowledges", knowledges);
        result.put("matrix", matrix);
        result.put("dataMode", paperIds != null && !paperIds.isEmpty() ? "papers" : "live");
        return result;
    }

    /**
     * Live class overview summary for window / paper-set scopes.
     */
    public Map<String, Object> classOverview(Long deptId, Long subjectId, Date examDateFrom, List<Long> paperIds)
    {
        List<SpasAnalysisScoreRow> rows = analysisMapper.selectScoreRowsForScope(null, subjectId, examDateFrom,
            paperIds, deptId, null);
        Map<Long, List<SpasAnalysisScoreRow>> byStudent = groupRowsByStudent(rows);
        Map<Long, List<Double>> kpRates = new HashMap<Long, List<Double>>();
        Map<Long, int[]> kpWeak = new HashMap<Long, int[]>();
        Map<Long, String> kpNames = new HashMap<Long, String>();
        List<Map<String, Object>> ranking = new ArrayList<Map<String, Object>>();
        int weakStudentCount = 0;
        int severeStudentCount = 0;
        int lowRateStudentCount = 0;
        int thinSampleStudentCount = 0;
        BigDecimal sumStuRate = BigDecimal.ZERO;
        int stuRateN = 0;
        for (Map.Entry<Long, List<SpasAnalysisScoreRow>> e : byStudent.entrySet())
        {
            Map<Long, KnowledgeStatCalculator.AggView> map = calculator.aggregateViews(e.getValue());
            int weakKnowledgeCount = 0;
            int severeKnowledgeCount = 0;
            // Distinct questions, not the sum of per-knowledge attempt counts
            // (one question bound to several points would otherwise be counted many times).
            Set<Long> questionIds = new HashSet<Long>();
            for (SpasAnalysisScoreRow row : e.getValue())
            {
                if (row.getQuestionId() != null)
                {
                    questionIds.add(row.getQuestionId());
                }
            }
            int totalAttempts = questionIds.size();
            int lowRateCount = 0;
            int lowSevereCount = 0;
            int thinSampleCount = 0;
            int minAttempts = calculator.resolveMinAttempts();
            boolean hasWeak = false;
            boolean hasSevere = false;
            for (KnowledgeStatCalculator.AggView agg : map.values())
            {
                SpasStudentKnowledgeStat stat = calculator.toStatView(agg);
                if (stat.getWeightedRate() == null || stat.getKnowledgeId() == null)
                {
                    continue;
                }
                int attempts = stat.getAttemptCount() == null ? 0 : stat.getAttemptCount().intValue();
                if (calculator.belowWeakRate(stat.getWeightedRate()))
                {
                    lowRateCount++;
                    if (attempts < minAttempts)
                    {
                        thinSampleCount++;
                    }
                }
                if (calculator.belowSevereRate(stat.getWeightedRate()))
                {
                    lowSevereCount++;
                }
                if ("3".equals(stat.getWeakLevel()))
                {
                    hasSevere = true;
                    hasWeak = true;
                    severeKnowledgeCount++;
                    weakKnowledgeCount++;
                }
                else if ("2".equals(stat.getWeakLevel()))
                {
                    hasWeak = true;
                    weakKnowledgeCount++;
                }
                List<Double> rates = kpRates.get(stat.getKnowledgeId());
                if (rates == null)
                {
                    rates = new ArrayList<Double>();
                    kpRates.put(stat.getKnowledgeId(), rates);
                }
                rates.add(stat.getWeightedRate().doubleValue());
                int[] cnt = kpWeak.get(stat.getKnowledgeId());
                if (cnt == null)
                {
                    cnt = new int[3];
                    kpWeak.put(stat.getKnowledgeId(), cnt);
                }
                if ("1".equals(stat.getWeakLevel()))
                {
                    cnt[0]++;
                }
                else if ("2".equals(stat.getWeakLevel()))
                {
                    cnt[1]++;
                }
                else if ("3".equals(stat.getWeakLevel()))
                {
                    cnt[2]++;
                }
                if (!kpNames.containsKey(stat.getKnowledgeId()) && agg.knowledgeName != null)
                {
                    kpNames.put(stat.getKnowledgeId(), agg.knowledgeName);
                }
            }
            if (hasSevere)
            {
                severeStudentCount++;
            }
            if (hasWeak)
            {
                weakStudentCount++;
            }
            BigDecimal stuRate = attemptWeightedOverallFromAggs(map);
            if (stuRate != null)
            {
                sumStuRate = sumStuRate.add(stuRate);
                stuRateN++;
                if (stuRate.compareTo(BigDecimal.valueOf(calculator.resolveWeakThreshold())) < 0)
                {
                    lowRateStudentCount++;
                }
            }
            if (thinSampleCount > 0 && weakKnowledgeCount <= 0)
            {
                thinSampleStudentCount++;
            }
            Map<String, Object> rank = new HashMap<String, Object>();
            rank.put("studentId", e.getKey());
            rank.put("overallRate", stuRate);
            rank.put("weakKnowledgeCount", weakKnowledgeCount);
            rank.put("severeKnowledgeCount", severeKnowledgeCount);
            rank.put("lowRateCount", lowRateCount);
            rank.put("lowSevereCount", lowSevereCount);
            rank.put("thinSampleCount", thinSampleCount);
            rank.put("totalAttempts", totalAttempts);
            SpasStudent st = studentMapper.selectSpasStudentById(e.getKey());
            if (st != null)
            {
                rank.put("studentNo", st.getStudentNo());
                rank.put("studentName", st.getStudentName());
            }
            ranking.add(rank);
        }
        ranking.sort((a, b) -> Double.compare(toDouble(b.get("overallRate")), toDouble(a.get("overallRate"))));
        int classSize = ranking.size();
        int seen = 0;
        int rankNo = 0;
        double prevRate = Double.NaN;
        for (Map<String, Object> peer : ranking)
        {
            double rate = toDouble(peer.get("overallRate"));
            seen++;
            if (Double.isNaN(prevRate) || Math.abs(rate - prevRate) > 1e-9)
            {
                rankNo = seen;
                prevRate = rate;
            }
            peer.put("rankNo", rankNo);
            peer.put("classSize", classSize);
            if (classSize > 1)
            {
                peer.put("percentile", BigDecimal.valueOf(100.0 * (classSize - rankNo) / (classSize - 1))
                    .setScale(1, RoundingMode.HALF_UP));
            }
        }
        // UI ranks weak→strong; keep desc rates for percentile, reverse for display list
        List<Map<String, Object>> rankingAsc = new ArrayList<Map<String, Object>>(ranking);
        rankingAsc.sort((a, b) -> Double.compare(toDouble(a.get("overallRate")), toDouble(b.get("overallRate"))));

        Map<Long, Integer> persistByKid = countPersistentWeakByKnowledge(byStudent, subjectId);
        List<Map<String, Object>> knowledges = new ArrayList<Map<String, Object>>();
        for (Map.Entry<Long, List<Double>> e : kpRates.entrySet())
        {
            double sum = 0;
            for (Double d : e.getValue())
            {
                sum += d.doubleValue();
            }
            int[] cnt = kpWeak.get(e.getKey());
            Map<String, Object> row = new HashMap<String, Object>();
            row.put("knowledgeId", e.getKey());
            row.put("name", kpNames.get(e.getKey()));
            row.put("knowledgeName", kpNames.get(e.getKey()));
            row.put("avgRate", BigDecimal.valueOf(sum / e.getValue().size()).setScale(6, RoundingMode.HALF_UP));
            row.put("watchCount", cnt == null ? 0 : cnt[0]);
            row.put("weakCount", cnt == null ? 0 : cnt[1]);
            row.put("severeCount", cnt == null ? 0 : cnt[2]);
            row.put("studentCount", e.getValue().size());
            Integer pc = persistByKid.get(e.getKey());
            row.put("persistentStudentCount", pc == null ? 0 : pc);
            knowledges.add(row);
        }
        knowledges.sort((a, b) -> Double.compare(toDouble(a.get("avgRate")), toDouble(b.get("avgRate"))));
        int weakKnowledgeCount = 0;
        double watchCut = calculator.resolveWatchThreshold();
        for (Map<String, Object> row : knowledges)
        {
            int watch = row.get("watchCount") == null ? 0 : ((Number) row.get("watchCount")).intValue();
            int weak = row.get("weakCount") == null ? 0 : ((Number) row.get("weakCount")).intValue();
            int severe = row.get("severeCount") == null ? 0 : ((Number) row.get("severeCount")).intValue();
            if (watch + weak + severe > 0 || toDouble(row.get("avgRate")) < watchCut)
            {
                weakKnowledgeCount++;
            }
        }
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("studentCount", byStudent.size());
        result.put("weakStudentCount", weakStudentCount);
        result.put("severeStudentCount", severeStudentCount);
        result.put("lowRateStudentCount", Integer.valueOf(lowRateStudentCount));
        result.put("thinSampleStudentCount", Integer.valueOf(thinSampleStudentCount));
        result.put("avgRate", stuRateN > 0
            ? sumStuRate.divide(BigDecimal.valueOf(stuRateN), 6, RoundingMode.HALF_UP) : null);
        result.put("knowledgeCount", weakKnowledgeCount);
        result.put("knowledges", knowledges);
        result.put("studentRanking", rankingAsc);
        result.put("dataMode", paperIds != null && !paperIds.isEmpty() ? "papers" : "live");
        return result;
    }

    /**
     * Live class chapter overview: per-student attempt-weighted chapter rate, then class avg.
     * Aligns with snapshot SQL selectClassChapterOverview:
     * studentCount = students with data under chapter;
     * weakCount = students whose chapter rate &lt; weak threshold (rate-based, not formal weak_level).
     */
    public Map<String, Object> classChapterOverview(Long deptId, Long subjectId, Date examDateFrom,
        List<Long> paperIds)
    {
        List<Map<String, Object>> pairs = analysisMapper.selectLeafChapterMap(subjectId);
        Map<Long, Long> leafToChapter = new HashMap<Long, Long>();
        Map<Long, String> chapterNames = new LinkedHashMap<Long, String>();
        Map<Long, Integer> chapterOrder = new HashMap<Long, Integer>();
        if (pairs != null)
        {
            for (Map<String, Object> p : pairs)
            {
                Long leafId = toLong(p.get("leafId"));
                Long chapterId = toLong(p.get("chapterId"));
                if (leafId == null || chapterId == null)
                {
                    continue;
                }
                // Prefer first (nearest by order) mapping
                if (!leafToChapter.containsKey(leafId))
                {
                    leafToChapter.put(leafId, chapterId);
                    chapterNames.put(chapterId, String.valueOf(p.get("chapterName")));
                    Object on = p.get("orderNum");
                    if (on != null)
                    {
                        try
                        {
                            chapterOrder.put(chapterId, Integer.valueOf(on.toString()));
                        }
                        catch (Exception ignored)
                        {
                        }
                    }
                }
            }
        }

        List<SpasAnalysisScoreRow> rows = analysisMapper.selectScoreRowsForScope(null, subjectId, examDateFrom,
            paperIds, deptId, null);
        Map<Long, List<SpasAnalysisScoreRow>> byStudent = groupRowsByStudent(rows);
        // chapterId -> student chapter rates
        Map<Long, List<Double>> chapterStuRates = new HashMap<Long, List<Double>>();
        double weakCut = calculator.resolveWeakThreshold();

        for (Map.Entry<Long, List<SpasAnalysisScoreRow>> e : byStudent.entrySet())
        {
            Map<Long, KnowledgeStatCalculator.AggView> map = calculator.aggregateViews(e.getValue());
            // chapterId -> [sum(rate*attempt), sum(attempt)]
            Map<Long, double[]> chapterAgg = new HashMap<Long, double[]>();
            for (Map.Entry<Long, KnowledgeStatCalculator.AggView> ae : map.entrySet())
            {
                Long chapterId = leafToChapter.get(ae.getKey());
                if (chapterId == null)
                {
                    continue;
                }
                SpasStudentKnowledgeStat st = calculator.toStatView(ae.getValue());
                if (st.getWeightedRate() == null)
                {
                    continue;
                }
                int att = st.getAttemptCount() == null ? 0 : st.getAttemptCount().intValue();
                double w = att > 0 ? att : 1.0;
                double rate = st.getWeightedRate().doubleValue();
                double[] bucket = chapterAgg.get(chapterId);
                if (bucket == null)
                {
                    bucket = new double[2];
                    chapterAgg.put(chapterId, bucket);
                }
                bucket[0] += rate * w;
                bucket[1] += w;
            }
            for (Map.Entry<Long, double[]> ce : chapterAgg.entrySet())
            {
                double[] bucket = ce.getValue();
                if (bucket[1] <= 0)
                {
                    continue;
                }
                double chapterRate = bucket[0] / bucket[1];
                List<Double> rates = chapterStuRates.get(ce.getKey());
                if (rates == null)
                {
                    rates = new ArrayList<Double>();
                    chapterStuRates.put(ce.getKey(), rates);
                }
                rates.add(chapterRate);
            }
        }

        List<Map<String, Object>> chapters = new ArrayList<Map<String, Object>>();
        for (Map.Entry<Long, List<Double>> e : chapterStuRates.entrySet())
        {
            List<Double> rates = e.getValue();
            if (rates == null || rates.isEmpty())
            {
                continue;
            }
            double sum = 0;
            int weak = 0;
            for (Double d : rates)
            {
                sum += d.doubleValue();
                if (d.doubleValue() < weakCut)
                {
                    weak++;
                }
            }
            Map<String, Object> row = new HashMap<String, Object>();
            row.put("knowledgeId", e.getKey());
            row.put("name", chapterNames.get(e.getKey()));
            row.put("avgRate", BigDecimal.valueOf(sum / rates.size()).setScale(6, RoundingMode.HALF_UP));
            row.put("studentCount", Integer.valueOf(rates.size()));
            row.put("weakCount", Integer.valueOf(weak));
            row.put("nodeKind", "chapter");
            row.put("orderNum", chapterOrder.get(e.getKey()));
            chapters.add(row);
        }
        chapters.sort((a, b) -> {
            Integer oa = (Integer) a.get("orderNum");
            Integer ob = (Integer) b.get("orderNum");
            int ia = oa == null ? Integer.MAX_VALUE : oa.intValue();
            int ib = ob == null ? Integer.MAX_VALUE : ob.intValue();
            if (ia != ib)
            {
                return Integer.compare(ia, ib);
            }
            return Long.compare(toLong(a.get("knowledgeId")), toLong(b.get("knowledgeId")));
        });
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("chapters", chapters);
        data.put("dataMode", paperIds != null && !paperIds.isEmpty() ? "papers" : "live");
        data.put("headline", chapters.isEmpty()
            ? "\u6682\u65e0\u7ae0\u8282\u6c47\u603b\u6570\u636e"
            : ("\u7ae0\u8282\u6570 " + chapters.size()));
        return data;
    }

    /**
     * Student chapter radar for window / paper-set (attempt-weighted rollup of leaf rates).
     */
    public List<Map<String, Object>> studentChapterRadar(Long studentId, Long subjectId, Date examDateFrom,
        List<Long> paperIds)
    {
        List<Map<String, Object>> leaves = studentRadar(studentId, subjectId, examDateFrom, paperIds);
        List<Map<String, Object>> pairs = analysisMapper.selectLeafChapterMap(subjectId);
        Map<Long, Long> leafToChapter = new HashMap<Long, Long>();
        Map<Long, String> chapterNames = new LinkedHashMap<Long, String>();
        Map<Long, Integer> chapterOrder = new HashMap<Long, Integer>();
        if (pairs != null)
        {
            for (Map<String, Object> p : pairs)
            {
                Long leafId = toLong(p.get("leafId"));
                Long chapterId = toLong(p.get("chapterId"));
                if (leafId == null || chapterId == null)
                {
                    continue;
                }
                if (!leafToChapter.containsKey(leafId))
                {
                    leafToChapter.put(leafId, chapterId);
                    chapterNames.put(chapterId, String.valueOf(p.get("chapterName")));
                    Object on = p.get("orderNum");
                    if (on != null)
                    {
                        try
                        {
                            chapterOrder.put(chapterId, Integer.valueOf(on.toString()));
                        }
                        catch (Exception ignored)
                        {
                        }
                    }
                }
            }
        }
        Map<Long, BigDecimal> sumRateW = new HashMap<Long, BigDecimal>();
        Map<Long, Integer> sumAttempts = new HashMap<Long, Integer>();
        for (Map<String, Object> leaf : leaves)
        {
            Long kid = toLong(leaf.get("knowledgeId"));
            Long chapterId = kid == null ? null : leafToChapter.get(kid);
            if (chapterId == null)
            {
                continue;
            }
            Double rate = toDoubleObj(leaf.get("rate"));
            int att = (int) Math.round(toDouble(leaf.get("attemptCount")));
            if (rate == null || att <= 0)
            {
                continue;
            }
            BigDecimal w = BigDecimal.valueOf(rate.doubleValue()).multiply(BigDecimal.valueOf(att));
            BigDecimal prev = sumRateW.get(chapterId);
            sumRateW.put(chapterId, prev == null ? w : prev.add(w));
            Integer pa = sumAttempts.get(chapterId);
            sumAttempts.put(chapterId, (pa == null ? 0 : pa.intValue()) + att);
        }
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        for (Map.Entry<Long, BigDecimal> e : sumRateW.entrySet())
        {
            int att = sumAttempts.get(e.getKey()) == null ? 0 : sumAttempts.get(e.getKey()).intValue();
            if (att <= 0)
            {
                continue;
            }
            BigDecimal rate = e.getValue().divide(BigDecimal.valueOf(att), 6, RoundingMode.HALF_UP);
            Map<String, Object> row = new HashMap<String, Object>();
            row.put("knowledgeId", e.getKey());
            row.put("name", chapterNames.get(e.getKey()));
            row.put("rate", rate);
            row.put("attemptCount", att);
            row.put("orderNum", chapterOrder.get(e.getKey()));
            row.put("confidence", calculator.confidence(att));
            list.add(row);
        }
        list.sort((a, b) -> {
            Integer oa = (Integer) a.get("orderNum");
            Integer ob = (Integer) b.get("orderNum");
            int ia = oa == null ? Integer.MAX_VALUE : oa.intValue();
            int ib = ob == null ? Integer.MAX_VALUE : ob.intValue();
            if (ia != ib)
            {
                return Integer.compare(ia, ib);
            }
            return Long.compare(toLong(a.get("knowledgeId")), toLong(b.get("knowledgeId")));
        });
        return list;
    }

    public Map<String, Object> paperAnnotationCoverage(List<Long> paperIds)
    {
        if (paperIds == null || paperIds.isEmpty())
        {
            Map<String, Object> empty = new HashMap<String, Object>();
            empty.put("questionCount", 0);
            empty.put("boundCount", 0);
            empty.put("unboundCount", 0);
            empty.put("unboundRatio", 0);
            empty.put("noTypeCount", 0);
            empty.put("noBloomCount", 0);
            empty.put("typeCoverageRate", 1);
            empty.put("bloomCoverageRate", 1);
            return empty;
        }
        Map<String, Object> row = analysisMapper.selectPaperAnnotationCoverage(paperIds);
        if (row == null)
        {
            row = new HashMap<String, Object>();
        }
        int q = (int) Math.round(toDouble(row.get("questionCount")));
        int unbound = (int) Math.round(toDouble(row.get("unboundCount")));
        int noType = (int) Math.round(toDouble(row.get("noTypeCount")));
        int noBloom = (int) Math.round(toDouble(row.get("noBloomCount")));
        row.put("questionCount", q);
        row.put("boundCount", (int) Math.round(toDouble(row.get("boundCount"))));
        row.put("unboundCount", unbound);
        row.put("noTypeCount", noType);
        row.put("noBloomCount", noBloom);
        row.put("unboundRatio", q > 0
            ? BigDecimal.valueOf(unbound * 1.0 / q).setScale(4, RoundingMode.HALF_UP) : BigDecimal.ZERO);
        row.put("typeCoverageRate", q > 0
            ? BigDecimal.valueOf((q - noType) * 1.0 / q).setScale(4, RoundingMode.HALF_UP) : BigDecimal.ONE);
        row.put("bloomCoverageRate", q > 0
            ? BigDecimal.valueOf((q - noBloom) * 1.0 / q).setScale(4, RoundingMode.HALF_UP) : BigDecimal.ONE);
        return row;
    }

    /**
     * Average mastery per knowledge across students who sat the selected papers (optional dept).
     */
    public Map<Long, Double> masteryAvgByPapers(List<Long> paperIds, Long subjectId, Long deptId)
    {
        if (paperIds == null || paperIds.isEmpty())
        {
            return Collections.emptyMap();
        }
        List<Long> studentIds = analysisMapper.selectStudentIdsByPaperIds(paperIds, deptId);
        if (studentIds == null || studentIds.isEmpty())
        {
            return Collections.emptyMap();
        }
        Map<Long, List<Double>> bucket = new HashMap<Long, List<Double>>();
        for (Long sid : studentIds)
        {
            List<SpasStudentKnowledgeStat> stats = computeStudentStats(sid, subjectId, null, paperIds);
            for (SpasStudentKnowledgeStat s : stats)
            {
                if (s.getWeightedRate() == null || s.getKnowledgeId() == null)
                {
                    continue;
                }
                List<Double> rates = bucket.get(s.getKnowledgeId());
                if (rates == null)
                {
                    rates = new ArrayList<Double>();
                    bucket.put(s.getKnowledgeId(), rates);
                }
                rates.add(s.getWeightedRate().doubleValue());
            }
        }
        Map<Long, Double> avg = new HashMap<Long, Double>();
        for (Map.Entry<Long, List<Double>> e : bucket.entrySet())
        {
            double sum = 0;
            for (Double d : e.getValue())
            {
                sum += d.doubleValue();
            }
            avg.put(e.getKey(), sum / e.getValue().size());
        }
        return avg;
    }

    public Map<Long, Double> attemptAvgByPapers(List<Long> paperIds, Long subjectId, Long deptId)
    {
        if (paperIds == null || paperIds.isEmpty())
        {
            return Collections.emptyMap();
        }
        List<Long> studentIds = analysisMapper.selectStudentIdsByPaperIds(paperIds, deptId);
        Map<Long, List<Integer>> bucket = new HashMap<Long, List<Integer>>();
        for (Long sid : studentIds)
        {
            List<SpasStudentKnowledgeStat> stats = computeStudentStats(sid, subjectId, null, paperIds);
            for (SpasStudentKnowledgeStat s : stats)
            {
                List<Integer> atts = bucket.get(s.getKnowledgeId());
                if (atts == null)
                {
                    atts = new ArrayList<Integer>();
                    bucket.put(s.getKnowledgeId(), atts);
                }
                atts.add(s.getAttemptCount() == null ? 0 : s.getAttemptCount().intValue());
            }
        }
        Map<Long, Double> avg = new HashMap<Long, Double>();
        for (Map.Entry<Long, List<Integer>> e : bucket.entrySet())
        {
            double sum = 0;
            for (Integer n : e.getValue())
            {
                sum += n.intValue();
            }
            avg.put(e.getKey(), sum / e.getValue().size());
        }
        return avg;
    }

    private static double toDouble(Object v)
    {
        if (v == null)
        {
            return 0D;
        }
        try
        {
            return Double.parseDouble(v.toString());
        }
        catch (Exception e)
        {
            return 0D;
        }
    }

    private static BigDecimal toDecimalOrNull(Object v)
    {
        if (v == null)
        {
            return null;
        }
        if (v instanceof BigDecimal)
        {
            return (BigDecimal) v;
        }
        try
        {
            return new BigDecimal(v.toString());
        }
        catch (Exception e)
        {
            return null;
        }
    }

    private static Double toDoubleObj(Object v)
    {
        if (v == null)
        {
            return null;
        }
        try
        {
            return Double.valueOf(v.toString());
        }
        catch (Exception e)
        {
            return null;
        }
    }

    private static Long toLong(Object v)
    {
        if (v == null)
        {
            return null;
        }
        try
        {
            return Long.valueOf(v.toString());
        }
        catch (Exception e)
        {
            return null;
        }
    }

    /**
     * Live knowledge overview for a leaf knowledge under window / paper scope.
     */
    public Map<String, Object> knowledgeOverview(Long knowledgeId, Long subjectId, Long deptId, Date examDateFrom,
        List<Long> paperIds)
    {
        List<SpasAnalysisScoreRow> rows = analysisMapper.selectScoreRowsForScope(null, subjectId, examDateFrom, paperIds,
            deptId, knowledgeId);
        Map<Long, List<SpasAnalysisScoreRow>> byStudent = groupRowsByStudent(rows);
        List<Map<String, Object>> students = new ArrayList<Map<String, Object>>();
        BigDecimal sum = BigDecimal.ZERO;
        int weakCount = 0;
        int attemptSum = 0;
        int rateN = 0;
        for (Map.Entry<Long, List<SpasAnalysisScoreRow>> e : byStudent.entrySet())
        {
            Map<Long, KnowledgeStatCalculator.AggView> map = calculator.aggregateViews(e.getValue());
            KnowledgeStatCalculator.AggView agg = map.get(knowledgeId);
            if (agg == null)
            {
                continue;
            }
            SpasStudentKnowledgeStat stat = calculator.toStatView(agg);
            Map<String, Object> row = new HashMap<String, Object>();
            row.put("studentId", e.getKey());
            row.put("rate", stat.getWeightedRate());
            row.put("weightedRate", stat.getWeightedRate());
            row.put("attemptCount", stat.getAttemptCount());
            row.put("weakLevel", stat.getWeakLevel());
            SpasStudent st = studentMapper.selectSpasStudentById(e.getKey());
            if (st != null)
            {
                row.put("studentNo", st.getStudentNo());
                row.put("studentName", st.getStudentName());
                row.put("deptId", st.getDeptId());
                row.put("deptName", st.getDeptName());
            }
            students.add(row);
            if (stat.getWeightedRate() != null)
            {
                sum = sum.add(stat.getWeightedRate());
                rateN++;
            }
            if (stat.getWeakLevel() != null && !"0".equals(stat.getWeakLevel()))
            {
                weakCount++;
            }
            attemptSum += stat.getAttemptCount() == null ? 0 : stat.getAttemptCount().intValue();
        }
        students.sort((a, b) -> Double.compare(toDouble(a.get("rate")), toDouble(b.get("rate"))));
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("chapterMode", Boolean.FALSE);
        result.put("students", students);
        result.put("studentCount", Integer.valueOf(students.size()));
        result.put("weakStudentCount", Integer.valueOf(weakCount));
        if (rateN > 0)
        {
            result.put("avgRate", sum.divide(new BigDecimal(rateN), 4, RoundingMode.HALF_UP));
        }
        if (!students.isEmpty())
        {
            result.put("avgAttemptCount",
                new BigDecimal(attemptSum).divide(new BigDecimal(students.size()), 2, RoundingMode.HALF_UP));
        }
        result.put("classComparison", new ArrayList<Map<String, Object>>());
        return result;
    }

    /**
     * Class avg rate per paper for one knowledge under window / paper scope.
     */
    public List<Map<String, Object>> classKnowledgeExamTrend(Long deptId, Long knowledgeId, Long subjectId,
        List<Long> paperIds, Date examDateFrom)
    {
        List<SpasAnalysisScoreRow> rows = analysisMapper.selectScoreRowsForScope(null, subjectId, examDateFrom, paperIds,
            deptId, knowledgeId);
        Map<String, List<SpasAnalysisScoreRow>> byPaperStudent = new LinkedHashMap<String, List<SpasAnalysisScoreRow>>();
        Map<Long, Map<String, Object>> paperMeta = new LinkedHashMap<Long, Map<String, Object>>();
        for (SpasAnalysisScoreRow row : rows)
        {
            if (row.getPaperId() == null || row.getStudentId() == null)
            {
                continue;
            }
            String key = row.getPaperId() + ":" + row.getStudentId();
            List<SpasAnalysisScoreRow> g = byPaperStudent.get(key);
            if (g == null)
            {
                g = new ArrayList<SpasAnalysisScoreRow>();
                byPaperStudent.put(key, g);
            }
            g.add(row);
            if (!paperMeta.containsKey(row.getPaperId()))
            {
                Map<String, Object> meta = new LinkedHashMap<String, Object>();
                meta.put("paperId", row.getPaperId());
                meta.put("paperName", row.getPaperName());
                meta.put("examDate", row.getExamDate());
                paperMeta.put(row.getPaperId(), meta);
            }
        }
        Map<Long, List<Double>> ratesByPaper = new HashMap<Long, List<Double>>();
        Map<Long, Integer> weakByPaper = new HashMap<Long, Integer>();
        for (Map.Entry<String, List<SpasAnalysisScoreRow>> e : byPaperStudent.entrySet())
        {
            Map<Long, KnowledgeStatCalculator.AggView> map = calculator.aggregateViews(e.getValue());
            KnowledgeStatCalculator.AggView agg = map.get(knowledgeId);
            if (agg == null && !map.isEmpty())
            {
                agg = map.values().iterator().next();
            }
            if (agg == null)
            {
                continue;
            }
            SpasStudentKnowledgeStat stat = calculator.toStatView(agg);
            if (stat.getWeightedRate() == null)
            {
                continue;
            }
            Long paperId = e.getValue().get(0).getPaperId();
            List<Double> rates = ratesByPaper.get(paperId);
            if (rates == null)
            {
                rates = new ArrayList<Double>();
                ratesByPaper.put(paperId, rates);
            }
            double rate = stat.getWeightedRate().doubleValue();
            rates.add(rate);
            if (rate < calculator.resolveWeakThreshold())
            {
                Integer w = weakByPaper.get(paperId);
                weakByPaper.put(paperId, w == null ? Integer.valueOf(1) : Integer.valueOf(w.intValue() + 1));
            }
        }
        List<Map<String, Object>> out = new ArrayList<Map<String, Object>>();
        double weakCut = calculator.resolveWeakThreshold();
        for (Map.Entry<Long, Map<String, Object>> e : paperMeta.entrySet())
        {
            List<Double> rates = ratesByPaper.get(e.getKey());
            if (rates == null || rates.isEmpty())
            {
                continue;
            }
            double sum = 0;
            for (Double r : rates)
            {
                sum += r.doubleValue();
            }
            Map<String, Object> row = new LinkedHashMap<String, Object>(e.getValue());
            row.put("avgRate", BigDecimal.valueOf(sum / rates.size()).setScale(4, RoundingMode.HALF_UP));
            row.put("studentCount", Integer.valueOf(rates.size()));
            Integer weak = weakByPaper.get(e.getKey());
            row.put("weakStudentCount", weak == null ? Integer.valueOf(0) : weak);
            row.put("low", Boolean.valueOf(sum / rates.size() < weakCut));
            out.add(row);
        }
        out.sort((a, b) -> {
            Date da = (Date) a.get("examDate");
            Date db = (Date) b.get("examDate");
            if (da == null && db == null)
            {
                return 0;
            }
            if (da == null)
            {
                return -1;
            }
            if (db == null)
            {
                return 1;
            }
            return da.compareTo(db);
        });
        return out;
    }

    /**
     * Warning metrics under a live window (same attempt-weighted formula as analysis).
     * metric: AVG_RATE | WEAK_COUNT | BELOW_CLASS_AVG
     */
    public List<Map<String, Object>> warningStudentMetrics(String metric, Long subjectId, Long deptId,
        Date examDateFrom)
    {
        List<SpasAnalysisScoreRow> rows = analysisMapper.selectScoreRowsForScope(null, subjectId, examDateFrom, null,
            deptId, null);
        Map<Long, List<SpasAnalysisScoreRow>> byStudent = groupRowsByStudent(rows);
        List<Map<String, Object>> stuRows = new ArrayList<Map<String, Object>>();
        Map<Long, List<BigDecimal>> byDept = new HashMap<Long, List<BigDecimal>>();
        for (Map.Entry<Long, List<SpasAnalysisScoreRow>> e : byStudent.entrySet())
        {
            Map<Long, KnowledgeStatCalculator.AggView> map = calculator.aggregateViews(e.getValue());
            BigDecimal overall = attemptWeightedOverallFromAggs(map);
            int weakCount = 0;
            for (KnowledgeStatCalculator.AggView agg : map.values())
            {
                SpasStudentKnowledgeStat stat = calculator.toStatView(agg);
                if (stat.getWeakLevel() != null
                    && ("2".equals(stat.getWeakLevel()) || "3".equals(stat.getWeakLevel())))
                {
                    weakCount++;
                }
            }
            SpasStudent st = studentMapper.selectSpasStudentById(e.getKey());
            if (st == null || "2".equals(st.getDelFlag()) || !"0".equals(String.valueOf(st.getStatus())))
            {
                continue;
            }
            Map<String, Object> row = new HashMap<String, Object>();
            row.put("studentId", e.getKey());
            row.put("studentName", st.getStudentName());
            row.put("deptId", st.getDeptId());
            row.put("subjectId", subjectId);
            row.put("overallRate", overall);
            row.put("weakCount", Integer.valueOf(weakCount));
            stuRows.add(row);
            if (overall != null && st.getDeptId() != null)
            {
                List<BigDecimal> rates = byDept.get(st.getDeptId());
                if (rates == null)
                {
                    rates = new ArrayList<BigDecimal>();
                    byDept.put(st.getDeptId(), rates);
                }
                rates.add(overall);
            }
        }
        List<Map<String, Object>> out = new ArrayList<Map<String, Object>>();
        for (Map<String, Object> row : stuRows)
        {
            Map<String, Object> m = new HashMap<String, Object>();
            m.put("studentId", row.get("studentId"));
            m.put("studentName", row.get("studentName"));
            m.put("deptId", row.get("deptId"));
            m.put("subjectId", row.get("subjectId"));
            if ("WEAK_COUNT".equals(metric))
            {
                m.put("metricValue", new BigDecimal(String.valueOf(row.get("weakCount"))));
            }
            else if ("BELOW_CLASS_AVG".equals(metric))
            {
                BigDecimal stuRate = (BigDecimal) row.get("overallRate");
                Long did = toLong(row.get("deptId"));
                List<BigDecimal> rates = did == null ? null : byDept.get(did);
                if (stuRate == null || rates == null || rates.isEmpty())
                {
                    continue;
                }
                BigDecimal sum = BigDecimal.ZERO;
                for (BigDecimal r : rates)
                {
                    sum = sum.add(r);
                }
                BigDecimal classAvg = sum.divide(new BigDecimal(rates.size()), 6, RoundingMode.HALF_UP);
                m.put("metricValue", classAvg.subtract(stuRate));
            }
            else
            {
                Object overall = row.get("overallRate");
                if (overall == null)
                {
                    continue;
                }
                m.put("metricValue", overall);
            }
            out.add(m);
        }
        return out;
    }

    /**
     * Count leaf knowledges whose last N paper rates are strictly decreasing.
     */
    public int countKnowledgeContinuousDrop(Long studentId, Long subjectId, int n, Date examDateFrom)
    {
        if (studentId == null || n < 2)
        {
            return 0;
        }
        List<Map<String, Object>> trend = knowledgeExamTrend(studentId, null, subjectId, null, examDateFrom);
        if (trend == null || trend.isEmpty())
        {
            return 0;
        }
        Map<Long, List<Map<String, Object>>> byKid = new LinkedHashMap<Long, List<Map<String, Object>>>();
        for (Map<String, Object> row : trend)
        {
            Long kid = toLong(row.get("knowledgeId"));
            if (kid == null)
            {
                continue;
            }
            List<Map<String, Object>> list = byKid.get(kid);
            if (list == null)
            {
                list = new ArrayList<Map<String, Object>>();
                byKid.put(kid, list);
            }
            list.add(row);
        }
        int count = 0;
        for (List<Map<String, Object>> papers : byKid.values())
        {
            papers.sort((a, b) -> {
                Date da = (Date) a.get("examDate");
                Date db = (Date) b.get("examDate");
                if (da == null && db == null)
                {
                    return 0;
                }
                if (da == null)
                {
                    return -1;
                }
                if (db == null)
                {
                    return 1;
                }
                return da.compareTo(db);
            });
            if (papers.size() < n)
            {
                continue;
            }
            List<Map<String, Object>> last = papers.subList(papers.size() - n, papers.size());
            boolean drop = true;
            Double prev = null;
            for (Map<String, Object> p : last)
            {
                Double rate = toDoubleObj(p.get("rate"));
                if (rate == null)
                {
                    drop = false;
                    break;
                }
                if (prev != null && rate.doubleValue() >= prev.doubleValue())
                {
                    drop = false;
                    break;
                }
                prev = rate;
            }
            if (drop)
            {
                count++;
            }
        }
        return count;
    }

    /**
     * Live roll-up for subject-all / version / chapter under a time window or paper set.
     * Aggregates leaf weighted rates (same engine as snapshot) into parent nodes.
     */
    public Map<String, Object> knowledgeRollupOverview(Long knowledgeId, Long subjectId, Long deptId,
        boolean subjectAll, boolean versionMode, boolean chapterMode, Date examDateFrom, List<Long> paperIds)
    {
        Map<String, Object> empty = new HashMap<String, Object>();
        empty.put("students", new ArrayList<Map<String, Object>>());
        empty.put("children", new ArrayList<Map<String, Object>>());
        empty.put("studentCount", Integer.valueOf(0));
        empty.put("weakStudentCount", Integer.valueOf(0));
        if (subjectId == null)
        {
            return empty;
        }
        String childType = subjectAll ? "0" : (versionMode ? "1" : "2");
        String childrenLabel = subjectAll ? "\u7248\u672c" : (versionMode ? "\u7ae0\u8282" : "\u77e5\u8bc6\u70b9");

        List<SpasKnowledge> nodes = knowledgeMapper.selectSpasKnowledgeBySubjectId(subjectId);
        if (nodes == null || nodes.isEmpty())
        {
            empty.put("childrenLabel", childrenLabel);
            return empty;
        }
        Map<Long, SpasKnowledge> byId = new HashMap<Long, SpasKnowledge>();
        for (SpasKnowledge kn : nodes)
        {
            if (kn != null && kn.getKnowledgeId() != null)
            {
                byId.put(kn.getKnowledgeId(), kn);
            }
        }

        List<SpasKnowledge> childNodes = new ArrayList<SpasKnowledge>();
        for (SpasKnowledge kn : nodes)
        {
            if (kn == null || !childType.equals(String.valueOf(kn.getNodeType())))
            {
                continue;
            }
            if ("0".equals(kn.getStatus()))
            {
                // status 0 = normal
            }
            else if (kn.getStatus() != null && !"0".equals(kn.getStatus()))
            {
                continue;
            }
            if (subjectAll)
            {
                if (kn.getParentId() != null && kn.getParentId().longValue() != 0L)
                {
                    continue;
                }
                childNodes.add(kn);
            }
            else if (knowledgeId != null)
            {
                if (isUnderParent(kn, knowledgeId))
                {
                    // direct-ish child: parent is knowledgeId, or ancestor contains it and node type matches
                    if (knowledgeId.equals(kn.getParentId()) || isDirectChildOf(kn, knowledgeId, childType, byId))
                    {
                        childNodes.add(kn);
                    }
                }
            }
        }
        // Flat tree fallback: no versions → chapters; no chapters → leaves
        if (childNodes.isEmpty() && subjectAll)
        {
            childType = "1";
            childrenLabel = "\u7ae0\u8282";
            for (SpasKnowledge kn : nodes)
            {
                if (kn != null && "1".equals(String.valueOf(kn.getNodeType()))
                    && (kn.getStatus() == null || "0".equals(kn.getStatus()))
                    && (kn.getParentId() == null || kn.getParentId().longValue() == 0L
                        || isRootish(kn, byId)))
                {
                    childNodes.add(kn);
                }
            }
            if (childNodes.isEmpty())
            {
                childType = "2";
                childrenLabel = "\u77e5\u8bc6\u70b9";
                for (SpasKnowledge kn : nodes)
                {
                    if (kn != null && "2".equals(String.valueOf(kn.getNodeType()))
                        && (kn.getStatus() == null || "0".equals(kn.getStatus())))
                    {
                        childNodes.add(kn);
                    }
                }
            }
        }
        else if (childNodes.isEmpty() && versionMode && knowledgeId != null)
        {
            childType = "2";
            childrenLabel = "\u77e5\u8bc6\u70b9";
            for (SpasKnowledge kn : nodes)
            {
                if (kn != null && "2".equals(String.valueOf(kn.getNodeType()))
                    && (kn.getStatus() == null || "0".equals(kn.getStatus())) && isUnderParent(kn, knowledgeId))
                {
                    childNodes.add(kn);
                }
            }
        }

        Map<Long, Long> leafToChild = new HashMap<Long, Long>();
        for (SpasKnowledge leaf : nodes)
        {
            if (leaf == null || !"2".equals(String.valueOf(leaf.getNodeType())))
            {
                continue;
            }
            if (knowledgeId != null && !subjectAll && !isUnderParent(leaf, knowledgeId))
            {
                continue;
            }
            Long mapped = mapLeafToChild(leaf, childNodes, byId);
            if (mapped != null)
            {
                leafToChild.put(leaf.getKnowledgeId(), mapped);
            }
        }

        List<SpasAnalysisScoreRow> rows = analysisMapper.selectScoreRowsForScope(null, subjectId, examDateFrom, paperIds,
            deptId, null);
        Map<Long, List<SpasAnalysisScoreRow>> byStudent = groupRowsByStudent(rows);

        Map<Long, List<Double>> childRates = new LinkedHashMap<Long, List<Double>>();
        Map<Long, Integer> childWeak = new HashMap<Long, Integer>();
        Map<Long, Integer> childAttempts = new HashMap<Long, Integer>();
        for (SpasKnowledge c : childNodes)
        {
            childRates.put(c.getKnowledgeId(), new ArrayList<Double>());
        }

        List<Map<String, Object>> students = new ArrayList<Map<String, Object>>();
        BigDecimal sum = BigDecimal.ZERO;
        int weakCount = 0;
        int attemptSum = 0;
        int rateN = 0;
        double weakCut = calculator.resolveWeakThreshold();

        for (Map.Entry<Long, List<SpasAnalysisScoreRow>> e : byStudent.entrySet())
        {
            Map<Long, KnowledgeStatCalculator.AggView> map = calculator.aggregateViews(e.getValue());
            // Per-child student rates (attempt-weighted across leaves under child)
            Map<Long, Double> stuChildRate = new HashMap<Long, Double>();
            Map<Long, Integer> stuChildAtt = new HashMap<Long, Integer>();
            Map<Long, Double> stuChildW = new HashMap<Long, Double>();
            BigDecimal rollSumW = BigDecimal.ZERO;
            BigDecimal rollSumR = BigDecimal.ZERO;
            int rollAtt = 0;
            for (Map.Entry<Long, KnowledgeStatCalculator.AggView> ae : map.entrySet())
            {
                Long leafId = ae.getKey();
                Long childId = leafToChild.get(leafId);
                if (childId == null)
                {
                    continue;
                }
                SpasStudentKnowledgeStat st = calculator.toStatView(ae.getValue());
                if (st.getWeightedRate() == null)
                {
                    continue;
                }
                int att = st.getAttemptCount() == null ? 0 : st.getAttemptCount().intValue();
                double rate = st.getWeightedRate().doubleValue();
                double w = att > 0 ? att : 1.0;
                Double prevR = stuChildRate.get(childId);
                Double prevW = stuChildW.get(childId);
                if (prevR == null)
                {
                    stuChildRate.put(childId, rate * w);
                    stuChildW.put(childId, w);
                    stuChildAtt.put(childId, Integer.valueOf(att));
                }
                else
                {
                    stuChildRate.put(childId, prevR.doubleValue() + rate * w);
                    stuChildW.put(childId, prevW.doubleValue() + w);
                    stuChildAtt.put(childId, Integer.valueOf(stuChildAtt.get(childId).intValue() + att));
                }
                rollSumR = rollSumR.add(BigDecimal.valueOf(rate * w));
                rollSumW = rollSumW.add(BigDecimal.valueOf(w));
                rollAtt += att;
            }
            if (rollSumW.compareTo(BigDecimal.ZERO) <= 0)
            {
                continue;
            }
            for (Map.Entry<Long, Double> ce : stuChildRate.entrySet())
            {
                double w = stuChildW.get(ce.getKey()).doubleValue();
                double avg = ce.getValue().doubleValue() / w;
                List<Double> bucket = childRates.get(ce.getKey());
                if (bucket != null)
                {
                    bucket.add(avg);
                }
                if (avg < weakCut)
                {
                    Integer wc = childWeak.get(ce.getKey());
                    childWeak.put(ce.getKey(), wc == null ? Integer.valueOf(1) : Integer.valueOf(wc.intValue() + 1));
                }
                Integer prevA = childAttempts.get(ce.getKey());
                int a = stuChildAtt.get(ce.getKey()) == null ? 0 : stuChildAtt.get(ce.getKey()).intValue();
                childAttempts.put(ce.getKey(), prevA == null ? Integer.valueOf(a) : Integer.valueOf(prevA.intValue() + a));
            }
            BigDecimal stuRate = rollSumR.divide(rollSumW, 6, RoundingMode.HALF_UP);
            Map<String, Object> row = new HashMap<String, Object>();
            row.put("studentId", e.getKey());
            row.put("rate", stuRate);
            row.put("weightedRate", stuRate);
            row.put("attemptCount", Integer.valueOf(rollAtt));
            row.put("weakLevel", calculator.resolveWeakLevel(stuRate, rollAtt));
            SpasStudent st = studentMapper.selectSpasStudentById(e.getKey());
            if (st != null)
            {
                row.put("studentNo", st.getStudentNo());
                row.put("studentName", st.getStudentName());
                row.put("deptId", st.getDeptId());
                row.put("deptName", st.getDeptName());
            }
            students.add(row);
            sum = sum.add(stuRate);
            rateN++;
            if (row.get("weakLevel") != null && !"0".equals(String.valueOf(row.get("weakLevel"))))
            {
                weakCount++;
            }
            attemptSum += rollAtt;
        }
        students.sort((a, b) -> Double.compare(toDouble(a.get("rate")), toDouble(b.get("rate"))));

        List<Map<String, Object>> children = new ArrayList<Map<String, Object>>();
        for (SpasKnowledge c : childNodes)
        {
            List<Double> rates = childRates.get(c.getKnowledgeId());
            if (rates == null || rates.isEmpty())
            {
                continue;
            }
            double s = 0;
            for (Double d : rates)
            {
                s += d.doubleValue();
            }
            Map<String, Object> crow = new HashMap<String, Object>();
            crow.put("knowledgeId", c.getKnowledgeId());
            crow.put("knowledgeName", c.getKnowledgeName());
            crow.put("nodeType", c.getNodeType());
            crow.put("avgRate", BigDecimal.valueOf(s / rates.size()).setScale(6, RoundingMode.HALF_UP));
            crow.put("studentCount", Integer.valueOf(rates.size()));
            crow.put("weakCount", childWeak.get(c.getKnowledgeId()) == null ? Integer.valueOf(0)
                : childWeak.get(c.getKnowledgeId()));
            Integer attSum = childAttempts.get(c.getKnowledgeId());
            if (attSum != null && rates.size() > 0)
            {
                crow.put("avgAttemptCount",
                    BigDecimal.valueOf(attSum.doubleValue() / rates.size()).setScale(2, RoundingMode.HALF_UP));
            }
            children.add(crow);
        }
        children.sort((a, b) -> Double.compare(toDouble(a.get("avgRate")), toDouble(b.get("avgRate"))));

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("students", students);
        result.put("children", children);
        result.put("childrenLabel", childrenLabel);
        result.put("studentCount", Integer.valueOf(students.size()));
        result.put("weakStudentCount", Integer.valueOf(weakCount));
        if (rateN > 0)
        {
            result.put("avgRate", sum.divide(new BigDecimal(rateN), 4, RoundingMode.HALF_UP));
        }
        if (!students.isEmpty())
        {
            result.put("avgAttemptCount",
                new BigDecimal(attemptSum).divide(new BigDecimal(students.size()), 2, RoundingMode.HALF_UP));
        }
        return result;
    }

    private static boolean isUnderParent(SpasKnowledge kn, Long parentId)
    {
        if (kn == null || parentId == null)
        {
            return false;
        }
        if (parentId.equals(kn.getParentId()) || parentId.equals(kn.getKnowledgeId()))
        {
            return true;
        }
        String anc = kn.getAncestors();
        if (anc == null || anc.isEmpty())
        {
            return false;
        }
        for (String p : anc.split(","))
        {
            if (parentId.toString().equals(p.trim()))
            {
                return true;
            }
        }
        return false;
    }

    private static boolean isDirectChildOf(SpasKnowledge kn, Long parentId, String childType,
        Map<Long, SpasKnowledge> byId)
    {
        if (parentId.equals(kn.getParentId()))
        {
            return true;
        }
        // Accept nodes whose nearest ancestor of this type sits under parent
        Long walk = kn.getParentId();
        while (walk != null && byId.containsKey(walk))
        {
            SpasKnowledge p = byId.get(walk);
            if (childType.equals(String.valueOf(p.getNodeType())))
            {
                return parentId.equals(p.getKnowledgeId()) || isUnderParent(p, parentId);
            }
            if (parentId.equals(walk))
            {
                return true;
            }
            walk = p.getParentId();
        }
        return false;
    }

    private static boolean isRootish(SpasKnowledge kn, Map<Long, SpasKnowledge> byId)
    {
        Long pid = kn.getParentId();
        if (pid == null || pid.longValue() == 0L)
        {
            return true;
        }
        SpasKnowledge p = byId.get(pid);
        return p == null || "0".equals(String.valueOf(p.getNodeType()));
    }

    private static Long mapLeafToChild(SpasKnowledge leaf, List<SpasKnowledge> childNodes,
        Map<Long, SpasKnowledge> byId)
    {
        if (leaf == null || childNodes == null || childNodes.isEmpty())
        {
            return null;
        }
        Set<Long> childIds = new HashSet<Long>();
        for (SpasKnowledge c : childNodes)
        {
            childIds.add(c.getKnowledgeId());
        }
        if (childIds.contains(leaf.getKnowledgeId()))
        {
            return leaf.getKnowledgeId();
        }
        if (leaf.getParentId() != null && childIds.contains(leaf.getParentId()))
        {
            return leaf.getParentId();
        }
        String anc = leaf.getAncestors();
        if (anc != null)
        {
            String[] parts = anc.split(",");
            // Prefer nearest ancestor that is a listed child
            for (int i = parts.length - 1; i >= 0; i--)
            {
                String p = parts[i].trim();
                if (p.isEmpty())
                {
                    continue;
                }
                try
                {
                    Long id = Long.valueOf(p);
                    if (childIds.contains(id))
                    {
                        return id;
                    }
                }
                catch (Exception ignored)
                {
                }
            }
        }
        return null;
    }
}
