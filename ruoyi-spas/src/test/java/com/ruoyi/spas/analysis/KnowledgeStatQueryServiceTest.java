package com.ruoyi.spas.analysis;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import com.ruoyi.spas.config.SpasAnalysisTuningProperties;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Relative-weak / formalWeak tagging (no Spring context).
 */
class KnowledgeStatQueryServiceTest
{
    private KnowledgeStatQueryService service;
    private KnowledgeStatCalculator calculator;

    @BeforeEach
    void setUp() throws Exception
    {
        calculator = new KnowledgeStatCalculator();
        set(calculator, "minAttempts", 3);
        set(calculator, "weakThreshold", 0.60);
        set(calculator, "watchThreshold", 0.75);
        set(calculator, "severeThreshold", 0.45);
        set(calculator, "severeMinAttempts", 3);

        service = new KnowledgeStatQueryService();
        set(service, "calculator", calculator);
        SpasAnalysisTuningProperties props = new SpasAnalysisTuningProperties();
        props.getRelativeWeak().setEnabled(true);
        props.getRelativeWeak().setDelta(0.10);
        set(service, "tuningProperties", props);
    }

    @Test
    void relativeWeakWhenGapBelowDelta()
    {
        Map<String, Object> row = new HashMap<String, Object>();
        service.annotateRelativeWeak(row, new BigDecimal("-0.11"));
        assertTrue(Boolean.TRUE.equals(row.get("relativeWeak")));
        assertEquals("低于班均", row.get("relativeWeakLabel"));

        Map<String, Object> ok = new HashMap<String, Object>();
        service.annotateRelativeWeak(ok, new BigDecimal("-0.09"));
        assertFalse(Boolean.TRUE.equals(ok.get("relativeWeak")));
    }

    @Test
    void formalWeakRequiresWeakLevel()
    {
        Map<String, Object> formal = new HashMap<String, Object>();
        formal.put("weakLevel", "2");
        formal.put("attemptCount", 5);
        service.annotateEvidence(formal);
        assertTrue(Boolean.TRUE.equals(formal.get("formalWeak")));
        assertTrue(Boolean.TRUE.equals(formal.get("evidenceOk")));

        Map<String, Object> thin = new HashMap<String, Object>();
        thin.put("weakLevel", "0");
        thin.put("attemptCount", 1);
        service.annotateEvidence(thin);
        assertFalse(Boolean.TRUE.equals(thin.get("formalWeak")));
        assertFalse(Boolean.TRUE.equals(thin.get("evidenceOk")));
        assertEquals("样本不足", thin.get("confidenceLabel"));
    }

    private static void set(Object target, String name, Object value) throws Exception
    {
        java.lang.reflect.Field f = target.getClass().getDeclaredField(name);
        f.setAccessible(true);
        if (value instanceof Double)
        {
            f.setDouble(target, ((Double) value).doubleValue());
        }
        else if (value instanceof Integer)
        {
            f.setInt(target, ((Integer) value).intValue());
        }
        else
        {
            f.set(target, value);
        }
    }
}
