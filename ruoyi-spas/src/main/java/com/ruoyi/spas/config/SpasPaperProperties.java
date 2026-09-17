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

    public boolean isAllowChangeKnowledgeAfterScore()
    {
        return allowChangeKnowledgeAfterScore;
    }

    public void setAllowChangeKnowledgeAfterScore(boolean allowChangeKnowledgeAfterScore)
    {
        this.allowChangeKnowledgeAfterScore = allowChangeKnowledgeAfterScore;
    }
}
