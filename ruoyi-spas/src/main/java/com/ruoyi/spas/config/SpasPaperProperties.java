package com.ruoyi.spas.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * Paper business settings (spas.paper.*)
 */
@Component
@ConfigurationProperties(prefix = "spas.paper")
public class SpasPaperProperties
{
    /** Allow knowledge link changes after scores imported */
    private boolean allowChangeKnowledgeAfterScore = false;

    /**
     * When true, publish/import requires every question to have question_type.
     * Soft metaWarnings still shown when false.
     */
    private boolean requireQuestionType = false;

    /**
     * When true, publish/import requires every question to have bloom_level.
     */
    private boolean requireBloomLevel = true;

    public boolean isAllowChangeKnowledgeAfterScore()
    {
        return allowChangeKnowledgeAfterScore;
    }

    public void setAllowChangeKnowledgeAfterScore(boolean allowChangeKnowledgeAfterScore)
    {
        this.allowChangeKnowledgeAfterScore = allowChangeKnowledgeAfterScore;
    }

    public boolean isRequireQuestionType()
    {
        return requireQuestionType;
    }

    public void setRequireQuestionType(boolean requireQuestionType)
    {
        this.requireQuestionType = requireQuestionType;
    }

    public boolean isRequireBloomLevel()
    {
        return requireBloomLevel;
    }

    public void setRequireBloomLevel(boolean requireBloomLevel)
    {
        this.requireBloomLevel = requireBloomLevel;
    }
}
