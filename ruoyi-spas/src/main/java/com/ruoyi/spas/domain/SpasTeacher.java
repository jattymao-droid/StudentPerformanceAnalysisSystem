package com.ruoyi.spas.domain;

import java.util.List;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Teacher profile spas_teacher
 */
public class SpasTeacher extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 1 subject 2 homeroom 3 grade 4 school */
    public static final String TYPE_SUBJECT = "1";
    public static final String TYPE_HOMEROOM = "2";
    public static final String TYPE_GRADE = "3";
    public static final String TYPE_SCHOOL = "4";

    private Long teacherId;

    @Excel(name = "\u5de5\u53f7")
    private String teacherNo;

    @Excel(name = "\u59d3\u540d")
    private String teacherName;

    @Excel(name = "\u6559\u5e08\u7c7b\u578b", readConverterExp = "1=\u4efb\u8bfe\u6559\u5e08,2=\u73ed\u4e3b\u4efb,3=\u5e74\u7ea7\u8d1f\u8d23\u4eba,4=\u6821\u7ea7\u9886\u5bfc")
    private String teacherType;

    @Excel(name = "\u90e8\u95e8ID")
    private Long deptId;

    private Long userId;

    @Excel(name = "\u624b\u673a")
    private String mobile;

    @Excel(name = "\u6027\u522b", readConverterExp = "0=\u7537,1=\u5973,2=\u672a\u77e5")
    private String gender;

    @Excel(name = "\u72b6\u6001", readConverterExp = "0=\u6b63\u5e38,1=\u505c\u7528")
    private String status;

    private String delFlag;

    private String deptName;

    private String roleKey;

    /** Extra class dept ids for subject teachers (type 1) */
    private List<Long> extraDeptIds;

    private String extraDeptNames;

    public Long getTeacherId() { return teacherId; }
    public void setTeacherId(Long teacherId) { this.teacherId = teacherId; }
    public String getTeacherNo() { return teacherNo; }
    public void setTeacherNo(String teacherNo) { this.teacherNo = teacherNo; }
    public String getTeacherName() { return teacherName; }
    public void setTeacherName(String teacherName) { this.teacherName = teacherName; }
    public String getTeacherType() { return teacherType; }
    public void setTeacherType(String teacherType) { this.teacherType = teacherType; }
    public Long getDeptId() { return deptId; }
    public void setDeptId(Long deptId) { this.deptId = deptId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }
    public String getRoleKey() { return roleKey; }
    public void setRoleKey(String roleKey) { this.roleKey = roleKey; }
    public List<Long> getExtraDeptIds() { return extraDeptIds; }
    public void setExtraDeptIds(List<Long> extraDeptIds) { this.extraDeptIds = extraDeptIds; }
    public String getExtraDeptNames() { return extraDeptNames; }
    public void setExtraDeptNames(String extraDeptNames) { this.extraDeptNames = extraDeptNames; }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("teacherId", getTeacherId())
            .append("teacherNo", getTeacherNo())
            .append("teacherName", getTeacherName())
            .append("teacherType", getTeacherType())
            .append("deptId", getDeptId())
            .append("userId", getUserId())
            .append("mobile", getMobile())
            .append("gender", getGender())
            .append("status", getStatus())
            .toString();
    }
}
