package com.ruoyi.spas.domain;

import java.util.ArrayList;
import java.util.List;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Knowledge point entity spas_knowledge
 */
public class SpasKnowledge extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** Knowledge ID */
    private Long knowledgeId;

    /** Subject ID */
    @Excel(name = "Subject Id")
    private Long subjectId;

    /** Parent ID */
    private Long parentId;

    /** Ancestors path */
    private String ancestors;

    /** Knowledge name */
    @Excel(name = "Knowledge Name")
    private String knowledgeName;

    /** Knowledge code */
    @Excel(name = "Knowledge Code")
    private String knowledgeCode;

    /** Default difficulty (1 easy 2 medium 3 hard) */
    @Excel(name = "Difficulty", readConverterExp = "1=easy,2=medium,3=hard")
    private String difficultyDefault;

    /** Node type (0 version 1 chapter 2 knowledge) */
    @Excel(name = "Node Type", readConverterExp = "0=version,1=chapter,2=knowledge")
    private String nodeType;

    /** Display order */
    private Integer orderNum;

    /** Status (0 normal 1 disabled) */
    @Excel(name = "Status", readConverterExp = "0=normal,1=disabled")
    private String status;

    /** Parent name (optional display) */
    private String parentName;

    /** Child nodes */
    private List<SpasKnowledge> children = new ArrayList<SpasKnowledge>();

    public Long getKnowledgeId()
    {
        return knowledgeId;
    }

    public void setKnowledgeId(Long knowledgeId)
    {
        this.knowledgeId = knowledgeId;
    }

    public Long getSubjectId()
    {
        return subjectId;
    }

    public void setSubjectId(Long subjectId)
    {
        this.subjectId = subjectId;
    }

    public Long getParentId()
    {
        return parentId;
    }

    public void setParentId(Long parentId)
    {
        this.parentId = parentId;
    }

    public String getAncestors()
    {
        return ancestors;
    }

    public void setAncestors(String ancestors)
    {
        this.ancestors = ancestors;
    }

    public String getKnowledgeName()
    {
        return knowledgeName;
    }

    public void setKnowledgeName(String knowledgeName)
    {
        this.knowledgeName = knowledgeName;
    }

    public String getKnowledgeCode()
    {
        return knowledgeCode;
    }

    public void setKnowledgeCode(String knowledgeCode)
    {
        this.knowledgeCode = knowledgeCode;
    }

    public String getDifficultyDefault()
    {
        return difficultyDefault;
    }

    public void setDifficultyDefault(String difficultyDefault)
    {
        this.difficultyDefault = difficultyDefault;
    }

    public String getNodeType()
    {
        return nodeType;
    }

    public void setNodeType(String nodeType)
    {
        this.nodeType = nodeType;
    }

    public Integer getOrderNum()
    {
        return orderNum;
    }

    public void setOrderNum(Integer orderNum)
    {
        this.orderNum = orderNum;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getParentName()
    {
        return parentName;
    }

    public void setParentName(String parentName)
    {
        this.parentName = parentName;
    }

    public List<SpasKnowledge> getChildren()
    {
        return children;
    }

    public void setChildren(List<SpasKnowledge> children)
    {
        this.children = children;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("knowledgeId", getKnowledgeId())
            .append("subjectId", getSubjectId())
            .append("parentId", getParentId())
            .append("ancestors", getAncestors())
            .append("knowledgeName", getKnowledgeName())
            .append("knowledgeCode", getKnowledgeCode())
            .append("difficultyDefault", getDifficultyDefault())
            .append("nodeType", getNodeType())
            .append("orderNum", getOrderNum())
            .append("status", getStatus())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
