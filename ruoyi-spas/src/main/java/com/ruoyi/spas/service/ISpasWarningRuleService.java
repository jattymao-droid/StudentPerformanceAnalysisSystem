package com.ruoyi.spas.service;

import java.util.List;
import com.ruoyi.spas.domain.SpasWarningRule;

public interface ISpasWarningRuleService
{
    List<SpasWarningRule> selectSpasWarningRuleList(SpasWarningRule rule);

    SpasWarningRule selectSpasWarningRuleById(Long ruleId);

    boolean checkRuleCodeUnique(SpasWarningRule rule);

    int insertSpasWarningRule(SpasWarningRule rule);

    int updateSpasWarningRule(SpasWarningRule rule);

    int deleteSpasWarningRuleByIds(Long[] ruleIds);

    int runEngine();
}
