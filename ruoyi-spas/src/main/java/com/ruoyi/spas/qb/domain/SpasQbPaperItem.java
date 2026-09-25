package com.ruoyi.spas.qb.domain;

import java.math.BigDecimal;

public class SpasQbPaperItem
{
    private Long itemId;
    private Long paperId;
    private Long questionId;
    private Integer orderNum;
    private BigDecimal scoreValue;
    private String questionNo;
    private String contentPreview;
    /** Full stem for preview/print */
    private String content;
    private String options;
    private String correctAnswer;
    private String stemImage;
    private String optionsImage;
    private String questionType;
    private String difficulty;
    /** Reviewed knowledge count on bank question */
    private Integer knowledgeCount;

    public Long getItemId() { return itemId; }
    public void setItemId(Long itemId) { this.itemId = itemId; }
    public Long getPaperId() { return paperId; }
    public void setPaperId(Long paperId) { this.paperId = paperId; }
    public Long getQuestionId() { return questionId; }
    public void setQuestionId(Long questionId) { this.questionId = questionId; }
    public Integer getOrderNum() { return orderNum; }
    public void setOrderNum(Integer orderNum) { this.orderNum = orderNum; }
    public BigDecimal getScoreValue() { return scoreValue; }
    public void setScoreValue(BigDecimal scoreValue) { this.scoreValue = scoreValue; }
    public String getQuestionNo() { return questionNo; }
    public void setQuestionNo(String questionNo) { this.questionNo = questionNo; }
    public String getContentPreview() { return contentPreview; }
    public void setContentPreview(String contentPreview) { this.contentPreview = contentPreview; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getOptions() { return options; }
    public void setOptions(String options) { this.options = options; }
    public String getCorrectAnswer() { return correctAnswer; }
    public void setCorrectAnswer(String correctAnswer) { this.correctAnswer = correctAnswer; }
    public String getStemImage() { return stemImage; }
    public void setStemImage(String stemImage) { this.stemImage = stemImage; }
    public String getOptionsImage() { return optionsImage; }
    public void setOptionsImage(String optionsImage) { this.optionsImage = optionsImage; }
    public String getQuestionType() { return questionType; }
    public void setQuestionType(String questionType) { this.questionType = questionType; }
    public String getDifficulty() { return difficulty; }
    public void setDifficulty(String difficulty) { this.difficulty = difficulty; }
    public Integer getKnowledgeCount() { return knowledgeCount; }
    public void setKnowledgeCount(Integer knowledgeCount) { this.knowledgeCount = knowledgeCount; }
}
