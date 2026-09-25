package com.ruoyi.spas.controller;

import java.util.ArrayList;
import java.util.List;
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
import com.ruoyi.spas.analysis.KnowledgeStatCalculator;
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
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds,
        @RequestParam(required = false) Boolean useRecency,
        @RequestParam(required = false) Integer limit)
    {
        applyRecencyOverride(useRecency);
        try
        {
            return success(reportService.previewStudent(studentId, subjectId, window, parsePaperIds(paperIds),
                useRecency, limit));
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @PreAuthorize("@ss.hasPermi('spas:report:export')")
    @GetMapping("/preview/class/{deptId}")
    public AjaxResult previewClass(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds)
    {
        return success(reportService.previewClass(deptId, subjectId, window, parsePaperIds(paperIds)));
    }

    @PreAuthorize("@ss.hasPermi('spas:report:export')")
    @Log(title = "学生学情报告", businessType = BusinessType.EXPORT)
    @PostMapping("/student/{studentId}")
    public void exportStudent(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds,
        @RequestParam(required = false) Boolean useRecency,
        @RequestParam(required = false) Integer limit,
        @RequestParam(defaultValue = "pdf") String format,
        HttpServletResponse response)
    {
        applyRecencyOverride(useRecency);
        try
        {
            reportService.exportStudent(studentId, subjectId, window, parsePaperIds(paperIds), useRecency, limit,
                format, response);
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @PreAuthorize("@ss.hasPermi('spas:report:export')")
    @Log(title = "班级学情报告", businessType = BusinessType.EXPORT)
    @PostMapping("/class/{deptId}")
    public void exportClass(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds,
        @RequestParam(defaultValue = "pdf") String format,
        HttpServletResponse response)
    {
        reportService.exportClass(deptId, subjectId, window, parsePaperIds(paperIds), format, response);
    }

    private List<Long> parsePaperIds(String paperIds)
    {
        if (paperIds == null || paperIds.trim().isEmpty())
        {
            return null;
        }
        List<Long> ids = new ArrayList<Long>();
        for (String part : paperIds.split(","))
        {
            String s = part.trim();
            if (s.isEmpty())
            {
                continue;
            }
            ids.add(Long.valueOf(s));
        }
        return ids.isEmpty() ? null : ids;
    }

    private void applyRecencyOverride(Boolean useRecency)
    {
        if (useRecency == null)
        {
            return;
        }
        if (Boolean.FALSE.equals(useRecency))
        {
            KnowledgeStatCalculator.setRecencyOverride(Integer.valueOf(0));
        }
        else
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }
}
