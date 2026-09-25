package com.ruoyi.spas.support;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import com.ruoyi.common.utils.StringUtils;

/**
 * Resolve analysis time-window codes to examDateFrom.
 * Codes: all | last30d | last90d | semester | prev_semester
 */
@Component
public class SpasAnalysisWindowHelper
{
    @Value("${spas.analysis.default-window:all}")
    private String defaultWindow;

    @Value("${spas.analysis.semester-start:}")
    private String semesterStart;

    /** Optional override for previous semester start (MM-dd or yyyy-MM-dd). */
    @Value("${spas.analysis.prev-semester-start:}")
    private String prevSemesterStart;

    /** Optional exclusive end for previous semester (defaults to current semester start). */
    @Value("${spas.analysis.prev-semester-end:}")
    private String prevSemesterEnd;

    public Date resolveExamDateFrom(String window)
    {
        String w = normalize(window);
        if (StringUtils.isEmpty(w) || "all".equals(w))
        {
            return null;
        }
        LocalDate today = LocalDate.now();
        LocalDate from;
        switch (w)
        {
            case "last30d":
                from = today.minusDays(30);
                break;
            case "last90d":
                from = today.minusDays(90);
                break;
            case "semester":
                from = parseSemesterStart(today);
                break;
            case "prev_semester":
                from = resolvePrevSemesterStart(today);
                break;
            default:
                return null;
        }
        return Date.from(from.atStartOfDay(ZoneId.systemDefault()).toInstant());
    }

    /**
     * Exclusive upper bound for windows that need a closed range (prev_semester).
     * Other windows return null (open-ended to present).
     */
    public Date resolveExamDateToExclusive(String window)
    {
        String w = normalize(window);
        if (!"prev_semester".equals(w))
        {
            return null;
        }
        LocalDate today = LocalDate.now();
        LocalDate end;
        if (StringUtils.isNotEmpty(prevSemesterEnd))
        {
            end = parseFlexibleDate(prevSemesterEnd, today);
            if (end == null)
            {
                end = parseSemesterStart(today);
            }
        }
        else
        {
            end = parseSemesterStart(today);
        }
        return Date.from(end.atStartOfDay(ZoneId.systemDefault()).toInstant());
    }

    public boolean isClosedRangeWindow(String window)
    {
        return "prev_semester".equals(normalize(window));
    }

    /**
     * Resolved previous-semester closed range for UI / analysisConfig.
     * Keys: from, toExclusive (yyyy-MM-dd), derived (bool), label
     */
    public Map<String, Object> describePrevSemester()
    {
        java.util.Map<String, Object> m = new java.util.LinkedHashMap<String, Object>();
        java.time.LocalDate today = java.time.LocalDate.now();
        boolean derived = StringUtils.isEmpty(prevSemesterStart) && StringUtils.isEmpty(prevSemesterEnd);
        java.time.LocalDate from = resolvePrevSemesterStart(today);
        java.time.LocalDate toEx;
        if (StringUtils.isNotEmpty(prevSemesterEnd))
        {
            toEx = parseFlexibleDate(prevSemesterEnd, today);
            if (toEx == null)
            {
                toEx = parseSemesterStart(today);
            }
        }
        else
        {
            toEx = parseSemesterStart(today);
        }
        m.put("from", from.toString());
        m.put("toExclusive", toEx.toString());
        m.put("derived", Boolean.valueOf(derived));
        m.put("configStart", prevSemesterStart == null ? "" : prevSemesterStart);
        m.put("configEnd", prevSemesterEnd == null ? "" : prevSemesterEnd);
        m.put("label", from.toString() + " ~ " + toEx.toString()
            + (derived ? "\uff08\u81ea\u52a8\u63a8\u7b97\uff09" : "\uff08\u914d\u7f6e\uff09"));
        return m;
    }

    public String getSemesterStartConfig()
    {
        return semesterStart == null ? "" : semesterStart;
    }

    private LocalDate resolvePrevSemesterStart(LocalDate today)
    {
        if (StringUtils.isNotEmpty(prevSemesterStart))
        {
            LocalDate parsed = parseFlexibleDate(prevSemesterStart, today);
            if (parsed != null)
            {
                return parsed;
            }
        }
        LocalDate currentStart = parseSemesterStart(today);
        // Prior term: if current starts in autumn (>=8), previous is spring same year Feb 15;
        // if current is spring, previous is autumn prior year Sep 1.
        if (currentStart.getMonthValue() >= 8)
        {
            return LocalDate.of(currentStart.getYear(), 2, 15);
        }
        return LocalDate.of(currentStart.getYear() - 1, 9, 1);
    }

    private LocalDate parseFlexibleDate(String value, LocalDate today)
    {
        try
        {
            String[] parts = value.split("-");
            if (parts.length == 2)
            {
                int m = Integer.parseInt(parts[0]);
                int d = Integer.parseInt(parts[1]);
                LocalDate cand = LocalDate.of(today.getYear(), m, d);
                if (cand.isAfter(today))
                {
                    cand = cand.minusYears(1);
                }
                return cand;
            }
            return LocalDate.parse(value);
        }
        catch (Exception e)
        {
            return null;
        }
    }

    /**
     * End of the current teaching semester (day before next semester start).
     * Used as optional recency as-of anchor so decay stays stable within a semester.
     */
    public LocalDate resolveSemesterEnd(LocalDate today)
    {
        LocalDate start = parseSemesterStart(today == null ? LocalDate.now() : today);
        LocalDate nextStart;
        if (start.getMonthValue() >= 8)
        {
            // Autumn → spring next year (Feb 15)
            nextStart = LocalDate.of(start.getYear() + 1, 2, 15);
        }
        else
        {
            // Spring → autumn same year (Sep 1)
            nextStart = LocalDate.of(start.getYear(), 9, 1);
        }
        return nextStart.minusDays(1);
    }

    public boolean isAll(String window)
    {
        return resolveExamDateFrom(window) == null;
    }

    public String getDefaultWindow()
    {
        return StringUtils.isEmpty(defaultWindow) ? "all" : defaultWindow.trim().toLowerCase();
    }

    public String normalize(String window)
    {
        return StringUtils.isEmpty(window) ? getDefaultWindow() : window.trim().toLowerCase();
    }

    private LocalDate parseSemesterStart(LocalDate today)
    {
        if (StringUtils.isNotEmpty(semesterStart))
        {
            try
            {
                // MM-dd
                String[] parts = semesterStart.split("-");
                if (parts.length == 2)
                {
                    int m = Integer.parseInt(parts[0]);
                    int d = Integer.parseInt(parts[1]);
                    LocalDate cand = LocalDate.of(today.getYear(), m, d);
                    if (cand.isAfter(today))
                    {
                        cand = cand.minusYears(1);
                    }
                    return cand;
                }
                // yyyy-MM-dd
                return LocalDate.parse(semesterStart);
            }
            catch (Exception ignored)
            {
            }
        }
        // default: Sep 1 or Feb 15 nearest past
        LocalDate sep = LocalDate.of(today.getYear(), 9, 1);
        LocalDate feb = LocalDate.of(today.getYear(), 2, 15);
        if (!sep.isAfter(today))
        {
            return sep;
        }
        if (!feb.isAfter(today))
        {
            return feb;
        }
        return LocalDate.of(today.getYear() - 1, 9, 1);
    }
}
