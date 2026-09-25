package com.ruoyi.spas.qb.domain;

import java.util.ArrayList;
import java.util.List;

/**
 * AI knowledge suggest response with mode (remote / heuristic / fallback).
 */
public class SpasQbAiSuggestResult
{
    private String mode;
    private List<SpasQbAiSuggestItem> suggestions = new ArrayList<>();

    public SpasQbAiSuggestResult()
    {
    }

    public SpasQbAiSuggestResult(String mode, List<SpasQbAiSuggestItem> suggestions)
    {
        this.mode = mode;
        this.suggestions = suggestions == null ? new ArrayList<>() : suggestions;
    }

    public String getMode()
    {
        return mode;
    }

    public void setMode(String mode)
    {
        this.mode = mode;
    }

    public List<SpasQbAiSuggestItem> getSuggestions()
    {
        return suggestions;
    }

    public void setSuggestions(List<SpasQbAiSuggestItem> suggestions)
    {
        this.suggestions = suggestions;
    }
}
