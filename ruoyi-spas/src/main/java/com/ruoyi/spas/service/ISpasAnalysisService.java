package com.ruoyi.spas.service;

import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * Analysis query and recalculation service
 */
public interface ISpasAnalysisService
{
    public List<Map<String, Object>> studentRadar(Long studentId, Long subjectId);

    public List<Map<String, Object>> studentTrend(Long studentId, Long subjectId);

    public List<Map<String, Object>> studentWeakTop(Long studentId, Long subjectId, Integer limit);

    public Map<String, Object> studentSummary(Long studentId, Long subjectId);

    public List<Map<String, Object>> classWeakTop(Long deptId, Long subjectId, Integer limit);

    public List<Map<String, Object>> classWeakTop(Long deptId, Long subjectId, Integer limit, String window,
        List<Long> paperIds);

    public Map<String, Object> classHeatmap(Long deptId, Long subjectId);

    public Map<String, Object> classHeatmap(Long deptId, Long subjectId, String window, List<Long> paperIds);

    public Map<String, Object> classOverview(Long deptId, Long subjectId);

    public Map<String, Object> classOverview(Long deptId, Long subjectId, String window, List<Long> paperIds);

    public Map<String, Object> knowledgeOverview(Long knowledgeId, Long deptId);

    public Map<String, Object> knowledgeOverview(Long knowledgeId, Long deptId, String window, List<Long> paperIds);

    /** knowledgeId null = subject-wide; version/chapter nodes roll up descendant leaves */
    public Map<String, Object> knowledgeOverview(Long knowledgeId, Long subjectId, Long deptId, String window,
        List<Long> paperIds);

    public List<Map<String, Object>> studentKnowledgeQuestions(Long studentId, Long knowledgeId, Long subjectId);

    public List<Map<String, Object>> studentKnowledgeQuestions(Long studentId, Long knowledgeId, Long subjectId,
        String window, List<Long> paperIds);

    public int recalculateByPaper(Long paperId);

    public int recalculateByStudent(Long studentId);

    public int recalculateByStudents(Collection<Long> studentIds, Long paperId);

    /** Recalc all students under dept (optional subject filter) with new algorithm, then refresh warnings. */
    public Map<String, Object> recalculateByDept(Long deptId, Long subjectId);

    public List<Map<String, Object>> studentChapterRadar(Long studentId, Long subjectId);

    public List<Map<String, Object>> studentChapterRadar(Long studentId, Long subjectId, String window,
        List<Long> paperIds);

    public Map<String, Object> classChapterOverview(Long deptId, Long subjectId);

    public Map<String, Object> classChapterOverview(Long deptId, Long subjectId, String window, List<Long> paperIds);

    public Map<String, Object> paperAnnotationCoverage(List<Long> paperIds);

    public List<Map<String, Object>> classTrend(Long deptId, Long subjectId, String window);

    public List<Map<String, Object>> classTrend(Long deptId, Long subjectId, String window, List<Long> paperIds);

    public List<Map<String, Object>> studentRadar(Long studentId, Long subjectId, String window);

    public List<Map<String, Object>> studentRadar(Long studentId, Long subjectId, String window, List<Long> paperIds);

    public List<Map<String, Object>> studentTrend(Long studentId, Long subjectId, String window);

    public List<Map<String, Object>> studentTrend(Long studentId, Long subjectId, String window, List<Long> paperIds);

    public Map<String, Object> studentSummary(Long studentId, Long subjectId, String window);

    public Map<String, Object> studentSummary(Long studentId, Long subjectId, String window, List<Long> paperIds);

    public List<Map<String, Object>> studentWeakTop(Long studentId, Long subjectId, Integer limit, String window);

    public List<Map<String, Object>> studentWeakTop(Long studentId, Long subjectId, Integer limit, String window,
        List<Long> paperIds);

    public List<Map<String, Object>> knowledgeExamTrend(Long studentId, Long knowledgeId, Long subjectId,
        List<Long> paperIds, String window);

    public List<Map<String, Object>> classKnowledgeExamTrend(Long deptId, Long knowledgeId, Long subjectId,
        String window, List<Long> paperIds);

    public List<Map<String, Object>> persistentWeak(Long studentId, Long subjectId, List<Long> paperIds, String window,
        Integer minPapers, Double rateThreshold, Double ratio);

    /** Papers-mode vs baseline window: delta overallRate + newly persistent weaks. */
    public Map<String, Object> studentScopeCompare(Long studentId, Long subjectId, List<Long> paperIds,
        String baselineWindow);

    /** Knowledge examination frequency for one or more papers */
    public Map<String, Object> knowledgeFrequency(List<Long> paperIds, Long subjectId);

    /** Knowledge priority: frequency × mastery cross analysis */
    public Map<String, Object> knowledgePriority(List<Long> paperIds, Long subjectId, Long deptId);

    public Map<String, Object> knowledgePriority(List<Long> paperIds, Long subjectId, Long deptId, String masteryScope);

    /** Analysis runtime config (window / recency / thresholds) */
    public Map<String, Object> analysisConfig();

    public int recalculateByPaper(Long paperId, Boolean useRecency);

    public int recalculateByStudent(Long studentId, Boolean useRecency);

    public Map<String, Object> recalculateByDept(Long deptId, Long subjectId, Boolean useRecency);

    /** D1 question-type breakdown */
    public Map<String, Object> studentQuestionType(Long studentId, Long subjectId, String window, List<Long> paperIds);

    public Map<String, Object> classQuestionType(Long deptId, Long subjectId, String window, List<Long> paperIds);

    /** D3 chapter progress/regress */
    public Map<String, Object> studentChapterDelta(Long studentId, Long subjectId, String window, List<Long> paperIds,
        String baselineWindow);

    public Map<String, Object> classChapterDelta(Long deptId, Long subjectId, String window, List<Long> paperIds,
        String baselineWindow);

    /** D4 Bloom level breakdown */
    public Map<String, Object> studentBloom(Long studentId, Long subjectId, String window, List<Long> paperIds);

    public Map<String, Object> classBloom(Long deptId, Long subjectId, String window, List<Long> paperIds);
}
