package com.ruoyi.spas.controller;

import java.util.List;
import java.util.Map;
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
import com.ruoyi.spas.service.ISpasAnalysisService;
import com.ruoyi.spas.support.SpasAccessService;

/**
 * Analysis dashboard and recalculation controller
 */
@RestController
@RequestMapping("/spas/analysis")
public class SpasAnalysisController extends BaseController
{
    @Autowired
    private ISpasAnalysisService analysisService;

    @Autowired
    private SpasAccessService accessService;

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @GetMapping("/student/{studentId}/summary")
    public AjaxResult studentSummary(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window)
    {
        accessService.checkStudentAccess(studentId);
        return success(analysisService.studentSummary(studentId, subjectId, window));
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @GetMapping("/student/{studentId}/radar")
    public AjaxResult studentRadar(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window)
    {
        accessService.checkStudentAccess(studentId);
        List<Map<String, Object>> list = analysisService.studentRadar(studentId, subjectId, window);
        return success(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @GetMapping("/student/{studentId}/trend")
    public AjaxResult studentTrend(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window)
    {
        accessService.checkStudentAccess(studentId);
        List<Map<String, Object>> list = analysisService.studentTrend(studentId, subjectId, window);
        return success(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @GetMapping("/student/{studentId}/weak-top")
    public AjaxResult studentWeakTop(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false, defaultValue = "10") Integer limit,
        @RequestParam(required = false) String window)
    {
        accessService.checkStudentAccess(studentId);
        List<Map<String, Object>> list = analysisService.studentWeakTop(studentId, subjectId, limit, window);
        return success(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:class')")
    @GetMapping("/class/{deptId}/weak-top")
    public AjaxResult classWeakTop(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false, defaultValue = "10") Integer limit)
    {
        accessService.checkDeptAccess(deptId);
        List<Map<String, Object>> list = analysisService.classWeakTop(deptId, subjectId, limit);
        return success(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:class')")
    @GetMapping("/class/{deptId}/heatmap")
    public AjaxResult classHeatmap(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId)
    {
        accessService.checkDeptAccess(deptId);
        Map<String, Object> data = analysisService.classHeatmap(deptId, subjectId);
        return success(data);
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:class')")
    @GetMapping("/class/{deptId}/overview")
    public AjaxResult classOverview(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId)
    {
        accessService.checkDeptAccess(deptId);
        Map<String, Object> data = analysisService.classOverview(deptId, subjectId);
        return success(data);
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @GetMapping("/student/{studentId}/chapter-radar")
    public AjaxResult studentChapterRadar(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId)
    {
        accessService.checkStudentAccess(studentId);
        return success(analysisService.studentChapterRadar(studentId, subjectId));
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:class')")
    @GetMapping("/class/{deptId}/chapter-overview")
    public AjaxResult classChapterOverview(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId)
    {
        accessService.checkDeptAccess(deptId);
        return success(analysisService.classChapterOverview(deptId, subjectId));
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:class')")
    @GetMapping("/class/{deptId}/trend")
    public AjaxResult classTrend(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window)
    {
        accessService.checkDeptAccess(deptId);
        return success(analysisService.classTrend(deptId, subjectId, window));
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:knowledge')")
    @GetMapping("/knowledge/{knowledgeId}/overview")
    public AjaxResult knowledgeOverview(@PathVariable Long knowledgeId,
        @RequestParam(required = false) Long deptId)
    {
        if (deptId != null)
        {
            accessService.checkDeptAccess(deptId);
        }
        Map<String, Object> data = analysisService.knowledgeOverview(knowledgeId, deptId);
        return success(data);
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @GetMapping("/student/{studentId}/knowledge/{knowledgeId}/questions")
    public AjaxResult studentKnowledgeQuestions(@PathVariable Long studentId,
        @PathVariable Long knowledgeId,
        @RequestParam(required = false) Long subjectId)
    {
        accessService.checkStudentAccess(studentId);
        List<Map<String, Object>> list = analysisService.studentKnowledgeQuestions(studentId, knowledgeId, subjectId);
        return success(list);
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:analysis:class,spas:analysis:student,spas:score:import')")
    @Log(title = "Analysis Recalc Paper", businessType = BusinessType.OTHER)
    @PostMapping("/recalc/paper/{paperId}")
    public AjaxResult recalcPaper(@PathVariable Long paperId)
    {
        accessService.assertCanWrite();
        // Scope check via paper dept (delegated in service layer through paper lookup)
        int rows = analysisService.recalculateByPaper(paperId);
        return success(rows);
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @Log(title = "Analysis Recalc Student", businessType = BusinessType.OTHER)
    @PostMapping("/recalc/student/{studentId}")
    public AjaxResult recalcStudent(@PathVariable Long studentId)
    {
        accessService.assertCanWrite();
        accessService.checkStudentAccess(studentId);
        int rows = analysisService.recalculateByStudent(studentId);
        return success(rows);
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:analysis:class,spas:analysis:student')")
    @Log(title = "Analysis Recalc Dept", businessType = BusinessType.OTHER)
    @PostMapping("/recalc/dept/{deptId}")
    public AjaxResult recalcDept(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId)
    {
        accessService.assertCanWrite();
        Map<String, Object> data = analysisService.recalculateByDept(deptId, subjectId);
        return success(data);
    }
}
