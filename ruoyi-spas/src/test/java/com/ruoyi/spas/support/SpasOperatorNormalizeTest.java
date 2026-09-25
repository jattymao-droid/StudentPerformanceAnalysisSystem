package com.ruoyi.spas.support;

import static org.junit.jupiter.api.Assertions.assertEquals;
import org.junit.jupiter.api.Test;

class SpasOperatorNormalizeTest
{
    @Test
    void aliasesAndEntities()
    {
        assertEquals("<", SpasOperatorNormalize.normalize("LT"));
        assertEquals("<=", SpasOperatorNormalize.normalize("LE"));
        assertEquals(">", SpasOperatorNormalize.normalize("GT"));
        assertEquals(">=", SpasOperatorNormalize.normalize("GE"));
        assertEquals("=", SpasOperatorNormalize.normalize("EQ"));
        assertEquals("<", SpasOperatorNormalize.normalize("&lt;"));
        assertEquals(">", SpasOperatorNormalize.normalize("&gt;"));
        assertEquals("<=", SpasOperatorNormalize.normalize("&lt;="));
    }
}
