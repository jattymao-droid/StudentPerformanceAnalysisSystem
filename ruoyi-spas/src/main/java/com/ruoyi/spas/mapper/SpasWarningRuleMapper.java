package com.ruoyi.spas.mapper;

import java.util.List;
import com.ruoyi.spas.domain.SpasWarningRule;

public interface SpasWarningRuleMapper
{
    List<SpasWarningRule> selectSpasWarningRuleList(SpasWarningRule rule);

    SpasWarningRule selectSpasWarningRuleById(Long ruleId);

    List<SpasWarningRule> selectEnabledRules();

    SpasWarningRule checkRuleCodeUnique(String ruleCode);

    int insertSpasWarningRule(SpasWarningRule rule);

    int updateSpasWarningRule(SpasWarningRule rule);

    int deleteSpasWarningRuleByIds(Long[] ruleIds);
}
