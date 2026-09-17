package com.ruoyi.spas.domain;

import java.math.BigDecimal;
import java.util.List;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Paper question entity spas_paper_question
 */
public class SpasPaperQuestion extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** Question ID */
    private Long questionId;

    /** Paper ID */
    private Long paperId;

    /** Question number */
    private String questionNo;

    /** Display order */
    private Integer questionOrder;

    /** Full score */
    private BigDecimal fullScore;

    /** Difficulty (1 easy 2 medium 3 hard) */
    private String difficulty;

    /** Question type */
    private String questionType;

    /** Bound knowledge list */
    private List<SpasQuestionKnowledge> knowledgeList;

    public Long getQuestionId()
    {
        return questionId;
    }

    public void setQuestionId(Long questionId)
    {
        this.questionId = questionId;
    }

    public Long getPaperId()
    {
        return paperId;
    }

    public void setPaperId(Long paperId)
    {
        this.paperId = paperId;
    }

    public String getQuestionNo()
    {
        return questionNo;
    }

    public void setQuestionNo(String questionNo)
    {
        this.questionNo = questionNo;
    }

    public Integer getQuestionOrder()
    {
        return questionOrder;
    }

    public void setQuestionOrder(Integer questionOrder)
    {
        this.questionOrder = questionOrder;
    }

    public BigDecimal getFullScore()
    {
        return fullScore;
    }

    public void setFullScore(BigDecimal fullScore)
    {
        this.fullScore = fullScore;
    }

    public String getDifficulty()
    {
        return difficulty;
    }

    public void setDifficulty(String difficulty)
    {
        this.difficulty = difficulty;
    }

    public String getQuestionType()
    {
        return questionType;
    }

    public void setQuestionType(String questionType)
    {
        this.questionType = questionType;
    }

    public List<SpasQuestionKnowledge> getKnowledgeList()
    {
        return knowledgeList;
    }

    public void setKnowledgeList(List<SpasQuestionKnowledge> knowledgeList)
    {
        this.knowledgeList = knowledgeList;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("questionId", getQuestionId())
            .append("paperId", getPaperId())
            .append("questionNo", getQuestionNo())
            .append("questionOrder", getQuestionOrder())
            .append("fullScore", getFullScore())
            .append("difficulty", getDifficulty())
            .append("questionType", getQuestionType())
            .append("remark", getRemark())
            .toString();
    }
}
