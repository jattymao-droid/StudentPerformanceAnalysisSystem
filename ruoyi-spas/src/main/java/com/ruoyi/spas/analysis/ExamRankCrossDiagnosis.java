package com.ruoyi.spas.analysis;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * School-rank trend × bound mastery cross codes (pure logic for unit tests).
 * Codes: dualDown | dualUp | rankUp+weakMastery | rankDown+solidMastery | neutral
 */
public final class ExamRankCrossDiagnosis
{
    private ExamRankCrossDiagnosis()
    {
    }

    /**
     * @param trend insufficient|up|down|flat|null
     * @param masteryRate null when no bound mastery
     * @param weakLine mastery &lt; weakLine → weak
     * @param solidLine mastery &gt;= solidLine → solid (usually watch threshold)
     */
    public static Map<String, String> diagnose(String trend, Double masteryRate, double weakLine, double solidLine)
    {
        Map<String, String> out = new LinkedHashMap<String, String>();
        if (masteryRate == null || trend == null || "insufficient".equals(trend) || "null".equals(trend))
        {
            out.put("crossCode", "neutral");
            out.put("crossLabel", "-");
            return out;
        }
        double mastery = masteryRate.doubleValue();
        boolean weakMastery = mastery < weakLine;
        boolean solidMastery = mastery >= solidLine;
        String code = "neutral";
        String label = "\u53e3\u5f84\u4e00\u81f4";
        if ("down".equals(trend) && weakMastery)
        {
            code = "dualDown";
            label = "\u6821\u6b21\u4e0e\u638c\u63e1\u53cc\u964d";
        }
        else if ("up".equals(trend) && weakMastery)
        {
            code = "rankUp+weakMastery";
            label = "\u6821\u6b21\u8fdb\u6b65\u4f46\u638c\u63e1\u4ecd\u5f31";
        }
        else if ("down".equals(trend) && solidMastery)
        {
            code = "rankDown+solidMastery";
            label = "\u6821\u6b21\u4e0b\u6ed1\u4f46\u5c0f\u9898\u638c\u63e1\u7a33";
        }
        else if ("up".equals(trend) && solidMastery)
        {
            code = "dualUp";
            label = "\u6821\u6b21\u4e0e\u638c\u63e1\u53cc\u5347";
        }
        out.put("crossCode", code);
        out.put("crossLabel", label);
        return out;
    }
}
