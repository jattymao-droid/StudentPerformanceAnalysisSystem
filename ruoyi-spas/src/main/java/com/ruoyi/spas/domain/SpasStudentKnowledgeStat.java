package com.ruoyi.spas.domain;

import java.math.BigDecimal;
import java.util.Date;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Student knowledge snapshot entity spas_student_knowledge_stat
 */
public class SpasStudentKnowledgeStat extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** Stat ID */
    private Long statId;

    /** Student ID */
    private Long studentId;

    /** Knowledge ID */
    private Long knowledgeId;

    /** Subject ID */
    private Long subjectId;

    /** Distinct question attempt count */
    private Integer attemptCount;

    /** Simple average rate */
    private BigDecimal avgRate;

    /** Difficulty-weighted rate */
    private BigDecimal weightedRate;

    /** Last related paper ID */
    private Long lastPaperId;

    /** Last exam date */
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date lastExamDate;

    /** Weak level: 0 normal 1 watch 2 weak 3 severe */
    private String weakLevel;

    /** Calculation time */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date calcTime;

    /** Knowledge name (display) */
    private String knowledgeName;

    /** Student name (display) */
    private String studentName;

    public Long getStatId()
    {
        return statId;
    }

    public void setStatId(Long statId)
    {
        this.statId = statId;
    }

    public Long getStudentId()
    {
        return studentId;
    }

    public void setStudentId(Long studentId)
    {
        this.studentId = studentId;
    }

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

    public Integer getAttemptCount()
    {
        return attemptCount;
    }

    public void setAttemptCount(Integer attemptCount)
    {
        this.attemptCount = attemptCount;
    }

    public BigDecimal getAvgRate()
    {
        return avgRate;
    }

    public void setAvgRate(BigDecimal avgRate)
    {
        this.avgRate = avgRate;
    }

    public BigDecimal getWeightedRate()
    {
        return weightedRate;
    }

    public void setWeightedRate(BigDecimal weightedRate)
    {
        this.weightedRate = weightedRate;
    }

    public Long getLastPaperId()
    {
        return lastPaperId;
    }

    public void setLastPaperId(Long lastPaperId)
    {
        this.lastPaperId = lastPaperId;
    }

    public Date getLastExamDate()
    {
        return lastExamDate;
    }

    public void setLastExamDate(Date lastExamDate)
    {
        this.lastExamDate = lastExamDate;
    }

    public String getWeakLevel()
    {
        return weakLevel;
    }

    public void setWeakLevel(String weakLevel)
    {
        this.weakLevel = weakLevel;
    }

    public Date getCalcTime()
    {
        return calcTime;
    }

    public void setCalcTime(Date calcTime)
    {
        this.calcTime = calcTime;
    }

    public String getKnowledgeName()
    {
        return knowledgeName;
    }

    public void setKnowledgeName(String knowledgeName)
    {
        this.knowledgeName = knowledgeName;
    }

    public String getStudentName()
    {
        return studentName;
    }

    public void setStudentName(String studentName)
    {
        this.studentName = studentName;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("statId", getStatId())
            .append("studentId", getStudentId())
            .append("knowledgeId", getKnowledgeId())
            .append("subjectId", getSubjectId())
            .append("attemptCount", getAttemptCount())
            .append("avgRate", getAvgRate())
            .append("weightedRate", getWeightedRate())
            .append("lastPaperId", getLastPaperId())
            .append("lastExamDate", getLastExamDate())
            .append("weakLevel", getWeakLevel())
            .append("calcTime", getCalcTime())
            .toString();
    }
}
