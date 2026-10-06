package com.ruoyi.spas.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

/**
 * Checkout line spas_practice_checkout_item
 */
public class SpasPracticeCheckoutItem
{
    private Long itemId;
    private Long checkoutId;
    private Long studentId;
    /** 1 done 2 partial 0 undone 3 difficulty L leave A absent */
    private String finishStatus;
    private String difficultyNote;
    /** 0 pending 1 ack 2 dispute 3 timeout */
    private String memberAck;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date ackTime;
    private String voided;
    private String followStatus;
    /** 1 match 2 loose 3 strict */
    private String spotResult;

    private String studentNo;
    private String studentName;
    private Long groupId;
    private String groupName;

    public Long getItemId() { return itemId; }
    public void setItemId(Long itemId) { this.itemId = itemId; }
    public Long getCheckoutId() { return checkoutId; }
    public void setCheckoutId(Long checkoutId) { this.checkoutId = checkoutId; }
    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }
    public String getFinishStatus() { return finishStatus; }
    public void setFinishStatus(String finishStatus) { this.finishStatus = finishStatus; }
    public String getDifficultyNote() { return difficultyNote; }
    public void setDifficultyNote(String difficultyNote) { this.difficultyNote = difficultyNote; }
    public String getMemberAck() { return memberAck; }
    public void setMemberAck(String memberAck) { this.memberAck = memberAck; }
    public Date getAckTime() { return ackTime; }
    public void setAckTime(Date ackTime) { this.ackTime = ackTime; }
    public String getVoided() { return voided; }
    public void setVoided(String voided) { this.voided = voided; }
    public String getFollowStatus() { return followStatus; }
    public void setFollowStatus(String followStatus) { this.followStatus = followStatus; }
    public String getSpotResult() { return spotResult; }
    public void setSpotResult(String spotResult) { this.spotResult = spotResult; }
    public String getStudentNo() { return studentNo; }
    public void setStudentNo(String studentNo) { this.studentNo = studentNo; }
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public Long getGroupId() { return groupId; }
    public void setGroupId(Long groupId) { this.groupId = groupId; }
    public String getGroupName() { return groupName; }
    public void setGroupName(String groupName) { this.groupName = groupName; }
}
