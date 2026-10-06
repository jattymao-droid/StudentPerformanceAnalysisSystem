package com.ruoyi.spas.domain;

/**
 * Practice log knowledge link
 */
public class SpasPracticeLogKnowledge
{
    private Long id;
    private Long logId;
    private Long knowledgeId;
    private String isPrimary;
    private String knowledgeName;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getLogId() { return logId; }
    public void setLogId(Long logId) { this.logId = logId; }
    public Long getKnowledgeId() { return knowledgeId; }
    public void setKnowledgeId(Long knowledgeId) { this.knowledgeId = knowledgeId; }
    public String getIsPrimary() { return isPrimary; }
    public void setIsPrimary(String isPrimary) { this.isPrimary = isPrimary; }
    public String getKnowledgeName() { return knowledgeName; }
    public void setKnowledgeName(String knowledgeName) { this.knowledgeName = knowledgeName; }
}
