package com.ruoyi.spas.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.spas.domain.SpasErrorTag;
import com.ruoyi.spas.service.ISpasErrorTagService;

@RestController
@RequestMapping("/spas/errorTag")
public class SpasErrorTagController extends BaseController
{
    @Autowired
    private ISpasErrorTagService errorTagService;

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @GetMapping("/student/{studentId}")
    public AjaxResult listByStudent(@PathVariable Long studentId)
    {
        List<SpasErrorTag> list = errorTagService.selectByStudentId(studentId);
        return success(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:class')")
    @GetMapping("/dept/{deptId}/summary")
    public AjaxResult deptSummary(@PathVariable Long deptId,
        @org.springframework.web.bind.annotation.RequestParam(required = false) Long subjectId)
    {
        return success(errorTagService.selectDeptCauseSummary(deptId, subjectId));
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @Log(title = "Error Tag", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult save(@RequestBody SpasErrorTag tag)
    {
        return toAjax(errorTagService.saveTag(tag));
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @Log(title = "Error Tag", businessType = BusinessType.DELETE)
    @DeleteMapping("/student/{studentId}/question/{questionId}")
    public AjaxResult remove(@PathVariable Long studentId, @PathVariable Long questionId)
    {
        return toAjax(errorTagService.deleteByStudentAndQuestion(studentId, questionId));
    }
}
