package com.ruoyi.spas.qb.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasKnowledge;
import com.ruoyi.spas.mapper.SpasKnowledgeMapper;
import com.ruoyi.spas.qb.config.SpasQbAiProperties;
import com.ruoyi.spas.qb.config.SpasQbAiConfigSupport;
import com.ruoyi.spas.qb.config.SpasQbAiHttpClient;
import com.ruoyi.spas.qb.config.SpasQbAiRuntimeConfig;
import com.ruoyi.spas.qb.domain.SpasQbAiSuggestItem;
import com.ruoyi.spas.qb.domain.SpasQbAiSuggestResult;
import com.ruoyi.spas.qb.domain.SpasQbBatchRequest;
import com.ruoyi.spas.qb.domain.SpasQbParseItem;
import com.ruoyi.spas.qb.domain.SpasQbParseResult;
import com.ruoyi.spas.qb.domain.SpasQbQuestion;
import com.ruoyi.spas.qb.domain.SpasQbQuestionKnowledge;
import com.ruoyi.spas.qb.mapper.SpasQbQuestionMapper;
import com.ruoyi.spas.qb.service.ISpasQbQuestionService;
import com.ruoyi.spas.qb.support.SpasQbFormulaPolishHelper;
import com.ruoyi.spas.qb.support.SpasQbPaperImportHelper;
import com.ruoyi.spas.qb.support.SpasQbSourceParseHelper;
import com.ruoyi.spas.support.SpasQuestionTypeAlias;
import com.ruoyi.spas.qb.domain.SpasQbSmartPickRequest;
import org.springframework.web.multipart.MultipartFile;
import java.util.HashMap;
import java.util.Map;

@Service
public class SpasQbQuestionServiceImpl implements ISpasQbQuestionService
{
    private static final BigDecimal WEIGHT_ONE = BigDecimal.ONE;

    @Autowired
    private SpasQbQuestionMapper questionMapper;

    @Autowired
    private SpasKnowledgeMapper knowledgeMapper;

    @Autowired
    private SpasQbAiProperties aiProperties;

    @Autowired
    private SpasQbAiConfigSupport aiConfigSupport;

    @Autowired
    private SpasQbAiHttpClient aiHttpClient;

    @Autowired
    private SpasQbPaperImportHelper paperImportHelper;

    @Override
    public List<SpasQbQuestion> selectSpasQbQuestionList(SpasQbQuestion query)
    {
        applyTypeFilterAliases(query);
        return questionMapper.selectSpasQbQuestionList(query);
    }

    /** Expand choice/blank ↔ single/fill so list/smart-pick do not miss catalog rows. */
    private void applyTypeFilterAliases(SpasQbQuestion query)
    {
        if (query == null || StringUtils.isEmpty(query.getQuestionType()))
        {
            return;
        }
        List<String> aliases = SpasQuestionTypeAlias.expand(query.getQuestionType());
        if (aliases.size() > 1)
        {
            query.setQuestionTypes(aliases);
            query.setQuestionType(null);
        }
        else
        {
            query.setQuestionType(SpasQuestionTypeAlias.normalize(query.getQuestionType()));
        }
    }

    @Override
    public SpasQbQuestion selectSpasQbQuestionById(Long questionId)
    {
        SpasQbQuestion q = questionMapper.selectSpasQbQuestionById(questionId);
        if (q != null)
        {
            q.setKnowledgeList(questionMapper.selectKnowledgeByQuestionId(questionId));
        }
        return q;
    }

