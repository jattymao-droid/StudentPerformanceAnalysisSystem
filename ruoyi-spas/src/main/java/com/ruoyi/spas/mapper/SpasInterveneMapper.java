package com.ruoyi.spas.mapper;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasInterveneTask;

public interface SpasInterveneMapper
{
    List<SpasInterveneTask> selectSpasInterveneTaskList(SpasInterveneTask task);

    SpasInterveneTask selectSpasInterveneTaskById(Long interveneId);

    List<SpasInterveneTask> selectOpenByStudentIds(@Param("studentIds") Collection<Long> studentIds);

    List<SpasInterveneTask> selectByStudentId(@Param("studentId") Long studentId);

    int insertSpasInterveneTask(SpasInterveneTask task);

    int updateSpasInterveneTask(SpasInterveneTask task);

    int countOpenByStudent(Long studentId);

    int deleteInterveneKnowledge(@Param("interveneId") Long interveneId);

    int insertInterveneKnowledge(@Param("interveneId") Long interveneId, @Param("knowledgeId") Long knowledgeId);

    List<Long> selectInterveneKnowledgeIds(@Param("interveneId") Long interveneId);

    Map<String, Object> selectDeptSummary(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId);
}
