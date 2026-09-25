package com.ruoyi.spas.warning;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.alibaba.fastjson2.JSON;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.analysis.KnowledgeStatQueryService;
import com.ruoyi.spas.domain.SpasSubject;
import com.ruoyi.spas.domain.SpasWarningRecord;
import com.ruoyi.spas.domain.SpasWarningRule;
import com.ruoyi.spas.domain.SpasExamRankPoint;
import com.ruoyi.spas.mapper.SpasExamScoreMapper;
import com.ruoyi.spas.mapper.SpasSubjectMapper;
import com.ruoyi.spas.mapper.SpasWarningMetricMapper;
import com.ruoyi.spas.mapper.SpasWarningRecordMapper;
import com.ruoyi.spas.mapper.SpasWarningRuleMapper;
import com.ruoyi.spas.support.SpasAnalysisWindowHelper;
import com.ruoyi.spas.config.SpasWarningNotifyProperties;
import com.ruoyi.system.domain.SysNotice;
import com.ruoyi.system.service.ISysNoticeService;

/**
 * Evaluate warning rules and create open records (dedup by student+rule).
 */
@Component
public class WarningEngine
{
    private static final Logger log = LoggerFactory.getLogger(WarningEngine.class);

    @Autowired
    private SpasWarningRuleMapper ruleMapper;

    @Autowired
    private SpasWarningRecordMapper recordMapper;

    @Autowired
    private SpasWarningMetricMapper metricMapper;

    @Autowired
    private SpasExamScoreMapper examScoreMapper;

    @Autowired
    private SpasSubjectMapper subjectMapper;

    @Autowired
    private KnowledgeStatQueryService knowledgeStatQueryService;

    @Autowired
    private SpasAnalysisWindowHelper windowHelper;

    @Autowired
    private ISysNoticeService noticeService;

    @Autowired(required = false)
    private SpasWarningNotifyProperties warningNotifyProperties;

    /** Current analysis window label written into reason_json (e.g. semester / all). */
    private String activeAnalysisWindow = "all";

    /** Optional override for evaluateAllEnabled / evaluateAfterPaper (null = default-window). */
    private final ThreadLocal<String> windowOverride = new ThreadLocal<>();

    public int evaluateAllEnabled()
    {
        return evaluateAllEnabled(null);
    }

    public int evaluateAllEnabled(String window)
    {
        try
        {
            if (StringUtils.isNotEmpty(window))
            {
                windowOverride.set(window);
            }
            List<SpasWarningRule> rules = ruleMapper.selectEnabledRules();
            int created = 0;
            for (SpasWarningRule rule : rules)
            {
                created += evaluateRule(rule, null);
            }
            log.info("WarningEngine evaluateAllEnabled window={} created={}",
                windowOverride.get() != null ? windowOverride.get() : windowHelper.getDefaultWindow(), created);
            return created;
        }
        finally
        {
            windowOverride.remove();
        }
    }

    public int evaluateAfterPaper(Long paperId)
    {
        return evaluateAfterPaper(paperId, null);
    }

    public int evaluateAfterPaper(Long paperId, String window)
    {
        if (paperId == null)
        {
            return 0;
        }
        List<Long> studentIds = metricMapper.selectStudentIdsByPaper(paperId);
        if (studentIds == null || studentIds.isEmpty())
        {
            return 0;
        }
        Set<Long> focus = new HashSet<>(studentIds);
        try
        {
            if (StringUtils.isNotEmpty(window))
            {
                windowOverride.set(window);
            }
            List<SpasWarningRule> rules = ruleMapper.selectEnabledRules();
            int created = 0;
            for (SpasWarningRule rule : rules)
            {
                created += evaluateRule(rule, focus);
            }
            log.info("WarningEngine evaluateAfterPaper paperId={} window={} created={}", paperId,
                windowOverride.get() != null ? windowOverride.get() : windowHelper.getDefaultWindow(), created);
            return created;
        }
        finally
        {
            windowOverride.remove();
        }
    }

