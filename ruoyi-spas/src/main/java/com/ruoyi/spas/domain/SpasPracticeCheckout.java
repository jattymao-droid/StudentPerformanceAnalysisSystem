package com.ruoyi.spas.domain;

import java.util.Date;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonFormat;

/**
 * Group checkout spas_practice_checkout
 */
public class SpasPracticeCheckout
{
    private Long checkoutId;
    private Long assignmentId;
    private Long groupId;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date practiceDate;
    private Long leaderStudentId;
    private Long checkerStudentId;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date submitTime;
    private String deviceCode;
    private String status;

    private String groupName;
    private String leaderStudentName;
    private String checkerStudentName;
    private List<SpasPracticeCheckoutItem> items;

    public Long getCheckoutId() { return checkoutId; }
    public void setCheckoutId(Long checkoutId) { this.checkoutId = checkoutId; }
    public Long getAssignmentId() { return assignmentId; }
    public void setAssignmentId(Long assignmentId) { this.assignmentId = assignmentId; }
    public Long getGroupId() { return groupId; }
    public void setGroupId(Long groupId) { this.groupId = groupId; }
    public Date getPracticeDate() { return practiceDate; }
    public void setPracticeDate(Date practiceDate) { this.practiceDate = practiceDate; }
    public Long getLeaderStudentId() { return leaderStudentId; }
    public void setLeaderStudentId(Long leaderStudentId) { this.leaderStudentId = leaderStudentId; }
    public Long getCheckerStudentId() { return checkerStudentId; }
    public void setCheckerStudentId(Long checkerStudentId) { this.checkerStudentId = checkerStudentId; }
    public Date getSubmitTime() { return submitTime; }
    public void setSubmitTime(Date submitTime) { this.submitTime = submitTime; }
    public String getDeviceCode() { return deviceCode; }
    public void setDeviceCode(String deviceCode) { this.deviceCode = deviceCode; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getGroupName() { return groupName; }
    public void setGroupName(String groupName) { this.groupName = groupName; }
    public String getLeaderStudentName() { return leaderStudentName; }
    public void setLeaderStudentName(String leaderStudentName) { this.leaderStudentName = leaderStudentName; }
    public String getCheckerStudentName() { return checkerStudentName; }
    public void setCheckerStudentName(String checkerStudentName) { this.checkerStudentName = checkerStudentName; }
    public List<SpasPracticeCheckoutItem> getItems() { return items; }
    public void setItems(List<SpasPracticeCheckoutItem> items) { this.items = items; }
}
