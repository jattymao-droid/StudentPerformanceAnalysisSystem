package com.ruoyi.spas.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasKnowledge;

/**
 * Knowledge mapper
 */
public interface SpasKnowledgeMapper
{
    public List<SpasKnowledge> selectSpasKnowledgeList(SpasKnowledge knowledge);

    public SpasKnowledge selectSpasKnowledgeById(Long knowledgeId);

    public List<SpasKnowledge> selectSpasKnowledgeBySubjectId(Long subjectId);

    public int hasChildByKnowledgeId(Long knowledgeId);

    public int countQuestionKnowledgeByKnowledgeId(Long knowledgeId);

    public List<SpasKnowledge> selectChildrenKnowledgeById(Long knowledgeId);

    public int insertSpasKnowledge(SpasKnowledge knowledge);

    public int updateSpasKnowledge(SpasKnowledge knowledge);

    public int updateKnowledgeChildren(@Param("knowledges") List<SpasKnowledge> knowledges);

    public int deleteSpasKnowledgeById(Long knowledgeId);
}
