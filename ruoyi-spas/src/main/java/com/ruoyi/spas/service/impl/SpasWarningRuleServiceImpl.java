package com.ruoyi.spas.service.impl;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasWarningRule;
import com.ruoyi.spas.mapper.SpasWarningRuleMapper;
import com.ruoyi.spas.service.ISpasWarningRuleService;
import com.ruoyi.spas.warning.WarningEngine;

@Service
public class SpasWarningRuleServiceImpl implements ISpasWarningRuleService
{
    private static final Set<String> METRICS = new HashSet<>(Arrays.asList(
            "AVG_RATE", "WEAK_COUNT", "BELOW_CLASS_AVG", "CONTINUOUS_DROP"));
    private static final Set<String> OPERATORS = new HashSet<>(Arrays.asList("<", "<=", ">", ">=", "="));

    @Autowired
    private SpasWarningRuleMapper ruleMapper;

    @Autowired
    private WarningEngine warningEngine;

    @Override
    public List<SpasWarningRule> selectSpasWarningRuleList(SpasWarningRule rule)
    {
        return ruleMapper.selectSpasWarningRuleList(rule);
    }

    @Override
    public SpasWarningRule selectSpasWarningRuleById(Long ruleId)
    {
        return ruleMapper.selectSpasWarningRuleById(ruleId);
    }

    @Override
    public boolean checkRuleCodeUnique(SpasWarningRule rule)
    {
        Long id = rule.getRuleId() == null ? -1L : rule.getRuleId();
        SpasWarningRule info = ruleMapper.checkRuleCodeUnique(rule.getRuleCode());
        if (StringUtils.isNotNull(info) && info.getRuleId().longValue() != id.longValue())
        {
            return UserConstants.NOT_UNIQUE;
        }
        return UserConstants.UNIQUE;
    }

    @Override
    public int insertSpasWarningRule(SpasWarningRule rule)
    {
        normalizeAndValidate(rule);
        return ruleMapper.insertSpasWarningRule(rule);
    }

    @Override
    public int updateSpasWarningRule(SpasWarningRule rule)
    {
        normalizeAndValidate(rule);
        return ruleMapper.updateSpasWarningRule(rule);
    }

    private void normalizeAndValidate(SpasWarningRule rule)
    {
        if (StringUtils.isEmpty(rule.getEnabled()))
        {
            rule.setEnabled("1");
        }
        if (StringUtils.isEmpty(rule.getNotifyChannels()))
        {
            rule.setNotifyChannels("system");
        }
        if (StringUtils.isEmpty(rule.getMetric()) || !METRICS.contains(rule.getMetric()))
        {
            throw new ServiceException("不支持的预警指标");
        }
        if (StringUtils.isEmpty(rule.getOperator()))
        {
            if ("AVG_RATE".equals(rule.getMetric()))
            {
                rule.setOperator("<");
            }
            else
            {
                rule.setOperator(">");
            }
        }
        if (!OPERATORS.contains(rule.getOperator()))
        {
            throw new ServiceException("运算符仅支持 < <= > >= =");
        }
        if (!"1".equals(rule.getScopeType()) && rule.getScopeId() == null)
        {
            throw new ServiceException("班级/学科范围必须填写范围ID");
        }
        if ("1".equals(rule.getScopeType()))
        {
            rule.setScopeId(null);
        }
        if (rule.getThreshold() == null)
        {
            throw new ServiceException("阈值不能为空");
        }
        BigDecimal threshold = rule.getThreshold();
        String metric = rule.getMetric();
        if ("AVG_RATE".equals(metric) || "BELOW_CLASS_AVG".equals(metric) || "CONTINUOUS_DROP".equals(metric))
        {
            if (threshold.compareTo(BigDecimal.ZERO) < 0 || threshold.compareTo(BigDecimal.ONE) > 0)
            {
                throw new ServiceException(metricLabel(metric) + "阈值请填写 0~1（如 0.6 表示 60%）");
            }
        }
        else if ("WEAK_COUNT".equals(metric))
        {
            if (threshold.compareTo(BigDecimal.ZERO) < 0)
            {
                throw new ServiceException("薄弱知识点数量阈值不能为负数");
            }
        }
        int window = rule.getWindowDays() == null ? 3 : rule.getWindowDays();
        if (window < 1 || window > 30)
        {
            throw new ServiceException("考试场次需在 1~30 之间");
        }
        if ("CONTINUOUS_DROP".equals(metric) && window < 2)
        {
            throw new ServiceException("连续下滑至少需要 2 场考试");
        }
        rule.setWindowDays(window);
    }

    private String metricLabel(String metric)
    {
        if ("AVG_RATE".equals(metric))
        {
            return "平均得分率";
        }
        if ("BELOW_CLASS_AVG".equals(metric))
        {
            return "低于班级均分差值";
        }
        if ("CONTINUOUS_DROP".equals(metric))
        {
            return "连续下滑幅度";
        }
        return metric;
    }

    @Override
    public int deleteSpasWarningRuleByIds(Long[] ruleIds)
    {
        return ruleMapper.deleteSpasWarningRuleByIds(ruleIds);
    }

    @Override
    public int runEngine()
    {
        return warningEngine.evaluateAllEnabled();
    }
}
