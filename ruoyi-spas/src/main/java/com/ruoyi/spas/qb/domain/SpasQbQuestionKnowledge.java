package com.ruoyi.spas.qb.domain;

import java.math.BigDecimal;

public class SpasQbQuestionKnowledge
{
    private Long id;
    private Long questionId;
    private Long knowledgeId;
    private BigDecimal weight;
    private String isPrimary;
    private String knowledgeName;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getQuestionId() { return questionId; }
    public void setQuestionId(Long questionId) { this.questionId = questionId; }
    public Long getKnowledgeId() { return knowledgeId; }
    public void setKnowledgeId(Long knowledgeId) { this.knowledgeId = knowledgeId; }
    public BigDecimal getWeight() { return weight; }
    public void setWeight(BigDecimal weight) { this.weight = weight; }
    public String getIsPrimary() { return isPrimary; }
    public void setIsPrimary(String isPrimary) { this.isPrimary = isPrimary; }
    public String getKnowledgeName() { return knowledgeName; }
    public void setKnowledgeName(String knowledgeName) { this.knowledgeName = knowledgeName; }
}
