package com.ruoyi.spas.qb.support;

import java.util.regex.Matcher;
import java.util.regex.Pattern;
import com.ruoyi.common.utils.StringUtils;

/**
 * Best-effort Office Math (OMML) to LaTeX for KaTeX preview.
 * Supports: frac / sub / sup / rad / delimiter / n-ary / limit / bar / matrix.
 */
public final class SpasQbOmmlLatexConverter
{
    private static final Pattern OMATH = Pattern.compile(
        "<(?:\\w+:)?oMath(?:Para)?\\b[^>]*>([\\s\\S]*?)</(?:\\w+:)?oMath(?:Para)?>",
        Pattern.CASE_INSENSITIVE);

    private static final Pattern FRAC = Pattern.compile(
        "<(?:\\w+:)?f\\b[\\s\\S]*?</(?:\\w+:)?f>", Pattern.CASE_INSENSITIVE);
    private static final Pattern SSUP = Pattern.compile(
        "<(?:\\w+:)?sSup\\b[\\s\\S]*?</(?:\\w+:)?sSup>", Pattern.CASE_INSENSITIVE);
    private static final Pattern SSUB = Pattern.compile(
        "<(?:\\w+:)?sSub\\b[\\s\\S]*?</(?:\\w+:)?sSub>", Pattern.CASE_INSENSITIVE);
    private static final Pattern SSUBSUP = Pattern.compile(
        "<(?:\\w+:)?sSubSup\\b[\\s\\S]*?</(?:\\w+:)?sSubSup>", Pattern.CASE_INSENSITIVE);
    private static final Pattern RAD = Pattern.compile(
        "<(?:\\w+:)?rad\\b[\\s\\S]*?</(?:\\w+:)?rad>", Pattern.CASE_INSENSITIVE);
    private static final Pattern DELIM = Pattern.compile(
        "<(?:\\w+:)?d\\b[\\s\\S]*?</(?:\\w+:)?d>", Pattern.CASE_INSENSITIVE);
    private static final Pattern NARY = Pattern.compile(
        "<(?:\\w+:)?nary\\b[\\s\\S]*?</(?:\\w+:)?nary>", Pattern.CASE_INSENSITIVE);
    private static final Pattern LIM_LOW = Pattern.compile(
        "<(?:\\w+:)?limLow\\b[\\s\\S]*?</(?:\\w+:)?limLow>", Pattern.CASE_INSENSITIVE);
    private static final Pattern LIM_UPP = Pattern.compile(
        "<(?:\\w+:)?limUpp\\b[\\s\\S]*?</(?:\\w+:)?limUpp>", Pattern.CASE_INSENSITIVE);
    private static final Pattern BAR = Pattern.compile(
        "<(?:\\w+:)?bar\\b[\\s\\S]*?</(?:\\w+:)?bar>", Pattern.CASE_INSENSITIVE);
    private static final Pattern ACC = Pattern.compile(
        "<(?:\\w+:)?acc\\b[\\s\\S]*?</(?:\\w+:)?acc>", Pattern.CASE_INSENSITIVE);
    private static final Pattern MATRIX = Pattern.compile(
        "<(?:\\w+:)?m\\b[\\s\\S]*?</(?:\\w+:)?m>", Pattern.CASE_INSENSITIVE);
    private static final Pattern MR = Pattern.compile(
        "<(?:\\w+:)?mr\\b[\\s\\S]*?</(?:\\w+:)?mr>", Pattern.CASE_INSENSITIVE);
    private static final Pattern ME = Pattern.compile(
        "<(?:\\w+:)?e\\b[^>]*>([\\s\\S]*?)</(?:\\w+:)?e>", Pattern.CASE_INSENSITIVE);

    private static final Pattern MATH_MARK = Pattern.compile("<MATH>([\\s\\S]*?)</MATH>");
    private static final Pattern T_NODE = Pattern.compile(
        "<(?:\\w+:)?t\\b[^>]*>([\\s\\S]*?)</(?:\\w+:)?t>", Pattern.CASE_INSENSITIVE);
    private static final Pattern CHR_ATTR = Pattern.compile(
        "<(?:\\w+:)?chr\\b[^>]*\\s(?:\\w+:)?val=\"([^\"]+)\"", Pattern.CASE_INSENSITIVE);
    private static final Pattern BEG_CHR = Pattern.compile(
        "<(?:\\w+:)?begChr\\b[^>]*\\s(?:\\w+:)?val=\"([^\"]*)\"", Pattern.CASE_INSENSITIVE);
    private static final Pattern END_CHR = Pattern.compile(
        "<(?:\\w+:)?endChr\\b[^>]*\\s(?:\\w+:)?val=\"([^\"]*)\"", Pattern.CASE_INSENSITIVE);

