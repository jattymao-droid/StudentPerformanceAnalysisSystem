package com.ruoyi.spas.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasStudent;

/**
 * Home dashboard aggregate queries
 */
public interface SpasDashboardMapper
{
    int countActiveStudents(@Param("scope") SpasStudent scope);

    int countOpenWarnings(@Param("scope") SpasStudent scope);

    int countPublishedPapers(@Param("scope") SpasStudent scope);

    List<Map<String, Object>> selectRecentBatches(@Param("scope") SpasStudent scope, @Param("limit") int limit);

    List<Map<String, Object>> selectWeakKnowledgeTop(@Param("scope") SpasStudent scope, @Param("limit") int limit);

    int countOpenIntervenes(@Param("scope") SpasStudent scope);

    int countQualityAlerts(@Param("scope") SpasStudent scope);
}
