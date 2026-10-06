package com.ruoyi.spas.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Teacher daily practice assignment spas_practice_assignment
 */
public class SpasPracticeAssignment extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long assignmentId;
    private Long deptId;
    private Long subjectId;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date assignDate;
    private Long knowledgeId;
    private String bookName;
    private Integer pageFrom;
    private Integer pageTo;
    private String questionText;
    private String completeDefinition;
    private Integer dueCountWeek;
    private String status;

    private String deptName;
    private String subjectName;
    private String knowledgeName;

    public Long getAssignmentId() { return assignmentId; }
    public void setAssignmentId(Long assignmentId) { this.assignmentId = assignmentId; }
    public Long getDeptId() { return deptId; }
    public void setDeptId(Long deptId) { this.deptId = deptId; }
    public Long getSubjectId() { return subjectId; }
    public void setSubjectId(Long subjectId) { this.subjectId = subjectId; }
    public Date getAssignDate() { return assignDate; }
    public void setAssignDate(Date assignDate) { this.assignDate = assignDate; }
    public Long getKnowledgeId() { return knowledgeId; }
    public void setKnowledgeId(Long knowledgeId) { this.knowledgeId = knowledgeId; }
    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }
    public Integer getPageFrom() { return pageFrom; }
    public void setPageFrom(Integer pageFrom) { this.pageFrom = pageFrom; }
    public Integer getPageTo() { return pageTo; }
    public void setPageTo(Integer pageTo) { this.pageTo = pageTo; }
    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }
    public String getCompleteDefinition() { return completeDefinition; }
    public void setCompleteDefinition(String completeDefinition) { this.completeDefinition = completeDefinition; }
    public Integer getDueCountWeek() { return dueCountWeek; }
    public void setDueCountWeek(Integer dueCountWeek) { this.dueCountWeek = dueCountWeek; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }
    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }
    public String getKnowledgeName() { return knowledgeName; }
    public void setKnowledgeName(String knowledgeName) { this.knowledgeName = knowledgeName; }
}