    /** Re-evaluate only school-rank rules after an exam roster import. */
    public int evaluateExamRankRules()
    {
        List<SpasWarningRule> rules = ruleMapper.selectEnabledRules();
        int created = 0;
        if (rules == null)
        {
            return 0;
        }
        for (SpasWarningRule rule : rules)
        {
            String metric = rule.getMetric();
            if ("RANK_DROP".equals(metric) || "SUBJECT_IMBALANCE".equals(metric))
            {
                created += evaluateRule(rule, null);
            }
        }
        log.info("WarningEngine evaluateExamRankRules created={}", created);
        return created;
    }

    private int evaluateRule(SpasWarningRule rule, Set<Long> focusStudentIds)
    {
        Long subjectId = null;
        Long deptId = null;
        // scope_type: 1=global, 3=dept, 4=subject
        if ("4".equals(rule.getScopeType()))
        {
            subjectId = rule.getScopeId();
        }
        else if ("3".equals(rule.getScopeType()))
        {
            deptId = rule.getScopeId();
        }

        String window = windowOverride.get();
        if (StringUtils.isEmpty(window))
        {
            window = windowHelper.getDefaultWindow();
        }
        Date examDateFrom = windowHelper.resolveExamDateFrom(window);
        activeAnalysisWindow = examDateFrom == null ? "all" : windowHelper.normalize(window);

        List<Map<String, Object>> rows;
        String metric = rule.getMetric();
        if ("WEAK_COUNT".equals(metric))
        {
            rows = loadMetricRows("WEAK_COUNT", subjectId, deptId, examDateFrom);
        }
        else if ("BELOW_CLASS_AVG".equals(metric))
        {
            rows = loadMetricRows("BELOW_CLASS_AVG", subjectId, deptId, examDateFrom);
        }
        else if ("CONTINUOUS_DROP".equals(metric))
        {
            return evaluateContinuousDrop(rule, focusStudentIds, subjectId, deptId, examDateFrom);
        }
        else if ("PERSISTENT_WEAK".equals(metric))
        {
            return evaluatePersistentWeak(rule, focusStudentIds, subjectId, deptId, examDateFrom);
        }
        else if ("KNOWLEDGE_CONTINUOUS_DROP".equals(metric))
        {
            return evaluateKnowledgeContinuousDrop(rule, focusStudentIds, subjectId, deptId, examDateFrom);
        }
        else if ("RANK_DROP".equals(metric))
        {
            return evaluateRankDrop(rule, focusStudentIds, deptId);
        }
        else if ("SUBJECT_IMBALANCE".equals(metric))
        {
            return evaluateSubjectImbalance(rule, focusStudentIds, subjectId, deptId);
        }
        else
        {
            rows = loadMetricRows("AVG_RATE", subjectId, deptId, examDateFrom);
        }

        Set<Long> matched = new HashSet<>();
        int created = 0;
        for (Map<String, Object> row : rows)
        {
            Long studentId = toLong(row.get("studentId"));
            if (studentId == null)
            {
                continue;
            }
            if (focusStudentIds != null && !focusStudentIds.contains(studentId))
            {
                continue;
            }
            BigDecimal value = toDecimal(row.get("metricValue"));
            if (value == null)
            {
                continue;
            }
            if (!match(value, resolveOperator(metric, rule.getOperator()), rule.getThreshold()))
            {
                continue;
            }
            matched.add(studentId);
            if (createIfAbsent(rule, studentId, toLong(row.get("subjectId")), value, row.get("studentName"),
                resolvePrimaryWeakKnowledgeId(studentId, toLong(row.get("subjectId")))))
            {
                created++;
            }
        }
        // Close open records when condition no longer holds
        Set<Long> toCheck = focusStudentIds;
        if (toCheck == null)
        {
            List<Long> openIds = recordMapper.selectOpenStudentIdsByRule(rule.getRuleId());
            toCheck = openIds == null ? new HashSet<>() : new HashSet<>(openIds);
        }
        for (Long sid : toCheck)
        {
            if (!matched.contains(sid))
            {
                closeOpenRecord(sid, rule.getRuleId());
            }
        }
        return created;
    }

