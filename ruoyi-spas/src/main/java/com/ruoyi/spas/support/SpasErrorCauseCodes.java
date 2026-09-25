package com.ruoyi.spas.support;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

/**
 * D2 error-cause subcodes and category mapping.
 */
public final class SpasErrorCauseCodes
{
    public static final String CAT_KNOWLEDGE = "knowledge";
    public static final String CAT_SKILL = "skill";
    public static final String CAT_STRATEGY = "strategy";
    public static final String CAT_PSYCHOLOGY = "psychology";
    public static final String CAT_SKIP = "skip";

    private static final Map<String, String> CODE_CATEGORY;
    private static final Map<String, String> CATEGORY_LABEL;

    static
    {
        Map<String, String> m = new LinkedHashMap<String, String>();
        m.put("concept_unclear", CAT_KNOWLEDGE);
        m.put("formula_wrong", CAT_KNOWLEDGE);
        m.put("calc_slip", CAT_SKILL);
        m.put("reading_miss", CAT_SKILL);
        m.put("unit_convert", CAT_SKILL);
        m.put("time_alloc", CAT_STRATEGY);
        m.put("hard_first", CAT_STRATEGY);
        m.put("anxiety", CAT_PSYCHOLOGY);
        m.put("careless", CAT_PSYCHOLOGY);
        m.put("skip", CAT_SKIP);
        // legacy (pre-migration tolerance)
        m.put("concept", CAT_KNOWLEDGE);
        m.put("calc", CAT_SKILL);
        m.put("reading", CAT_SKILL);
        CODE_CATEGORY = Collections.unmodifiableMap(m);

        Map<String, String> c = new LinkedHashMap<String, String>();
        c.put(CAT_KNOWLEDGE, "\u77e5\u8bc6\u6027\u9519\u8bef");
        c.put(CAT_SKILL, "\u6280\u80fd\u6027\u9519\u8bef");
        c.put(CAT_STRATEGY, "\u7b56\u7565\u6027\u9519\u8bef");
        c.put(CAT_PSYCHOLOGY, "\u5fc3\u7406\u6027\u56e0\u7d20");
        c.put(CAT_SKIP, "\u672a\u505a");
        CATEGORY_LABEL = Collections.unmodifiableMap(c);
    }

    private SpasErrorCauseCodes()
    {
    }

    public static Set<String> allowedCodes()
    {
        return CODE_CATEGORY.keySet();
    }

    public static boolean isAllowed(String code)
    {
        return code != null && CODE_CATEGORY.containsKey(code.trim());
    }

    public static String categoryOf(String code)
    {
        if (code == null)
        {
            return null;
        }
        return CODE_CATEGORY.get(code.trim());
    }

    public static String categoryLabel(String category)
    {
        if (category == null)
        {
            return null;
        }
        String label = CATEGORY_LABEL.get(category);
        return label == null ? category : label;
    }
}
