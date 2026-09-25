package com.ruoyi.spas.analysis;

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
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

    @Test
    void primaryFullModeSecondaryIsExposureOnly() throws Exception
    {
        com.ruoyi.spas.config.SpasAnalysisTuningProperties props =
            new com.ruoyi.spas.config.SpasAnalysisTuningProperties();
        props.setAllocationMode("primary-full");
        set(calculator, "tuningProperties", props);

        List<SpasAnalysisScoreRow> rows = new ArrayList<SpasAnalysisScoreRow>();
        SpasAnalysisScoreRow primary = row(1L, 10L, 100L, "0.20", "0.70", "2", null);
        primary.setIsPrimary("1");
        SpasAnalysisScoreRow secondary = row(1L, 11L, 100L, "0.20", "0.30", "2", null);
        secondary.setIsPrimary("0");
        rows.add(primary);
        rows.add(secondary);

        Map<Long, KnowledgeStatCalculator.AggView> views = calculator.aggregateViews(rows);
        SpasStudentKnowledgeStat pStat = calculator.toStatView(views.get(10L));
        SpasStudentKnowledgeStat sStat = calculator.toStatView(views.get(11L));
        assertEquals(0, new BigDecimal("0.200000").compareTo(pStat.getWeightedRate()));
        assertEquals(Integer.valueOf(1), pStat.getAttemptCount());
        assertEquals(0, BigDecimal.ZERO.compareTo(sStat.getWeightedRate()));
        assertEquals("0", sStat.getWeakLevel());
        assertEquals(Integer.valueOf(1), sStat.getAttemptCount());
    }

    @Test
    void subjectOverrideRaisesWeakThreshold() throws Exception
    {
        com.ruoyi.spas.config.SpasAnalysisTuningProperties props =
            new com.ruoyi.spas.config.SpasAnalysisTuningProperties();
        com.ruoyi.spas.config.SpasAnalysisTuningProperties.ThresholdOverride o =
            new com.ruoyi.spas.config.SpasAnalysisTuningProperties.ThresholdOverride();
        o.setWatch(0.80);
        o.setWeak(0.65);
        o.setSevere(0.50);
        o.setMinAttempts(3);
        java.util.Map<String, com.ruoyi.spas.config.SpasAnalysisTuningProperties.ThresholdOverride> map =
            new java.util.LinkedHashMap<String, com.ruoyi.spas.config.SpasAnalysisTuningProperties.ThresholdOverride>();
        map.put("MATH", o);
        props.setSubjectOverrides(map);
        set(calculator, "tuningProperties", props);

        com.ruoyi.spas.mapper.SpasSubjectMapper mapper = stubSubjectMapper(2L, "MATH");
        set(calculator, "subjectMapper", mapper);

        // 0.62 默认落在「关注」(watch=0.75, weak=0.60)；MATH 覆盖 weak=0.65 后升为正式薄弱
        assertEquals("1", calculator.resolveWeakLevel(new BigDecimal("0.62"), 3, null));
        assertEquals("2", calculator.resolveWeakLevel(new BigDecimal("0.62"), 3, 2L));
        assertEquals(Integer.valueOf(3), Integer.valueOf(calculator.resolveMinAttempts(2L)));
        assertTrue(calculator.belowWeakRate(new BigDecimal("0.64"), 2L));
        assertTrue(!calculator.belowWeakRate(new BigDecimal("0.65"), 2L));
    }

    private static com.ruoyi.spas.mapper.SpasSubjectMapper stubSubjectMapper(final Long id, final String code)
    {
        final com.ruoyi.spas.domain.SpasSubject subject = new com.ruoyi.spas.domain.SpasSubject();
        subject.setSubjectId(id);
        subject.setSubjectCode(code);
        return new com.ruoyi.spas.mapper.SpasSubjectMapper()
        {
            @Override
            public java.util.List<com.ruoyi.spas.domain.SpasSubject> selectSpasSubjectList(
                com.ruoyi.spas.domain.SpasSubject q)
            {
                return java.util.Collections.emptyList();
            }

            @Override
            public com.ruoyi.spas.domain.SpasSubject selectSpasSubjectById(Long subjectId)
            {
                return id.equals(subjectId) ? subject : null;
            }

            @Override
            public java.util.List<com.ruoyi.spas.domain.SpasSubject> selectSpasSubjectAll()
            {
                return java.util.Collections.singletonList(subject);
            }

            @Override
            public com.ruoyi.spas.domain.SpasSubject checkSubjectCodeUnique(String subjectCode)
            {
                return null;
            }

            @Override
            public int insertSpasSubject(com.ruoyi.spas.domain.SpasSubject s)
            {
                return 0;
            }

            @Override
            public int updateSpasSubject(com.ruoyi.spas.domain.SpasSubject s)
            {
                return 0;
            }

            @Override
            public int deleteSpasSubjectById(Long subjectId)
            {
                return 0;
            }

            @Override
            public int deleteSpasSubjectByIds(Long[] subjectIds)
            {
                return 0;
            }
        };
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
