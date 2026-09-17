package com.ruoyi.spas.domain;

import java.math.BigDecimal;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * Question-knowledge link spas_question_knowledge
 */
public class SpasQuestionKnowledge
{
    private static final long serialVersionUID = 1L;

    /** Link ID */
    private Long id;

    /** Question ID */
    private Long questionId;

    /** Knowledge ID */
    private Long knowledgeId;

    /** Weight (sum per question = 1) */
    private BigDecimal weight;

    /** Primary flag (0 no 1 yes) */
    private String isPrimary;

    /** Knowledge name (display) */
    private String knowledgeName;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getQuestionId()
    {
        return questionId;
    }

    public void setQuestionId(Long questionId)
    {
        this.questionId = questionId;
    }

    public Long getKnowledgeId()
    {
        return knowledgeId;
    }

    public void setKnowledgeId(Long knowledgeId)
    {
        this.knowledgeId = knowledgeId;
    }

    public BigDecimal getWeight()
    {
        return weight;
    }

    public void setWeight(BigDecimal weight)
    {
        this.weight = weight;
    }

    public String getIsPrimary()
    {
        return isPrimary;
    }

    public void setIsPrimary(String isPrimary)
    {
        this.isPrimary = isPrimary;
    }

    public String getKnowledgeName()
    {
        return knowledgeName;
    }

    public void setKnowledgeName(String knowledgeName)
    {
        this.knowledgeName = knowledgeName;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("questionId", getQuestionId())
            .append("knowledgeId", getKnowledgeId())
            .append("weight", getWeight())
            .append("isPrimary", getIsPrimary())
            .toString();
    }
}
