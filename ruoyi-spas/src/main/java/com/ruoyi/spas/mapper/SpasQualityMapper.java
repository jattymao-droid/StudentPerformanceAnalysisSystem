package com.ruoyi.spas.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;

public interface SpasQualityMapper
{
    Map<String, Object> selectOverview(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("minAttempts") int minAttempts,
        @Param("questionMin") int questionMin,
        @Param("weakRate") double weakRate);

    List<Map<String, Object>> selectNoKnowledge(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId);

    List<Map<String, Object>> selectNoQuestionType(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId);

    List<Map<String, Object>> selectNoBloom(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId);

    List<Map<String, Object>> selectWeightSum(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId);

    List<Map<String, Object>> selectLowAttempt(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("minAttempts") int minAttempts);

    /** Weak tagged but attempt &lt; minAttempts (do not over-interpret). */
    List<Map<String, Object>> selectWeakLowEvidence(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("minAttempts") int minAttempts);

    List<Map<String, Object>> selectMissingExamDate(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId);

    List<Map<String, Object>> selectPartialPaper(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId);

    List<Map<String, Object>> selectOrphanScore(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId);

    List<Map<String, Object>> selectBlankZero(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId);

    List<Map<String, Object>> selectHighFreqLowMastery(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("minAttempts") int minAttempts, @Param("questionMin") int questionMin, @Param("weakRate") double weakRate);
}