    private List<Map<String, Object>> loadMetricRows(String metric, Long subjectId, Long deptId, Date examDateFrom)
    {
        if (examDateFrom != null)
        {
            return knowledgeStatQueryService.warningStudentMetrics(metric, subjectId, deptId, examDateFrom);
        }
        if ("WEAK_COUNT".equals(metric))
        {
            return metricMapper.selectStudentWeakCount(subjectId, deptId);
        }
        if ("BELOW_CLASS_AVG".equals(metric))
        {
            return metricMapper.selectStudentVsClassGap(subjectId, deptId);
        }
        return metricMapper.selectStudentAvgRate(subjectId, deptId);
    }

    private int evaluateContinuousDrop(SpasWarningRule rule, Set<Long> focusStudentIds, Long subjectId, Long deptId,
        Date examDateFrom)
    {
        List<Map<String, Object>> students = loadMetricRows("AVG_RATE", subjectId, deptId, examDateFrom);
        int n = rule.getWindowDays() != null && rule.getWindowDays() > 0 ? Math.min(rule.getWindowDays(), 30) : 3;
        Map<Long, List<Map<String, Object>>> ratesByStudent = new HashMap<>();
        List<Map<String, Object>> bulk = metricMapper.selectDeptStudentPaperRates(subjectId, deptId, n, examDateFrom);
        if (bulk != null)
        {
            for (Map<String, Object> row : bulk)
            {
                Long sid = toLong(row.get("studentId"));
                if (sid == null)
                {
                    continue;
                }
                ratesByStudent.computeIfAbsent(sid, k -> new ArrayList<>()).add(row);
            }
        }
        Set<Long> matched = new HashSet<>();
        int created = 0;
        for (Map<String, Object> stu : students)
        {
            Long studentId = toLong(stu.get("studentId"));
            if (studentId == null)
            {
                continue;
            }
            if (focusStudentIds != null && !focusStudentIds.contains(studentId))
            {
                continue;
            }
            List<Map<String, Object>> rates = ratesByStudent.get(studentId);
            if (rates == null || rates.size() < n)
            {
                continue;
            }
            List<BigDecimal> seq = new ArrayList<>();
            // bulk query returns oldest→newest by rn asc? We ordered by rn ascending (1=most recent).
            // Original selectStudentPaperRates was exam_date desc; then reversed into chronological seq.
            // ranked rn=1 is most recent; for chronological first→last we need reverse of rates list.
            for (int i = rates.size() - 1; i >= 0; i--)
            {
                seq.add(toDecimal(rates.get(i).get("rate")));
            }
            boolean drop = true;
            for (int i = 1; i < seq.size(); i++)
            {
                if (seq.get(i - 1) == null || seq.get(i) == null || seq.get(i).compareTo(seq.get(i - 1)) >= 0)
                {
                    drop = false;
                    break;
                }
            }
            if (!drop)
            {
                continue;
            }
            BigDecimal first = seq.get(0);
            BigDecimal last = seq.get(seq.size() - 1);
            BigDecimal dropSpan = first.subtract(last);
            String op = resolveOperator("CONTINUOUS_DROP", rule.getOperator());
            if (rule.getThreshold() != null && !match(dropSpan, op, rule.getThreshold()))
            {
                continue;
            }
            matched.add(studentId);
            if (createIfAbsent(rule, studentId, subjectId, dropSpan, stu.get("studentName"),
                resolvePrimaryWeakKnowledgeId(studentId, subjectId)))
            {
                created++;
            }
        }
        Set<Long> toCheck = focusStudentIds;
        if (toCheck == null)
        {
            List<Long> openIds = recordMapper.selectOpenStudentIdsByRule(rule.getRuleId());
            toCheck = openIds == null ? new HashSet<>() : new HashSet<>(openIds);
        }
        for (Long sid : toCheck)
        {
            if (!matched.contains(sid))
            {
                closeOpenRecord(sid, rule.getRuleId());
            }
        }
        return created;
    }

