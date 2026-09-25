package com.ruoyi.spas.domain;

import java.util.Date;

/**
 * One school-rank cell used by rank-drop and subject-imbalance warnings.
 */
public class SpasExamRankPoint
{
    private Long studentId;
    private String studentName;
    private Long deptId;
    private Long examId;
    private Date examDate;
    private String scoreType;
    private String subjectName;
    private Integer schoolRank;

    public Long getStudentId()
    {
        return studentId;
    }

    public void setStudentId(Long studentId)
    {
        this.studentId = studentId;
    }

    public String getStudentName()
    {
        return studentName;
    }

    public void setStudentName(String studentName)
    {
        this.studentName = studentName;
    }

    public Long getDeptId()
    {
        return deptId;
    }

    public void setDeptId(Long deptId)
    {
        this.deptId = deptId;
    }

    public Long getExamId()
    {
        return examId;
    }

    public void setExamId(Long examId)
    {
        this.examId = examId;
    }

    public Date getExamDate()
    {
        return examDate;
    }

    public void setExamDate(Date examDate)
    {
        this.examDate = examDate;
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

    public Integer getSchoolRank()
    {
        return schoolRank;
    }

    public void setSchoolRank(Integer schoolRank)
    {
        this.schoolRank = schoolRank;
    }
}
