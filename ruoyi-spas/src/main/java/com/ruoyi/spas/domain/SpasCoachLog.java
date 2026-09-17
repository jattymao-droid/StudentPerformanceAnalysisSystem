package com.ruoyi.spas.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Coach log spas_coach_log
 */
public class SpasCoachLog extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long logId;
    private Long studentId;
    private Long warningId;
    private Long interveneId;
    private Long knowledgeId;
    private String content;
    private String nextPlan;
    private String studentName;

    public Long getLogId() { return logId; }
    public void setLogId(Long logId) { this.logId = logId; }
    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }
    public Long getWarningId() { return warningId; }
    public void setWarningId(Long warningId) { this.warningId = warningId; }
    public Long getInterveneId() { return interveneId; }
    public void setInterveneId(Long interveneId) { this.interveneId = interveneId; }
    public Long getKnowledgeId() { return knowledgeId; }
    public void setKnowledgeId(Long knowledgeId) { this.knowledgeId = knowledgeId; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getNextPlan() { return nextPlan; }
    public void setNextPlan(String nextPlan) { this.nextPlan = nextPlan; }
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
}