    /**
     * PERSISTENT_WEAK: metricValue = count of knowledges tagged as persistent weak.
     * windowDays = minPapers (default from config via query service).
     */
    private int evaluatePersistentWeak(SpasWarningRule rule, Set<Long> focusStudentIds, Long subjectId, Long deptId,
        Date examDateFrom)
    {
        List<Map<String, Object>> students = loadMetricRows("AVG_RATE", subjectId, deptId, examDateFrom);
        int minPapers = rule.getWindowDays() != null && rule.getWindowDays() > 0
            ? Math.min(rule.getWindowDays(), 30) : knowledgeStatQueryService.getPersistMinPapers();
        Set<Long> matched = new HashSet<>();
        int created = 0;
        for (Map<String, Object> stu : students)
        {
            Long studentId = toLong(stu.get("studentId"));
            if (studentId == null)
            {
                continue;
            }
            if (focusStudentIds != null && !focusStudentIds.contains(studentId))
            {
                continue;
            }
            List<Map<String, Object>> tags = knowledgeStatQueryService.persistentWeak(studentId, subjectId, null,
                examDateFrom, Integer.valueOf(minPapers), null, null);
            int persistCount = 0;
            Long primaryKid = null;
            if (tags != null)
            {
                for (Map<String, Object> t : tags)
                {
                    if ("\u53cd\u590d\u8584\u5f31".equals(String.valueOf(t.get("persistTag"))))
                    {
                        persistCount++;
                        if (primaryKid == null)
                        {
                            primaryKid = toLong(t.get("knowledgeId"));
                        }
                    }
                }
            }
            BigDecimal value = BigDecimal.valueOf(persistCount);
            String op = resolveOperator("PERSISTENT_WEAK", rule.getOperator());
            if (!match(value, op, rule.getThreshold()))
            {
                continue;
            }
            matched.add(studentId);
            if (primaryKid == null)
            {
                primaryKid = resolvePrimaryWeakKnowledgeId(studentId, subjectId);
            }
            if (createIfAbsent(rule, studentId, subjectId, value, stu.get("studentName"), primaryKid))
            {
                created++;
            }
        }
        Set<Long> toCheck = focusStudentIds;
        if (toCheck == null)
        {
            List<Long> openIds = recordMapper.selectOpenStudentIdsByRule(rule.getRuleId());
            toCheck = openIds == null ? new HashSet<>() : new HashSet<>(openIds);
        }
        for (Long sid : toCheck)
        {
            if (!matched.contains(sid))
            {
                closeOpenRecord(sid, rule.getRuleId());
            }
        }
        return created;
    }

    private int evaluateKnowledgeContinuousDrop(SpasWarningRule rule, Set<Long> focusStudentIds, Long subjectId,
        Long deptId, Date examDateFrom)
    {
        List<Map<String, Object>> students = loadMetricRows("AVG_RATE", subjectId, deptId, examDateFrom);
        int n = rule.getWindowDays() != null && rule.getWindowDays() > 0 ? Math.min(rule.getWindowDays(), 30) : 3;
        if (n < 2)
        {
            n = 2;
        }
        Set<Long> matched = new HashSet<>();
        int created = 0;
        for (Map<String, Object> stu : students)
        {
            Long studentId = toLong(stu.get("studentId"));
            if (studentId == null)
            {
                continue;
            }
            if (focusStudentIds != null && !focusStudentIds.contains(studentId))
            {
                continue;
            }
            int dropCount = knowledgeStatQueryService.countKnowledgeContinuousDrop(studentId, subjectId, n,
                examDateFrom);
            BigDecimal value = BigDecimal.valueOf(dropCount);
            String op = resolveOperator("KNOWLEDGE_CONTINUOUS_DROP", rule.getOperator());
            if (!match(value, op, rule.getThreshold()))
            {
                continue;
            }
            matched.add(studentId);
            if (createIfAbsent(rule, studentId, subjectId, value, stu.get("studentName"),
                resolvePrimaryWeakKnowledgeId(studentId, subjectId)))
            {
                created++;
            }
        }
        Set<Long> toCheck = focusStudentIds;
        if (toCheck == null)
        {
            List<Long> openIds = recordMapper.selectOpenStudentIdsByRule(rule.getRuleId());
            toCheck = openIds == null ? new HashSet<>() : new HashSet<>(openIds);
        }
        for (Long sid : toCheck)
        {
            if (!matched.contains(sid))
            {
                closeOpenRecord(sid, rule.getRuleId());
            }
        }
        return created;
    }

