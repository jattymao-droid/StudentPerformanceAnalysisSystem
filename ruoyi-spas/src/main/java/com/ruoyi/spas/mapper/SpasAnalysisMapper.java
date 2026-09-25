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
     * Batch load score rows for full-history recalc (avoids per-student round trips).
     */
    public List<SpasAnalysisScoreRow> selectScoreRowsForRecalcByStudents(@Param("studentIds") List<Long> studentIds);

    /**
     * Score rows for scoped live aggregation (optional student / subject / date / papers / dept / knowledge).
     */
    public List<SpasAnalysisScoreRow> selectScoreRowsForScope(@Param("studentId") Long studentId,
        @Param("subjectId") Long subjectId, @Param("examDateFrom") java.util.Date examDateFrom,
        @Param("paperIds") List<Long> paperIds, @Param("deptId") Long deptId,
        @Param("knowledgeId") Long knowledgeId);

    public List<Long> selectStudentIdsByPaperIds(@Param("paperIds") List<Long> paperIds,
        @Param("deptId") Long deptId);

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
     * Delete stats for many students in one statement
     */
    public int deleteStatByStudents(@Param("studentIds") List<Long> studentIds);

    /**
     * Student radar points
     */
    public List<Map<String, Object>> selectStudentRadar(@Param("studentId") Long studentId,
        @Param("subjectId") Long subjectId);

    /**
     * Student paper trend
     */
    public List<Map<String, Object>> selectStudentTrend(@Param("studentId") Long studentId,
        @Param("subjectId") Long subjectId, @Param("examDateFrom") java.util.Date examDateFrom,
        @Param("paperIds") List<Long> paperIds);

    /** D1: student score aggregated by question_type */
    public List<Map<String, Object>> selectStudentQuestionType(@Param("studentId") Long studentId,
        @Param("subjectId") Long subjectId, @Param("examDateFrom") java.util.Date examDateFrom,
        @Param("paperIds") List<Long> paperIds);

    /** D1: class score aggregated by question_type */
    public List<Map<String, Object>> selectClassQuestionType(@Param("deptId") Long deptId,
        @Param("subjectId") Long subjectId, @Param("examDateFrom") java.util.Date examDateFrom,
        @Param("paperIds") List<Long> paperIds);

    /** D4: student score aggregated by bloom_level */
    public List<Map<String, Object>> selectStudentBloom(@Param("studentId") Long studentId,
        @Param("subjectId") Long subjectId, @Param("examDateFrom") java.util.Date examDateFrom,
        @Param("paperIds") List<Long> paperIds);

    /** D4: class score aggregated by bloom_level */
    public List<Map<String, Object>> selectClassBloom(@Param("deptId") Long deptId,
        @Param("subjectId") Long subjectId, @Param("examDateFrom") java.util.Date examDateFrom,
        @Param("paperIds") List<Long> paperIds);

    /** Papers in exam-date range for prev-semester / chapter-delta baselines */
    public List<Long> selectPaperIdsByExamDateRange(@Param("subjectId") Long subjectId,
        @Param("examDateFrom") java.util.Date examDateFrom, @Param("examDateTo") java.util.Date examDateTo);

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
        @Param("subjectId") Long subjectId, @Param("weakRate") Double weakRate,
        @Param("severeRate") Double severeRate, @Param("minAttempts") Integer minAttempts);

    /**
     * Subjects that have annotated score_detail for the student (optional window / papers).
     */
    public List<Map<String, Object>> selectStudentSubjectsWithData(@Param("studentId") Long studentId,
        @Param("examDateFrom") java.util.Date examDateFrom, @Param("paperIds") List<Long> paperIds);

    /**
     * Subjects that have annotated score_detail in a dept (optional window / papers).
     */
    public List<Map<String, Object>> selectDeptSubjectsWithData(@Param("deptId") Long deptId,
        @Param("examDateFrom") java.util.Date examDateFrom, @Param("paperIds") List<Long> paperIds);

    /**
     * Class student ranking by overall attempt-weighted rate (asc = weakest first)
     */
    public List<Map<String, Object>> selectClassStudentRanking(@Param("deptId") Long deptId,
        @Param("subjectId") Long subjectId, @Param("weakRate") Double weakRate,
        @Param("severeRate") Double severeRate, @Param("minAttempts") Integer minAttempts);

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
        @Param("knowledgeId") Long knowledgeId, @Param("subjectId") Long subjectId,
        @Param("examDateFrom") java.util.Date examDateFrom, @Param("paperIds") List<Long> paperIds);

    /**
     * All knowledge stats for a student (optional subject)
     */
    public List<SpasStudentKnowledgeStat> selectStudentKnowledgeStats(@Param("studentId") Long studentId,
        @Param("subjectId") Long subjectId);

    public List<Map<String, Object>> selectStudentChapterRadar(@Param("studentId") Long studentId,
        @Param("subjectId") Long subjectId);

    public List<Map<String, Object>> selectClassChapterOverview(@Param("deptId") Long deptId,
        @Param("subjectId") Long subjectId, @Param("weakRate") Double weakRate);

    /** leaf knowledgeId -> chapter knowledgeId/name for rollup */
    public List<Map<String, Object>> selectLeafChapterMap(@Param("subjectId") Long subjectId);

    /** Annotation coverage for selected papers */
    public Map<String, Object> selectPaperAnnotationCoverage(@Param("paperIds") List<Long> paperIds);

    public List<Map<String, Object>> selectKnowledgeOverviewChapter(@Param("knowledgeId") Long knowledgeId,
        @Param("deptId") Long deptId, @Param("deptIds") List<Long> deptIds);

    /** Subject-wide leaf rollup (全部知识点) */
    public List<Map<String, Object>> selectKnowledgeOverviewSubject(@Param("subjectId") Long subjectId,
        @Param("deptId") Long deptId, @Param("deptIds") List<Long> deptIds);

    /** Child breakdown: versions under subject, chapters under version, leaves under chapter */
    public List<Map<String, Object>> selectKnowledgeChildBreakdown(@Param("subjectId") Long subjectId,
        @Param("parentId") Long parentId, @Param("childNodeType") String childNodeType,
        @Param("deptId") Long deptId, @Param("deptIds") List<Long> deptIds,
        @Param("weakRate") Double weakRate);

    /** Class comparison for subject/version/chapter rollup */
    public List<Map<String, Object>> selectKnowledgeClassComparisonRollup(@Param("subjectId") Long subjectId,
        @Param("knowledgeId") Long knowledgeId, @Param("deptIds") List<Long> deptIds);

    public List<Map<String, Object>> selectClassTrend(@Param("deptId") Long deptId,
        @Param("subjectId") Long subjectId, @Param("examDateFrom") java.util.Date examDateFrom,
        @Param("paperIds") List<Long> paperIds, @Param("weakRate") Double weakRate);

    /**
     * Knowledge exam frequency aggregated across selected papers
     */
    public List<Map<String, Object>> selectKnowledgeFrequency(@Param("paperIds") List<Long> paperIds,
        @Param("subjectId") Long subjectId);

    /**
     * Knowledge frequency broken down by paper (for multi-exam comparison)
     */
    public List<Map<String, Object>> selectKnowledgeFrequencyByPaper(@Param("paperIds") List<Long> paperIds,
        @Param("subjectId") Long subjectId);

    /**
     * Knowledge priority matrix: exam frequency × mastery for selected papers
     */
    public List<Map<String, Object>> selectKnowledgePriority(@Param("paperIds") List<Long> paperIds,
        @Param("subjectId") Long subjectId, @Param("deptId") Long deptId);

    /** Per-question class avg rate and student count for empirical difficulty. */
    public List<Map<String, Object>> selectQuestionEmpiricalRates();

    /** Weak students in a dept tree for one knowledge (for batch intervene). */
    public List<Map<String, Object>> selectWeakStudentsByKnowledge(@Param("deptId") Long deptId,
        @Param("subjectId") Long subjectId, @Param("knowledgeId") Long knowledgeId);
}
