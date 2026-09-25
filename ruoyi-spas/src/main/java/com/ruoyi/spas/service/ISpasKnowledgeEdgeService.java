package com.ruoyi.spas.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.spas.domain.SpasKnowledgeEdge;

/**
 * Knowledge prerequisite edge service
 */
public interface ISpasKnowledgeEdgeService
{
    public List<SpasKnowledgeEdge> selectBySubjectId(Long subjectId);

    public List<SpasKnowledgeEdge> selectByToKnowledgeId(Long toKnowledgeId);

    public List<SpasKnowledgeEdge> selectByFromKnowledgeId(Long fromKnowledgeId);

    public SpasKnowledgeEdge selectById(Long edgeId);

    public int insertSpasKnowledgeEdge(SpasKnowledgeEdge edge);

    public int deleteById(Long edgeId);

    /**
     * Enrich each weak row (with knowledgeId) with dependencyHints / rootHint
     * when prerequisites are also weak (in weakList or rate below weak threshold).
     */
    public void buildDependencyHints(Long studentId, Long subjectId, List<Map<String, Object>> weakList);

    /**
     * Same as {@link #buildDependencyHints(Long, Long, List)} but accepts an external
     * knowledgeId to rate map (e.g. class average rates for class weak-top).
     */
    public void buildDependencyHints(Long studentId, Long subjectId, List<Map<String, Object>> weakList,
        Map<Long, java.math.BigDecimal> externalRates);
}
