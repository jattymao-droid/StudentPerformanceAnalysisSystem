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
import com.ruoyi.spas.analysis.KnowledgeStatCalculator;
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
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds,
        @RequestParam(required = false) Boolean useRecency)
    {
        accessService.checkStudentAccess(studentId);
        applyRecencyOverride(useRecency);
        try
        {
            return success(analysisService.studentSummary(studentId, subjectId, window, parsePaperIds(paperIds)));
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @GetMapping("/student/{studentId}/radar")
    public AjaxResult studentRadar(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds,
        @RequestParam(required = false) Boolean useRecency)
    {
        accessService.checkStudentAccess(studentId);
        applyRecencyOverride(useRecency);
        try
        {
            List<Map<String, Object>> list = analysisService.studentRadar(studentId, subjectId, window,
                parsePaperIds(paperIds));
            return success(list);
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @GetMapping("/student/{studentId}/trend")
    public AjaxResult studentTrend(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds)
    {
        accessService.checkStudentAccess(studentId);
        List<Map<String, Object>> list = analysisService.studentTrend(studentId, subjectId, window,
            parsePaperIds(paperIds));
        return success(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @GetMapping("/student/{studentId}/weak-top")
    public AjaxResult studentWeakTop(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false, defaultValue = "10") Integer limit,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds,
        @RequestParam(required = false) Boolean useRecency)
    {
        accessService.checkStudentAccess(studentId);
        applyRecencyOverride(useRecency);
        try
        {
            List<Map<String, Object>> list = analysisService.studentWeakTop(studentId, subjectId, limit, window,
                parsePaperIds(paperIds));
            return success(list);
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @GetMapping("/student/{studentId}/knowledge-exam-trend")
    public AjaxResult knowledgeExamTrend(@PathVariable Long studentId,
        @RequestParam(required = false) Long knowledgeId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String paperIds,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) Boolean useRecency)
    {
        accessService.checkStudentAccess(studentId);
        applyRecencyOverride(useRecency);
        try
        {
            return success(analysisService.knowledgeExamTrend(studentId, knowledgeId, subjectId,
                parsePaperIds(paperIds), window));
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @GetMapping("/student/{studentId}/persistent-weak")
    public AjaxResult persistentWeak(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String paperIds,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) Integer minPapers,
        @RequestParam(required = false) Double rateThreshold,
        @RequestParam(required = false) Double persistRatio,
        @RequestParam(required = false) Boolean useRecency)
    {
        accessService.checkStudentAccess(studentId);
        applyRecencyOverride(useRecency);
        try
        {
            return success(analysisService.persistentWeak(studentId, subjectId, parsePaperIds(paperIds), window,
                minPapers, rateThreshold, persistRatio));
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @GetMapping("/student/{studentId}/scope-compare")
    public AjaxResult scopeCompare(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String paperIds,
        @RequestParam(required = false, defaultValue = "all") String baselineWindow,
        @RequestParam(required = false) Boolean useRecency)
    {
        accessService.checkStudentAccess(studentId);
        applyRecencyOverride(useRecency);
        try
        {
            return success(analysisService.studentScopeCompare(studentId, subjectId, parsePaperIds(paperIds),
                baselineWindow));
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:class')")
    @GetMapping("/class/{deptId}/weak-top")
    public AjaxResult classWeakTop(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false, defaultValue = "10") Integer limit,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds,
        @RequestParam(required = false) Boolean useRecency)
    {
        accessService.checkClassAnalysisDept(deptId);
        applyRecencyOverride(useRecency);
        try
        {
            List<Map<String, Object>> list = analysisService.classWeakTop(deptId, subjectId, limit, window,
                parsePaperIds(paperIds));
            return success(list);
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:class')")
    @GetMapping("/class/{deptId}/heatmap")
    public AjaxResult classHeatmap(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds,
        @RequestParam(required = false) Boolean useRecency)
    {
        accessService.checkClassAnalysisDept(deptId);
        applyRecencyOverride(useRecency);
        try
        {
            Map<String, Object> data = analysisService.classHeatmap(deptId, subjectId, window, parsePaperIds(paperIds));
            return success(data);
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:class')")
    @GetMapping("/class/{deptId}/overview")
    public AjaxResult classOverview(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds,
        @RequestParam(required = false) Boolean useRecency)
    {
        accessService.checkClassAnalysisDept(deptId);
        applyRecencyOverride(useRecency);
        try
        {
            Map<String, Object> data = analysisService.classOverview(deptId, subjectId, window, parsePaperIds(paperIds));
            return success(data);
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @GetMapping("/student/{studentId}/chapter-radar")
    public AjaxResult studentChapterRadar(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds,
        @RequestParam(required = false) Boolean useRecency)
    {
        accessService.checkStudentAccess(studentId);
        applyRecencyOverride(useRecency);
        try
        {
            return success(analysisService.studentChapterRadar(studentId, subjectId, window, parsePaperIds(paperIds)));
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:class')")
    @GetMapping("/class/{deptId}/chapter-overview")
    public AjaxResult classChapterOverview(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds,
        @RequestParam(required = false) Boolean useRecency)
    {
        accessService.checkClassAnalysisDept(deptId);
        applyRecencyOverride(useRecency);
        try
        {
            return success(analysisService.classChapterOverview(deptId, subjectId, window, parsePaperIds(paperIds)));
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:analysis:knowledge,spas:analysis:frequency,spas:analysis:student,spas:analysis:class')")
    @GetMapping("/paper-annotation-coverage")
    public AjaxResult paperAnnotationCoverage(@RequestParam("paperIds") String paperIds)
    {
        return success(analysisService.paperAnnotationCoverage(parsePaperIds(paperIds)));
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:class')")
    @GetMapping("/class/{deptId}/trend")
    public AjaxResult classTrend(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds)
    {
        accessService.checkClassAnalysisDept(deptId);
        return success(analysisService.classTrend(deptId, subjectId, window, parsePaperIds(paperIds)));
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @GetMapping("/student/{studentId}/question-type")
    public AjaxResult studentQuestionType(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds)
    {
        accessService.checkStudentAccess(studentId);
        return success(analysisService.studentQuestionType(studentId, subjectId, window, parsePaperIds(paperIds)));
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:class')")
    @GetMapping("/class/{deptId}/question-type")
    public AjaxResult classQuestionType(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds)
    {
        accessService.checkClassAnalysisDept(deptId);
        return success(analysisService.classQuestionType(deptId, subjectId, window, parsePaperIds(paperIds)));
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @GetMapping("/student/{studentId}/bloom")
    public AjaxResult studentBloom(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds)
    {
        accessService.checkStudentAccess(studentId);
        return success(analysisService.studentBloom(studentId, subjectId, window, parsePaperIds(paperIds)));
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:class')")
    @GetMapping("/class/{deptId}/bloom")
    public AjaxResult classBloom(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds)
    {
        accessService.checkClassAnalysisDept(deptId);
        return success(analysisService.classBloom(deptId, subjectId, window, parsePaperIds(paperIds)));
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @GetMapping("/student/{studentId}/chapter-delta")
    public AjaxResult studentChapterDelta(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds,
        @RequestParam(required = false) String baselineWindow,
        @RequestParam(required = false) Boolean useRecency)
    {
        accessService.checkStudentAccess(studentId);
        applyRecencyOverride(useRecency);
        try
        {
            return success(analysisService.studentChapterDelta(studentId, subjectId, window, parsePaperIds(paperIds),
                baselineWindow));
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:class')")
    @GetMapping("/class/{deptId}/chapter-delta")
    public AjaxResult classChapterDelta(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds,
        @RequestParam(required = false) String baselineWindow,
        @RequestParam(required = false) Boolean useRecency)
    {
        accessService.checkClassAnalysisDept(deptId);
        applyRecencyOverride(useRecency);
        try
        {
            return success(analysisService.classChapterDelta(deptId, subjectId, window, parsePaperIds(paperIds),
                baselineWindow));
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:class')")
    @GetMapping("/class/{deptId}/knowledge-exam-trend")
    public AjaxResult classKnowledgeExamTrend(@PathVariable Long deptId,
        @RequestParam Long knowledgeId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds,
        @RequestParam(required = false) Boolean useRecency)
    {
        accessService.checkClassAnalysisDept(deptId);
        applyRecencyOverride(useRecency);
        try
        {
            return success(analysisService.classKnowledgeExamTrend(deptId, knowledgeId, subjectId, window,
                parsePaperIds(paperIds)));
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:knowledge')")
    @GetMapping("/knowledge/overview")
    public AjaxResult knowledgeOverviewQuery(@RequestParam(required = false) Long knowledgeId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) Long deptId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds)
    {
        if (deptId != null)
        {
            accessService.checkClassAnalysisDept(deptId);
        }
        Map<String, Object> data = analysisService.knowledgeOverview(knowledgeId, subjectId, deptId, window,
            parsePaperIds(paperIds));
        return success(data);
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:knowledge')")
    @GetMapping("/knowledge/{knowledgeId:\\d+}/overview")
    public AjaxResult knowledgeOverview(@PathVariable Long knowledgeId,
        @RequestParam(required = false) Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds)
    {
        if (deptId != null)
        {
            accessService.checkClassAnalysisDept(deptId);
        }
        Map<String, Object> data = analysisService.knowledgeOverview(knowledgeId, subjectId, deptId, window,
            parsePaperIds(paperIds));
        return success(data);
    }

    /**
     * Knowledge examination frequency across one or more papers.
     * paperIds: comma-separated, e.g. 1,2,3
     */
    @PreAuthorize("@ss.hasAnyPermi('spas:analysis:knowledge,spas:analysis:frequency')")
    @GetMapping("/knowledge-frequency")
    public AjaxResult knowledgeFrequency(@RequestParam("paperIds") String paperIds,
        @RequestParam(required = false) Long subjectId)
    {
        List<Long> ids = new java.util.ArrayList<Long>();
        if (paperIds != null && !paperIds.trim().isEmpty())
        {
            for (String part : paperIds.split(","))
            {
                String s = part.trim();
                if (s.isEmpty())
                {
                    continue;
                }
                ids.add(Long.valueOf(s));
            }
        }
        return success(analysisService.knowledgeFrequency(ids, subjectId));
    }

    /**
     * Knowledge priority matrix: exam frequency × mastery.
     */
    @PreAuthorize("@ss.hasAnyPermi('spas:analysis:knowledge,spas:analysis:frequency')")
    @GetMapping("/knowledge-priority")
    public AjaxResult knowledgePriority(@RequestParam("paperIds") String paperIds,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) Long deptId,
        @RequestParam(required = false, defaultValue = "papers") String masteryScope,
        @RequestParam(required = false) Boolean useRecency)
    {
        applyRecencyOverride(useRecency);
        try
        {
            return success(analysisService.knowledgePriority(parsePaperIds(paperIds), subjectId, deptId, masteryScope));
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @GetMapping("/student/{studentId}/knowledge/{knowledgeId}/questions")
    public AjaxResult studentKnowledgeQuestions(@PathVariable Long studentId,
        @PathVariable Long knowledgeId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds)
    {
        accessService.checkStudentAccess(studentId);
        List<Map<String, Object>> list = analysisService.studentKnowledgeQuestions(studentId, knowledgeId, subjectId,
            window, parsePaperIds(paperIds));
        return success(list);
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:analysis:class,spas:analysis:student')")
    @GetMapping("/config")
    public AjaxResult analysisConfig()
    {
        return success(analysisService.analysisConfig());
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:analysis:class,spas:analysis:student,spas:score:import')")
    @Log(title = "Analysis Recalc Paper", businessType = BusinessType.OTHER)
    @PostMapping("/recalc/paper/{paperId}")
    public AjaxResult recalcPaper(@PathVariable Long paperId,
        @RequestParam(required = false) Boolean useRecency)
    {
        accessService.assertCanWrite();
        int rows = analysisService.recalculateByPaper(paperId, useRecency);
        return success(rows);
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student')")
    @Log(title = "Analysis Recalc Student", businessType = BusinessType.OTHER)
    @PostMapping("/recalc/student/{studentId}")
    public AjaxResult recalcStudent(@PathVariable Long studentId,
        @RequestParam(required = false) Boolean useRecency)
    {
        accessService.assertCanWrite();
        accessService.checkStudentAccess(studentId);
        int rows = analysisService.recalculateByStudent(studentId, useRecency);
        return success(rows);
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:analysis:class,spas:analysis:student')")
    @Log(title = "Analysis Recalc Dept", businessType = BusinessType.OTHER)
    @PostMapping("/recalc/dept/{deptId}")
    public AjaxResult recalcDept(@PathVariable Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) Boolean useRecency)
    {
        accessService.assertCanWrite();
        Map<String, Object> data = analysisService.recalculateByDept(deptId, subjectId, useRecency);
        return success(data);
    }

    private List<Long> parsePaperIds(String paperIds)
    {
        if (paperIds == null || paperIds.trim().isEmpty())
        {
            return null;
        }
        List<Long> ids = new java.util.ArrayList<Long>();
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
