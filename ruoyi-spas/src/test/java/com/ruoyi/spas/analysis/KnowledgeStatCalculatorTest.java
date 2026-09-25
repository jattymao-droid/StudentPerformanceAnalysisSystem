package com.ruoyi.spas.analysis;

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import com.ruoyi.spas.domain.SpasAnalysisScoreRow;
import com.ruoyi.spas.domain.SpasStudentKnowledgeStat;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Core mastery formula / weak-level / confidence unit tests (no Spring context).
 */
class KnowledgeStatCalculatorTest
{
    private KnowledgeStatCalculator calculator;

    @BeforeEach
    void setUp() throws Exception
    {
        calculator = new KnowledgeStatCalculator();
        set(calculator, "difficultyEasy", 1.0);
        set(calculator, "difficultyMedium", 1.2);
        set(calculator, "difficultyHard", 1.5);
        set(calculator, "empiricalEnabled", false);
        set(calculator, "watchThreshold", 0.75);
        set(calculator, "weakThreshold", 0.60);
        set(calculator, "severeThreshold", 0.45);
        set(calculator, "minAttempts", 3);
        set(calculator, "severeMinAttempts", 3);
        set(calculator, "recencyHalfLifeDays", 0);
        set(calculator, "rateScale", 6);
    }

    @Test
    void weightedRateUsesKnowledgeWeight()
    {
        List<SpasAnalysisScoreRow> rows = new ArrayList<SpasAnalysisScoreRow>();
        rows.add(row(1L, 10L, 100L, "0.5", "1.0", "2", null));
        rows.add(row(1L, 10L, 101L, "1.0", "3.0", "2", null));
        SpasStudentKnowledgeStat stat = calculator.toStatView(calculator.aggregateViews(rows).get(10L));
        // (0.5*1 + 1.0*3) / (1+3) = 0.875
        assertEquals(0, new BigDecimal("0.875000").compareTo(stat.getWeightedRate()));
        assertEquals(Integer.valueOf(2), stat.getAttemptCount());
    }

    @Test
    void weakLevelRequiresMinAttempts()
    {
        assertEquals("0", calculator.resolveWeakLevel(new BigDecimal("0.30"), 2));
        assertEquals("3", calculator.resolveWeakLevel(new BigDecimal("0.30"), 3));
        assertEquals("2", calculator.resolveWeakLevel(new BigDecimal("0.50"), 3));
        assertEquals("1", calculator.resolveWeakLevel(new BigDecimal("0.70"), 3));
        assertEquals("0", calculator.resolveWeakLevel(new BigDecimal("0.80"), 3));
    }

    @Test
    void belowWeakRateUsesConfiguredThreshold()
    {
        assertTrue(calculator.belowWeakRate(new BigDecimal("0.59")));
        assertTrue(!calculator.belowWeakRate(new BigDecimal("0.60")));
    }

    @Test
    void confidenceIncreasesWithAttempts()
    {
        BigDecimal c0 = calculator.confidence(0);
        BigDecimal c3 = calculator.confidence(3);
        BigDecimal c6 = calculator.confidence(6);
        assertTrue(c3.compareTo(c0) > 0);
        assertTrue(c6.compareTo(c3) > 0);
        assertTrue(c6.compareTo(BigDecimal.ONE) < 0);
    }

    private static SpasAnalysisScoreRow row(Long studentId, Long knowledgeId, Long questionId, String rate,
        String weight, String difficulty, Date examDate)
    {
        SpasAnalysisScoreRow r = new SpasAnalysisScoreRow();
        r.setStudentId(studentId);
        r.setKnowledgeId(knowledgeId);
        r.setQuestionId(questionId);
        r.setSubjectId(2L);
        r.setRate(new BigDecimal(rate));
        r.setWeight(new BigDecimal(weight));
        r.setDifficulty(difficulty);
        r.setExamDate(examDate);
        r.setScoreSource("2");
        r.setKnowledgeName("kp-" + knowledgeId);
        return r;
    }

    private static void set(Object target, String name, Object value) throws Exception
    {
        Field f = KnowledgeStatCalculator.class.getDeclaredField(name);
        f.setAccessible(true);
        if (value instanceof Double)
        {
            f.setDouble(target, ((Double) value).doubleValue());
        }
        else if (value instanceof Integer)
        {
            f.setInt(target, ((Integer) value).intValue());
        }
        else if (value instanceof Boolean)
        {
            f.setBoolean(target, ((Boolean) value).booleanValue());
        }
        else
        {
            f.set(target, value);
        }
    }
}
