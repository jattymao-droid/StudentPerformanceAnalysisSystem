package com.ruoyi.spas.domain;

import java.math.BigDecimal;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Score detail entity spas_score_detail
 */
public class SpasScoreDetail extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** Detail ID */
    private Long detailId;

    /** Paper ID */
    private Long paperId;

    /** Question ID */
    private Long questionId;

    /** Student ID */
    private Long studentId;

    /** Batch ID */
    private Long batchId;

    /** Score */
    @Excel(name = "\u5f97\u5206")
    private BigDecimal score;

    /** Full score snapshot */
    @Excel(name = "\u6ee1\u5206")
    private BigDecimal fullScore;

    /** Score rate */
    @Excel(name = "\u5f97\u5206\u7387")
    private BigDecimal rate;

    /** 1=manual 2=import 3=blank-as-zero */
    private String scoreSource;

    /** Student no (display) */
    @Excel(name = "\u5b66\u53f7")
    private String studentNo;

    /** Student name (display) */
    @Excel(name = "\u59d3\u540d")
    private String studentName;

    /** Question no (display) */
    @Excel(name = "\u9898\u53f7")
    private String questionNo;

    public Long getDetailId()
    {
        return detailId;
    }

    public void setDetailId(Long detailId)
    {
        this.detailId = detailId;
    }

    public Long getPaperId()
    {
        return paperId;
    }

    public void setPaperId(Long paperId)
    {
        this.paperId = paperId;
    }

    public Long getQuestionId()
    {
        return questionId;
    }

    public void setQuestionId(Long questionId)
    {
        this.questionId = questionId;
    }

    public Long getStudentId()
    {
        return studentId;
    }

    public void setStudentId(Long studentId)
    {
        this.studentId = studentId;
    }

    public Long getBatchId()
    {
        return batchId;
    }

    public void setBatchId(Long batchId)
    {
        this.batchId = batchId;
    }

    public BigDecimal getScore()
    {
        return score;
    }

    public void setScore(BigDecimal score)
    {
        this.score = score;
    }

    public BigDecimal getFullScore()
    {
        return fullScore;
    }

    public void setFullScore(BigDecimal fullScore)
    {
        this.fullScore = fullScore;
    }

    public BigDecimal getRate()
    {
        return rate;
    }

    public void setRate(BigDecimal rate)
    {
        this.rate = rate;
    }

    public String getStudentNo()
    {
        return studentNo;
    }

    public void setStudentNo(String studentNo)
    {
        this.studentNo = studentNo;
    }

    public String getStudentName()
    {
        return studentName;
    }

    public void setStudentName(String studentName)
    {
        this.studentName = studentName;
    }

    public String getQuestionNo()
    {
        return questionNo;
    }

    public void setQuestionNo(String questionNo)
    {
        this.questionNo = questionNo;
    }

    public String getScoreSource()
    {
        return scoreSource;
    }

    public void setScoreSource(String scoreSource)
    {
        this.scoreSource = scoreSource;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("detailId", getDetailId())
            .append("paperId", getPaperId())
            .append("questionId", getQuestionId())
            .append("studentId", getStudentId())
            .append("batchId", getBatchId())
            .append("score", getScore())
            .append("fullScore", getFullScore())
            .append("rate", getRate())
            .append("scoreSource", getScoreSource())
            .toString();
    }
}
