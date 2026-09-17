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

    public Map<String, Object> classHeatmap(Long deptId, Long subjectId);

    public Map<String, Object> classOverview(Long deptId, Long subjectId);

    public Map<String, Object> knowledgeOverview(Long knowledgeId, Long deptId);

    public List<Map<String, Object>> studentKnowledgeQuestions(Long studentId, Long knowledgeId, Long subjectId);

    public int recalculateByPaper(Long paperId);

    public int recalculateByStudent(Long studentId);

    public int recalculateByStudents(Collection<Long> studentIds, Long paperId);

    /** Recalc all students under dept (optional subject filter) with new algorithm, then refresh warnings. */
    public Map<String, Object> recalculateByDept(Long deptId, Long subjectId);

    public List<Map<String, Object>> studentChapterRadar(Long studentId, Long subjectId);

    public Map<String, Object> classChapterOverview(Long deptId, Long subjectId);

    public List<Map<String, Object>> classTrend(Long deptId, Long subjectId, String window);

    public List<Map<String, Object>> studentRadar(Long studentId, Long subjectId, String window);

    public List<Map<String, Object>> studentTrend(Long studentId, Long subjectId, String window);

    public Map<String, Object> studentSummary(Long studentId, Long subjectId, String window);

    public List<Map<String, Object>> studentWeakTop(Long studentId, Long subjectId, Integer limit, String window);
}