    private SpasQbOmmlLatexConverter()
    {
    }

    public static String convert(String xml)
    {
        if (StringUtils.isEmpty(xml))
        {
            return "";
        }
        Matcher om = OMATH.matcher(xml);
        StringBuilder out = new StringBuilder();
        boolean found = false;
        while (om.find())
        {
            found = true;
            String piece = convertFragment(om.group(1));
            if (StringUtils.isEmpty(piece))
            {
                continue;
            }
            if (out.length() > 0)
            {
                out.append(' ');
            }
            out.append(piece);
        }
        if (!found)
        {
            return convertFragment(xml);
        }
        return out.toString().trim();
    }

    private static String convertFragment(String xml)
    {
        String work = xml;
        for (int i = 0; i < 32; i++)
        {
            String next = replaceOnce(work);
            if (next.equals(work))
            {
                break;
            }
            work = next;
        }
        return flatten(work).replaceAll("\\s+", " ").trim();
    }

    private static String replaceOnce(String xml)
    {
        String s = replaceFrac(xml);
        s = replaceMatrix(s);
        s = replaceNary(s);
        s = replaceDelim(s);
        s = replaceLim(s, LIM_LOW, true);
        s = replaceLim(s, LIM_UPP, false);
        s = replaceBarOrAcc(s, BAR, "\\overline");
        s = replaceBarOrAcc(s, ACC, "\\hat");
        s = replaceScript(s, SSUBSUP, true, true);
        s = replaceScript(s, SSUP, true, false);
        s = replaceScript(s, SSUB, false, true);
        s = replaceRad(s);
        return s;
    }

    private static String replaceFrac(String xml)
    {
        Matcher fm = FRAC.matcher(xml);
        StringBuffer sb = new StringBuffer();
        boolean any = false;
        while (fm.find())
        {
            any = true;
            String block = fm.group();
            String num = flatten(extractTaggedInner(block, "num"));
            String den = flatten(extractTaggedInner(block, "den"));
            String latex = "\\frac{" + escapeGroup(num) + "}{" + escapeGroup(den) + "}";
            fm.appendReplacement(sb, Matcher.quoteReplacement("<MATH>" + latex + "</MATH>"));
        }
        if (!any)
        {
            return xml;
        }
        fm.appendTail(sb);
        return sb.toString();
    }

    private static String replaceScript(String xml, Pattern blockPat, boolean hasSup, boolean hasSub)
    {
        Matcher sm = blockPat.matcher(xml);
        StringBuffer sb = new StringBuffer();
        boolean any = false;
        while (sm.find())
        {
            any = true;
            String block = sm.group();
            String base = flatten(extractTaggedInner(block, "e"));
            StringBuilder latex = new StringBuilder(escapeGroup(base));
            if (hasSub)
            {
                latex.append("_{").append(escapeGroup(flatten(extractTaggedInner(block, "sub")))).append('}');
            }
            if (hasSup)
            {
                latex.append("^{").append(escapeGroup(flatten(extractTaggedInner(block, "sup")))).append('}');
            }
            sm.appendReplacement(sb, Matcher.quoteReplacement("<MATH>" + latex + "</MATH>"));
        }
        if (!any)
        {
            return xml;
        }
        sm.appendTail(sb);
        return sb.toString();
    }

    private static String replaceRad(String xml)
    {
        Matcher rm = RAD.matcher(xml);
        StringBuffer sb = new StringBuffer();
        boolean any = false;
        while (rm.find())
        {
            any = true;
            String block = rm.group();
            String deg = flatten(extractTaggedInner(block, "deg"));
            String e = flatten(extractTaggedInner(block, "e"));
            String latex = StringUtils.isNotEmpty(deg)
                ? ("\\sqrt[" + escapeGroup(deg) + "]{" + escapeGroup(e) + "}")
                : ("\\sqrt{" + escapeGroup(e) + "}");
            rm.appendReplacement(sb, Matcher.quoteReplacement("<MATH>" + latex + "</MATH>"));
        }
        if (!any)
        {
            return xml;
        }
        rm.appendTail(sb);
        return sb.toString();
    }

