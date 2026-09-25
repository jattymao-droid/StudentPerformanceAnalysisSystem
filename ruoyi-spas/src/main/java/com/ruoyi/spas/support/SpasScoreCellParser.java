package com.ruoyi.spas.support;

import java.math.BigDecimal;
import com.ruoyi.common.utils.StringUtils;

/**
 * Parse Excel score cell into numeric score + score_source.
 * Sources: 1=manual 2=import 3=blank-as-zero 4=absent 5=not-attempted
 */
public final class SpasScoreCellParser
{
    public static final String SRC_MANUAL = "1";
    public static final String SRC_IMPORT = "2";
    public static final String SRC_BLANK_ZERO = "3";
    public static final String SRC_ABSENT = "4";
    public static final String SRC_NOT_ATTEMPTED = "5";

    private SpasScoreCellParser()
    {
    }

    public static boolean countsTowardMastery(String scoreSource)
    {
        return !SRC_ABSENT.equals(scoreSource) && !SRC_NOT_ATTEMPTED.equals(scoreSource);
    }

    public static Result parse(String raw, boolean blankAsZero)
    {
        String text = raw == null ? "" : raw.trim();
        if (StringUtils.isEmpty(text))
        {
            if (!blankAsZero)
            {
                return null;
            }
            return new Result(BigDecimal.ZERO, SRC_BLANK_ZERO);
        }
        String norm = text.toUpperCase().replace(" ", "");
        String absentCn = "\u7f3a\u8003";
        String absentCn2 = "\u7f3a\u5e2d";
        String skipCn = "\u672a\u505a";
        String skipCn2 = "\u672a\u7b54";
        String dash = "\u2014";
        String dash2 = "\uff0d";
        if (absentCn.equals(text) || "ABS".equals(norm) || "ABSENT".equals(norm) || absentCn2.equals(text))
        {
            return new Result(BigDecimal.ZERO, SRC_ABSENT);
        }
        if (skipCn.equals(text) || skipCn2.equals(text) || "NA".equals(norm) || "N/A".equals(norm)
            || "-".equals(text) || dash.equals(text) || dash2.equals(text))
        {
            return new Result(BigDecimal.ZERO, SRC_NOT_ATTEMPTED);
        }
        try
        {
            return new Result(new BigDecimal(text), SRC_IMPORT);
        }
        catch (NumberFormatException ex)
        {
            throw new IllegalArgumentException("bad score: " + text);
        }
    }

    public static final class Result
    {
        private final BigDecimal score;
        private final String scoreSource;

        public Result(BigDecimal score, String scoreSource)
        {
            this.score = score;
            this.scoreSource = scoreSource;
        }

        public BigDecimal getScore()
        {
            return score;
        }

        public String getScoreSource()
        {
            return scoreSource;
        }
    }
}
