package com.ruoyi.spas.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasAnalysisScoreRow;
import com.ruoyi.spas.domain.SpasStudentKnowledgeStat;

/**
 * Analysis and knowledge-stat mapper
 */
public interface SpasAnalysisMapper
{
    /**
     * Load score rows for recalculation. Filters are optional.
     */
    public List<SpasAnalysisScoreRow> selectScoreRowsForRecalc(@Param("studentId") Long studentId,
        @Param("paperId") Long paperId);

    /**
     * Distinct students who have scores on the paper
     */
    public List<Long> selectStudentIdsByPaperId(Long paperId);

    /**
     * Students with any score detail, scoped by dept (and optional subject via paper)
     */
    public List<Long> selectStudentIdsForRecalc(@Param("deptId") Long deptId,
        @Param("subjectId") Long subjectId);

    /**
     * Upsert knowledge stat snapshot
     */
    public int upsertStat(SpasStudentKnowledgeStat stat);

    /**
     * Delete all stats for a student
     */
    public int deleteStatByStudent(Long studentId);

    /**
     * Student radar points
     */
    public List<Map<String, Object>> selectStudentRadar(@Param("studentId") Long studentId,
        @Param("subjectId") Long subjectId);

    /**
     * Student paper trend
     */
    public List<Map<String, Object>> selectStudentTrend(@Param("studentId") Long studentId,
        @Param("subjectId") Long subjectId, @Param("examDateFrom") java.util.Date examDateFrom);

    /**
     * Student weak knowledge top-N
     */
    public List<Map<String, Object>> selectStudentWeakTop(@Param("studentId") Long studentId,
        @Param("subjectId") Long subjectId, @Param("limit") Integer limit);

    /**
     * Class weak knowledge top-N (avg weighted rate)
     */
    public List<Map<String, Object>> selectClassWeakTop(@Param("deptId") Long deptId,
        @Param("subjectId") Long subjectId, @Param("limit") Integer limit);

    /**
     * Students in class for heatmap axis
     */
    public List<Map<String, Object>> selectClassHeatmapStudents(@Param("deptId") Long deptId);

    /**
     * Knowledges for heatmap axis (with any class stats)
     */
    public List<Map<String, Object>> selectClassHeatmapKnowledges(@Param("deptId") Long deptId,
        @Param("subjectId") Long subjectId);

    /**
     * Student-knowledge rates for heatmap cells
     */
    public List<Map<String, Object>> selectClassHeatmapRates(@Param("deptId") Long deptId,
        @Param("subjectId") Long subjectId);

    /**
     * Class knowledge overview rows (avg rates and weak counts)
     */
    public List<Map<String, Object>> selectClassOverview(@Param("deptId") Long deptId,
        @Param("subjectId") Long subjectId);

    /**
     * Class summary KPIs (avgRate / studentCount / weakStudentCount)
     */
    public Map<String, Object> selectClassSummary(@Param("deptId") Long deptId,
        @Param("subjectId") Long subjectId);

    /**
     * Student overall summary vs class (attempt-weighted)
     */
    public Map<String, Object> selectStudentSummary(@Param("studentId") Long studentId,
        @Param("subjectId") Long subjectId);

    /**
     * Class student ranking by overall attempt-weighted rate (asc = weakest first)
     */
    public List<Map<String, Object>> selectClassStudentRanking(@Param("deptId") Long deptId,
        @Param("subjectId") Long subjectId);

    /**
     * Knowledge drill-down overview by class
     */
    public List<Map<String, Object>> selectKnowledgeOverview(@Param("knowledgeId") Long knowledgeId,
        @Param("deptId") Long deptId, @Param("deptIds") List<Long> deptIds);

    /**
     * Class comparison for a knowledge point
     */
    public List<Map<String, Object>> selectKnowledgeClassComparison(@Param("knowledgeId") Long knowledgeId,
        @Param("deptIds") List<Long> deptIds);

    /**
     * Questions linked to a knowledge point with avg rates
     */
    public List<Map<String, Object>> selectKnowledgeQuestions(@Param("knowledgeId") Long knowledgeId,
        @Param("deptId") Long deptId, @Param("deptIds") List<Long> deptIds);

    /**
     * Student question breakdown for a knowledge point
     */
    public List<Map<String, Object>> selectStudentKnowledgeQuestions(@Param("studentId") Long studentId,
        @Param("knowledgeId") Long knowledgeId, @Param("subjectId") Long subjectId);

    /**
     * All knowledge stats for a student (optional subject)
     */
    public List<SpasStudentKnowledgeStat> selectStudentKnowledgeStats(@Param("studentId") Long studentId,
        @Param("subjectId") Long subjectId);

    public List<Map<String, Object>> selectStudentChapterRadar(@Param("studentId") Long studentId,
        @Param("subjectId") Long subjectId);

    public List<Map<String, Object>> selectClassChapterOverview(@Param("deptId") Long deptId,
        @Param("subjectId") Long subjectId);

    public List<Map<String, Object>> selectStudentRadarLive(@Param("studentId") Long studentId,
        @Param("subjectId") Long subjectId, @Param("examDateFrom") java.util.Date examDateFrom);

    public Map<String, Object> selectStudentSummaryLive(@Param("studentId") Long studentId,
        @Param("subjectId") Long subjectId, @Param("examDateFrom") java.util.Date examDateFrom);

    public List<Map<String, Object>> selectKnowledgeOverviewChapter(@Param("knowledgeId") Long knowledgeId,
        @Param("deptId") Long deptId, @Param("deptIds") List<Long> deptIds);

    public List<Map<String, Object>> selectClassTrend(@Param("deptId") Long deptId,
        @Param("subjectId") Long subjectId, @Param("examDateFrom") java.util.Date examDateFrom);
}