    private static String replaceDelim(String xml)
    {
        Matcher dm = DELIM.matcher(xml);
        StringBuffer sb = new StringBuffer();
        boolean any = false;
        while (dm.find())
        {
            any = true;
            String block = dm.group();
            String beg = attrVal(BEG_CHR, block, "(");
            String end = attrVal(END_CHR, block, ")");
            String e = flatten(extractTaggedInner(block, "e"));
            String latex = "\\left" + delimTex(beg) + escapeGroup(e) + "\\right" + delimTex(end);
            dm.appendReplacement(sb, Matcher.quoteReplacement("<MATH>" + latex + "</MATH>"));
        }
        if (!any)
        {
            return xml;
        }
        dm.appendTail(sb);
        return sb.toString();
    }

    private static String replaceNary(String xml)
    {
        Matcher nm = NARY.matcher(xml);
        StringBuffer sb = new StringBuffer();
        boolean any = false;
        while (nm.find())
        {
            any = true;
            String block = nm.group();
            String chr = attrVal(CHR_ATTR, block, "\\sum");
            String sub = flatten(extractTaggedInner(block, "sub"));
            String sup = flatten(extractTaggedInner(block, "sup"));
            String e = flatten(extractTaggedInner(block, "e"));
            String op = naryOp(chr);
            StringBuilder latex = new StringBuilder(op);
            if (StringUtils.isNotEmpty(sub))
            {
                latex.append("_{").append(escapeGroup(sub)).append('}');
            }
            if (StringUtils.isNotEmpty(sup))
            {
                latex.append("^{").append(escapeGroup(sup)).append('}');
            }
            latex.append(' ').append(escapeGroup(e));
            nm.appendReplacement(sb, Matcher.quoteReplacement("<MATH>" + latex + "</MATH>"));
        }
        if (!any)
        {
            return xml;
        }
        nm.appendTail(sb);
        return sb.toString();
    }

    private static String replaceLim(String xml, Pattern pat, boolean low)
    {
        Matcher lm = pat.matcher(xml);
        StringBuffer sb = new StringBuffer();
        boolean any = false;
        while (lm.find())
        {
            any = true;
            String block = lm.group();
            String e = flatten(extractTaggedInner(block, "e"));
            String lim = flatten(extractTaggedInner(block, "lim"));
            String latex = escapeGroup(e) + (low ? "_{" : "^{") + escapeGroup(lim) + "}";
            lm.appendReplacement(sb, Matcher.quoteReplacement("<MATH>" + latex + "</MATH>"));
        }
        if (!any)
        {
            return xml;
        }
        lm.appendTail(sb);
        return sb.toString();
    }

    private static String replaceBarOrAcc(String xml, Pattern pat, String cmd)
    {
        Matcher bm = pat.matcher(xml);
        StringBuffer sb = new StringBuffer();
        boolean any = false;
        while (bm.find())
        {
            any = true;
            String block = bm.group();
            String e = flatten(extractTaggedInner(block, "e"));
            String latex = cmd + "{" + escapeGroup(e) + "}";
            bm.appendReplacement(sb, Matcher.quoteReplacement("<MATH>" + latex + "</MATH>"));
        }
        if (!any)
        {
            return xml;
        }
        bm.appendTail(sb);
        return sb.toString();
    }

    private static String replaceMatrix(String xml)
    {
        Matcher mm = MATRIX.matcher(xml);
        StringBuffer sb = new StringBuffer();
        boolean any = false;
        while (mm.find())
        {
            any = true;
            String block = mm.group();
            StringBuilder rows = new StringBuilder();
            Matcher rm = MR.matcher(block);
            boolean firstRow = true;
            while (rm.find())
            {
                if (!firstRow)
                {
                    rows.append(" \\\\ ");
                }
                firstRow = false;
                String rowXml = rm.group();
                Matcher em = ME.matcher(rowXml);
                boolean firstCell = true;
                while (em.find())
                {
                    if (!firstCell)
                    {
                        rows.append(" & ");
                    }
                    firstCell = false;
                    rows.append(escapeGroup(flatten(em.group(1))));
                }
            }
            String latex = "\\begin{matrix}" + rows + "\\end{matrix}";
            mm.appendReplacement(sb, Matcher.quoteReplacement("<MATH>" + latex + "</MATH>"));
        }
        if (!any)
        {
            return xml;
        }
        mm.appendTail(sb);
        return sb.toString();
    }

    private static String attrVal(Pattern p, String block, String def)
    {
        Matcher m = p.matcher(block);
        return m.find() ? m.group(1) : def;
    }

