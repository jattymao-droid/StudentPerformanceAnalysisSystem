package com.ruoyi.spas.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.spas.domain.SpasWarningRule;
import com.ruoyi.spas.service.ISpasWarningRuleService;
import com.ruoyi.spas.support.SpasAccessService;

@RestController
@RequestMapping("/spas/warning/rule")
public class SpasWarningRuleController extends BaseController
{
    @Autowired
    private ISpasWarningRuleService ruleService;

    @Autowired
    private SpasAccessService accessService;

    @PreAuthorize("@ss.hasPermi('spas:warning:rule')")
    @GetMapping("/list")
    public TableDataInfo list(SpasWarningRule rule)
    {
        startPage();
        List<SpasWarningRule> list = ruleService.selectSpasWarningRuleList(rule);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:warning:rule')")
    @GetMapping(value = "/{ruleId}")
    public AjaxResult getInfo(@PathVariable Long ruleId)
    {
        return success(ruleService.selectSpasWarningRuleById(ruleId));
    }

    @PreAuthorize("@ss.hasPermi('spas:warning:rule:add')")
    @Log(title = "预警规则", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SpasWarningRule rule)
    {
        accessService.assertCanWrite();
        if (!ruleService.checkRuleCodeUnique(rule))
        {
            return error("规则编码已存在");
        }
        rule.setCreateBy(getUsername());
        return toAjax(ruleService.insertSpasWarningRule(rule));
    }

    @PreAuthorize("@ss.hasPermi('spas:warning:rule:edit')")
    @Log(title = "预警规则", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody SpasWarningRule rule)
    {
        accessService.assertCanWrite();
        if (!ruleService.checkRuleCodeUnique(rule))
        {
            return error("规则编码已存在");
        }
        rule.setUpdateBy(getUsername());
        return toAjax(ruleService.updateSpasWarningRule(rule));
    }

    @PreAuthorize("@ss.hasPermi('spas:warning:rule:remove')")
    @Log(title = "预警规则", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ruleIds}")
    public AjaxResult remove(@PathVariable Long[] ruleIds)
    {
        accessService.assertCanWrite();
        return toAjax(ruleService.deleteSpasWarningRuleByIds(ruleIds));
    }

    @PreAuthorize("@ss.hasPermi('spas:warning:rule:run')")
    @Log(title = "预警引擎", businessType = BusinessType.OTHER)
    @PostMapping("/run")
    public AjaxResult run()
    {
        accessService.assertCanWrite();
        int created = ruleService.runEngine();
        return success("新增 " + created + " 条预警");
    }
}
