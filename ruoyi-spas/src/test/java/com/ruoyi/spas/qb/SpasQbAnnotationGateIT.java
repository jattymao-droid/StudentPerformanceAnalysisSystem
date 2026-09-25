package com.ruoyi.spas.qb;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import org.junit.jupiter.api.Test;
import com.ruoyi.spas.domain.SpasPaperQuestion;
import com.ruoyi.spas.domain.SpasQuestionKnowledge;
import com.ruoyi.spas.support.PaperAnnotationInspector;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Skeleton for publish/score annotation gates (P0).
 * Extensible to SpringBootTest + MockMvc against /spas/qb/paper/{id}/annotation-check.
 */
class SpasQbAnnotationGateIT
{
    @Test
    void unboundFails()
    {
        SpasPaperQuestion q = new SpasPaperQuestion();
        q.setQuestionId(1L);
        q.setQuestionNo("1");
        q.setFullScore(new BigDecimal("5"));
        List<String> issues = PaperAnnotationInspector.issues(Collections.singletonList(q), Collections.emptyList());
        assertFalse(issues.isEmpty());
        assertTrue(issues.stream().anyMatch(m -> m != null && m.indexOf('\u7ed1') >= 0));
    }

    @Test
    void weightOnePasses()
    {
        SpasPaperQuestion q = new SpasPaperQuestion();
        q.setQuestionId(1L);
        q.setQuestionNo("1");
        q.setFullScore(new BigDecimal("5"));
        q.setQuestionType("choice");
        q.setBloomLevel("3");
        SpasQuestionKnowledge k = new SpasQuestionKnowledge();
        k.setQuestionId(1L);
        k.setKnowledgeId(10L);
        k.setWeight(BigDecimal.ONE);
        List<String> issues = PaperAnnotationInspector.issues(
            Collections.singletonList(q), Collections.singletonList(k));
        assertTrue(issues.isEmpty());
    }
}
