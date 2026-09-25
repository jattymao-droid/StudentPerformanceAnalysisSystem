package com.ruoyi.spas.qb.domain;

import java.util.ArrayList;
import java.util.List;

/**
 * One candidate question from paper parse / batch import preview
 */
public class SpasQbParseItem
{
    private String questionNo;
    private String content;
    private String questionType;
    private String difficulty;
    private Boolean selected;
    private Boolean duplicate;
    private Long duplicateId;
    /** Primary stem/diagram image under /profile */
    private String stemImage;
    /** Extra images belonging to this question */
    private List<String> imageUrls = new ArrayList<>();
    /** Chapter (nodeType=1) for UI / display */
    private Long chapterId;
    private String chapterName;
    /** Reviewed knowledge bindings to save on insert */
    private List<SpasQbQuestionKnowledge> knowledgeList = new ArrayList<>();
    /** Client row index for merge after smart-annotate */
    private Integer rowIndex;
    /** none | heuristic | remote | remote-fail */
    private String annotateMode;
    /** Client flag: human reviewed KP for this row */
    private Boolean knowledgeConfirmed;

    public String getQuestionNo() { return questionNo; }
    public void setQuestionNo(String questionNo) { this.questionNo = questionNo; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getQuestionType() { return questionType; }
    public void setQuestionType(String questionType) { this.questionType = questionType; }
    public String getDifficulty() { return difficulty; }
    public void setDifficulty(String difficulty) { this.difficulty = difficulty; }
    public Boolean getSelected() { return selected; }
    public void setSelected(Boolean selected) { this.selected = selected; }
    public Boolean getDuplicate() { return duplicate; }
    public void setDuplicate(Boolean duplicate) { this.duplicate = duplicate; }
    public Long getDuplicateId() { return duplicateId; }
    public void setDuplicateId(Long duplicateId) { this.duplicateId = duplicateId; }
    public String getStemImage() { return stemImage; }
    public void setStemImage(String stemImage) { this.stemImage = stemImage; }
    public List<String> getImageUrls() { return imageUrls; }
    public void setImageUrls(List<String> imageUrls) { this.imageUrls = imageUrls; }
    public Long getChapterId() { return chapterId; }
    public void setChapterId(Long chapterId) { this.chapterId = chapterId; }
    public String getChapterName() { return chapterName; }
    public void setChapterName(String chapterName) { this.chapterName = chapterName; }
    public List<SpasQbQuestionKnowledge> getKnowledgeList() { return knowledgeList; }
    public void setKnowledgeList(List<SpasQbQuestionKnowledge> knowledgeList) { this.knowledgeList = knowledgeList; }
    public Integer getRowIndex() { return rowIndex; }
    public void setRowIndex(Integer rowIndex) { this.rowIndex = rowIndex; }
    public String getAnnotateMode() { return annotateMode; }
    public void setAnnotateMode(String annotateMode) { this.annotateMode = annotateMode; }
    public Boolean getKnowledgeConfirmed() { return knowledgeConfirmed; }
    public void setKnowledgeConfirmed(Boolean knowledgeConfirmed) { this.knowledgeConfirmed = knowledgeConfirmed; }
}
