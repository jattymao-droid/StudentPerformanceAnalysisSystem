package com.ruoyi.spas.qb.domain;

import java.util.ArrayList;
import java.util.List;

/**
 * Paper parse response for teacher review before batch insert
 */
public class SpasQbParseResult
{
    private String fileName;
    private String fileType;
    private String warn;
    private String rawPreview;
    private List<SpasQbParseItem> items = new ArrayList<>();
    /** True when digital text missing; client should OCR pageImageUrls */
    private Boolean ocrNeeded;
    private String ocrSessionId;
    private List<String> pageImageUrls = new ArrayList<>();

    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }
    public String getFileType() { return fileType; }
    public void setFileType(String fileType) { this.fileType = fileType; }
    public String getWarn() { return warn; }
    public void setWarn(String warn) { this.warn = warn; }
    public String getRawPreview() { return rawPreview; }
    public void setRawPreview(String rawPreview) { this.rawPreview = rawPreview; }
    public List<SpasQbParseItem> getItems() { return items; }
    public void setItems(List<SpasQbParseItem> items) { this.items = items; }
    public Boolean getOcrNeeded() { return ocrNeeded; }
    public void setOcrNeeded(Boolean ocrNeeded) { this.ocrNeeded = ocrNeeded; }
    public String getOcrSessionId() { return ocrSessionId; }
    public void setOcrSessionId(String ocrSessionId) { this.ocrSessionId = ocrSessionId; }
    public List<String> getPageImageUrls() { return pageImageUrls; }
    public void setPageImageUrls(List<String> pageImageUrls) { this.pageImageUrls = pageImageUrls; }
}
