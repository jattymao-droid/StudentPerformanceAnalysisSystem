package com.ruoyi.spas.qb.domain;

import java.util.List;
import java.util.Map;

/**
 * Rule-based smart pick / blueprint compose request.
 */
public class SpasQbSmartPickRequest
{
    private Long subjectId;
    /** Preferred knowledge ids (OR). Empty = any bound. */
    private List<Long> knowledgeIds;
    /** chapter root (optional) */
    private Long chapterId;
    /** questionType -> count, e.g. choice:5, blank:3, short:2 */
    private Map<String, Integer> typeQuotas;
    /** difficulty -> weight/count preference: 1/2/3 */
    private Map<String, Integer> difficultyQuotas;
    /** total fallback when typeQuotas empty */
    private Integer totalCount;
    /** Prefer questions with knowledge bound */
    private Boolean boundOnly = Boolean.TRUE;
    /** Blueprint rows: knowledgeId, questionType, count, score */
    private List<SpasQbBlueprintRow> blueprint;

    public Long getSubjectId() { return subjectId; }
    public void setSubjectId(Long subjectId) { this.subjectId = subjectId; }
    public List<Long> getKnowledgeIds() { return knowledgeIds; }
    public void setKnowledgeIds(List<Long> knowledgeIds) { this.knowledgeIds = knowledgeIds; }
    public Long getChapterId() { return chapterId; }
    public void setChapterId(Long chapterId) { this.chapterId = chapterId; }
    public Map<String, Integer> getTypeQuotas() { return typeQuotas; }
    public void setTypeQuotas(Map<String, Integer> typeQuotas) { this.typeQuotas = typeQuotas; }
    public Map<String, Integer> getDifficultyQuotas() { return difficultyQuotas; }
    public void setDifficultyQuotas(Map<String, Integer> difficultyQuotas) { this.difficultyQuotas = difficultyQuotas; }
    public Integer getTotalCount() { return totalCount; }
    public void setTotalCount(Integer totalCount) { this.totalCount = totalCount; }
    public Boolean getBoundOnly() { return boundOnly; }
    public void setBoundOnly(Boolean boundOnly) { this.boundOnly = boundOnly; }
    public List<SpasQbBlueprintRow> getBlueprint() { return blueprint; }
    public void setBlueprint(List<SpasQbBlueprintRow> blueprint) { this.blueprint = blueprint; }

    public static class SpasQbBlueprintRow
    {
        private Long knowledgeId;
        private String questionType;
        private Integer count;
        private Double score;
        /** Optional preferred difficulty 1/2/3 */
        private String difficulty;

        public Long getKnowledgeId() { return knowledgeId; }
        public void setKnowledgeId(Long knowledgeId) { this.knowledgeId = knowledgeId; }
        public String getQuestionType() { return questionType; }
        public void setQuestionType(String questionType) { this.questionType = questionType; }
        public Integer getCount() { return count; }
        public void setCount(Integer count) { this.count = count; }
        public Double getScore() { return score; }
        public void setScore(Double score) { this.score = score; }
        public String getDifficulty() { return difficulty; }
        public void setDifficulty(String difficulty) { this.difficulty = difficulty; }
    }
}
