package com.ruoyi.spas.controller;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
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
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.spas.domain.SpasSubject;
import com.ruoyi.spas.service.ISpasSubjectService;
import com.ruoyi.spas.support.SpasAccessService;

/**
 * Subject controller
 */
@RestController
@RequestMapping("/spas/subject")
public class SpasSubjectController extends BaseController
{
    @Autowired
    private ISpasSubjectService subjectService;

    @Autowired
    private SpasAccessService accessService;

    @PreAuthorize("@ss.hasPermi('spas:subject:list')")
    @GetMapping("/list")
    public TableDataInfo list(SpasSubject subject)
    {
        startPage();
        List<SpasSubject> list = subjectService.selectSpasSubjectList(subject);
        return getDataTable(list);
    }

    @Log(title = "Subject", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('spas:subject:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, SpasSubject subject)
    {
        List<SpasSubject> list = subjectService.selectSpasSubjectList(subject);
        ExcelUtil<SpasSubject> util = new ExcelUtil<SpasSubject>(SpasSubject.class);
        util.exportExcel(response, list, "subject");
    }

    @PreAuthorize("@ss.hasPermi('spas:subject:query')")
    @GetMapping(value = "/{subjectId}")
    public AjaxResult getInfo(@PathVariable Long subjectId)
    {
        return success(subjectService.selectSpasSubjectById(subjectId));
    }

    @GetMapping("/optionselect")
    public AjaxResult optionselect()
    {
        return success(subjectService.selectSpasSubjectAll());
    }

    @PreAuthorize("@ss.hasPermi('spas:subject:add')")
    @Log(title = "Subject", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SpasSubject subject)
    {
        accessService.assertCanWrite();
        if (!subjectService.checkSubjectCodeUnique(subject))
        {
            return error("学科编码已存在");
        }
        subject.setCreateBy(getUsername());
        return toAjax(subjectService.insertSpasSubject(subject));
    }

    @PreAuthorize("@ss.hasPermi('spas:subject:edit')")
    @Log(title = "Subject", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody SpasSubject subject)
    {
        accessService.assertCanWrite();
        if (!subjectService.checkSubjectCodeUnique(subject))
        {
            return error("学科编码已存在");
        }
        subject.setUpdateBy(getUsername());
        return toAjax(subjectService.updateSpasSubject(subject));
    }

    @PreAuthorize("@ss.hasPermi('spas:subject:remove')")
    @Log(title = "Subject", businessType = BusinessType.DELETE)
    @DeleteMapping("/{subjectIds}")
    public AjaxResult remove(@PathVariable Long[] subjectIds)
    {
        accessService.assertCanWrite();
        return toAjax(subjectService.deleteSpasSubjectByIds(subjectIds));
    }
}
