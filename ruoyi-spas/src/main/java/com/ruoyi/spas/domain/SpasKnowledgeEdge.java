package com.ruoyi.spas.domain;

import java.math.BigDecimal;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Knowledge prerequisite edge spas_knowledge_edge
 * from_knowledge_id = prerequisite of to_knowledge_id
 */
public class SpasKnowledgeEdge extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long edgeId;

    private Long subjectId;

    /** Prerequisite (先修) */
    private Long fromKnowledgeId;

    /** Dependent (后继) */
    private Long toKnowledgeId;

    /** Default: prerequisite */
    private String relation;

    private BigDecimal weight;

    private String status;

    /** display */
    private String fromKnowledgeName;

    private String toKnowledgeName;

    private String subjectName;

    public Long getEdgeId()
    {
        return edgeId;
    }

    public void setEdgeId(Long edgeId)
    {
        this.edgeId = edgeId;
    }

    public Long getSubjectId()
    {
        return subjectId;
    }

    public void setSubjectId(Long subjectId)
    {
        this.subjectId = subjectId;
    }

    public Long getFromKnowledgeId()
    {
        return fromKnowledgeId;
    }

    public void setFromKnowledgeId(Long fromKnowledgeId)
    {
        this.fromKnowledgeId = fromKnowledgeId;
    }

    public Long getToKnowledgeId()
    {
        return toKnowledgeId;
    }

    public void setToKnowledgeId(Long toKnowledgeId)
    {
        this.toKnowledgeId = toKnowledgeId;
    }

    public String getRelation()
    {
        return relation;
    }

    public void setRelation(String relation)
    {
        this.relation = relation;
    }

    public BigDecimal getWeight()
    {
        return weight;
    }

    public void setWeight(BigDecimal weight)
    {
        this.weight = weight;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getFromKnowledgeName()
    {
        return fromKnowledgeName;
    }

    public void setFromKnowledgeName(String fromKnowledgeName)
    {
        this.fromKnowledgeName = fromKnowledgeName;
    }

    public String getToKnowledgeName()
    {
        return toKnowledgeName;
    }

    public void setToKnowledgeName(String toKnowledgeName)
    {
        this.toKnowledgeName = toKnowledgeName;
    }

    public String getSubjectName()
    {
        return subjectName;
    }

    public void setSubjectName(String subjectName)
    {
        this.subjectName = subjectName;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("edgeId", getEdgeId())
            .append("subjectId", getSubjectId())
            .append("fromKnowledgeId", getFromKnowledgeId())
            .append("toKnowledgeId", getToKnowledgeId())
            .append("relation", getRelation())
            .append("weight", getWeight())
            .append("status", getStatus())
            .append("remark", getRemark())
            .toString();
    }
}