    private static String delimTex(String chr)
    {
        if (chr == null || chr.isEmpty())
        {
            return ".";
        }
        if ("(".equals(chr) || ")".equals(chr) || "[".equals(chr) || "]".equals(chr) || "|".equals(chr))
        {
            return chr;
        }
        if ("{".equals(chr))
        {
            return "\\{";
        }
        if ("}".equals(chr))
        {
            return "\\}";
        }
        if ("\u2225".equals(chr) || "||".equals(chr))
        {
            return "\\|";
        }
        if ("\u27e8".equals(chr) || "\u2329".equals(chr) || "<".equals(chr))
        {
            return "\\langle ";
        }
        if ("\u27e9".equals(chr) || "\u232a".equals(chr) || ">".equals(chr))
        {
            return "\\rangle ";
        }
        return chr;
    }

    private static String naryOp(String chr)
    {
        if (chr == null)
        {
            return "\\sum ";
        }
        if ("\u2211".equals(chr) || "sum".equalsIgnoreCase(chr) || "\\sum".equals(chr))
        {
            return "\\sum ";
        }
        if ("\u222b".equals(chr) || "int".equalsIgnoreCase(chr) || "\\int".equals(chr))
        {
            return "\\int ";
        }
        if ("\u220f".equals(chr) || "prod".equalsIgnoreCase(chr) || "\\prod".equals(chr))
        {
            return "\\prod ";
        }
        if ("\u22c5".equals(chr))
        {
            return "\\cdot ";
        }
        if (chr.startsWith("\\"))
        {
            return chr.endsWith(" ") ? chr : (chr + " ");
        }
        return chr + " ";
    }

    private static String extractTaggedInner(String block, String tag)
    {
        Pattern p = Pattern.compile(
            "<(?:\\w+:)?" + tag + "\\b[^>]*>([\\s\\S]*?)</(?:\\w+:)?" + tag + ">",
            Pattern.CASE_INSENSITIVE);
        Matcher m = p.matcher(block);
        return m.find() ? m.group(1) : "";
    }

    private static String flatten(String xml)
    {
        if (StringUtils.isEmpty(xml))
        {
            return "";
        }
        if (xml.contains("<MATH>"))
        {
            Matcher mm = MATH_MARK.matcher(xml);
            StringBuilder sb = new StringBuilder();
            int last = 0;
            while (mm.find())
            {
                sb.append(plainText(xml.substring(last, mm.start())));
                sb.append(mm.group(1));
                last = mm.end();
            }
            sb.append(plainText(xml.substring(last)));
            return sb.toString();
        }
        return plainText(xml);
    }

    private static String plainText(String xml)
    {
        Matcher tm = T_NODE.matcher(xml);
        StringBuilder sb = new StringBuilder();
        while (tm.find())
        {
            sb.append(decodeXml(tm.group(1)));
        }
        if (sb.length() == 0)
        {
            return decodeXml(xml.replaceAll("<[^>]+>", "")).trim();
        }
        return mapSymbols(sb.toString());
    }

    private static String decodeXml(String s)
    {
        if (s == null)
        {
            return "";
        }
        return s.replace("&lt;", "<").replace("&gt;", ">").replace("&amp;", "&")
            .replace("&quot;", "\"").replace("&apos;", "'");
    }

    private static String mapSymbols(String s)
    {
        if (s == null)
        {
            return "";
        }
        return s
            .replace("\u00b1", "\\pm ")
            .replace("\u00d7", "\\times ")
            .replace("\u00f7", "\\div ")
            .replace("\u2260", "\\neq ")
            .replace("\u2264", "\\leq ")
            .replace("\u2265", "\\geq ")
            .replace("\u221e", "\\infty ")
            .replace("\u2211", "\\sum ")
            .replace("\u222b", "\\int ")
            .replace("\u220f", "\\prod ")
            .replace("\u03b1", "\\alpha ")
            .replace("\u03b2", "\\beta ")
            .replace("\u03b3", "\\gamma ")
            .replace("\u03b8", "\\theta ")
            .replace("\u03c0", "\\pi ")
            .replace("\u0394", "\\Delta ")
            .replace("\u03a3", "\\Sigma ")
            .replace("\u03a9", "\\Omega ")
            .replaceAll("\u221a\\s*\\(([^)]{1,40})\\)", "\\sqrt{$1}")
            .replaceAll("\u221a([A-Za-z0-9]+)", "\\sqrt{$1}")
            .replace("\u00b0", "^\\circ ")
            .replace("\u2192", "\\rightarrow ")
            .replace("\u21d2", "\\Rightarrow ")
            .replace("\u22c5", "\\cdot ")
            .replace("\u2026", "\\ldots ");
    }

    private static String escapeGroup(String s)
    {
        if (s == null)
        {
            return "";
        }
        String t = s.trim();
        if (t.indexOf('\\') >= 0)
        {
            return t;
        }
        return t.replace("{", "\\{").replace("}", "\\}");
    }
}
