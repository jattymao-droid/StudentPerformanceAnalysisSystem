package com.ruoyi.spas.mapper;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;

/**
 * Extra queries for warning engine metrics
 */
public interface SpasWarningMetricMapper
{
    List<Map<String, Object>> selectStudentAvgRate(@Param("subjectId") Long subjectId, @Param("deptId") Long deptId);

    List<Map<String, Object>> selectStudentWeakCount(@Param("subjectId") Long subjectId, @Param("deptId") Long deptId);

    List<Map<String, Object>> selectStudentVsClassGap(@Param("subjectId") Long subjectId, @Param("deptId") Long deptId);

    List<Map<String, Object>> selectStudentPaperRates(@Param("studentId") Long studentId, @Param("subjectId") Long subjectId, @Param("limit") Integer limit);

    List<Long> selectStudentIdsByPaper(@Param("paperId") Long paperId);
}
