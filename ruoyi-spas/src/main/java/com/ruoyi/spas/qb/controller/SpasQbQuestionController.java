package com.ruoyi.spas.qb.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.spas.qb.domain.SpasQbAiSuggestResult;
import com.ruoyi.spas.qb.domain.SpasQbBatchRequest;
import com.ruoyi.spas.qb.domain.SpasQbParseItem;
import com.ruoyi.spas.qb.domain.SpasQbParseResult;
import com.ruoyi.spas.qb.domain.SpasQbQuestion;
import com.ruoyi.spas.qb.domain.SpasQbQuestionKnowledge;
import com.ruoyi.spas.qb.domain.SpasQbSmartPickRequest;
import com.ruoyi.spas.qb.service.ISpasQbQuestionService;
import com.ruoyi.spas.support.SpasAccessService;

@RestController
@RequestMapping("/spas/qb/question")
public class SpasQbQuestionController extends BaseController
{
    @Autowired
    private ISpasQbQuestionService questionService;

    @Autowired
    private SpasAccessService accessService;

    @PreAuthorize("@ss.hasPermi('spas:qb:question:list')")
    @GetMapping("/list")
    public TableDataInfo list(SpasQbQuestion query)
    {
        startPage();
        List<SpasQbQuestion> list = questionService.selectSpasQbQuestionList(query);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:question:query')")
    @GetMapping("/{questionId}")
    public AjaxResult getInfo(@PathVariable Long questionId)
    {
        return success(questionService.selectSpasQbQuestionById(questionId));
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:question:query')")
    @GetMapping("/check-dup")
    public AjaxResult checkDup(@RequestParam Long subjectId, @RequestParam String content)
    {
        SpasQbQuestion dup = questionService.findDuplicate(subjectId, content);
        Map<String, Object> data = new HashMap<>();
        data.put("duplicate", dup != null);
        data.put("question", dup);
        return success(data);
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:question:add')")
    @Log(title = "QB Question", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SpasQbQuestion question)
    {
        accessService.assertCanWrite();
        question.setCreateBy(getUsername());
        return toAjax(questionService.insertSpasQbQuestion(question));
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:question:edit')")
    @Log(title = "QB Question", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SpasQbQuestion question)
    {
        accessService.assertCanWrite();
        question.setUpdateBy(getUsername());
        return toAjax(questionService.updateSpasQbQuestion(question));
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:question:remove')")
    @Log(title = "QB Question", businessType = BusinessType.DELETE)
    @DeleteMapping("/{questionIds}")
    public AjaxResult remove(@PathVariable Long[] questionIds)
    {
        accessService.assertCanWrite();
        return toAjax(questionService.deleteSpasQbQuestionByIds(questionIds));
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:question:edit')")
    @Log(title = "QB Knowledge Review", businessType = BusinessType.UPDATE)
    @PutMapping("/{questionId}/knowledge")
    public AjaxResult saveKnowledge(@PathVariable Long questionId, @RequestBody List<SpasQbQuestionKnowledge> list)
    {
        accessService.assertCanWrite();
        return toAjax(questionService.saveKnowledge(questionId, list));
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:question:edit')")
    @Log(title = "QB AI Suggest", businessType = BusinessType.OTHER)
    @PostMapping("/{questionId}/ai-suggest")
    public AjaxResult aiSuggest(@PathVariable Long questionId)
    {
        accessService.assertCanWrite();
        SpasQbAiSuggestResult result = questionService.aiSuggest(questionId, getUsername());
        return success(result);
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:question:add')")
    @Log(title = "QB Parse Paper", businessType = BusinessType.OTHER)
    @PostMapping("/parse-paper")
    public AjaxResult parsePaper(@RequestParam("file") MultipartFile file, @RequestParam("subjectId") Long subjectId)
    {
        accessService.assertCanWrite();
        SpasQbParseResult result = questionService.parsePaper(file, subjectId);
        return success(result);
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:question:add')")
    @Log(title = "QB Parse OCR Text", businessType = BusinessType.OTHER)
    @PostMapping("/parse-ocr-text")
    public AjaxResult parseOcrText(@RequestBody java.util.Map<String, Object> body)
    {
        accessService.assertCanWrite();
        if (body == null || body.get("subjectId") == null)
        {
            return error("\u8bf7\u5148\u9009\u62e9\u5b66\u79d1");
        }
        Long subjectId = Long.valueOf(String.valueOf(body.get("subjectId")));
        String text = body.get("text") == null ? "" : String.valueOf(body.get("text"));
        String fileName = body.get("fileName") == null ? "ocr.txt" : String.valueOf(body.get("fileName"));
        SpasQbParseResult result = questionService.parseOcrText(subjectId, text, fileName);
        return success(result);
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:question:add')")
    @Log(title = "QB Cleanup OCR Session", businessType = BusinessType.OTHER)
    @DeleteMapping("/ocr-session/{sessionId}")
    public AjaxResult cleanupOcrSession(@PathVariable String sessionId)
    {
        accessService.assertCanWrite();
        questionService.cleanupOcrSession(sessionId);
        return success();
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:qb:question:add,spas:qb:question:edit')")
    @Log(title = "QB Polish Formula", businessType = BusinessType.OTHER)
    @PostMapping("/polish-formula")
    public AjaxResult polishFormula(@RequestBody java.util.Map<String, Object> body)
    {
        accessService.assertCanWrite();
        String content = body == null || body.get("content") == null ? "" : String.valueOf(body.get("content"));
        return success(questionService.polishFormula(content));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:qb:question:add,spas:qb:question:edit')")
    @Log(title = "QB Polish Formula Batch", businessType = BusinessType.OTHER)
    @PostMapping("/polish-formula-batch")
    public AjaxResult polishFormulaBatch(@RequestBody java.util.Map<String, Object> body)
    {
        accessService.assertCanWrite();
        java.util.List<String> contents = new java.util.ArrayList<>();
        if (body != null && body.get("contents") instanceof java.util.List)
        {
            for (Object o : (java.util.List<?>) body.get("contents"))
            {
                contents.add(o == null ? "" : String.valueOf(o));
            }
        }
        java.util.List<java.util.Map<String, Object>> items = new java.util.ArrayList<>();
        for (String c : contents)
        {
            items.add(questionService.polishFormula(c));
        }
        java.util.Map<String, Object> data = new java.util.HashMap<>();
        data.put("items", items);
        return success(data);
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:question:add')")
    @Log(title = "QB Smart Annotate", businessType = BusinessType.OTHER)
    @PostMapping("/smart-annotate")
    public AjaxResult smartAnnotate(@RequestBody SpasQbBatchRequest request)
    {
        accessService.assertCanWrite();
        if (request == null || request.getSubjectId() == null)
        {
            return error("\u8bf7\u5148\u9009\u62e9\u5b66\u79d1");
        }
        List<SpasQbParseItem> items = questionService.smartAnnotate(request.getSubjectId(), request.getItems());
        java.util.Map<String, Object> data = new java.util.HashMap<>();
        data.put("items", items);
        int heuristic = 0;
        int remote = 0;
        int remoteFail = 0;
        int none = 0;
        int withKp = 0;
        if (items != null)
        {
            for (SpasQbParseItem it : items)
            {
                if (it == null)
                {
                    continue;
                }
                if (it.getKnowledgeList() != null && !it.getKnowledgeList().isEmpty())
                {
                    withKp++;
                }
                String m = it.getAnnotateMode() == null ? "" : it.getAnnotateMode();
                if (m.startsWith("remote-fail"))
                {
                    remoteFail++;
                }
                else if ("remote".equals(m))
                {
                    remote++;
                }
                else if ("heuristic".equals(m))
                {
                    heuristic++;
                }
                else
                {
                    none++;
                }
            }
        }
        java.util.Map<String, Object> stats = new java.util.HashMap<>();
        stats.put("heuristic", heuristic);
        stats.put("remote", remote);
        stats.put("remoteFail", remoteFail);
        stats.put("none", none);
        stats.put("withKp", withKp);
        data.put("stats", stats);
        return success(data);
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:question:add')")
    @Log(title = "QB Batch Insert", businessType = BusinessType.INSERT)
    @PostMapping("/batch")
    public AjaxResult batch(@RequestBody SpasQbBatchRequest request)
    {
        accessService.assertCanWrite();
        return success(questionService.batchInsert(request, getUsername()));
    }

    /** Rule-based smart pick / blueprint for select-center & compose */
    @PreAuthorize("@ss.hasPermi('spas:qb:question:list')")
    @Log(title = "QB Smart Pick", businessType = BusinessType.OTHER)
    @PostMapping("/smart-pick")
    public AjaxResult smartPick(@RequestBody SpasQbSmartPickRequest request)
    {
        return success(questionService.smartPick(request));
    }
}
