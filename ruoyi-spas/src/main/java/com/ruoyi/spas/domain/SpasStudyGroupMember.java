package com.ruoyi.spas.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

/**
 * Study group member spas_study_group_member
 */
public class SpasStudyGroupMember
{
    private Long id;
    private Long groupId;
    private Long studentId;
    /** 0 member 1 leader */
    private String roleInGroup;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date joinTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date leaveTime;

    private String studentNo;
    private String studentName;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getGroupId() { return groupId; }
    public void setGroupId(Long groupId) { this.groupId = groupId; }
    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }
    public String getRoleInGroup() { return roleInGroup; }
    public void setRoleInGroup(String roleInGroup) { this.roleInGroup = roleInGroup; }
    public Date getJoinTime() { return joinTime; }
    public void setJoinTime(Date joinTime) { this.joinTime = joinTime; }
    public Date getLeaveTime() { return leaveTime; }
    public void setLeaveTime(Date leaveTime) { this.leaveTime = leaveTime; }
    public String getStudentNo() { return studentNo; }
    public void setStudentNo(String studentNo) { this.studentNo = studentNo; }
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
}
