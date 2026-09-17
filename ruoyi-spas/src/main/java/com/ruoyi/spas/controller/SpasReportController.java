package com.ruoyi.spas.controller;

import java.util.Map;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.spas.service.ISpasReportService;

@RestController
@RequestMapping("/spas/report")
public class SpasReportController extends BaseController
{
    @Autowired
    private ISpasReportService reportService;

    @PreAuthorize("@ss.hasPermi('spas:report:export')")
    @GetMapping("/preview/student/{studentId}")
    public AjaxResult previewStudent(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId)
    {
        return success(reportService.previewStudent(studentId, subjectId));
    }

    @PreAuthorize("@ss.hasPermi('spas:report:export')")
    @GetMapping("/preview/class/{deptId}")
    public AjaxResult previewClass(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId)
    {
        return success(reportService.previewClass(deptId, subjectId));
    }

    @PreAuthorize("@ss.hasPermi('spas:report:export')")
    @Log(title = "学生学情报告", businessType = BusinessType.EXPORT)
    @PostMapping("/student/{studentId}")
    public void exportStudent(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(defaultValue = "pdf") String format,
        HttpServletResponse response)
    {
        reportService.exportStudent(studentId, subjectId, format, response);
    }

    @PreAuthorize("@ss.hasPermi('spas:report:export')")
    @Log(title = "班级学情报告", businessType = BusinessType.EXPORT)
    @PostMapping("/class/{deptId}")
    public void exportClass(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(defaultValue = "pdf") String format,
        HttpServletResponse response)
    {
        reportService.exportClass(deptId, subjectId, format, response);
    }
}
