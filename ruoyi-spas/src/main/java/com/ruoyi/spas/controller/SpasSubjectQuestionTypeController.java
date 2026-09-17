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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.spas.domain.SpasSubjectQuestionType;
import com.ruoyi.spas.service.ISpasSubjectQuestionTypeService;
import com.ruoyi.spas.support.SpasAccessService;

/**
 * Subject-scoped question type controller
 */
@RestController
@RequestMapping("/spas/questionType")
public class SpasSubjectQuestionTypeController extends BaseController
{
    @Autowired
    private ISpasSubjectQuestionTypeService questionTypeService;

    @Autowired
    private SpasAccessService accessService;

    @PreAuthorize("@ss.hasPermi('spas:subject:list')")
    @GetMapping("/list")
    public TableDataInfo list(SpasSubjectQuestionType query)
    {
        startPage();
        List<SpasSubjectQuestionType> list = questionTypeService.selectList(query);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:subject:list')")
    @GetMapping("/optionselect")
    public AjaxResult optionselect(@RequestParam Long subjectId)
    {
        return success(questionTypeService.selectEnabledBySubjectId(subjectId));
    }

    @PreAuthorize("@ss.hasPermi('spas:subject:query')")
    @GetMapping("/{typeId}")
    public AjaxResult getInfo(@PathVariable Long typeId)
    {
        return success(questionTypeService.selectById(typeId));
    }

    @PreAuthorize("@ss.hasPermi('spas:subject:edit')")
    @Log(title = "Question Type", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SpasSubjectQuestionType entity)
    {
        accessService.assertCanWrite();
        if (!questionTypeService.checkTypeCodeUnique(entity))
        {
            return error("Question type code already exists");
        }
        entity.setCreateBy(getUsername());
        return toAjax(questionTypeService.insert(entity));
    }

    @PreAuthorize("@ss.hasPermi('spas:subject:edit')")
    @Log(title = "Question Type", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody SpasSubjectQuestionType entity)
    {
        accessService.assertCanWrite();
        if (!questionTypeService.checkTypeCodeUnique(entity))
        {
            return error("Question type code already exists");
        }
        entity.setUpdateBy(getUsername());
        return toAjax(questionTypeService.update(entity));
    }

    @PreAuthorize("@ss.hasPermi('spas:subject:edit')")
    @Log(title = "Question Type", businessType = BusinessType.DELETE)
    @DeleteMapping("/{typeIds}")
    public AjaxResult remove(@PathVariable Long[] typeIds)
    {
        accessService.assertCanWrite();
        return toAjax(questionTypeService.deleteByIds(typeIds));
    }
}
