package com.ruoyi.spas.qb.support;

import java.util.regex.Matcher;
import java.util.regex.Pattern;
import com.ruoyi.common.utils.StringUtils;

/**
 * Local heuristic polish for OCR / plain stems: wrap math, fix common OCR typos.
 */
public final class SpasQbFormulaPolishHelper
{
    private static final Pattern DOLLAR_SPAN = Pattern.compile("\\$\\$[\\s\\S]+?\\$\\$|\\$[^$\\n]+\\$");

    private SpasQbFormulaPolishHelper()
    {
    }

    public static String polishLocal(String raw)
    {
        if (StringUtils.isEmpty(raw))
        {
            return "";
        }
        String s = raw.replace("\r\n", "\n").replace('\r', '\n');
        s = mapOutsideDollar(s, SpasQbFormulaPolishHelper::mapUnicodePlain);
        s = mapOutsideDollar(s, SpasQbFormulaPolishHelper::fixOcrLetterDigitScripts);
        s = mapOutsideDollar(s, SpasQbFormulaPolishHelper::wrapFractionsAndSimple);
        return s.replaceAll("\n{3,}", "\n\n").trim();
    }

    public static boolean looksMathy(String raw)
    {
        if (StringUtils.isEmpty(raw))
        {
            return false;
        }
        String s = raw;
        if (s.indexOf('$') >= 0 || s.indexOf('\\') >= 0)
        {
            return true;
        }
        for (int i = 0; i < s.length(); i++)
        {
            char c = s.charAt(i);
            if (c == '\u00b1' || c == '\u00d7' || c == '\u00f7' || c == '\u2260' || c == '\u2264' || c == '\u2265'
                || c == '\u221a' || c == '\u2211' || c == '\u222b' || (c >= '\u03b1' && c <= '\u03c9'))
            {
                return true;
            }
        }
        return s.matches("(?s).*[A-Za-z]\\s*[=/^_]\\s*[A-Za-z0-9].*")
            || s.matches("(?s).*\\([^)]{1,40}\\)\\s*/\\s*\\([^)]{1,40}\\).*");
    }

    private interface Mapper
    {
        String apply(String in);
    }

    private static String mapOutsideDollar(String s, Mapper fn)
    {
        Matcher m = DOLLAR_SPAN.matcher(s);
        StringBuilder sb = new StringBuilder();
        int last = 0;
        boolean any = false;
        while (m.find())
        {
            any = true;
            sb.append(fn.apply(s.substring(last, m.start())));
            sb.append(m.group());
            last = m.end();
        }
        if (!any)
        {
            return fn.apply(s);
        }
        sb.append(fn.apply(s.substring(last)));
        return sb.toString();
    }

    private static String mapUnicodePlain(String s)
    {
        String t = s
            .replace("\u00b1", "$\\pm$")
            .replace("\u00d7", "$\\times$")
            .replace("\u00f7", "$\\div$")
            .replace("\u2260", "$\\neq$")
            .replace("\u2264", "$\\leq$")
            .replace("\u2265", "$\\geq$")
            .replace("\u221e", "$\\infty$")
            .replace("\u2211", "$\\sum$")
            .replace("\u222b", "$\\int$")
            .replace("\u03b1", "$\\alpha$")
            .replace("\u03b2", "$\\beta$")
            .replace("\u03b8", "$\\theta$")
            .replace("\u03c0", "$\\pi$")
            .replace("\u00b0", "$^{\\circ}$");
        t = t.replaceAll("\u221a\\s*\\(([^)]{1,40})\\)", "\\$\\\\sqrt{$1}\\$");
        t = t.replaceAll("\u221a([A-Za-z0-9]+)", "\\$\\\\sqrt{$1}\\$");
        return t;
    }

    private static String fixOcrLetterDigitScripts(String s)
    {
        // Only single physics-like letters: x2->x^2, v0->v_0 (avoid multi-letter words)
        s = s.replaceAll("(?<=(?<![A-Za-z])[A-Za-z])([2-3])(?=[\\u4e00-\\u9fff\\s,\\uFF0C\\u3002\\uFF1B;\\uFF09)\\]=])", "^$1");
        s = s.replaceAll("(?<=(?<![A-Za-z])[vvFaAmMsSuU])([01])(?=[\\u4e00-\\u9fff\\s,\\uFF0C\\u3002\\uFF1B;\\uFF09)\\]=])", "_$1");
        return s;
    }

    private static String wrapFractionsAndSimple(String s)
    {
        s = s.replaceAll(
            "\\(([A-Za-z0-9+\\-*/^_\\\\.\\s]{1,40})\\)\\s*/\\s*\\(([A-Za-z0-9+\\-*/^_\\\\.\\s]{1,40})\\)",
            "\\$\\\\frac{$1}{$2}\\$");
        s = s.replaceAll(
            "([\\u4e00-\\u9fff\\s(\\uFF08\\[\\u3010,\\uFF0C:\\uFF1A;\\uFF1B]|^)([A-Za-z][A-Za-z0-9]*)/([A-Za-z][A-Za-z0-9]*)(?=[\\u4e00-\\u9fff\\s)\\uFF09\\]\\u3011,\\uFF0C\\u3002.\\uFF1B;!]|$)",
            "$1\\$\\\\frac{$2}{$3}\\$");
        s = s.replaceAll(
            "([\\u4e00-\\u9fff\\s(\\uFF08\\[\\u3010,\\uFF0C:\\uFF1A;\\uFF1B])(([A-Za-z](?:_[0-9A-Za-z]+|\\^[0-9A-Za-z]+){1,3})|([A-Za-z]\\s*=\\s*[A-Za-z0-9+\\-*/^_]{1,24}))(?=[\\u4e00-\\u9fff\\s)\\uFF09\\]\\u3011,\\uFF0C\\u3002.\\uFF1B;!]|$)",
            "$1\\$$2\\$");
        s = s.replaceAll(
            "(^|\\n)(([A-Za-z](?:_[0-9A-Za-z]+|\\^[0-9A-Za-z]+){1,3})|([A-Za-z]\\s*=\\s*[A-Za-z0-9+\\-*/^_]{1,24}))(?=[\\u4e00-\\u9fff\\s)\\uFF09\\]\\u3011,\\uFF0C\\u3002.\\uFF1B;]|$)",
            "$1\\$$2\\$");
        // Compact spaces: protect LaTeX commands (\\frac / \\text); only strip simple math
        Matcher m = Pattern.compile("\\$([^$\\n]+)\\$").matcher(s);
        StringBuffer sb = new StringBuffer();
        while (m.find())
        {
            String inner = m.group(1);
            if (inner.indexOf('\\') < 0)
            {
                inner = inner.replace(" ", "");
            }
            else
            {
                inner = inner.replaceAll("\\s*([=+\\-*/^_])\\s*", "$1");
            }
            m.appendReplacement(sb, Matcher.quoteReplacement("$" + inner + "$"));
        }
        m.appendTail(sb);
        return sb.toString();
    }
}