    private int evaluateRankDrop(SpasWarningRule rule, Set<Long> focusStudentIds, Long deptId)
    {
        int window = rule.getWindowDays() == null || rule.getWindowDays().intValue() < 2 ? 3 : rule.getWindowDays().intValue();
        List<ExamRankMetrics.Hit> hits = ExamRankMetrics.rankDrop(examScoreMapper.selectRankPoints(), deptId, window);
        return applyRankHits(rule, focusStudentIds, null, hits);
    }

    private int evaluateSubjectImbalance(SpasWarningRule rule, Set<Long> focusStudentIds, Long subjectId, Long deptId)
    {
        String subjectName = null;
        if (subjectId != null)
        {
            SpasSubject subject = subjectMapper.selectSpasSubjectById(subjectId);
            if (subject != null)
            {
                subjectName = subject.getSubjectName();
            }
        }
        List<ExamRankMetrics.Hit> hits = ExamRankMetrics.subjectImbalance(examScoreMapper.selectRankPoints(), deptId, subjectName);
        return applyRankHits(rule, focusStudentIds, subjectId, hits);
    }

    private int applyRankHits(SpasWarningRule rule, Set<Long> focusStudentIds, Long subjectId, List<ExamRankMetrics.Hit> hits)
    {
        Set<Long> matched = new HashSet<>();
        int created = 0;
        if (hits != null)
        {
            for (ExamRankMetrics.Hit hit : hits)
            {
                if (hit.getStudentId() == null)
                {
                    continue;
                }
                if (focusStudentIds != null && !focusStudentIds.contains(hit.getStudentId()))
                {
                    continue;
                }
                if (hit.getMetricValue() == null)
                {
                    continue;
                }
                if (!match(hit.getMetricValue(), resolveOperator(rule.getMetric(), rule.getOperator()), rule.getThreshold()))
                {
                    continue;
                }
                matched.add(hit.getStudentId());
                Long boundSubjectId = resolveSubjectIdByName(hit.getSubjectName(), subjectId);
                Long knowledgeId = resolvePrimaryWeakKnowledgeId(hit.getStudentId(), boundSubjectId);
                if (createIfAbsent(rule, hit.getStudentId(), boundSubjectId, hit.getMetricValue(), hit.getStudentName(), knowledgeId,
                    hit.getDetail()))
                {
                    created++;
                }
            }
        }
        Set<Long> toCheck = focusStudentIds;
        if (toCheck == null)
        {
            List<Long> openIds = recordMapper.selectOpenStudentIdsByRule(rule.getRuleId());
            toCheck = openIds == null ? new HashSet<>() : new HashSet<>(openIds);
        }
        for (Long sid : toCheck)
        {
            if (!matched.contains(sid))
            {
                closeOpenRecord(sid, rule.getRuleId());
            }
        }
        return created;
    }

    private Long resolveSubjectIdByName(String excelName, Long fallback)
    {
        if (StringUtils.isEmpty(excelName))
        {
            return fallback;
        }
        List<com.ruoyi.spas.domain.SpasSubject> all = subjectMapper.selectSpasSubjectAll();
        if (all == null)
        {
            return fallback;
        }
        for (com.ruoyi.spas.domain.SpasSubject subject : all)
        {
            if (subject != null && com.ruoyi.spas.support.SubjectAlias.same(excelName, subject.getSubjectName()))
            {
                return subject.getSubjectId();
            }
        }
        return fallback;
    }

