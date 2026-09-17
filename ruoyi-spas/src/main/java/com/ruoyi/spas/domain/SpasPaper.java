package com.ruoyi.spas.domain;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Paper entity spas_paper
 */
public class SpasPaper extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** Paper ID */
    private Long paperId;

    /** Paper name */
    @Excel(name = "Paper Name")
    private String paperName;

    /** Paper type (1 exam 2 homework) */
    @Excel(name = "Paper Type", readConverterExp = "1=exam,2=homework")
    private String paperType;

    /** Subject ID */
    @Excel(name = "Subject Id")
    private Long subjectId;

    /** Class dept ID */
    @Excel(name = "Dept Id")
    private Long deptId;

    /** Exam date */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "Exam Date", width = 30, dateFormat = "yyyy-MM-dd")
    private Date examDate;

    /** Total score */
    @Excel(name = "Total Score")
    private BigDecimal totalScore;

    /** Status (0 draft 1 published 2 archived) */
    @Excel(name = "Status", readConverterExp = "0=draft,1=published,2=archived")
    private String status;

    /** Publish time */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date publishTime;

    /** Subject name (display) */
    private String subjectName;

    /** Dept name (display) */
    private String deptName;

    /** Question list */
    private List<SpasPaperQuestion> questions;

    /** Score detail count (display / UI lock) */
    private Integer scoreCount;

    /** Whether knowledge links can change after scores (from config, not persisted) */
    private Boolean allowChangeKnowledgeAfterScore;

    public Long getPaperId()
    {
        return paperId;
    }

    public void setPaperId(Long paperId)
    {
        this.paperId = paperId;
    }

    public String getPaperName()
    {
        return paperName;
    }

    public void setPaperName(String paperName)
    {
        this.paperName = paperName;
    }

    public String getPaperType()
    {
        return paperType;
    }

    public void setPaperType(String paperType)
    {
        this.paperType = paperType;
    }

    public Long getSubjectId()
    {
        return subjectId;
    }

    public void setSubjectId(Long subjectId)
    {
        this.subjectId = subjectId;
    }

    public Long getDeptId()
    {
        return deptId;
    }

    public void setDeptId(Long deptId)
    {
        this.deptId = deptId;
    }

    public Date getExamDate()
    {
        return examDate;
    }

    public void setExamDate(Date examDate)
    {
        this.examDate = examDate;
    }

    public BigDecimal getTotalScore()
    {
        return totalScore;
    }

    public void setTotalScore(BigDecimal totalScore)
    {
        this.totalScore = totalScore;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public Date getPublishTime()
    {
        return publishTime;
    }

    public void setPublishTime(Date publishTime)
    {
        this.publishTime = publishTime;
    }

    public String getSubjectName()
    {
        return subjectName;
    }

    public void setSubjectName(String subjectName)
    {
        this.subjectName = subjectName;
    }

    public String getDeptName()
    {
        return deptName;
    }

    public void setDeptName(String deptName)
    {
        this.deptName = deptName;
    }

    public List<SpasPaperQuestion> getQuestions()
    {
        return questions;
    }

    public void setQuestions(List<SpasPaperQuestion> questions)
    {
        this.questions = questions;
    }

    public Integer getScoreCount()
    {
        return scoreCount;
    }

    public void setScoreCount(Integer scoreCount)
    {
        this.scoreCount = scoreCount;
    }

    public Boolean getAllowChangeKnowledgeAfterScore()
    {
        return allowChangeKnowledgeAfterScore;
    }

    public void setAllowChangeKnowledgeAfterScore(Boolean allowChangeKnowledgeAfterScore)
    {
        this.allowChangeKnowledgeAfterScore = allowChangeKnowledgeAfterScore;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("paperId", getPaperId())
            .append("paperName", getPaperName())
            .append("paperType", getPaperType())
            .append("subjectId", getSubjectId())
            .append("deptId", getDeptId())
            .append("examDate", getExamDate())
            .append("totalScore", getTotalScore())
            .append("status", getStatus())
            .append("publishTime", getPublishTime())
            .append("scoreCount", getScoreCount())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
