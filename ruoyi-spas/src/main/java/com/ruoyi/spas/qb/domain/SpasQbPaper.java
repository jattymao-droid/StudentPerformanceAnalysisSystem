package com.ruoyi.spas.qb.domain;

import java.math.BigDecimal;
import java.util.List;
import com.ruoyi.common.core.domain.BaseEntity;

public class SpasQbPaper extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long paperId;
    private String paperTitle;
    private Long subjectId;
    private BigDecimal totalScore;
    private String status;
    private String subjectName;
    private Integer itemCount;
    private List<SpasQbPaperItem> items;
    /** JSON: [{name,questionType,fromOrder,toOrder}] */
    private String sectionJson;

    public Long getPaperId() { return paperId; }
    public void setPaperId(Long paperId) { this.paperId = paperId; }
    public String getPaperTitle() { return paperTitle; }
    public void setPaperTitle(String paperTitle) { this.paperTitle = paperTitle; }
    public Long getSubjectId() { return subjectId; }
    public void setSubjectId(Long subjectId) { this.subjectId = subjectId; }
    public BigDecimal getTotalScore() { return totalScore; }
    public void setTotalScore(BigDecimal totalScore) { this.totalScore = totalScore; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }
    public Integer getItemCount() { return itemCount; }
    public void setItemCount(Integer itemCount) { this.itemCount = itemCount; }
    public List<SpasQbPaperItem> getItems() { return items; }
    public void setItems(List<SpasQbPaperItem> items) { this.items = items; }
    public String getSectionJson() { return sectionJson; }
    public void setSectionJson(String sectionJson) { this.sectionJson = sectionJson; }
}

