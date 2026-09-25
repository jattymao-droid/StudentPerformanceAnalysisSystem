package com.ruoyi.spas.support;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.fail;
import org.junit.jupiter.api.Test;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.spas.domain.SpasPaperQuestion;
import com.ruoyi.spas.domain.SpasQuestionKnowledge;

class PaperAnnotationInspectorTest
{
    @Test
    void rejectsMissingKnowledge()
    {
        SpasPaperQuestion question = question(1L, "1");
        try
        {
            PaperAnnotationInspector.assertReady(Collections.singletonList(question), Collections.emptyList());
            fail("expected missing knowledge");
        }
        catch (ServiceException ex)
        {
            assertTrue(ex.getMessage().contains("\u672a\u7ed1\u5b9a\u77e5\u8bc6\u70b9"));
        }
    }

    @Test
    void rejectsWeightSumNotOne()
    {
        SpasPaperQuestion question = question(1L, "2");
        SpasQuestionKnowledge link = link(1L, new BigDecimal("0.4"));
        try
        {
            PaperAnnotationInspector.assertReady(Collections.singletonList(question), Collections.singletonList(link));
            fail("expected weight sum");
        }
        catch (ServiceException ex)
        {
            assertTrue(ex.getMessage().contains("\u987b\u7b49\u4e8e 1"));
        }
    }

    @Test
    void acceptsWeightSumOne()
    {
        SpasPaperQuestion question = question(8L, "3");
        PaperAnnotationInspector.assertReady(Collections.singletonList(question), Arrays.asList(
            link(8L, new BigDecimal("0.6")),
            link(8L, new BigDecimal("0.4"))));
    }

    @Test
    void hardFailMissingQuestionType()
    {
        SpasPaperQuestion question = question(1L, "4");
        question.setQuestionType("");
        try
        {
            PaperAnnotationInspector.assertReady(
                Collections.singletonList(question),
                Collections.singletonList(link(1L, BigDecimal.ONE)),
                true,
                false);
            fail("expected missing question type");
        }
        catch (ServiceException ex)
        {
            assertTrue(ex.getMessage().contains("\u672a\u9009\u9898\u578b"));
        }
    }

    @Test
    void hardFailMissingBloom()
    {
        SpasPaperQuestion question = question(1L, "5");
        question.setQuestionType("choice");
        question.setBloomLevel(null);
        try
        {
            PaperAnnotationInspector.assertReady(
                Collections.singletonList(question),
                Collections.singletonList(link(1L, BigDecimal.ONE)),
                false,
                true);
            fail("expected missing bloom");
        }
        catch (ServiceException ex)
        {
            assertTrue(ex.getMessage().contains("\u8ba4\u77e5\u5c42\u7ea7"));
        }
    }

    @Test
    void metaWarningsDoNotThrow()
    {
        SpasPaperQuestion question = question(1L, "6");
        List<String> warnings = PaperAnnotationInspector.metaWarnings(Collections.singletonList(question));
        assertTrue(warnings.size() >= 1);
        PaperAnnotationInspector.assertReady(
            Collections.singletonList(question),
            Collections.singletonList(link(1L, BigDecimal.ONE)),
            false,
            false);
    }

    private static SpasPaperQuestion question(Long id, String no)
    {
        SpasPaperQuestion question = new SpasPaperQuestion();
        question.setQuestionId(id);
        question.setQuestionNo(no);
        return question;
    }

    private static SpasQuestionKnowledge link(Long questionId, BigDecimal weight)
    {
        SpasQuestionKnowledge link = new SpasQuestionKnowledge();
        link.setQuestionId(questionId);
        link.setKnowledgeId(1L);
        link.setWeight(weight);
        return link;
    }
}