    @Override
    public SpasQbQuestion findDuplicate(Long subjectId, String content)
    {
        if (subjectId == null || StringUtils.isEmpty(content))
        {
            return null;
        }
        return questionMapper.selectByContentHash(subjectId, contentHash(content));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertSpasQbQuestion(SpasQbQuestion question)
    {
        if (question.getSubjectId() == null || StringUtils.isEmpty(question.getContent()))
        {
            throw new ServiceException("学科与题干不能为空");
        }
        String hash = contentHash(question.getContent());
        SpasQbQuestion dup = questionMapper.selectByContentHash(question.getSubjectId(), hash);
        if (dup != null)
        {
            throw new ServiceException("题干与已有题目重复（ID=" + dup.getQuestionId() + "），请直接复用");
        }
        question.setContentHash(hash);
        SpasQbSourceParseHelper.fillFromContent(question);
        if (StringUtils.isEmpty(question.getDifficulty()))
        {
            question.setDifficulty("2");
        }
        if (StringUtils.isEmpty(question.getQuestionType()))
        {
            question.setQuestionType("short");
        }
        else
        {
            question.setQuestionType(SpasQuestionTypeAlias.normalize(question.getQuestionType()));
        }
        int rows = questionMapper.insertSpasQbQuestion(question);
        if (rows > 0 && question.getKnowledgeList() != null && !question.getKnowledgeList().isEmpty())
        {
            saveKnowledge(question.getQuestionId(), question.getKnowledgeList());
        }
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateSpasQbQuestion(SpasQbQuestion question)
    {
        if (question.getQuestionId() == null)
        {
            throw new ServiceException("题目ID不能为空");
        }
        SpasQbQuestion old = questionMapper.selectSpasQbQuestionById(question.getQuestionId());
        if (old == null)
        {
            throw new ServiceException("题目不存在");
        }
        if (StringUtils.isNotEmpty(question.getContent()))
        {
            Long subjectId = question.getSubjectId() != null ? question.getSubjectId() : old.getSubjectId();
            String hash = contentHash(question.getContent());
            SpasQbQuestion dup = questionMapper.selectByContentHash(subjectId, hash);
            if (dup != null && !dup.getQuestionId().equals(question.getQuestionId()))
            {
                throw new ServiceException("题干与已有题目重复（ID=" + dup.getQuestionId() + "）");
            }
            question.setContentHash(hash);
        }
        SpasQbSourceParseHelper.fillFromContent(question);
        int rows = questionMapper.updateSpasQbQuestion(question);
        if (question.getKnowledgeList() != null)
        {
            saveKnowledge(question.getQuestionId(), question.getKnowledgeList());
        }
        return rows;
    }

    @Override
    public int deleteSpasQbQuestionByIds(Long[] questionIds)
    {
        return questionMapper.deleteSpasQbQuestionByIds(questionIds);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int saveKnowledge(Long questionId, List<SpasQbQuestionKnowledge> list)
    {
        SpasQbQuestion q = questionMapper.selectSpasQbQuestionById(questionId);
        if (q == null)
        {
            throw new ServiceException("题目不存在");
        }
        questionMapper.deleteKnowledgeByQuestionId(questionId);
        if (list == null || list.isEmpty())
        {
            return 1;
        }
        normalizeWeights(list);
        Set<Long> leafIds = loadLeafIds(q.getSubjectId());
        for (SpasQbQuestionKnowledge link : list)
        {
            if (link.getKnowledgeId() == null || !leafIds.contains(link.getKnowledgeId()))
            {
                throw new ServiceException("知识点必须为当前学科叶子节点: " + link.getKnowledgeId());
            }
            link.setQuestionId(questionId);
            if (link.getWeight() == null)
            {
                link.setWeight(WEIGHT_ONE);
            }
            if (StringUtils.isEmpty(link.getIsPrimary()))
            {
                link.setIsPrimary("0");
            }
        }
        if (list.stream().noneMatch(k -> "1".equals(k.getIsPrimary())))
        {
            list.get(0).setIsPrimary("1");
        }
        return questionMapper.batchInsertQuestionKnowledge(list);
    }

    @Override
    public SpasQbAiSuggestResult aiSuggest(Long questionId, String operator)
    {
        SpasQbQuestion q = selectSpasQbQuestionById(questionId);
        if (q == null)
        {
            throw new ServiceException("题目不存在");
        }
        List<SpasKnowledge> leaves = loadLeaves(q.getSubjectId());
        if (leaves.isEmpty())
        {
            throw new ServiceException("当前学科无叶子知识点，请先维护知识树");
        }
        List<SpasQbAiSuggestItem> items;
        String mode;
        SpasQbAiRuntimeConfig aiCfg = aiConfigSupport.resolve();
        if (aiCfg.isEnabled() && StringUtils.isNotEmpty(aiCfg.getEndpoint()))
        {
            try
            {
                items = callRemoteAi(q, leaves, aiCfg);
                mode = "remote";
            }
            catch (Exception e)
            {
                items = heuristicSuggest(q, leaves, aiCfg.getTopK());
                mode = "heuristic-fallback:" + e.getMessage();
            }
        }
        else
        {
            items = heuristicSuggest(q, leaves, aiCfg.getTopK());
            mode = "heuristic";
        }
        JSONObject req = new JSONObject();
        req.put("mode", mode);
        req.put("questionId", questionId);
        questionMapper.insertAiSuggestLog(questionId, req.toJSONString(), JSON.toJSONString(items), "0", operator);
        return new SpasQbAiSuggestResult(mode, items);
    }

    @Override
    public String contentHash(String content)
    {
        String normalized = normalizeContent(content);
        try
        {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] dig = md.digest(normalized.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(dig.length * 2);
            for (byte b : dig)
            {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        }
        catch (Exception e)
        {
            throw new ServiceException("计算题干指纹失败");
        }
    }

    private String normalizeContent(String content)
    {
        if (content == null)
        {
            return "";
        }
        return content.replaceAll("\\s+", "").trim().toLowerCase(Locale.ROOT);
    }

    private void normalizeWeights(List<SpasQbQuestionKnowledge> list)
    {
        BigDecimal sum = BigDecimal.ZERO;
        for (SpasQbQuestionKnowledge k : list)
        {
            if (k.getWeight() != null)
            {
                sum = sum.add(k.getWeight());
            }
        }
        if (sum.compareTo(BigDecimal.ZERO) <= 0)
        {
            BigDecimal each = WEIGHT_ONE.divide(BigDecimal.valueOf(list.size()), 4, RoundingMode.HALF_UP);
            for (SpasQbQuestionKnowledge k : list)
            {
                k.setWeight(each);
            }
            return;
        }
        if (sum.subtract(WEIGHT_ONE).abs().compareTo(new BigDecimal("0.0001")) > 0)
        {
            for (SpasQbQuestionKnowledge k : list)
            {
                BigDecimal w = k.getWeight() == null ? BigDecimal.ZERO : k.getWeight();
                k.setWeight(w.divide(sum, 4, RoundingMode.HALF_UP));
            }
        }
    }

    private Set<Long> loadLeafIds(Long subjectId)
    {
        return loadLeaves(subjectId).stream().map(SpasKnowledge::getKnowledgeId).collect(Collectors.toSet());
    }

    private List<SpasKnowledge> loadLeaves(Long subjectId)
    {
        SpasKnowledge query = new SpasKnowledge();
        query.setSubjectId(subjectId);
        query.setNodeType("2");
        query.setStatus("0");
        List<SpasKnowledge> list = knowledgeMapper.selectSpasKnowledgeList(query);
        return list == null ? new ArrayList<>() : list;
    }

    private List<SpasQbAiSuggestItem> heuristicSuggest(SpasQbQuestion q, List<SpasKnowledge> leaves)
    {
        String text = (q.getContent() == null ? "" : q.getContent())
                + " " + (q.getAnalysis() == null ? "" : q.getAnalysis());
        return heuristicSuggestByText(text, leaves, aiConfigSupport.resolve().getTopK());
    }

    private List<SpasQbAiSuggestItem> heuristicSuggest(SpasQbQuestion q, List<SpasKnowledge> leaves, int topK)
    {
        String text = (q.getContent() == null ? "" : q.getContent())
                + " " + (q.getAnalysis() == null ? "" : q.getAnalysis());
        return heuristicSuggestByText(text, leaves, topK);
    }

    private List<SpasQbAiSuggestItem> heuristicSuggestByText(String text, List<SpasKnowledge> leaves, int topK)
    {
        if (text == null)
        {
            text = "";
        }
        String lower = text.toLowerCase(Locale.ROOT);
        List<SpasQbAiSuggestItem> scored = new ArrayList<>();
        for (SpasKnowledge leaf : leaves)
        {
            String name = leaf.getKnowledgeName() == null ? "" : leaf.getKnowledgeName();
            String code = leaf.getKnowledgeCode() == null ? "" : leaf.getKnowledgeCode();
            if (StringUtils.isEmpty(name) || name.length() < 2)
            {
                continue;
            }
            double score = 0;
            if (text.contains(name))
            {
                score += 3.5 + Math.min(name.length(), 16) * 0.15;
                if (name.length() >= 4)
                {
                    score += 0.8;
                }
            }
            if (StringUtils.isNotEmpty(code) && (text.contains(code) || lower.contains(code.toLowerCase(Locale.ROOT))))
            {
                score += 2.2;
            }
            for (String token : name.split("[\\s\\u3001\\uff0c,\\uff1b;/.]+"))
            {
                if (token.length() >= 2 && text.contains(token))
                {
                    score += 0.9 + Math.min(token.length(), 8) * 0.05;
                }
            }
            if (score < 2.0)
            {
                continue;
            }
                        SpasQbAiSuggestItem item = new SpasQbAiSuggestItem();
            item.setKnowledgeId(leaf.getKnowledgeId());
            item.setKnowledgeName(name);
            item.setScore(score);
            item.setReason("\u9898\u5e72\u6216\u89e3\u6790\u547d\u4e2d\u77e5\u8bc6\u70b9\u540d\u79f0\u6216\u7f16\u7801\uff08\u542f\u53d1\u5f0f\uff09");
            scored.add(item);
        }
        scored.sort(Comparator.comparing(SpasQbAiSuggestItem::getScore, Comparator.nullsLast(Comparator.reverseOrder())));
        int k = Math.max(1, topK);
        List<SpasQbAiSuggestItem> top = scored.stream().limit(k).collect(Collectors.toList());
        assignEqualWeights(top);
        return top;
    }

    
    private static final int AI_STEM_MAX_CHARS = 2000;
    private static final int AI_CATALOG_MAX = 200;

    private List<SpasQbAiSuggestItem> callRemoteAi(SpasQbQuestion q, List<SpasKnowledge> leaves, SpasQbAiRuntimeConfig aiCfg)
    {
        return callRemoteAiByText(q.getContent(), q.getAnalysis(), leaves, aiCfg);
    }

    private List<SpasQbAiSuggestItem> callRemoteAiByText(String content, String analysisRaw, List<SpasKnowledge> leaves, SpasQbAiRuntimeConfig aiCfg)
    {
        String stem = truncateText(stripHtml(content), AI_STEM_MAX_CHARS);
        String analysis = truncateText(stripHtml(analysisRaw), 800);
        List<SpasKnowledge> catalogLeaves = selectCatalogLeaves(stem + " " + analysis, leaves, AI_CATALOG_MAX);
        JSONArray catalog = new JSONArray();
        for (SpasKnowledge leaf : catalogLeaves)
        {
            JSONObject o = new JSONObject();
            o.put("knowledgeId", leaf.getKnowledgeId());
            o.put("knowledgeName", leaf.getKnowledgeName());
            o.put("knowledgeCode", leaf.getKnowledgeCode());
            catalog.add(o);
        }
        int topK = Math.max(1, aiCfg.getTopK());
        JSONObject body = new JSONObject();
        body.put("model", aiCfg.getModel());
        body.put("temperature", 0.2);
        JSONArray messages = new JSONArray();
        JSONObject sys = new JSONObject();
        sys.put("role", "system");
        sys.put("content",
                "You are a question-bank knowledge-point tagging assistant. "
                        + "Select at most TopK items ONLY from the given catalog. "
                        + "Reply with a JSON array only, no markdown: "
                        + "[{knowledgeId,weight,reason}]. knowledgeId must be from catalog.");
        messages.add(sys);
        JSONObject user = new JSONObject();
        user.put("role", "user");
        user.put("content", "TopK=" + topK + "\nStem:\n" + stem
                + (StringUtils.isEmpty(analysis) ? "" : ("\nAnalysis:\n" + analysis))
                + "\nCatalog:\n" + catalog.toJSONString());
        messages.add(user);
        body.put("messages", messages);

        String resp = aiHttpClient.postChatCompletions(aiCfg, body.toJSONString());
        if (StringUtils.isEmpty(resp))
        {
            throw new ServiceException("AI empty response");
        }
        Set<Long> allowed = leaves.stream().map(SpasKnowledge::getKnowledgeId).collect(Collectors.toCollection(HashSet::new));
        List<SpasQbAiSuggestItem> items = parseAiResponse(resp, allowed, leaves);
        if (items.isEmpty())
        {
            throw new ServiceException("AI response not parseable");
        }
        assignEqualWeights(items);
        return items;
    }

    private List<SpasKnowledge> selectCatalogLeaves(String text, List<SpasKnowledge> leaves, int max)
    {
        if (leaves == null || leaves.isEmpty())
        {
            return new ArrayList<>();
        }
        String hay = text == null ? "" : text;
        List<SpasKnowledge> hit = new ArrayList<>();
        List<SpasKnowledge> rest = new ArrayList<>();
        for (SpasKnowledge leaf : leaves)
        {
            String name = leaf.getKnowledgeName() == null ? "" : leaf.getKnowledgeName();
            String code = leaf.getKnowledgeCode() == null ? "" : leaf.getKnowledgeCode();
            boolean matched = false;
            if (StringUtils.isNotEmpty(name) && hay.contains(name))
            {
                matched = true;
            }
            else if (StringUtils.isNotEmpty(code) && hay.contains(code))
            {
                matched = true;
            }
            else
            {
                for (String token : name.split("[\\s\\u3001\\uff0c,\\uff1b;/.]+"))
                {
                    if (token.length() >= 2 && hay.contains(token))
                    {
                        matched = true;
                        break;
                    }
                }
            }
            if (matched)
            {
                hit.add(leaf);
            }
            else
            {
                rest.add(leaf);
            }
        }
        List<SpasKnowledge> out = new ArrayList<>(hit);
        for (SpasKnowledge leaf : rest)
        {
            if (out.size() >= max)
            {
                break;
            }
            out.add(leaf);
        }
        if (out.size() > max)
        {
            return out.subList(0, max);
        }
        return out;
    }

    private String stripHtml(String html)
    {
        if (html == null)
        {
            return "";
        }
        return html.replaceAll("<[^>]+>", " ").replaceAll("\\s+", " ").trim();
    }

    private String truncateText(String text, int maxChars)
    {
        if (text == null)
        {
            return "";
        }
        if (text.length() <= maxChars)
        {
            return text;
        }
        return text.substring(0, maxChars);
    }

    private List<SpasQbAiSuggestItem> parseAiResponse(String resp, Set<Long> allowed, List<SpasKnowledge> leaves)
    {
        List<SpasQbAiSuggestItem> out = new ArrayList<>();
        try
        {
            JSONObject root = JSON.parseObject(resp);
            String content = null;
            if (root.containsKey("choices"))
            {
                JSONArray choices = root.getJSONArray("choices");
                if (choices != null && !choices.isEmpty())
                {
                    JSONObject c0 = choices.getJSONObject(0);
                    if (c0.getJSONObject("message") != null)
                    {
                        content = c0.getJSONObject("message").getString("content");
                    }
                }
            }
            if (content == null && root.containsKey("suggestions"))
            {
                content = root.getJSONArray("suggestions").toJSONString();
            }
            if (content == null)
            {
                content = resp;
            }
            int start = content.indexOf('[');
            int end = content.lastIndexOf(']');
            if (start >= 0 && end > start)
            {
                content = content.substring(start, end + 1);
            }
            JSONArray arr = JSON.parseArray(content);
            for (int i = 0; i < arr.size(); i++)
            {
                JSONObject o = arr.getJSONObject(i);
                Long kid = o.getLong("knowledgeId");
                if (kid == null || !allowed.contains(kid))
                {
                    continue;
                }
                SpasQbAiSuggestItem item = new SpasQbAiSuggestItem();
                item.setKnowledgeId(kid);
                item.setWeight(o.getBigDecimal("weight"));
                item.setReason(o.getString("reason") == null ? "AI suggest" : o.getString("reason"));
                leaves.stream().filter(l -> l.getKnowledgeId().equals(kid)).findFirst()
                        .ifPresent(l -> item.setKnowledgeName(l.getKnowledgeName()));
                out.add(item);
            }
        }
        catch (Exception e)
        {
            throw new ServiceException("解析 AI 响应失败: " + e.getMessage());
        }
        return out.stream().limit(Math.max(1, aiConfigSupport.resolve().getTopK())).collect(Collectors.toList());
    }

    private void assignEqualWeights(List<SpasQbAiSuggestItem> items)
    {
        if (items == null || items.isEmpty())
        {
            return;
        }
        boolean any = items.stream().anyMatch(i -> i.getWeight() != null && i.getWeight().compareTo(BigDecimal.ZERO) > 0);
        if (any)
        {
            BigDecimal sum = items.stream()
                    .map(i -> i.getWeight() == null ? BigDecimal.ZERO : i.getWeight())
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            if (sum.compareTo(BigDecimal.ZERO) > 0)
            {
                for (SpasQbAiSuggestItem i : items)
                {
                    BigDecimal w = i.getWeight() == null ? BigDecimal.ZERO : i.getWeight();
                    i.setWeight(w.divide(sum, 4, RoundingMode.HALF_UP));
                }
                return;
            }
        }
        BigDecimal each = WEIGHT_ONE.divide(BigDecimal.valueOf(items.size()), 4, RoundingMode.HALF_UP);
        for (SpasQbAiSuggestItem i : items)
        {
            i.setWeight(each);
        }
    }

    @Override
    public SpasQbParseResult parsePaper(MultipartFile file, Long subjectId)
    {
        SpasQbParseResult result = paperImportHelper.parse(file, subjectId);
        fillDupAndAnnotate(subjectId, result);
        return result;
    }

    @Override
    public SpasQbParseResult parseOcrText(Long subjectId, String text, String fileName)
    {
        String polished = SpasQbFormulaPolishHelper.polishLocal(text);
        SpasQbParseResult result = paperImportHelper.parseText(polished, subjectId, fileName);
        fillDupAndAnnotate(subjectId, result);
        return result;
    }

    @Override
    public Map<String, Object> polishFormula(String content)
    {
        Map<String, Object> data = new HashMap<>();
        String src = content == null ? "" : content;
        String local = SpasQbFormulaPolishHelper.polishLocal(src);
        String out = local;
        String mode = "local";
        SpasQbAiRuntimeConfig aiCfg = aiConfigSupport.resolve();
        if (aiCfg.isEnabled() && StringUtils.isNotEmpty(aiCfg.getApiKey())
            && SpasQbFormulaPolishHelper.looksMathy(local))
        {
            try
            {
                String remote = callRemoteFormulaPolish(local, aiCfg);
                if (StringUtils.isNotEmpty(remote))
                {
                    out = remote.trim();
                    mode = "remote";
                }
            }
            catch (Exception ex)
            {
                mode = "local-fallback";
            }
        }
        data.put("content", out);
        data.put("mode", mode);
        data.put("changed", !out.equals(src));
        data.put("mathy", SpasQbFormulaPolishHelper.looksMathy(out));
        return data;
    }

    private String callRemoteFormulaPolish(String content, SpasQbAiRuntimeConfig aiCfg)
    {
        String stem = truncateText(stripHtml(content), AI_STEM_MAX_CHARS);
        JSONObject body = new JSONObject();
        body.put("model", aiCfg.getModel());
        body.put("temperature", 0.1);
        JSONArray messages = new JSONArray();
        JSONObject sys = new JSONObject();
        sys.put("role", "system");
        sys.put("content",
            "You clean exam question stems for a question bank. "
                + "Keep Chinese prose unchanged. Convert math to KaTeX-friendly LaTeX wrapped in $...$ or $$...$$. "
                + "Fix OCR errors in formulas (fractions, subscripts, superscripts, greek letters). "
                + "Do NOT invent new problem content. Reply with the polished stem text ONLY, no markdown fences.");
        messages.add(sys);
        JSONObject user = new JSONObject();
        user.put("role", "user");
        user.put("content", stem);
        messages.add(user);
        body.put("messages", messages);
        String resp = aiHttpClient.postChatCompletions(aiCfg, body.toJSONString());
        return extractChatContent(resp);
    }

    private String extractChatContent(String resp)
    {
        if (StringUtils.isEmpty(resp))
        {
            return "";
        }
        try
        {
            JSONObject root = JSON.parseObject(resp);
            JSONArray choices = root.getJSONArray("choices");
            if (choices == null || choices.isEmpty())
            {
                return "";
            }
            JSONObject msg = choices.getJSONObject(0).getJSONObject("message");
            if (msg == null)
            {
                return "";
            }
            String c = msg.getString("content");
            if (c == null)
            {
                return "";
            }
            c = c.trim();
            if (c.startsWith("```"))
            {
                int nl = c.indexOf('\n');
                if (nl > 0)
                {
                    c = c.substring(nl + 1);
                }
                if (c.endsWith("```"))
                {
                    c = c.substring(0, c.length() - 3).trim();
                }
            }
            return c.trim();
        }
        catch (Exception e)
        {
            return "";
        }
    }

    private void fillDupAndAnnotate(Long subjectId, SpasQbParseResult result)
    {
        if (result == null || result.getItems() == null || result.getItems().isEmpty())
        {
            return;
        }
        if (Boolean.TRUE.equals(result.getOcrNeeded()))
        {
            return;
        }
        for (SpasQbParseItem item : result.getItems())
        {
            if (StringUtils.isEmpty(item.getContent()))
            {
                continue;
            }
            if (SpasQbFormulaPolishHelper.looksMathy(item.getContent()))
            {
                item.setContent(SpasQbFormulaPolishHelper.polishLocal(item.getContent()));
            }
            SpasQbQuestion dup = findDuplicate(subjectId, item.getContent());
            if (dup != null)
            {
                item.setDuplicate(Boolean.TRUE);
                item.setDuplicateId(dup.getQuestionId());
                item.setSelected(Boolean.FALSE);
            }
            else
            {
                item.setDuplicate(Boolean.FALSE);
            }
        }
        smartAnnotate(subjectId, result.getItems());
    }

    @Override
    public List<SpasQbParseItem> smartAnnotate(Long subjectId, List<SpasQbParseItem> items)
    {
        if (subjectId == null)
        {
            throw new ServiceException("请先选择学科");
        }
        if (items == null || items.isEmpty())
        {
            return items == null ? new ArrayList<>() : items;
        }
        List<SpasKnowledge> leaves = loadLeaves(subjectId);
        Map<Long, SpasKnowledge> byId = loadKnowledgeMap(subjectId);
        SpasQbAiRuntimeConfig batchAiCfg = aiConfigSupport.resolve();
        int importTopK = Math.min(3, Math.max(1, batchAiCfg.getTopK()));
        int remoteBudget = batchAiCfg.isEnabled() ? 20 : 0;
        for (SpasQbParseItem item : items)
        {
            if (item == null || StringUtils.isEmpty(item.getContent()))
            {
                continue;
            }
            if (StringUtils.isEmpty(item.getQuestionType()))
            {
                item.setQuestionType(SpasQbPaperImportHelper.guessTypeFromContent(item.getContent()));
            }
            else
            {
                // re-check content when section said short but options present
                String fromContent = SpasQbPaperImportHelper.guessTypeFromContent(item.getContent());
                if ("single".equals(fromContent) && !"single".equals(item.getQuestionType())
                    && !"multi".equals(item.getQuestionType()) && !"choice".equals(item.getQuestionType()))
                {
                    item.setQuestionType("single");
                }
                else if ("fill".equals(fromContent) && "short".equals(item.getQuestionType()))
                {
                    item.setQuestionType("fill");
                }
                item.setQuestionType(SpasQuestionTypeAlias.normalize(item.getQuestionType()));
            }
            if (StringUtils.isEmpty(item.getDifficulty()))
            {
                item.setDifficulty(guessDifficulty(item.getContent()));
            }
            if (leaves.isEmpty())
            {
                continue;
            }
            SpasQbAiRuntimeConfig aiCfg = batchAiCfg;
            List<SpasQbAiSuggestItem> suggest = heuristicSuggestByText(item.getContent(), leaves, aiCfg.getTopK());
            String mode = "none";
            boolean weak = suggest.isEmpty();
            if (!weak && suggest.get(0).getScore() != null && suggest.get(0).getScore() < 2.0)
            {
                weak = true;
            }
            if (!suggest.isEmpty() && !weak)
            {
                mode = "heuristic";
            }
            if (weak && aiCfg.isEnabled() && StringUtils.isNotEmpty(aiCfg.getEndpoint())
                    && remoteBudget > 0)
            {
                try
                {
                    List<SpasQbAiSuggestItem> remote = callRemoteAiByText(item.getContent(), null, leaves, aiCfg);
                    remoteBudget--;
                    if (remote != null && !remote.isEmpty())
                    {
                        suggest = remote;
                        mode = "remote";
                    }
                    else if (suggest.isEmpty())
                    {
                        mode = "remote-fail";
                    }
                    else
                    {
                        mode = "heuristic";
                    }
                }
                catch (Exception e)
                {
                    mode = suggest.isEmpty() ? ("remote-fail:" + e.getMessage()) : "heuristic";
                    if (mode.length() > 120)
                    {
                        mode = mode.substring(0, 120);
                    }
                }
            }
            item.setAnnotateMode(mode);
            if (suggest.isEmpty())
            {
                continue;
            }
            if (suggest.size() > importTopK)
            {
                suggest = suggest.subList(0, importTopK);
                assignEqualWeights(suggest);
            }
            List<SpasQbQuestionKnowledge> kl = new ArrayList<>();
            for (int i = 0; i < suggest.size(); i++)
            {
                SpasQbAiSuggestItem s = suggest.get(i);
                SpasQbQuestionKnowledge k = new SpasQbQuestionKnowledge();
                k.setKnowledgeId(s.getKnowledgeId());
                k.setKnowledgeName(s.getKnowledgeName());
                k.setWeight(s.getWeight());
                k.setIsPrimary(i == 0 ? "1" : "0");
                kl.add(k);
            }
            item.setKnowledgeList(kl);
            SpasKnowledge chapter = findChapterOf(kl.get(0).getKnowledgeId(), byId);
            if (chapter != null)
            {
                item.setChapterId(chapter.getKnowledgeId());
                item.setChapterName(chapter.getKnowledgeName());
            }
        }
        return items;
    }

    private Map<Long, SpasKnowledge> loadKnowledgeMap(Long subjectId)
    {
        List<SpasKnowledge> all = knowledgeMapper.selectSpasKnowledgeBySubjectId(subjectId);
        Map<Long, SpasKnowledge> map = new HashMap<>();
        if (all != null)
        {
            for (SpasKnowledge k : all)
            {
                if (k != null && k.getKnowledgeId() != null)
                {
                    map.put(k.getKnowledgeId(), k);
                }
            }
        }
        return map;
    }

    private SpasKnowledge findChapterOf(Long leafId, Map<Long, SpasKnowledge> byId)
    {
        SpasKnowledge n = byId.get(leafId);
        int guard = 0;
        while (n != null && guard++ < 32)
        {
            if ("1".equals(n.getNodeType()))
            {
                return n;
            }
            Long pid = n.getParentId();
            if (pid == null || pid == 0L)
            {
                break;
            }
            n = byId.get(pid);
        }
        return null;
    }

    private String guessDifficulty(String content)
    {
        if (content == null)
        {
            return "2";
        }
        if (content.contains("\u8f83\u96be") || content.contains("\u96be\u9898") || content.contains("\u6311\u6218"))
        {
            return "3";
        }
        if (content.contains("\u7b80\u6613") || content.contains("\u57fa\u7840\u9898") || content.contains("\u5bb9\u6613"))
        {
            return "1";
        }
        return "2";
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> batchInsert(SpasQbBatchRequest request, String operator)
    {
        Map<String, Object> out = new HashMap<>();
        int inserted = 0;
        int skipped = 0;
        int failed = 0;
        List<String> messages = new ArrayList<>();
        if (request == null || request.getSubjectId() == null || request.getItems() == null || request.getItems().isEmpty())
        {
            throw new ServiceException("批量入库参数不完整");
        }
        boolean skipDup = request.getSkipDuplicate() == null || Boolean.TRUE.equals(request.getSkipDuplicate());
        for (SpasQbParseItem item : request.getItems())
        {
            if (item == null || Boolean.FALSE.equals(item.getSelected()))
            {
                skipped++;
                continue;
            }
            if (StringUtils.isEmpty(item.getContent()))
            {
                skipped++;
                continue;
            }
            try
            {
                SpasQbQuestion dup = findDuplicate(request.getSubjectId(), item.getContent());
                if (dup != null)
                {
                    if (skipDup)
                    {
                        skipped++;
                        messages.add("skip dup#" + dup.getQuestionId());
                        continue;
                    }
                    throw new ServiceException("dup#" + dup.getQuestionId());
                }
                SpasQbQuestion q = new SpasQbQuestion();
                q.setSubjectId(request.getSubjectId());
                q.setContent(item.getContent().trim());
                q.setQuestionType(StringUtils.isEmpty(item.getQuestionType()) ? "short"
                    : SpasQuestionTypeAlias.normalize(item.getQuestionType()));
                q.setDifficulty(StringUtils.isEmpty(item.getDifficulty()) ? "2" : item.getDifficulty());
                q.setQuestionCode(item.getQuestionNo());
                q.setStatus("0");
                q.setCreateBy(operator);
                if (StringUtils.isNotEmpty(item.getStemImage()))
                {
                    q.setStemImage(item.getStemImage());
                }
                else if (item.getImageUrls() != null && !item.getImageUrls().isEmpty())
                {
                    q.setStemImage(item.getImageUrls().get(0));
                }
                if (item.getKnowledgeList() != null && !item.getKnowledgeList().isEmpty())
                {
                    boolean acceptKp = Boolean.TRUE.equals(request.getAcceptAiKnowledge())
                            || Boolean.TRUE.equals(item.getKnowledgeConfirmed());
                    if (acceptKp)
                    {
                        q.setKnowledgeList(item.getKnowledgeList());
                    }
                }
                insertSpasQbQuestion(q);
                inserted++;
            }
            catch (Exception e)
            {
                failed++;
                messages.add((item.getQuestionNo() == null ? "?" : item.getQuestionNo()) + ":" + e.getMessage());
            }
        }
        out.put("inserted", inserted);
        out.put("skipped", skipped);
        out.put("failed", failed);
        out.put("messages", messages);
        return out;
    }

    @Override
    public List<SpasQbQuestion> smartPick(SpasQbSmartPickRequest request)
    {
        if (request == null || request.getSubjectId() == null)
        {
            throw new ServiceException("请先选择学科");
        }
        List<SpasQbQuestion> picked = new ArrayList<>();
        Set<Long> used = new HashSet<>();
        if (request.getBlueprint() != null && !request.getBlueprint().isEmpty())
        {
            for (SpasQbSmartPickRequest.SpasQbBlueprintRow row : request.getBlueprint())
            {
                if (row == null || row.getCount() == null || row.getCount() <= 0)
                {
                    continue;
                }
                SpasQbQuestion q = new SpasQbQuestion();
                q.setSubjectId(request.getSubjectId());
                if (Boolean.TRUE.equals(request.getBoundOnly()))
                {
                    q.setBoundOnly(Boolean.TRUE);
                }
                if (row.getKnowledgeId() != null)
                {
                    q.setKnowledgeId(row.getKnowledgeId());
                }
                if (StringUtils.isNotEmpty(row.getQuestionType()))
                {
                    q.setQuestionType(row.getQuestionType());
                }
                List<SpasQbQuestion> pool = diversifyPool(selectSpasQbQuestionList(q), null);
                pool = diversifyPool(pool, row.getDifficulty());
                int need = row.getCount();
                for (SpasQbQuestion cand : pool)
                {
                    if (need <= 0)
                    {
                        break;
                    }
                    if (cand == null || used.contains(cand.getQuestionId()))
                    {
                        continue;
                    }
                    used.add(cand.getQuestionId());
                    picked.add(cand);
                    need--;
                }
            }
            return picked;
        }
        Map<String, Integer> quotas = request.getTypeQuotas();
        if (quotas == null || quotas.isEmpty())
        {
            int total = request.getTotalCount() == null ? 10 : Math.max(1, Math.min(50, request.getTotalCount()));
            SpasQbQuestion q = basePickQuery(request);
            List<SpasQbQuestion> pool = diversifyPool(selectSpasQbQuestionList(q), null);
            for (SpasQbQuestion cand : pool)
            {
                if (picked.size() >= total)
                {
                    break;
                }
                if (cand == null || used.contains(cand.getQuestionId()))
                {
                    continue;
                }
                used.add(cand.getQuestionId());
                picked.add(cand);
            }
            return picked;
        }
        for (Map.Entry<String, Integer> e : quotas.entrySet())
        {
            if (e.getValue() == null || e.getValue() <= 0)
            {
                continue;
            }
            SpasQbQuestion q = basePickQuery(request);
            q.setQuestionType(e.getKey());
            List<SpasQbQuestion> pool = diversifyPool(selectSpasQbQuestionList(q), null);
            Map<String, Integer> diffQ = request.getDifficultyQuotas();
            int need = e.getValue();
            if (diffQ != null && !diffQ.isEmpty())
            {
                for (Map.Entry<String, Integer> de : diffQ.entrySet())
                {
                    int dNeed = de.getValue() == null ? 0 : de.getValue();
                    for (SpasQbQuestion cand : pool)
                    {
                        if (dNeed <= 0 || need <= 0)
                        {
                            break;
                        }
                        if (cand == null || used.contains(cand.getQuestionId()))
                        {
                            continue;
                        }
                        if (!de.getKey().equals(String.valueOf(cand.getDifficulty())))
                        {
                            continue;
                        }
                        used.add(cand.getQuestionId());
                        picked.add(cand);
                        dNeed--;
                        need--;
                    }
                }
            }
            for (SpasQbQuestion cand : pool)
            {
                if (need <= 0)
                {
                    break;
                }
                if (cand == null || used.contains(cand.getQuestionId()))
                {
                    continue;
                }
                used.add(cand.getQuestionId());
                picked.add(cand);
                need--;
            }
        }
        return picked;
    }


    private List<SpasQbQuestion> diversifyPool(List<SpasQbQuestion> pool, String preferDifficulty)
    {
        if (pool == null || pool.isEmpty())
        {
            return pool == null ? new ArrayList<>() : pool;
        }
        List<SpasQbQuestion> preferred = new ArrayList<>();
        List<SpasQbQuestion> rest = new ArrayList<>();
        for (SpasQbQuestion cand : pool)
        {
            if (cand == null)
            {
                continue;
            }
            if (StringUtils.isNotEmpty(preferDifficulty)
                    && preferDifficulty.equals(String.valueOf(cand.getDifficulty())))
            {
                preferred.add(cand);
            }
            else
            {
                rest.add(cand);
            }
        }
        Collections.shuffle(preferred);
        Collections.shuffle(rest);
        List<SpasQbQuestion> out = new ArrayList<>(preferred.size() + rest.size());
        out.addAll(preferred);
        out.addAll(rest);
        return out;
    }

    @Override
    public void cleanupOcrSession(String sessionId)
    {
        paperImportHelper.cleanupSession(sessionId);
    }

    private SpasQbQuestion basePickQuery(SpasQbSmartPickRequest request)
    {
        SpasQbQuestion q = new SpasQbQuestion();
        q.setSubjectId(request.getSubjectId());
        if (Boolean.TRUE.equals(request.getBoundOnly()))
        {
            q.setBoundOnly(Boolean.TRUE);
        }
        q.setChapterId(request.getChapterId());
        if (request.getKnowledgeIds() != null && !request.getKnowledgeIds().isEmpty())
        {
            q.setKnowledgeIds(request.getKnowledgeIds().toArray(new Long[0]));
        }
        return q;
    }
}
