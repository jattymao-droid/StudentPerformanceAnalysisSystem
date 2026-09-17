package com.ruoyi.spas.warning;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasWarningRecord;
import com.ruoyi.spas.domain.SpasWarningRule;
import com.ruoyi.spas.mapper.SpasWarningMetricMapper;
import com.ruoyi.spas.mapper.SpasWarningRecordMapper;
import com.ruoyi.spas.mapper.SpasWarningRuleMapper;
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
    private ISysNoticeService noticeService;

    public int evaluateAllEnabled()
    {
        List<SpasWarningRule> rules = ruleMapper.selectEnabledRules();
        int created = 0;
        for (SpasWarningRule rule : rules)
        {
            created += evaluateRule(rule, null);
        }
        log.info("WarningEngine evaluateAllEnabled created={}", created);
        return created;
    }

    public int evaluateAfterPaper(Long paperId)
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
        List<SpasWarningRule> rules = ruleMapper.selectEnabledRules();
        int created = 0;
        for (SpasWarningRule rule : rules)
        {
            created += evaluateRule(rule, focus);
        }
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

        List<Map<String, Object>> rows;
        String metric = rule.getMetric();
        if ("WEAK_COUNT".equals(metric))
        {
            rows = metricMapper.selectStudentWeakCount(subjectId, deptId);
        }
        else if ("BELOW_CLASS_AVG".equals(metric))
        {
            rows = metricMapper.selectStudentVsClassGap(subjectId, deptId);
        }
        else if ("CONTINUOUS_DROP".equals(metric))
        {
            return evaluateContinuousDrop(rule, focusStudentIds, subjectId, deptId);
        }
        else
        {
            rows = metricMapper.selectStudentAvgRate(subjectId, deptId);
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
            if (createIfAbsent(rule, studentId, toLong(row.get("subjectId")), value, row.get("studentName")))
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

    private int evaluateContinuousDrop(SpasWarningRule rule, Set<Long> focusStudentIds, Long subjectId, Long deptId)
    {
        List<Map<String, Object>> students = metricMapper.selectStudentAvgRate(subjectId, deptId);
        int n = rule.getWindowDays() != null && rule.getWindowDays() > 0 ? Math.min(rule.getWindowDays(), 30) : 3;
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
            List<Map<String, Object>> rates = metricMapper.selectStudentPaperRates(studentId, subjectId, n);
            if (rates == null || rates.size() < n)
            {
                continue;
            }
            List<BigDecimal> seq = new ArrayList<>();
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
            if (createIfAbsent(rule, studentId, subjectId, dropSpan, stu.get("studentName")))
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
     * Default operators by metric:
     * AVG_RATE: rate below threshold -> &lt;
     * WEAK_COUNT / BELOW_CLASS_AVG / CONTINUOUS_DROP: magnitude above threshold -> &gt;
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
        if ("WEAK_COUNT".equals(metric) || "BELOW_CLASS_AVG".equals(metric) || "CONTINUOUS_DROP".equals(metric))
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

    private boolean createIfAbsent(SpasWarningRule rule, Long studentId, Long subjectId, BigDecimal value, Object studentName)
    {
        SpasWarningRecord open = recordMapper.selectOpenRecord(studentId, rule.getRuleId());
        if (open != null)
        {
            open.setMetricValue(value);
            open.setContent(buildContent(rule, value, studentName));
            recordMapper.updateSpasWarningRecord(open);
            return false;
        }
        SpasWarningRecord rec = new SpasWarningRecord();
        rec.setRuleId(rule.getRuleId());
        rec.setStudentId(studentId);
        rec.setSubjectId(subjectId);
        rec.setLevel(StringUtils.isNotEmpty(rule.getLevel()) ? rule.getLevel() : "1");
        rec.setTitle(rule.getRuleName());
        rec.setContent(buildContent(rule, value, studentName));
        rec.setMetricValue(value);
        rec.setStatus("0");
        recordMapper.insertSpasWarningRecord(rec);
        dispatchNotice(rule, rec);
        return true;
    }

    private void dispatchNotice(SpasWarningRule rule, SpasWarningRecord rec)
    {
        String channels = rule.getNotifyChannels();
        if (StringUtils.isEmpty(channels) || !channels.contains("system"))
        {
            return;
        }
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

    private String buildContent(SpasWarningRule rule, BigDecimal value, Object studentName)
    {
        return String.format("学生%s触发规则[%s/%s]，当前值=%s，条件=%s %s",
            studentName == null ? "-" : studentName.toString(),
            rule.getRuleCode(), rule.getMetric(),
            value, resolveOperator(rule.getMetric(), rule.getOperator()), rule.getThreshold());
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
