package com.ruoyi.spas.qb.domain;

import java.math.BigDecimal;

public class SpasQbAiSuggestItem
{
    private Long knowledgeId;
    private String knowledgeName;
    private BigDecimal weight;
    private String reason;
    private Double score;

    public Long getKnowledgeId() { return knowledgeId; }
    public void setKnowledgeId(Long knowledgeId) { this.knowledgeId = knowledgeId; }
    public String getKnowledgeName() { return knowledgeName; }
    public void setKnowledgeName(String knowledgeName) { this.knowledgeName = knowledgeName; }
    public BigDecimal getWeight() { return weight; }
    public void setWeight(BigDecimal weight) { this.weight = weight; }
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    public Double getScore() { return score; }
    public void setScore(Double score) { this.score = score; }
}
