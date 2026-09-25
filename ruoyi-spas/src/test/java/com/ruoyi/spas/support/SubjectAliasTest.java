package com.ruoyi.spas.support;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.Test;

class SubjectAliasTest
{
    @Test
    void biologyAliasesMatch()
    {
        assertTrue(SubjectAlias.same("\u751f\u7269", "\u751f\u7269\u5b66"));
        assertFalse(SubjectAlias.same("\u6570\u5b66", "\u8bed\u6587"));
    }
}
