package com.ruoyi.spas.qb.domain;

/**
 * Visual annotate upload session
 */
public class SpasQbAnnotateSession
{
    private String sessionId;
    private Long subjectId;
    private String fileName;
    private String filePath;
    private Integer pageCount;
    private String status;
    private String createBy;

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }
    public Long getSubjectId() { return subjectId; }
    public void setSubjectId(Long subjectId) { this.subjectId = subjectId; }
    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }
    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }
    public Integer getPageCount() { return pageCount; }
    public void setPageCount(Integer pageCount) { this.pageCount = pageCount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getCreateBy() { return createBy; }
    public void setCreateBy(String createBy) { this.createBy = createBy; }
}
