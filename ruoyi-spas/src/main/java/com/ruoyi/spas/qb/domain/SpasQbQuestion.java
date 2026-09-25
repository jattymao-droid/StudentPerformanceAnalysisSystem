package com.ruoyi.spas.qb.domain;

import java.util.List;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Bank question spas_qb_question
 */
public class SpasQbQuestion extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long questionId;
    private String questionCode;
    private String content;
    private String options;
    private String correctAnswer;
    private Long subjectId;
    private String questionType;
    private String difficulty;
    private String analysis;
    private String contentHash;
    private String status;
    private String delFlag;
    private String subjectName;
    private List<SpasQbQuestionKnowledge> knowledgeList;
    /** Bound knowledge count (list display) */
    private Integer knowledgeCount;
    /** Filter: true = only unbound questions */
    private Boolean unboundOnly;
    private String stemImage;
    private String optionsImage;
    private String answerImage;
    private String analysisImage;
    /** Exam year from stem header */
    private Integer sourceYear;
    private String sourceRegion;
    private String sourceExam;
    /** Filter: knowledge leaf id */
    private Long knowledgeId;
    /** Filter: chapter/version node — match descendants */
    private Long chapterId;
    /** Filter: multiple knowledge ids (OR) */
    private Long[] knowledgeIds;
    /** Filter: bound-only */
    private Boolean boundOnly;

    public Long getQuestionId() { return questionId; }
    public void setQuestionId(Long questionId) { this.questionId = questionId; }
    public String getQuestionCode() { return questionCode; }
    public void setQuestionCode(String questionCode) { this.questionCode = questionCode; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getOptions() { return options; }
    public void setOptions(String options) { this.options = options; }
    public String getCorrectAnswer() { return correctAnswer; }
    public void setCorrectAnswer(String correctAnswer) { this.correctAnswer = correctAnswer; }
    public Long getSubjectId() { return subjectId; }
    public void setSubjectId(Long subjectId) { this.subjectId = subjectId; }
    public String getQuestionType() { return questionType; }
    public void setQuestionType(String questionType) { this.questionType = questionType; }
    public String getDifficulty() { return difficulty; }
    public void setDifficulty(String difficulty) { this.difficulty = difficulty; }
    public String getAnalysis() { return analysis; }
    public void setAnalysis(String analysis) { this.analysis = analysis; }
    public String getContentHash() { return contentHash; }
    public void setContentHash(String contentHash) { this.contentHash = contentHash; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }
    public List<SpasQbQuestionKnowledge> getKnowledgeList() { return knowledgeList; }
    public void setKnowledgeList(List<SpasQbQuestionKnowledge> knowledgeList) { this.knowledgeList = knowledgeList; }
    public Integer getKnowledgeCount() { return knowledgeCount; }
    public void setKnowledgeCount(Integer knowledgeCount) { this.knowledgeCount = knowledgeCount; }
    public Boolean getUnboundOnly() { return unboundOnly; }
    public void setUnboundOnly(Boolean unboundOnly) { this.unboundOnly = unboundOnly; }
    public String getStemImage() { return stemImage; }
    public void setStemImage(String stemImage) { this.stemImage = stemImage; }
    public String getOptionsImage() { return optionsImage; }
    public void setOptionsImage(String optionsImage) { this.optionsImage = optionsImage; }
    public String getAnswerImage() { return answerImage; }
    public void setAnswerImage(String answerImage) { this.answerImage = answerImage; }
    public String getAnalysisImage() { return analysisImage; }
    public void setAnalysisImage(String analysisImage) { this.analysisImage = analysisImage; }
    public Integer getSourceYear() { return sourceYear; }
    public void setSourceYear(Integer sourceYear) { this.sourceYear = sourceYear; }
    public String getSourceRegion() { return sourceRegion; }
    public void setSourceRegion(String sourceRegion) { this.sourceRegion = sourceRegion; }
    public String getSourceExam() { return sourceExam; }
    public void setSourceExam(String sourceExam) { this.sourceExam = sourceExam; }
    public Long getKnowledgeId() { return knowledgeId; }
    public void setKnowledgeId(Long knowledgeId) { this.knowledgeId = knowledgeId; }
    public Long getChapterId() { return chapterId; }
    public void setChapterId(Long chapterId) { this.chapterId = chapterId; }
    public Long[] getKnowledgeIds() { return knowledgeIds; }
    public void setKnowledgeIds(Long[] knowledgeIds) { this.knowledgeIds = knowledgeIds; }
    public Boolean getBoundOnly() { return boundOnly; }
    public void setBoundOnly(Boolean boundOnly) { this.boundOnly = boundOnly; }
}

