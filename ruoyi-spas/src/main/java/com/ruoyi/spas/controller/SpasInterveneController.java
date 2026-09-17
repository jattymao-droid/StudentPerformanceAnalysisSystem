package com.ruoyi.spas.controller;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
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
import com.ruoyi.spas.domain.SpasInterveneTask;
import com.ruoyi.spas.service.ISpasInterveneService;
import com.ruoyi.spas.support.SpasAccessService;

@RestController
@RequestMapping("/spas/intervene")
public class SpasInterveneController extends BaseController
{
    @Autowired
    private ISpasInterveneService interveneService;

    @Autowired
    private SpasAccessService accessService;

    @PreAuthorize("@ss.hasPermi('spas:intervene:list')")
    @GetMapping("/list")
    public TableDataInfo list(SpasInterveneTask task)
    {
        startPage();
        List<SpasInterveneTask> list = interveneService.selectSpasInterveneTaskList(task);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:intervene:list')")
    @GetMapping("/{interveneId}")
    public AjaxResult getInfo(@PathVariable Long interveneId)
    {
        return success(interveneService.selectSpasInterveneTaskById(interveneId));
    }

    @PreAuthorize("@ss.hasPermi('spas:intervene:add')")
    @Log(title = "干预任务", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SpasInterveneTask task)
    {
        task.setCreateBy(getUsername());
        return toAjax(interveneService.insertSpasInterveneTask(task));
    }

    @PreAuthorize("@ss.hasPermi('spas:intervene:edit')")
    @Log(title = "干预任务", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SpasInterveneTask task)
    {
        return toAjax(interveneService.updateSpasInterveneTask(task));
    }

    @PreAuthorize("@ss.hasPermi('spas:intervene:add')")
    @Log(title = "预警转干预", businessType = BusinessType.INSERT)
    @PostMapping("/from-warning/{warningId}")
    public AjaxResult fromWarning(@PathVariable Long warningId, @RequestBody(required = false) SpasInterveneTask form)
    {
        return success(interveneService.createFromWarning(warningId, form));
    }

    @PreAuthorize("@ss.hasPermi('spas:intervene:handle')")
    @Log(title = "干预效果评估", businessType = BusinessType.UPDATE)
    @PostMapping("/{interveneId}/evaluate")
    public AjaxResult evaluate(@PathVariable Long interveneId)
    {
        return success(interveneService.evaluate(interveneId));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:intervene:list,spas:portfolio:list,spas:portfolio:mine')")
    @GetMapping("/student/{studentId}/timeline")
    public AjaxResult timeline(@PathVariable Long studentId)
    {
        accessService.checkStudentAccess(studentId);
        List<Map<String, Object>> list = interveneService.studentTimeline(studentId);
        return success(list);
    }
}
