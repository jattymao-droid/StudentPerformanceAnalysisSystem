package com.ruoyi.spas.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasKnowledgeEdge;

/**
 * Knowledge prerequisite edge mapper
 */
public interface SpasKnowledgeEdgeMapper
{
    public SpasKnowledgeEdge selectById(Long edgeId);

    public List<SpasKnowledgeEdge> selectBySubjectId(@Param("subjectId") Long subjectId);

    public List<SpasKnowledgeEdge> selectByToKnowledgeId(@Param("toKnowledgeId") Long toKnowledgeId);

    public List<SpasKnowledgeEdge> selectByFromKnowledgeId(@Param("fromKnowledgeId") Long fromKnowledgeId);

    public SpasKnowledgeEdge selectUnique(@Param("fromKnowledgeId") Long fromKnowledgeId,
        @Param("toKnowledgeId") Long toKnowledgeId, @Param("relation") String relation);

    public int insertSpasKnowledgeEdge(SpasKnowledgeEdge edge);

    public int deleteById(Long edgeId);

    public int deleteByKnowledgeId(Long knowledgeId);
}
