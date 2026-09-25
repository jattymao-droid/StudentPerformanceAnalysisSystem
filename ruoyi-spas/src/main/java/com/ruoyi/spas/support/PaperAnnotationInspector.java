package com.ruoyi.spas.support;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.spas.domain.SpasPaperQuestion;
import com.ruoyi.spas.domain.SpasQuestionKnowledge;

/**
 * Re-check persisted question annotations before publish or score import.
 */
public final class PaperAnnotationInspector
{
    private static final BigDecimal WEIGHT_ONE = BigDecimal.ONE;
    private static final BigDecimal WEIGHT_EPS = new BigDecimal("0.0001");
    private static final int MAX_MESSAGES = 8;

    private PaperAnnotationInspector()
    {
    }

    public static List<String> issues(List<SpasPaperQuestion> questions, List<SpasQuestionKnowledge> links)
    {
        List<String> issues = new ArrayList<String>();
        if (questions == null || questions.isEmpty())
        {
            issues.add("试卷尚未维护题目");
            return issues;
        }
        Map<Long, List<SpasQuestionKnowledge>> byQuestion = new HashMap<Long, List<SpasQuestionKnowledge>>();
        if (links != null)
        {
            for (SpasQuestionKnowledge link : links)
            {
                if (link == null || link.getQuestionId() == null)
                {
                    continue;
                }
                List<SpasQuestionKnowledge> bucket = byQuestion.get(link.getQuestionId());
                if (bucket == null)
                {
                    bucket = new ArrayList<SpasQuestionKnowledge>();
                    byQuestion.put(link.getQuestionId(), bucket);
                }
                bucket.add(link);
            }
        }
        for (SpasPaperQuestion question : questions)
        {
            if (question == null)
            {
                continue;
            }
            String no = question.getQuestionNo() == null ? "?" : question.getQuestionNo();
            List<SpasQuestionKnowledge> bound = question.getQuestionId() == null ? null : byQuestion.get(question.getQuestionId());
            if (bound == null || bound.isEmpty())
            {
                issues.add("题目 " + no + " 未绑定知识点");
                continue;
            }
            BigDecimal sum = BigDecimal.ZERO;
            boolean missingWeight = false;
            for (SpasQuestionKnowledge link : bound)
            {
                if (link.getWeight() == null)
                {
                    missingWeight = true;
                    break;
                }
                sum = sum.add(link.getWeight());
            }
            if (missingWeight)
            {
                issues.add("题目 " + no + " 存在空权重");
                continue;
            }
            if (sum.subtract(WEIGHT_ONE).abs().compareTo(WEIGHT_EPS) > 0)
            {
                issues.add("题目 " + no + " 知识点权重之和为 " + sum.stripTrailingZeros().toPlainString() + "，须等于 1");
            }
        }
        return issues;
    }

    /**
     * Soft warnings for question_type / bloom_level (do not block publish).
     */
    public static List<String> metaWarnings(List<SpasPaperQuestion> questions)
    {
        List<String> warnings = new ArrayList<String>();
        if (questions == null || questions.isEmpty())
        {
            return warnings;
        }
        int noType = 0;
        int noBloom = 0;
        for (SpasPaperQuestion question : questions)
        {
            if (question == null)
            {
                continue;
            }
            if (question.getQuestionType() == null || question.getQuestionType().trim().isEmpty())
            {
                noType++;
            }
            if (question.getBloomLevel() == null || question.getBloomLevel().trim().isEmpty())
            {
                noBloom++;
            }
        }
        if (noType > 0)
        {
            warnings.add(noType + " \u9053\u9898\u672a\u9009\u9898\u578b\uff08\u9898\u578b\u5206\u6790\u5c06\u8bb0\u4e3a\u672a\u6807\u6ce8\uff09");
        }
        if (noBloom > 0)
        {
            warnings.add(noBloom + " \u9053\u9898\u672a\u6807\u8ba4\u77e5\u5c42\u7ea7\uff08\u80fd\u529b\u5c42\u7ea7\u5206\u6790\u5c06\u8bb0\u4e3a\u672a\u6807\u6ce8\uff09");
        }
        return warnings;
    }

    public static void assertReady(List<SpasPaperQuestion> questions, List<SpasQuestionKnowledge> links)
    {
        assertReady(questions, links, false, false);
    }

    /**
     * @param requireQuestionType hard-fail when any question lacks question_type
     * @param requireBloomLevel hard-fail when any question lacks bloom_level
     */
    public static void assertReady(List<SpasPaperQuestion> questions, List<SpasQuestionKnowledge> links,
        boolean requireQuestionType, boolean requireBloomLevel)
    {
        List<String> issues = issues(questions, links);
        if (requireQuestionType || requireBloomLevel)
        {
            issues.addAll(metaHardIssues(questions, requireQuestionType, requireBloomLevel));
        }
        if (issues.isEmpty())
        {
            return;
        }
        StringBuilder sb = new StringBuilder("\u6807\u6ce8\u672a\u901a\u8fc7\uff0c\u65e0\u6cd5\u53d1\u5e03\u6216\u5bfc\u5165\u6210\u7ee9\uff1a");
        int shown = Math.min(MAX_MESSAGES, issues.size());
        for (int i = 0; i < shown; i++)
        {
            if (i > 0)
            {
                sb.append("\uff1b");
            }
            sb.append(issues.get(i));
        }
        if (issues.size() > shown)
        {
            sb.append("\uff1b\u7b49\u5171 ").append(issues.size()).append(" \u5904");
        }
        throw new ServiceException(sb.toString());
    }

    private static List<String> metaHardIssues(List<SpasPaperQuestion> questions, boolean requireType,
        boolean requireBloom)
    {
        List<String> issues = new ArrayList<String>();
        if (questions == null)
        {
            return issues;
        }
        for (SpasPaperQuestion question : questions)
        {
            if (question == null)
            {
                continue;
            }
            String no = question.getQuestionNo() == null ? "?" : question.getQuestionNo();
            if (requireType && (question.getQuestionType() == null || question.getQuestionType().trim().isEmpty()))
            {
                issues.add("\u9898\u76ee " + no + " \u672a\u9009\u9898\u578b");
            }
            if (requireBloom && (question.getBloomLevel() == null || question.getBloomLevel().trim().isEmpty()))
            {
                issues.add("\u9898\u76ee " + no + " \u672a\u6807\u8ba4\u77e5\u5c42\u7ea7");
            }
        }
        return issues;
    }
}
