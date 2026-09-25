package com.ruoyi.spas.qb.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

public class SpasQbPublishRequest
{
    private Long bankPaperId;
    private Long deptId;
    private Long subjectId;
    private String paperName;
    private String paperType;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date examDate;
    private Boolean knowledgeOnly;
    /** When true, allow publish even if some items lack reviewed knowledge */
    private Boolean force;

    public Long getBankPaperId() { return bankPaperId; }
    public void setBankPaperId(Long bankPaperId) { this.bankPaperId = bankPaperId; }
    public Long getDeptId() { return deptId; }
    public void setDeptId(Long deptId) { this.deptId = deptId; }
    public Long getSubjectId() { return subjectId; }
    public void setSubjectId(Long subjectId) { this.subjectId = subjectId; }
    public String getPaperName() { return paperName; }
    public void setPaperName(String paperName) { this.paperName = paperName; }
    public String getPaperType() { return paperType; }
    public void setPaperType(String paperType) { this.paperType = paperType; }
    public Date getExamDate() { return examDate; }
    public void setExamDate(Date examDate) { this.examDate = examDate; }
    public Boolean getKnowledgeOnly() { return knowledgeOnly; }
    public void setKnowledgeOnly(Boolean knowledgeOnly) { this.knowledgeOnly = knowledgeOnly; }
    public Boolean getForce() { return force; }
    public void setForce(Boolean force) { this.force = force; }
}
