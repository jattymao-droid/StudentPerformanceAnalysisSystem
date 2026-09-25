package com.ruoyi.spas.qb.support;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.qb.domain.SpasQbQuestion;

/**
 * Parse exam provenance from stem headers like:
 * 1.(2025\u00b7Henan\u00b7Exam)
 */
public final class SpasQbSourceParseHelper
{
    private SpasQbSourceParseHelper()
    {
    }

    /** middle dot and fullwidth parentheses */
    private static final Pattern HEADER = Pattern.compile(
            "(?:^|[\\n\\r])\\s*(?:\\d{1,3}|[\\u4e00\\u4e8c\\u4e09\\u56db\\u4e94\\u516d\\u4e03\\u516b\\u4e5d\\u5341]{1,3})"
                    + "\\s*[\\.\\uff0e\\u3001\\)\\uff09]?\\s*[\\(\\uff08]\\s*(\\d{4})\\s*[\\u00b7\\.\\uff0e]\\s*([^\\u00b7\\.\\uff0e\\)\\uff09]+)"
                    + "\\s*[\\u00b7\\.\\uff0e]\\s*([^\\)\\uff09]+)[\\)\\uff09]");

    private static final Pattern LOOSE = Pattern.compile(
            "[\\(\\uff08]\\s*(\\d{4})\\s*[\\u00b7\\.\\uff0e]\\s*([^\\u00b7\\.\\uff0e\\)\\uff09]+)\\s*[\\u00b7\\.\\uff0e]\\s*([^\\)\\uff09]+)[\\)\\uff09]");

    public static void fillFromContent(SpasQbQuestion q)
    {
        if (q == null || StringUtils.isEmpty(q.getContent()))
        {
            return;
        }
        Map<String, Object> parsed = parse(q.getContent());
        if (parsed.isEmpty())
        {
            return;
        }
        if (q.getSourceYear() == null && parsed.get("year") != null)
        {
            q.setSourceYear((Integer) parsed.get("year"));
        }
        if (StringUtils.isEmpty(q.getSourceRegion()) && parsed.get("region") != null)
        {
            q.setSourceRegion(String.valueOf(parsed.get("region")));
        }
        if (StringUtils.isEmpty(q.getSourceExam()) && parsed.get("exam") != null)
        {
            q.setSourceExam(String.valueOf(parsed.get("exam")));
        }
    }

    public static Map<String, Object> parse(String content)
    {
        Map<String, Object> out = new HashMap<>();
        if (StringUtils.isEmpty(content))
        {
            return out;
        }
        String head = content.length() > 200 ? content.substring(0, 200) : content;
        Matcher m = HEADER.matcher("\n" + head);
        if (!m.find())
        {
            m = LOOSE.matcher(head);
            if (!m.find())
            {
                return out;
            }
        }
        try
        {
            out.put("year", Integer.parseInt(m.group(1)));
        }
        catch (Exception e)
        {
            /* ignore */
        }
        String region = m.group(2) == null ? "" : m.group(2).trim();
        String exam = m.group(3) == null ? "" : m.group(3).trim();
        if (region.length() > 64)
        {
            region = region.substring(0, 64);
        }
        if (exam.length() > 64)
        {
            exam = exam.substring(0, 64);
        }
        if (!region.isEmpty())
        {
            out.put("region", region);
        }
        if (!exam.isEmpty())
        {
            out.put("exam", exam);
        }
        return out;
    }
}