    /**
     * Default operators by metric:
     * AVG_RATE: rate below threshold -> &lt;
     * WEAK_COUNT / BELOW_CLASS_AVG / CONTINUOUS_DROP / PERSISTENT_WEAK: magnitude above threshold -> &gt;
     * BELOW_CLASS_AVG metricValue = class_rate - stu_rate (larger = more below class)
     */
    private String resolveOperator(String metric, String configured)
    {
        if (StringUtils.isNotEmpty(configured))
        {
            String op = configured.trim();
            // Legacy seed/configs used "<" for BELOW_CLASS_AVG; treat as ">"
            if ("BELOW_CLASS_AVG".equals(metric) && "<".equals(op))
            {
                return ">";
            }
            return op;
        }
        if ("WEAK_COUNT".equals(metric) || "BELOW_CLASS_AVG".equals(metric) || "CONTINUOUS_DROP".equals(metric)
            || "PERSISTENT_WEAK".equals(metric) || "KNOWLEDGE_CONTINUOUS_DROP".equals(metric)
            || "RANK_DROP".equals(metric) || "SUBJECT_IMBALANCE".equals(metric))
        {
            return ">";
        }
        return "<";
    }

    private void closeOpenRecord(Long studentId, Long ruleId)
    {
        SpasWarningRecord open = recordMapper.selectOpenRecord(studentId, ruleId);
        if (open == null)
        {
            return;
        }
        open.setStatus("2");
        open.setHandleBy("system");
        open.setHandleTime(new java.util.Date());
        open.setHandleRemark("条件已消除，系统自动关闭");
        recordMapper.updateSpasWarningRecord(open);
    }

    private boolean createIfAbsent(SpasWarningRule rule, Long studentId, Long subjectId, BigDecimal value,
        Object studentName)
    {
        return createIfAbsent(rule, studentId, subjectId, value, studentName, null);
    }

    private boolean createIfAbsent(SpasWarningRule rule, Long studentId, Long subjectId, BigDecimal value,
        Object studentName, Long knowledgeId)
    {
        return createIfAbsent(rule, studentId, subjectId, value, studentName, knowledgeId, null);
    }

    private boolean createIfAbsent(SpasWarningRule rule, Long studentId, Long subjectId, BigDecimal value,
        Object studentName, Long knowledgeId, String detail)
    {
        SpasWarningRecord open = recordMapper.selectOpenRecord(studentId, rule.getRuleId());
        if (open != null)
        {
            open.setMetricValue(value);
            open.setContent(buildContent(rule, value, studentName, detail));
            open.setReasonJson(buildReasonJson(rule, value, studentName, knowledgeId, detail));
            if (open.getKnowledgeId() == null && knowledgeId != null)
            {
                open.setKnowledgeId(knowledgeId);
            }
            recordMapper.updateSpasWarningRecord(open);
            return false;
        }
        SpasWarningRecord rec = new SpasWarningRecord();
        rec.setRuleId(rule.getRuleId());
        rec.setStudentId(studentId);
        rec.setSubjectId(subjectId);
        rec.setKnowledgeId(knowledgeId);
        rec.setLevel(StringUtils.isNotEmpty(rule.getLevel()) ? rule.getLevel() : "1");
        rec.setTitle(rule.getRuleName());
        rec.setContent(buildContent(rule, value, studentName, detail));
        rec.setReasonJson(buildReasonJson(rule, value, studentName, knowledgeId, detail));
        rec.setMetricValue(value);
        rec.setStatus("0");
        recordMapper.insertSpasWarningRecord(rec);
        dispatchNotice(rule, rec);
        return true;
    }

