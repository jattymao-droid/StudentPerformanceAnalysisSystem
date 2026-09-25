package com.ruoyi.spas.support;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.ruoyi.common.utils.StringUtils;

/**
 * Match exam Excel subject headers to spas_subject names.
 */
public final class SubjectAlias
{
    private static final Map<String, String> CANONICAL = new HashMap<String, String>();

    static
    {
        group("bio", "\u751f\u7269", "\u751f\u7269\u5b66");
        group("politics", "\u653f\u6cbb", "\u9053\u5fb7\u4e0e\u6cd5\u6cbb", "\u9053\u6cd5", "\u601d\u60f3\u653f\u6cbb");
        group("chinese", "\u8bed\u6587");
        group("math", "\u6570\u5b66");
        group("english", "\u82f1\u8bed");
        group("physics", "\u7269\u7406");
        group("chemistry", "\u5316\u5b66");
        group("history", "\u5386\u53f2");
        group("geography", "\u5730\u7406");
    }

    private SubjectAlias()
    {
    }

    public static boolean same(String left, String right)
    {
        String a = canonical(left);
        String b = canonical(right);
        return StringUtils.isNotEmpty(a) && a.equals(b);
    }

    public static String canonical(String raw)
    {
        if (StringUtils.isEmpty(raw))
        {
            return "";
        }
        String key = raw.trim().replace(" ", "");
        String mapped = CANONICAL.get(key);
        return mapped == null ? key : mapped;
    }

    private static void group(String canon, String... names)
    {
        List<String> list = Arrays.asList(names);
        for (String name : list)
        {
            CANONICAL.put(name, canon);
        }
    }
}
