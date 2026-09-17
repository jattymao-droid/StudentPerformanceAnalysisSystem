package com.ruoyi.spas.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Subject question type spas_subject_question_type
 */
public class SpasSubjectQuestionType extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long typeId;

    private Long subjectId;

    @Excel(name = "Type Code")
    private String typeCode;

    @Excel(name = "Type Name")
    private String typeName;

    private Integer sort;

    @Excel(name = "Status", readConverterExp = "0=normal,1=disabled")
    private String status;

    /** display only */
    private String subjectName;

    public Long getTypeId()
    {
        return typeId;
    }

    public void setTypeId(Long typeId)
    {
        this.typeId = typeId;
    }

    public Long getSubjectId()
    {
        return subjectId;
    }

    public void setSubjectId(Long subjectId)
    {
        this.subjectId = subjectId;
    }

    public String getTypeCode()
    {
        return typeCode;
    }

    public void setTypeCode(String typeCode)
    {
        this.typeCode = typeCode;
    }

    public String getTypeName()
    {
        return typeName;
    }

    public void setTypeName(String typeName)
    {
        this.typeName = typeName;
    }

    public Integer getSort()
    {
        return sort;
    }

    public void setSort(Integer sort)
    {
        this.sort = sort;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
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
            .append("typeId", getTypeId())
            .append("subjectId", getSubjectId())
            .append("typeCode", getTypeCode())
            .append("typeName", getTypeName())
            .append("sort", getSort())
            .append("status", getStatus())
            .append("remark", getRemark())
            .toString();
    }
}
