package com.ruoyi.spas.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Quality work-order spas_quality_ticket
 */
public class SpasQualityTicket extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long ticketId;
    private String metricCode;
    private String title;
    /** 0 open 1 processing 2 done 3 closed */
    private String status;
    /** 1 high 2 mid 3 low */
    private String priority;
    private Long deptId;
    private Long subjectId;
    private String refJson;
    private String ownerBy;

    /** display */
    private String deptName;
    private String subjectName;

    public Long getTicketId()
    {
        return ticketId;
    }

    public void setTicketId(Long ticketId)
    {
        this.ticketId = ticketId;
    }

    public String getMetricCode()
    {
        return metricCode;
    }

    public void setMetricCode(String metricCode)
    {
        this.metricCode = metricCode;
    }

    public String getTitle()
    {
        return title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getPriority()
    {
        return priority;
    }

    public void setPriority(String priority)
    {
        this.priority = priority;
    }

    public Long getDeptId()
    {
        return deptId;
    }

    public void setDeptId(Long deptId)
    {
        this.deptId = deptId;
    }

    public Long getSubjectId()
    {
        return subjectId;
    }

    public void setSubjectId(Long subjectId)
    {
        this.subjectId = subjectId;
    }

    public String getRefJson()
    {
        return refJson;
    }

    public void setRefJson(String refJson)
    {
        this.refJson = refJson;
    }

    public String getOwnerBy()
    {
        return ownerBy;
    }

    public void setOwnerBy(String ownerBy)
    {
        this.ownerBy = ownerBy;
    }

    public String getDeptName()
    {
        return deptName;
    }

    public void setDeptName(String deptName)
    {
        this.deptName = deptName;
    }

    public String getSubjectName()
    {
        return subjectName;
    }

    public void setSubjectName(String subjectName)
    {
        this.subjectName = subjectName;
    }
}
