package com.ruoyi.spas.domain;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Intervention task spas_intervene_task
 */
public class SpasInterveneTask extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long interveneId;
    private Long studentId;
    private Long subjectId;
    /** 1=warning 2=weak 3=manual */
    private String sourceType;
    private Long sourceId;
    private String knowledgeIds;
    private String title;
    private BigDecimal targetRate;
    private BigDecimal baselineRate;
    private String baselineJson;
    /** 0 open 1 passed 2 closed 3 overdue */
    private String status;
    private String ownerBy;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date dueDate;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date closeTime;
    private BigDecimal effectRate;
    private BigDecimal effectDelta;
    private String effectPassed;

    /** display */
    private String studentName;
    private String studentNo;
    private String deptName;
    private String subjectName;
    private Long deptId;

    /** create helpers (not persisted directly) */
    private Long warningId;
    private List<Long> knowledgeIdList;
    private List<SpasCoachLog> coachLogs;

    public Long getInterveneId() { return interveneId; }
    public void setInterveneId(Long interveneId) { this.interveneId = interveneId; }
    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }
    public Long getSubjectId() { return subjectId; }
    public void setSubjectId(Long subjectId) { this.subjectId = subjectId; }
    public String getSourceType() { return sourceType; }
    public void setSourceType(String sourceType) { this.sourceType = sourceType; }
    public Long getSourceId() { return sourceId; }
    public void setSourceId(Long sourceId) { this.sourceId = sourceId; }
    public String getKnowledgeIds() { return knowledgeIds; }
    public void setKnowledgeIds(String knowledgeIds) { this.knowledgeIds = knowledgeIds; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public BigDecimal getTargetRate() { return targetRate; }
    public void setTargetRate(BigDecimal targetRate) { this.targetRate = targetRate; }
    public BigDecimal getBaselineRate() { return baselineRate; }
    public void setBaselineRate(BigDecimal baselineRate) { this.baselineRate = baselineRate; }
    public String getBaselineJson() { return baselineJson; }
    public void setBaselineJson(String baselineJson) { this.baselineJson = baselineJson; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getOwnerBy() { return ownerBy; }
    public void setOwnerBy(String ownerBy) { this.ownerBy = ownerBy; }
    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }
    public Date getCloseTime() { return closeTime; }
    public void setCloseTime(Date closeTime) { this.closeTime = closeTime; }
    public BigDecimal getEffectRate() { return effectRate; }
    public void setEffectRate(BigDecimal effectRate) { this.effectRate = effectRate; }
    public BigDecimal getEffectDelta() { return effectDelta; }
    public void setEffectDelta(BigDecimal effectDelta) { this.effectDelta = effectDelta; }
    public String getEffectPassed() { return effectPassed; }
    public void setEffectPassed(String effectPassed) { this.effectPassed = effectPassed; }
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public String getStudentNo() { return studentNo; }
    public void setStudentNo(String studentNo) { this.studentNo = studentNo; }
    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }
    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }
    public Long getDeptId() { return deptId; }
    public void setDeptId(Long deptId) { this.deptId = deptId; }
    public Long getWarningId() { return warningId; }
    public void setWarningId(Long warningId) { this.warningId = warningId; }
    public List<Long> getKnowledgeIdList() { return knowledgeIdList; }
    public void setKnowledgeIdList(List<Long> knowledgeIdList) { this.knowledgeIdList = knowledgeIdList; }
    public List<SpasCoachLog> getCoachLogs() { return coachLogs; }
    public void setCoachLogs(List<SpasCoachLog> coachLogs) { this.coachLogs = coachLogs; }
}
