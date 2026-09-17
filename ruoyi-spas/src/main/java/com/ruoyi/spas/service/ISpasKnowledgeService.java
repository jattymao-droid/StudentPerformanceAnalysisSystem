package com.ruoyi.spas.service;

import java.util.List;
import com.ruoyi.spas.domain.SpasKnowledge;

/**
 * Knowledge service
 */
public interface ISpasKnowledgeService
{
    public List<SpasKnowledge> selectSpasKnowledgeList(SpasKnowledge knowledge);

    public SpasKnowledge selectSpasKnowledgeById(Long knowledgeId);

    public List<SpasKnowledge> selectKnowledgeTree(Long subjectId);

    public int insertSpasKnowledge(SpasKnowledge knowledge);

    public int updateSpasKnowledge(SpasKnowledge knowledge);

    public int deleteSpasKnowledgeById(Long knowledgeId);
}
