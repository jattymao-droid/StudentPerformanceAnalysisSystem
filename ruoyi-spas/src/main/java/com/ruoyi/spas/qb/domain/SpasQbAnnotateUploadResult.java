package com.ruoyi.spas.qb.domain;

import java.util.ArrayList;
import java.util.List;

/**
 * Upload + render response
 */
public class SpasQbAnnotateUploadResult
{
    private String sessionId;
    private Long subjectId;
    private String fileName;
    private Integer pageCount;
    private List<SpasQbAnnotatePage> pages = new ArrayList<>();

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }
    public Long getSubjectId() { return subjectId; }
    public void setSubjectId(Long subjectId) { this.subjectId = subjectId; }
    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }
    public Integer getPageCount() { return pageCount; }
    public void setPageCount(Integer pageCount) { this.pageCount = pageCount; }
    public List<SpasQbAnnotatePage> getPages() { return pages; }
    public void setPages(List<SpasQbAnnotatePage> pages) { this.pages = pages; }
}
