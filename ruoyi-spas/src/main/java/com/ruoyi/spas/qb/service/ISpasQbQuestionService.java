package com.ruoyi.spas.qb.service;

import java.util.List;
import java.util.Map;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.spas.qb.domain.SpasQbAiSuggestResult;
import com.ruoyi.spas.qb.domain.SpasQbBatchRequest;
import com.ruoyi.spas.qb.domain.SpasQbParseItem;
import com.ruoyi.spas.qb.domain.SpasQbParseResult;
import com.ruoyi.spas.qb.domain.SpasQbQuestion;
import com.ruoyi.spas.qb.domain.SpasQbQuestionKnowledge;
import com.ruoyi.spas.qb.domain.SpasQbSmartPickRequest;

/**
 * Bank question service
 */
public interface ISpasQbQuestionService
{
    List<SpasQbQuestion> selectSpasQbQuestionList(SpasQbQuestion query);

    SpasQbQuestion selectSpasQbQuestionById(Long questionId);

    SpasQbQuestion findDuplicate(Long subjectId, String content);

    int insertSpasQbQuestion(SpasQbQuestion question);

    int updateSpasQbQuestion(SpasQbQuestion question);

    int deleteSpasQbQuestionByIds(Long[] questionIds);

    int saveKnowledge(Long questionId, List<SpasQbQuestionKnowledge> list);

    SpasQbAiSuggestResult aiSuggest(Long questionId, String operator);

    String contentHash(String content);

    SpasQbParseResult parsePaper(MultipartFile file, Long subjectId);

    /** Split questions from client OCR plain text */
    SpasQbParseResult parseOcrText(Long subjectId, String text, String fileName);

    /**
     * Polish stem text/formulas: local heuristics + optional remote LLM LaTeX cleanup.
     * Returns map: content, mode (local|remote), changed (boolean)
     */
    Map<String, Object> polishFormula(String content);

    /**
     * Smart annotate import rows: question type + chapter + knowledge (heuristic / local).
     */
    List<SpasQbParseItem> smartAnnotate(Long subjectId, List<SpasQbParseItem> items);

    Map<String, Object> batchInsert(SpasQbBatchRequest request, String operator);

    /** Rule-based smart pick / blueprint compose */
    List<SpasQbQuestion> smartPick(SpasQbSmartPickRequest request);

    /** Best-effort cleanup of OCR/import page images for a session. */
    void cleanupOcrSession(String sessionId);
}