    /** Worst weak knowledge for intervene binding; null if none. */
    private Long resolvePrimaryWeakKnowledgeId(Long studentId, Long subjectId)
    {
        if (studentId == null)
        {
            return null;
        }
        try
        {
            List<Map<String, Object>> weak = knowledgeStatQueryService.studentWeakTop(studentId, subjectId, 1, null,
                null);
            if (weak == null || weak.isEmpty())
            {
                return null;
            }
            return toLong(weak.get(0).get("knowledgeId") != null ? weak.get(0).get("knowledgeId") : weak.get(0).get("id"));
        }
        catch (Exception e)
        {
            log.debug("resolvePrimaryWeakKnowledgeId failed studentId={}: {}", studentId, e.getMessage());
            return null;
        }
    }

    private void dispatchNotice(SpasWarningRule rule, SpasWarningRecord rec)
    {
        String channels = rule.getNotifyChannels();
        if (StringUtils.isEmpty(channels))
        {
            return;
        }
        if (channels.contains("system"))
        {
            try
            {
                SysNotice notice = new SysNotice();
                notice.setNoticeTitle("学情预警：" + rule.getRuleName());
                notice.setNoticeType("1");
                notice.setNoticeContent(rec.getContent());
                notice.setStatus("0");
                notice.setCreateBy("system");
                noticeService.insertNotice(notice);
            }
            catch (Exception e)
            {
                log.warn("Failed to publish warning notice ruleId={}", rule.getRuleId(), e);
            }
        }
        if (channels.contains("webhook"))
        {
            dispatchWebhook(rule, rec);
        }
    }

    private void dispatchWebhook(SpasWarningRule rule, SpasWarningRecord rec)
    {
        if (warningNotifyProperties == null || !warningNotifyProperties.isWebhookEnabled())
        {
            log.warn("Warning webhook channel selected but spas.warning.webhook-url is empty; skip ruleId={}",
                rule.getRuleId());
            return;
        }
        java.net.HttpURLConnection conn = null;
        try
        {
            Map<String, Object> body = new LinkedHashMap<String, Object>();
            body.put("ruleId", rule.getRuleId());
            body.put("ruleName", rule.getRuleName());
            body.put("ruleCode", rule.getRuleCode());
            body.put("level", rule.getLevel());
            body.put("content", rec.getContent());
            body.put("studentId", rec.getStudentId());
            body.put("metricValue", rec.getMetricValue());
            body.put("recordId", rec.getWarningId());
            body.put("source", "spas-warning");
            byte[] bytes = JSON.toJSONBytes(body);
            java.net.URL url = new java.net.URL(warningNotifyProperties.getWebhookUrl());
            conn = (java.net.HttpURLConnection) url.openConnection();
            conn.setConnectTimeout(warningNotifyProperties.getWebhookTimeoutMs());
            conn.setReadTimeout(warningNotifyProperties.getWebhookTimeoutMs());
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
            conn.getOutputStream().write(bytes);
            int code = conn.getResponseCode();
            if (code < 200 || code >= 300)
            {
                log.warn("Warning webhook HTTP {} ruleId={}", Integer.valueOf(code), rule.getRuleId());
            }
        }
        catch (Exception e)
        {
            log.warn("Warning webhook failed ruleId={}: {}", rule.getRuleId(), e.getMessage());
        }
        finally
        {
            if (conn != null)
            {
                conn.disconnect();
            }
        }
    }

    private String buildContent(SpasWarningRule rule, BigDecimal value, Object studentName)
    {
        return buildContent(rule, value, studentName, null);
    }

    private String buildContent(SpasWarningRule rule, BigDecimal value, Object studentName, String detail)
    {
        String name = studentName == null ? "-" : studentName.toString();
        String metric = rule.getMetric();
        String op = resolveOperator(metric, rule.getOperator());
        String metricLabel = metricLabel(metric);
        String valueText = formatMetricDisplay(metric, value);
        String thresholdText = formatMetricDisplay(metric, rule.getThreshold());
        String extra = StringUtils.isEmpty(detail) ? "" : "。" + detail;
        return String.format("学生%s触发「%s」：%s 当前=%s，条件 %s %s（规则码 %s，口径 %s）%s",
            name, rule.getRuleName(), metricLabel, valueText, op, thresholdText, rule.getRuleCode(),
            activeAnalysisWindow, extra);
    }

