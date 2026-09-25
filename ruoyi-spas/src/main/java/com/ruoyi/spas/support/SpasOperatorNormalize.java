package com.ruoyi.spas.support;

import com.ruoyi.common.utils.StringUtils;

/**
 * Normalize compare operators after XSS entity escaping / FE aliases.
 */
public final class SpasOperatorNormalize
{
    private SpasOperatorNormalize()
    {
    }

    public static String normalize(String operator)
    {
        if (StringUtils.isEmpty(operator))
        {
            return operator;
        }
        String op = operator.trim();
        op = op.replace("&lt;", "<")
            .replace("&gt;", ">")
            .replace("&#60;", "<")
            .replace("&#62;", ">")
            .replace("&amp;", "&");
        if ("LT".equalsIgnoreCase(op))
        {
            return "<";
        }
        if ("LE".equalsIgnoreCase(op) || "LTE".equalsIgnoreCase(op))
        {
            return "<=";
        }
        if ("GT".equalsIgnoreCase(op))
        {
            return ">";
        }
        if ("GE".equalsIgnoreCase(op) || "GTE".equalsIgnoreCase(op))
        {
            return ">=";
        }
        if ("EQ".equalsIgnoreCase(op))
        {
            return "=";
        }
        return op;
    }
}
