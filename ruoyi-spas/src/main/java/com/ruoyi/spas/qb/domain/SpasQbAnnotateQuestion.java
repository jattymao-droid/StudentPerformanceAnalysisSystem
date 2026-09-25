package com.ruoyi.spas.qb.domain;

import java.util.ArrayList;
import java.util.List;

/**
 * One question card from visual annotate commit
 */
public class SpasQbAnnotateQuestion
{
    private String questionCode;
    private String content;
    private String options;
    private String correctAnswer;
    private String questionType;
    private String difficulty;
    private String analysis;
    private List<SpasQbAnnotateRegion> regions = new ArrayList<>();
    private List<SpasQbQuestionKnowledge> knowledgeList = new ArrayList<>();

    public String getQuestionCode() { return questionCode; }
    public void setQuestionCode(String questionCode) { this.questionCode = questionCode; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getOptions() { return options; }
    public void setOptions(String options) { this.options = options; }
    public String getCorrectAnswer() { return correctAnswer; }
    public void setCorrectAnswer(String correctAnswer) { this.correctAnswer = correctAnswer; }
    public String getQuestionType() { return questionType; }
    public void setQuestionType(String questionType) { this.questionType = questionType; }
    public String getDifficulty() { return difficulty; }
    public void setDifficulty(String difficulty) { this.difficulty = difficulty; }
    public String getAnalysis() { return analysis; }
    public void setAnalysis(String analysis) { this.analysis = analysis; }
    public List<SpasQbAnnotateRegion> getRegions() { return regions; }
    public void setRegions(List<SpasQbAnnotateRegion> regions) { this.regions = regions; }
    public List<SpasQbQuestionKnowledge> getKnowledgeList() { return knowledgeList; }
    public void setKnowledgeList(List<SpasQbQuestionKnowledge> knowledgeList) { this.knowledgeList = knowledgeList; }
}
