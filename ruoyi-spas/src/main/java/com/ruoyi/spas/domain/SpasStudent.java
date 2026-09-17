package com.ruoyi.spas.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Student profile entity spas_student
 */
public class SpasStudent extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** Student ID */
    private Long studentId;

    /** Student number (login name) */
    @Excel(name = "\u5b66\u53f7", sort = 1)
    private String studentNo;

    /** Student name */
    @Excel(name = "\u59d3\u540d", sort = 2)
    private String studentName;

    /** Gender (0 male 1 female 2 unknown) */
    @Excel(name = "\u6027\u522b", readConverterExp = "0=\u7537,1=\u5973,2=\u672a\u77e5", sort = 3)
    private String gender;

    /** Class dept ID */
    private Long deptId;

    /** Grade year */
    @Excel(name = "\u5165\u5b66\u5e74\u7ea7", sort = 5)
    private String gradeYear;

    /** Bound sys_user ID */
    private Long userId;

    /** Parent mobile */
    @Excel(name = "\u5bb6\u957f\u624b\u673a", sort = 6)
    private String parentMobile;

    /** Status (0 normal 1 disabled) */
    @Excel(name = "\u72b6\u6001", readConverterExp = "0=\u6b63\u5e38,1=\u505c\u7528", sort = 7)
    private String status;

    /** Delete flag (0 exist 1 deleted) */
    private String delFlag;

    /** Dept name (import/display). Prefer path like parent/class when names duplicate. */
    @Excel(name = "\u73ed\u7ea7\u540d\u79f0", sort = 4)
    private String deptName;

    public Long getStudentId()
    {
        return studentId;
    }

    public void setStudentId(Long studentId)
    {
        this.studentId = studentId;
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

    public String getGender()
    {
        return gender;
    }

    public void setGender(String gender)
    {
        this.gender = gender;
    }

    public Long getDeptId()
    {
        return deptId;
    }

    public void setDeptId(Long deptId)
    {
        this.deptId = deptId;
    }

    public String getGradeYear()
    {
        return gradeYear;
    }

    public void setGradeYear(String gradeYear)
    {
        this.gradeYear = gradeYear;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public String getParentMobile()
    {
        return parentMobile;
    }

    public void setParentMobile(String parentMobile)
    {
        this.parentMobile = parentMobile;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getDelFlag()
    {
        return delFlag;
    }

    public void setDelFlag(String delFlag)
    {
        this.delFlag = delFlag;
    }

    public String getDeptName()
    {
        return deptName;
    }

    public void setDeptName(String deptName)
    {
        this.deptName = deptName;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("studentId", getStudentId())
            .append("studentNo", getStudentNo())
            .append("studentName", getStudentName())
            .append("gender", getGender())
            .append("deptId", getDeptId())
            .append("gradeYear", getGradeYear())
            .append("userId", getUserId())
            .append("parentMobile", getParentMobile())
            .append("status", getStatus())
            .append("delFlag", getDelFlag())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
