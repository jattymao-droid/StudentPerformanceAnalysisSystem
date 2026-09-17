package com.ruoyi.spas.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.mapper.SpasQualityMapper;
import com.ruoyi.spas.service.ISpasQualityService;
import com.ruoyi.spas.support.SpasAccessService;

@Service
public class SpasQualityServiceImpl implements ISpasQualityService
{
    @Autowired
    private SpasQualityMapper qualityMapper;

    @Autowired
    private SpasAccessService accessService;

    @Value("${spas.analysis.weak-thresholds.min-attempts:3}")
    private int minAttempts;

    @Override
    public Map<String, Object> overview(Long deptId, Long subjectId)
    {
        if (deptId != null)
        {
            accessService.checkDeptAccess(deptId);
        }
        Map<String, Object> raw = qualityMapper.selectOverview(deptId, subjectId, minAttempts);
        if (raw == null)
        {
            raw = new HashMap<>();
        }
        long blankZero = toLong(raw.get("blankZero"));
        long scoreTotal = toLong(raw.get("scoreTotal"));
        List<Map<String, Object>> metrics = new ArrayList<>();
        metrics.add(metric("Q_NO_KNOWLEDGE", "severe", toLong(raw.get("noKnowledge")), null));
        metrics.add(metric("Q_WEIGHT_SUM", "severe", toLong(raw.get("weightSum")), null));
        metrics.add(metric("Q_ORPHAN_SCORE", "severe", toLong(raw.get("orphanScore")), null));
        metrics.add(metric("Q_LOW_ATTEMPT", "watch", toLong(raw.get("lowAttempt")), null));
        metrics.add(metric("Q_MISSING_EXAM_DATE", "watch", toLong(raw.get("missingExamDate")), null));
        metrics.add(metric("Q_PARTIAL_PAPER", "watch", toLong(raw.get("partialPaper")), null));
        String ratio = scoreTotal <= 0 ? "0%" :
            BigDecimal.valueOf(blankZero * 100.0 / scoreTotal).setScale(1, RoundingMode.HALF_UP).toPlainString() + "%";
        Map<String, Object> blank = metric("Q_BLANK_ZERO", "info", blankZero, ratio);
        blank.put("total", scoreTotal);
        metrics.add(blank);

        long alertCount = metrics.stream()
            .filter(m -> !"info".equals(m.get("level")) && toLong(m.get("count")) > 0)
            .count();
        Map<String, Object> data = new HashMap<>();
        data.put("metrics", metrics);
        data.put("alertCount", alertCount);
        data.put("minAttempts", minAttempts);
        data.put("deptId", deptId);
        data.put("subjectId", subjectId);
        return data;
    }

    @Override
    public List<Map<String, Object>> detail(String metric, Long deptId, Long subjectId)
    {
        if (deptId != null)
        {
            accessService.checkDeptAccess(deptId);
        }
        if (StringUtils.isEmpty(metric))
        {
            throw new ServiceException("未知质量指标");
        }
        switch (metric)
        {
            case "Q_NO_KNOWLEDGE":
                return qualityMapper.selectNoKnowledge(deptId, subjectId);
            case "Q_WEIGHT_SUM":
                return qualityMapper.selectWeightSum(deptId, subjectId);
            case "Q_LOW_ATTEMPT":
                return qualityMapper.selectLowAttempt(deptId, subjectId, minAttempts);
            case "Q_MISSING_EXAM_DATE":
                return qualityMapper.selectMissingExamDate(deptId, subjectId);
            case "Q_PARTIAL_PAPER":
                return qualityMapper.selectPartialPaper(deptId, subjectId);
            case "Q_ORPHAN_SCORE":
                return qualityMapper.selectOrphanScore(deptId, subjectId);
            case "Q_BLANK_ZERO":
                return qualityMapper.selectBlankZero(deptId, subjectId);
            default:
                throw new ServiceException("未知质量指标");
        }
    }

    private Map<String, Object> metric(String code, String level, long count, String extra)
    {
        Map<String, Object> m = new HashMap<>();
        m.put("code", code);
        m.put("level", level);
        m.put("count", count);
        if (extra != null)
        {
            m.put("ratio", extra);
        }
        return m;
    }

    private long toLong(Object v)
    {
        if (v == null)
        {
            return 0L;
        }
        if (v instanceof Number)
        {
            return ((Number) v).longValue();
        }
        try
        {
            return Long.parseLong(String.valueOf(v));
        }
        catch (Exception e)
        {
            return 0L;
        }
    }
}
