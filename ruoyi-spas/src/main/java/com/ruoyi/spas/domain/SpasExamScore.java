package com.ruoyi.spas.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Exam subject/total score with school rank spas_exam_score
 */
public class SpasExamScore extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    public static final String TYPE_SUBJECT = "1";
    public static final String TYPE_TOTAL = "2";

    private Long scoreId;
    private Long examId;
    private Long studentId;
    private String scoreType;
    /** Subject label from Excel header; null for total row */
    private String subjectName;
    private BigDecimal score;
    private Integer schoolRank;
    private Date createTime;
    private Date updateTime;

    /** display */
    private String studentNo;
    private String studentName;
    private String examName;
    private Date examDate;
    private Long paperId;

    public Long getScoreId()
    {
        return scoreId;
    }

    public void setScoreId(Long scoreId)
    {
        this.scoreId = scoreId;
    }

    public Long getExamId()
    {
        return examId;
    }

    public void setExamId(Long examId)
    {
        this.examId = examId;
    }

    public Long getStudentId()
    {
        return studentId;
    }

    public void setStudentId(Long studentId)
    {
        this.studentId = studentId;
    }

    public String getScoreType()
    {
        return scoreType;
    }

    public void setScoreType(String scoreType)
    {
        this.scoreType = scoreType;
    }

    public String getSubjectName()
    {
        return subjectName;
    }

    public void setSubjectName(String subjectName)
    {
        this.subjectName = subjectName;
    }

    public BigDecimal getScore()
    {
        return score;
    }

    public void setScore(BigDecimal score)
    {
        this.score = score;
    }

    public Integer getSchoolRank()
    {
        return schoolRank;
    }

    public void setSchoolRank(Integer schoolRank)
    {
        this.schoolRank = schoolRank;
    }

    @Override
    public Date getCreateTime()
    {
        return createTime;
    }

    @Override
    public void setCreateTime(Date createTime)
    {
        this.createTime = createTime;
    }

    @Override
    public Date getUpdateTime()
    {
        return updateTime;
    }

    @Override
    public void setUpdateTime(Date updateTime)
    {
        this.updateTime = updateTime;
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

    public Long getPaperId()
    {
        return paperId;
    }

    public void setPaperId(Long paperId)
    {
        this.paperId = paperId;
    }
}
