package com.ruoyi.spas.support;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import com.ruoyi.common.utils.StringUtils;

/**
 * Resolve analysis time-window codes to examDateFrom.
 * Codes: all | last30d | last90d | semester
 */
@Component
public class SpasAnalysisWindowHelper
{
    @Value("${spas.analysis.default-window:all}")
    private String defaultWindow;

    @Value("${spas.analysis.semester-start:}")
    private String semesterStart;

    public Date resolveExamDateFrom(String window)
    {
        String w = StringUtils.isEmpty(window) ? defaultWindow : window.trim().toLowerCase();
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
            default:
                return null;
        }
        return Date.from(from.atStartOfDay(ZoneId.systemDefault()).toInstant());
    }

    public boolean isAll(String window)
    {
        return resolveExamDateFrom(window) == null;
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