    private String buildReasonJson(SpasWarningRule rule, BigDecimal value, Object studentName)
    {
        return buildReasonJson(rule, value, studentName, null);
    }

    private String buildReasonJson(SpasWarningRule rule, BigDecimal value, Object studentName, Long knowledgeId)
    {
        return buildReasonJson(rule, value, studentName, knowledgeId, null);
    }

    private String buildReasonJson(SpasWarningRule rule, BigDecimal value, Object studentName, Long knowledgeId, String detail)
    {
        Map<String, Object> reason = new LinkedHashMap<String, Object>();
        reason.put("studentName", studentName == null ? "-" : studentName.toString());
        reason.put("ruleId", rule.getRuleId());
        reason.put("ruleCode", rule.getRuleCode());
        reason.put("ruleName", rule.getRuleName());
        reason.put("metric", rule.getMetric());
        reason.put("metricLabel", metricLabel(rule.getMetric()));
        reason.put("operator", resolveOperator(rule.getMetric(), rule.getOperator()));
        reason.put("threshold", rule.getThreshold());
        reason.put("metricValue", value);
        reason.put("windowDays", rule.getWindowDays());
        reason.put("analysisWindow", activeAnalysisWindow);
        reason.put("level", rule.getLevel());
        if (knowledgeId != null)
        {
            reason.put("knowledgeId", knowledgeId);
        }
        if (StringUtils.isNotEmpty(detail))
        {
            reason.put("detail", detail);
        }
        return JSON.toJSONString(reason);
    }

    private String metricLabel(String metric)
    {
        if ("AVG_RATE".equals(metric))
        {
            return "综合得分率";
        }
        if ("WEAK_COUNT".equals(metric))
        {
            return "薄弱知识点数";
        }
        if ("BELOW_CLASS_AVG".equals(metric))
        {
            return "低于班均幅度";
        }
        if ("CONTINUOUS_DROP".equals(metric))
        {
            return "连续考试得分率降幅";
        }
        if ("PERSISTENT_WEAK".equals(metric))
        {
            return "\u53cd\u590d\u8584\u5f31\u77e5\u8bc6\u70b9\u6570";
        }
        if ("KNOWLEDGE_CONTINUOUS_DROP".equals(metric))
        {
            return "知识点连续下滑数";
        }
        if ("RANK_DROP".equals(metric))
        {
            return "总分校次退步名次";
        }
        if ("SUBJECT_IMBALANCE".equals(metric))
        {
            return "单科落后总分名次";
        }
        return metric == null ? "-" : metric;
    }

    private String formatMetricDisplay(String metric, BigDecimal value)
    {
        if (value == null)
        {
            return "-";
        }
        if ("AVG_RATE".equals(metric) || "BELOW_CLASS_AVG".equals(metric) || "CONTINUOUS_DROP".equals(metric))
        {
            return value.multiply(new BigDecimal("100")).setScale(1, java.math.RoundingMode.HALF_UP) + "%";
        }
        return value.stripTrailingZeros().toPlainString();
    }

    private boolean match(BigDecimal value, String operator, BigDecimal threshold)
    {
        if (threshold == null)
        {
            return false;
        }
        String op = StringUtils.isEmpty(operator) ? "<" : operator.trim();
        int cmp = value.compareTo(threshold);
        switch (op)
        {
            case "<=": return cmp <= 0;
            case ">": return cmp > 0;
            case ">=": return cmp >= 0;
            case "=":
            case "==": return cmp == 0;
            case "<":
            default: return cmp < 0;
        }
    }

    private Long toLong(Object v)
    {
        if (v == null)
        {
            return null;
        }
        if (v instanceof Number)
        {
            return ((Number) v).longValue();
        }
        try
        {
            return Long.parseLong(v.toString());
        }
        catch (Exception e)
        {
            return null;
        }
    }

    private BigDecimal toDecimal(Object v)
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
}
