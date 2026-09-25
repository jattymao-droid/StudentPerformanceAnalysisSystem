package com.ruoyi.spas.analysis;

import java.util.Map;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

class ExamRankCrossDiagnosisTest
{
    @Test
    void dualDownWhenRankAndMasteryBothWeak()
    {
        Map<String, String> d = ExamRankCrossDiagnosis.diagnose("down", 0.40, 0.60, 0.75);
        assertEquals("dualDown", d.get("crossCode"));
    }

    @Test
    void rankUpWeakMastery()
    {
        Map<String, String> d = ExamRankCrossDiagnosis.diagnose("up", 0.50, 0.60, 0.75);
        assertEquals("rankUp+weakMastery", d.get("crossCode"));
    }

    @Test
    void dualUpWhenBothImprove()
    {
        Map<String, String> d = ExamRankCrossDiagnosis.diagnose("up", 0.80, 0.60, 0.75);
        assertEquals("dualUp", d.get("crossCode"));
    }

    @Test
    void neutralWhenMasteryMissing()
    {
        Map<String, String> d = ExamRankCrossDiagnosis.diagnose("down", null, 0.60, 0.75);
        assertEquals("neutral", d.get("crossCode"));
        assertEquals("-", d.get("crossLabel"));
    }
}
