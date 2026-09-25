package com.ruoyi.spas.support;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import com.ruoyi.common.utils.StringUtils;

/**
 * Maps legacy QB heuristic codes (choice/blank) to catalog seed codes (single/fill)
 * and expands aliases for list/smart-pick filters.
 */
public final class SpasQuestionTypeAlias
{
    private SpasQuestionTypeAlias()
    {
    }

    /**
     * Normalize stored/queried type toward subject catalog codes.
     */
    public static String normalize(String type)
    {
        if (StringUtils.isEmpty(type))
        {
            return type;
        }
        String t = type.trim().toLowerCase(Locale.ROOT);
        if ("choice".equals(t) || "select".equals(t))
        {
            return "single";
        }
        if ("blank".equals(t) || "cloze".equals(t))
        {
            return "fill";
        }
        return t;
    }

    /**
     * Expand a UI/filter code into all DB values that should match.
     */
    public static List<String> expand(String type)
    {
        if (StringUtils.isEmpty(type))
        {
            return Collections.emptyList();
        }
        String raw = type.trim();
        String norm = normalize(raw);
        Set<String> set = new LinkedHashSet<String>();
        set.add(raw);
        set.add(norm);
        if ("single".equals(norm) || "choice".equalsIgnoreCase(raw))
        {
            set.addAll(Arrays.asList("single", "choice", "multi", "select"));
        }
        else if ("fill".equals(norm) || "blank".equalsIgnoreCase(raw))
        {
            set.addAll(Arrays.asList("fill", "blank", "cloze"));
        }
        else if ("short".equalsIgnoreCase(raw))
        {
            set.add("short");
        }
        else if ("calc".equalsIgnoreCase(raw))
        {
            set.add("calc");
        }
        else if ("experiment".equalsIgnoreCase(raw) || "judge".equalsIgnoreCase(raw))
        {
            set.add(norm);
        }
        return new ArrayList<String>(set);
    }

    public static boolean isChoiceFamily(String type)
    {
        if (StringUtils.isEmpty(type))
        {
            return true;
        }
        String t = type.trim().toLowerCase(Locale.ROOT);
        return "choice".equals(t) || "single".equals(t) || "multi".equals(t)
            || "select".equals(t) || "judge".equals(t) || t.contains("choice");
    }
}
