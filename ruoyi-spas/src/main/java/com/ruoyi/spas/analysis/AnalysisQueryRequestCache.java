package com.ruoyi.spas.analysis;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.ruoyi.spas.domain.SpasAnalysisScoreRow;
import com.ruoyi.spas.domain.SpasStudent;

/**
 * Per-request reuse of score-row queries and student lookups within one HTTP thread.
 * Cleared by {@link AnalysisQueryCacheInterceptor} after each request.
 */
public final class AnalysisQueryRequestCache
{
    private static final ThreadLocal<Map<String, List<SpasAnalysisScoreRow>>> SCORE_ROWS =
        ThreadLocal.withInitial(HashMap::new);

    private static final ThreadLocal<Map<Long, SpasStudent>> STUDENTS =
        ThreadLocal.withInitial(HashMap::new);

    private static final ThreadLocal<Map<String, List<Map<String, Object>>>> RADAR =
        ThreadLocal.withInitial(HashMap::new);

    private AnalysisQueryRequestCache()
    {
    }

    public static String scoreKey(Long studentId, Long subjectId, Date examDateFrom, List<Long> paperIds,
        Long deptId, Long knowledgeId)
    {
        StringBuilder sb = new StringBuilder(96);
        sb.append(studentId == null ? "-" : studentId).append('|');
        sb.append(subjectId == null ? "-" : subjectId).append('|');
        sb.append(examDateFrom == null ? "-" : examDateFrom.getTime()).append('|');
        sb.append(deptId == null ? "-" : deptId).append('|');
        sb.append(knowledgeId == null ? "-" : knowledgeId).append('|');
        if (paperIds == null || paperIds.isEmpty())
        {
            sb.append('-');
        }
        else
        {
            for (int i = 0; i < paperIds.size(); i++)
            {
                if (i > 0)
                {
                    sb.append(',');
                }
                sb.append(paperIds.get(i));
            }
        }
        return sb.toString();
    }

    public static String radarKey(Long studentId, Long subjectId, Date examDateFrom, List<Long> paperIds)
    {
        return "r|" + scoreKey(studentId, subjectId, examDateFrom, paperIds, null, null);
    }

    public static List<SpasAnalysisScoreRow> getScoreRows(String key)
    {
        return SCORE_ROWS.get().get(key);
    }

    public static void putScoreRows(String key, List<SpasAnalysisScoreRow> rows)
    {
        SCORE_ROWS.get().put(key, rows);
    }

    public static SpasStudent getStudent(Long studentId)
    {
        return studentId == null ? null : STUDENTS.get().get(studentId);
    }

    public static void putStudent(Long studentId, SpasStudent student)
    {
        if (studentId != null)
        {
            STUDENTS.get().put(studentId, student);
        }
    }

    @SuppressWarnings("unchecked")
    public static List<Map<String, Object>> getRadar(String key)
    {
        return RADAR.get().get(key);
    }

    public static void putRadar(String key, List<Map<String, Object>> radar)
    {
        RADAR.get().put(key, radar);
    }

    public static void clear()
    {
        SCORE_ROWS.remove();
        STUDENTS.remove();
        RADAR.remove();
    }
}
