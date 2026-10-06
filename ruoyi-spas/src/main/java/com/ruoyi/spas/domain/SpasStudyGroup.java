package com.ruoyi.spas.domain;

import java.util.List;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Study group spas_study_group
 */
public class SpasStudyGroup extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long groupId;
    private Long deptId;
    private Long subjectId;
    private String groupName;
    private Long leaderStudentId;
    private String status;
    private Integer sortOrder;

    /** display */
    private String deptName;
    private String subjectName;
    private String leaderStudentName;
    private Integer memberCount;

    /** members for detail / save */
    private List<SpasStudyGroupMember> members;
    /** request: replace active members */
    private Long[] studentIds;

    public Long getGroupId() { return groupId; }
    public void setGroupId(Long groupId) { this.groupId = groupId; }
    public Long getDeptId() { return deptId; }
    public void setDeptId(Long deptId) { this.deptId = deptId; }
    public Long getSubjectId() { return subjectId; }
    public void setSubjectId(Long subjectId) { this.subjectId = subjectId; }
    public String getGroupName() { return groupName; }
    public void setGroupName(String groupName) { this.groupName = groupName; }
    public Long getLeaderStudentId() { return leaderStudentId; }
    public void setLeaderStudentId(Long leaderStudentId) { this.leaderStudentId = leaderStudentId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }
    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }
    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }
    public String getLeaderStudentName() { return leaderStudentName; }
    public void setLeaderStudentName(String leaderStudentName) { this.leaderStudentName = leaderStudentName; }
    public Integer getMemberCount() { return memberCount; }
    public void setMemberCount(Integer memberCount) { this.memberCount = memberCount; }
    public List<SpasStudyGroupMember> getMembers() { return members; }
    public void setMembers(List<SpasStudyGroupMember> members) { this.members = members; }
    public Long[] getStudentIds() { return studentIds; }
    public void setStudentIds(Long[] studentIds) { this.studentIds = studentIds; }
}
