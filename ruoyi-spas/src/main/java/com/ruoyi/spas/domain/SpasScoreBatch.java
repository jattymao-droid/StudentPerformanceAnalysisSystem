package com.ruoyi.spas.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Score import batch entity spas_score_batch
 */
public class SpasScoreBatch extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** Batch ID */
    private Long batchId;

    /** Paper ID */
    private Long paperId;

    /** Uploaded file name */
    private String fileName;

    /** Total rows */
    private Integer totalRows;

    /** Success rows */
    private Integer successRows;

    /** Fail rows */
    private Integer failRows;

    /** Status (0 processing 1 done 2 failed) */
    private String status;

    /** Error log text */
    private String errorLog;

    /** Paper name (display) */
    private String paperName;

    public Long getBatchId()
    {
        return batchId;
    }

    public void setBatchId(Long batchId)
    {
        this.batchId = batchId;
    }

    public Long getPaperId()
    {
        return paperId;
    }

    public void setPaperId(Long paperId)
    {
        this.paperId = paperId;
    }

    public String getFileName()
    {
        return fileName;
    }

    public void setFileName(String fileName)
    {
        this.fileName = fileName;
    }

    public Integer getTotalRows()
    {
        return totalRows;
    }

    public void setTotalRows(Integer totalRows)
    {
        this.totalRows = totalRows;
    }

    public Integer getSuccessRows()
    {
        return successRows;
    }

    public void setSuccessRows(Integer successRows)
    {
        this.successRows = successRows;
    }

    public Integer getFailRows()
    {
        return failRows;
    }

    public void setFailRows(Integer failRows)
    {
        this.failRows = failRows;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getErrorLog()
    {
        return errorLog;
    }

    public void setErrorLog(String errorLog)
    {
        this.errorLog = errorLog;
    }

    public String getPaperName()
    {
        return paperName;
    }

    public void setPaperName(String paperName)
    {
        this.paperName = paperName;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("batchId", getBatchId())
            .append("paperId", getPaperId())
            .append("fileName", getFileName())
            .append("totalRows", getTotalRows())
            .append("successRows", getSuccessRows())
            .append("failRows", getFailRows())
            .append("status", getStatus())
            .append("errorLog", getErrorLog())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .toString();
    }
}
