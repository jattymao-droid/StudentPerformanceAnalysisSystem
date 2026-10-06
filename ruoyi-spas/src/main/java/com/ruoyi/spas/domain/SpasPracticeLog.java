package com.ruoyi.spas.domain;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Daily self-practice log spas_practice_log (not fed into mastery)
 */
public class SpasPracticeLog extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long logId;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date practiceDate;
    private Long deptId;
    private Long groupId;
    private Long studentId;
    private Long subjectId;
    private String bookName;
    private Integer pageFrom;
    private Integer pageTo;
    private String questionText;
    /** 1 done 2 partial 3 difficulty */
    private String finishStatus;
    private String difficultyNote;
    private BigDecimal selfCorrectRate;
    private String hardestQuestion;
    private Integer durationMin;
    /** 0 in-class 1 makeup */
    private String submitSlot;
    private Long submitByStudentId;
    private String proxyFlag;
    /** 0 N/A 1 pending 2 confirmed 3 rejected */
    private String confirmStatus;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date confirmTime;
    private String clientType;
    private String deviceCode;
    /** 0 none 1 pass 2 suspect */
    private String spotStatus;
    private String spotBy;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date spotTime;
    private String spotRemark;
    private String status;

    private String studentName;
    private String studentNo;
    private String deptName;
    private String groupName;
    private String subjectName;
    private String submitByName;
    private String knowledgeNames;

    private List<Long> knowledgeIds;
    private List<SpasPracticeLogKnowledge> knowledgeList;

    public Long getLogId() { return logId; }
    public void setLogId(Long logId) { this.logId = logId; }
    public Date getPracticeDate() { return practiceDate; }
    public void setPracticeDate(Date practiceDate) { this.practiceDate = practiceDate; }
    public Long getDeptId() { return deptId; }
    public void setDeptId(Long deptId) { this.deptId = deptId; }
    public Long getGroupId() { return groupId; }
    public void setGroupId(Long groupId) { this.groupId = groupId; }
    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }
    public Long getSubjectId() { return subjectId; }
    public void setSubjectId(Long subjectId) { this.subjectId = subjectId; }
    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }
    public Integer getPageFrom() { return pageFrom; }
    public void setPageFrom(Integer pageFrom) { this.pageFrom = pageFrom; }
    public Integer getPageTo() { return pageTo; }
    public void setPageTo(Integer pageTo) { this.pageTo = pageTo; }
    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }
    public String getFinishStatus() { return finishStatus; }
    public void setFinishStatus(String finishStatus) { this.finishStatus = finishStatus; }
    public String getDifficultyNote() { return difficultyNote; }
    public void setDifficultyNote(String difficultyNote) { this.difficultyNote = difficultyNote; }
    public BigDecimal getSelfCorrectRate() { return selfCorrectRate; }
    public void setSelfCorrectRate(BigDecimal selfCorrectRate) { this.selfCorrectRate = selfCorrectRate; }
    public String getHardestQuestion() { return hardestQuestion; }
    public void setHardestQuestion(String hardestQuestion) { this.hardestQuestion = hardestQuestion; }
    public Integer getDurationMin() { return durationMin; }
    public void setDurationMin(Integer durationMin) { this.durationMin = durationMin; }
    public String getSubmitSlot() { return submitSlot; }
    public void setSubmitSlot(String submitSlot) { this.submitSlot = submitSlot; }
    public Long getSubmitByStudentId() { return submitByStudentId; }
    public void setSubmitByStudentId(Long submitByStudentId) { this.submitByStudentId = submitByStudentId; }
    public String getProxyFlag() { return proxyFlag; }
    public void setProxyFlag(String proxyFlag) { this.proxyFlag = proxyFlag; }
    public String getConfirmStatus() { return confirmStatus; }
    public void setConfirmStatus(String confirmStatus) { this.confirmStatus = confirmStatus; }
    public Date getConfirmTime() { return confirmTime; }
    public void setConfirmTime(Date confirmTime) { this.confirmTime = confirmTime; }
    public String getClientType() { return clientType; }
    public void setClientType(String clientType) { this.clientType = clientType; }
    public String getDeviceCode() { return deviceCode; }
    public void setDeviceCode(String deviceCode) { this.deviceCode = deviceCode; }
    public String getSpotStatus() { return spotStatus; }
    public void setSpotStatus(String spotStatus) { this.spotStatus = spotStatus; }
    public String getSpotBy() { return spotBy; }
    public void setSpotBy(String spotBy) { this.spotBy = spotBy; }
    public Date getSpotTime() { return spotTime; }
    public void setSpotTime(Date spotTime) { this.spotTime = spotTime; }
    public String getSpotRemark() { return spotRemark; }
    public void setSpotRemark(String spotRemark) { this.spotRemark = spotRemark; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public String getStudentNo() { return studentNo; }
    public void setStudentNo(String studentNo) { this.studentNo = studentNo; }
    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }
    public String getGroupName() { return groupName; }
    public void setGroupName(String groupName) { this.groupName = groupName; }
    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }
    public String getSubmitByName() { return submitByName; }
    public void setSubmitByName(String submitByName) { this.submitByName = submitByName; }
    public String getKnowledgeNames() { return knowledgeNames; }
    public void setKnowledgeNames(String knowledgeNames) { this.knowledgeNames = knowledgeNames; }
    public List<Long> getKnowledgeIds() { return knowledgeIds; }
    public void setKnowledgeIds(List<Long> knowledgeIds) { this.knowledgeIds = knowledgeIds; }
    public List<SpasPracticeLogKnowledge> getKnowledgeList() { return knowledgeList; }
    public void setKnowledgeList(List<SpasPracticeLogKnowledge> knowledgeList) { this.knowledgeList = knowledgeList; }
}
