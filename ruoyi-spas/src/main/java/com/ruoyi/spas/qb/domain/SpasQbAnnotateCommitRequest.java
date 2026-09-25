package com.ruoyi.spas.qb.domain;

import java.util.ArrayList;
import java.util.List;

/**
 * Commit visual annotate session into question bank
 */
public class SpasQbAnnotateCommitRequest
{
    private String sessionId;
    private Long subjectId;
    private List<SpasQbAnnotateQuestion> questions = new ArrayList<>();

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }
    public Long getSubjectId() { return subjectId; }
    public void setSubjectId(Long subjectId) { this.subjectId = subjectId; }
    public List<SpasQbAnnotateQuestion> getQuestions() { return questions; }
    public void setQuestions(List<SpasQbAnnotateQuestion> questions) { this.questions = questions; }
}
