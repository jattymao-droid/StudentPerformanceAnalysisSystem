package com.ruoyi.spas.support;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import java.math.BigDecimal;
import org.junit.jupiter.api.Test;

class SpasScoreCellParserTest
{
    @Test
    void blankAsZero()
    {
        SpasScoreCellParser.Result r = SpasScoreCellParser.parse("", true);
        assertNotNull(r);
        assertEquals(0, r.getScore().compareTo(BigDecimal.ZERO));
        assertEquals(SpasScoreCellParser.SRC_BLANK_ZERO, r.getScoreSource());
    }

    @Test
    void blankSkip()
    {
        assertNull(SpasScoreCellParser.parse("  ", false));
    }

    @Test
    void absentAndNotAttempted()
    {
        assertEquals(SpasScoreCellParser.SRC_ABSENT, SpasScoreCellParser.parse("\u7f3a\u8003", true).getScoreSource());
        assertEquals(SpasScoreCellParser.SRC_ABSENT, SpasScoreCellParser.parse("ABS", true).getScoreSource());
        assertEquals(SpasScoreCellParser.SRC_NOT_ATTEMPTED, SpasScoreCellParser.parse("\u672a\u505a", true).getScoreSource());
        assertEquals(SpasScoreCellParser.SRC_NOT_ATTEMPTED, SpasScoreCellParser.parse("NA", true).getScoreSource());
        assertFalse(SpasScoreCellParser.countsTowardMastery(SpasScoreCellParser.SRC_ABSENT));
        assertTrue(SpasScoreCellParser.countsTowardMastery(SpasScoreCellParser.SRC_IMPORT));
    }

    @Test
    void realZeroIsImport()
    {
        SpasScoreCellParser.Result r = SpasScoreCellParser.parse("0", true);
        assertEquals(SpasScoreCellParser.SRC_IMPORT, r.getScoreSource());
        assertEquals(0, r.getScore().compareTo(BigDecimal.ZERO));
    }

    @Test
    void badNumber()
    {
        assertThrows(IllegalArgumentException.class, () -> SpasScoreCellParser.parse("abc", true));
    }
}
