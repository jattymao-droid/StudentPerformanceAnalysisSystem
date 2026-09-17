package com.ruoyi.spas.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;

public interface SpasQualityMapper
{
    Map<String, Object> selectOverview(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("minAttempts") int minAttempts);

    List<Map<String, Object>> selectNoKnowledge(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId);

    List<Map<String, Object>> selectWeightSum(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId);

    List<Map<String, Object>> selectLowAttempt(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("minAttempts") int minAttempts);

    List<Map<String, Object>> selectMissingExamDate(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId);

    List<Map<String, Object>> selectPartialPaper(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId);

    List<Map<String, Object>> selectOrphanScore(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId);

    List<Map<String, Object>> selectBlankZero(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId);
}
