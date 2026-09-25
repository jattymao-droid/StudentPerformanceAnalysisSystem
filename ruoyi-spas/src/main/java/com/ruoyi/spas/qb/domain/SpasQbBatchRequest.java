package com.ruoyi.spas.qb.domain;

import java.util.List;

/**
 * Batch insert after human review of parsed paper
 */
public class SpasQbBatchRequest
{
    private Long subjectId;
    private List<SpasQbParseItem> items;
    /** Skip rows that hit content_hash; default true */
    private Boolean skipDuplicate;
    /**
     * When true, persist smart-annotate knowledgeList on insert.
     * Default false: strip AI/heuristic KP unless item.knowledgeConfirmed.
     */
    private Boolean acceptAiKnowledge;

    public Long getSubjectId() { return subjectId; }
    public void setSubjectId(Long subjectId) { this.subjectId = subjectId; }
    public List<SpasQbParseItem> getItems() { return items; }
    public void setItems(List<SpasQbParseItem> items) { this.items = items; }
    public Boolean getSkipDuplicate() { return skipDuplicate; }
    public void setSkipDuplicate(Boolean skipDuplicate) { this.skipDuplicate = skipDuplicate; }
    public Boolean getAcceptAiKnowledge() { return acceptAiKnowledge; }
    public void setAcceptAiKnowledge(Boolean acceptAiKnowledge) { this.acceptAiKnowledge = acceptAiKnowledge; }
}
