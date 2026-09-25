package com.ruoyi.spas.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Multi-subject exam import batch spas_exam
 */
public class SpasExam extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    public static final String STATUS_PROCESSING = "0";
    public static final String STATUS_DONE = "1";
    public static final String STATUS_FAILED = "2";

    private Long examId;
    private String examName;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date examDate;

    private Long deptId;
    private Long paperId;
    private String fileName;
    private Integer totalRows;
    private Integer successRows;
    private Integer failRows;
    private String status;
    private String errorLog;

    /** display */
    private String deptName;

    public Long getExamId()
    {
        return examId;
    }

    public void setExamId(Long examId)
    {
        this.examId = examId;
    }

    public String getExamName()
    {
        return examName;
    }

    public void setExamName(String examName)
    {
        this.examName = examName;
    }

    public Date getExamDate()
    {
        return examDate;
    }

    public void setExamDate(Date examDate)
    {
        this.examDate = examDate;
    }

    public Long getDeptId()
    {
        return deptId;
    }

    public void setDeptId(Long deptId)
    {
        this.deptId = deptId;
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

    public String getDeptName()
    {
        return deptName;
    }

    public void setDeptName(String deptName)
    {
        this.deptName = deptName;
    }
}
