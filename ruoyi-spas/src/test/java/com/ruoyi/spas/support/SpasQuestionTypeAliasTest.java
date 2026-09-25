package com.ruoyi.spas.support;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import java.util.List;
import org.junit.jupiter.api.Test;

class SpasQuestionTypeAliasTest
{
    @Test
    void normalizesLegacyCodes()
    {
        assertEquals("single", SpasQuestionTypeAlias.normalize("choice"));
        assertEquals("fill", SpasQuestionTypeAlias.normalize("blank"));
        assertEquals("short", SpasQuestionTypeAlias.normalize("short"));
        assertEquals("calc", SpasQuestionTypeAlias.normalize("CALC"));
    }

    @Test
    void expandsChoiceFamily()
    {
        List<String> a = SpasQuestionTypeAlias.expand("choice");
        assertTrue(a.contains("single"));
        assertTrue(a.contains("choice"));
        assertTrue(a.contains("multi"));
        List<String> b = SpasQuestionTypeAlias.expand("blank");
        assertTrue(b.contains("fill"));
        assertTrue(b.contains("blank"));
    }

    @Test
    void optionsFieldFamily()
    {
        assertTrue(SpasQuestionTypeAlias.isChoiceFamily("single"));
        assertTrue(SpasQuestionTypeAlias.isChoiceFamily("multi"));
        assertTrue(SpasQuestionTypeAlias.isChoiceFamily("choice"));
        assertTrue(SpasQuestionTypeAlias.isChoiceFamily("judge"));
        assertFalse(SpasQuestionTypeAlias.isChoiceFamily("fill"));
        assertFalse(SpasQuestionTypeAlias.isChoiceFamily("calc"));
    }
}
