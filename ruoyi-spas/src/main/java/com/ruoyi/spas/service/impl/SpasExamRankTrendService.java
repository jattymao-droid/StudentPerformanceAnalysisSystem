package com.ruoyi.spas.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.file.FileUtils;
import com.ruoyi.spas.domain.SpasExamScore;
import com.ruoyi.spas.domain.SpasSubject;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.mapper.SpasExamScoreMapper;
import com.ruoyi.spas.mapper.SpasSubjectMapper;
import com.ruoyi.spas.mapper.SpasStudentMapper;
import com.ruoyi.spas.service.ISpasAnalysisService;
import com.ruoyi.spas.support.SpasAccessService;
import com.ruoyi.spas.support.SpasReportPdfWriter;

/**
 * School-rank progress across imported exam batches. Rank number down = progress.
 */
@Service
public class SpasExamRankTrendService
{
    private static final String TYPE_TOTAL = "2";
    private static final String TOTAL = "\u603b\u5206";
    private static final String[] PREFERRED = {
        "\u8bed\u6587", "\u6570\u5b66", "\u82f1\u8bed", "\u7269\u7406", "\u5316\u5b66", "\u751f\u7269\u5b66", "\u751f\u7269", TOTAL
    };

    @Autowired
    private SpasExamScoreMapper examScoreMapper;

    @Autowired
    private SpasStudentMapper studentMapper;

    @Autowired
    private SpasAccessService accessService;

    @Autowired
    private SpasSubjectMapper subjectMapper;

    @Autowired
    private ISpasAnalysisService analysisService;

    @Autowired
    private com.ruoyi.spas.analysis.KnowledgeStatCalculator knowledgeStatCalculator;

    public Map<String, Object> selectRankTrend(Long studentId)
    {
        return selectRankTrend(studentId, null, null, null);
    }

    public Map<String, Object> selectRankTrend(Long studentId, String window, List<Long> paperIds)
    {
        return selectRankTrend(studentId, window, paperIds, null);
    }

    public Map<String, Object> selectRankTrend(Long studentId, String window, List<Long> paperIds, Long subjectId)
    {
        if (studentId == null)
        {
            throw new ServiceException("\u8bf7\u9009\u62e9\u5b66\u751f");
        }
        accessService.checkStudentAccess(studentId);
        SpasStudent student = studentMapper.selectSpasStudentById(studentId);
        if (student == null || "2".equals(student.getDelFlag()))
        {
            throw new ServiceException("\u5b66\u751f\u4e0d\u5b58\u5728");
        }

        Map<String, SpasSubject> alias = buildSubjectAliasMap();
        SpasSubject filterSubject = null;
        if (subjectId != null)
        {
            filterSubject = subjectMapper.selectSpasSubjectById(subjectId);
            if (filterSubject == null)
            {
                throw new ServiceException("\u5b66\u79d1\u4e0d\u5b58\u5728");
            }
        }

        List<SpasExamScore> rows = examScoreMapper.selectScoresByStudentId(studentId);
        LinkedHashMap<Long, Map<String, Object>> exams = new LinkedHashMap<Long, Map<String, Object>>();
        LinkedHashMap<String, List<Map<String, Object>>> series = new LinkedHashMap<String, List<Map<String, Object>>>();

        if (rows != null)
        {
            for (SpasExamScore row : rows)
            {
                if (row.getExamId() == null)
                {
                    continue;
                }
                String label = TYPE_TOTAL.equals(row.getScoreType()) ? TOTAL : row.getSubjectName();
                if (StringUtils.isEmpty(label))
                {
                    continue;
                }
                if (!matchesSubjectFilter(label, subjectId, alias, filterSubject))
                {
                    continue;
                }
                Map<String, Object> exam = exams.get(row.getExamId());
                if (exam == null)
                {
                    exam = new LinkedHashMap<String, Object>();
                    exam.put("examId", row.getExamId());
                    exam.put("examName", row.getExamName());
                    exam.put("examDate", formatDate(row.getExamDate()));
                    exam.put("paperId", row.getPaperId());
                    exams.put(row.getExamId(), exam);
                }
                List<Map<String, Object>> points = series.get(label);
                if (points == null)
                {
                    points = new ArrayList<Map<String, Object>>();
                    series.put(label, points);
                }
                Map<String, Object> point = new LinkedHashMap<String, Object>();
                point.put("examId", row.getExamId());
                point.put("examName", row.getExamName());
                point.put("examDate", formatDate(row.getExamDate()));
                point.put("paperId", row.getPaperId());
                point.put("rank", row.getSchoolRank());
                point.put("score", row.getScore());
                points.add(point);
            }
        }

        List<Map<String, Object>> subjects = new ArrayList<Map<String, Object>>();
        int up = 0;
        int down = 0;
        int flat = 0;
        int insufficient = 0;
        for (String name : orderedSubjects(series))
        {
            Map<String, Object> item = buildSubject(name, series.get(name));
            attachWeakExplain(item, studentId, alias, window, paperIds);
            attachBoundMastery(item, studentId, alias);
            attachCrossDiagnosis(item);
            subjects.add(item);
            String trend = String.valueOf(item.get("trend"));
            if ("up".equals(trend))
            {
                up++;
            }
            else if ("down".equals(trend))
            {
                down++;
            }
            else if ("flat".equals(trend))
            {
                flat++;
            }
            else
            {
                insufficient++;
            }
        }
        annotateBias(subjects);

        int dualDown = 0;
        int rankUpWeak = 0;
        int dualUp = 0;
        for (Map<String, Object> item : subjects)
        {
            String code = String.valueOf(item.get("crossCode"));
            if ("dualDown".equals(code))
            {
                dualDown++;
            }
            else if ("rankUp+weakMastery".equals(code))
            {
                rankUpWeak++;
            }
            else if ("dualUp".equals(code))
            {
                dualUp++;
            }
        }

        Map<String, Object> summary = new LinkedHashMap<String, Object>();
        summary.put("examCount", exams.size());
        summary.put("improved", up);
        summary.put("declined", down);
        summary.put("flat", flat);
        summary.put("insufficient", insufficient);
        summary.put("dualDown", Integer.valueOf(dualDown));
        summary.put("rankUpWeakMastery", Integer.valueOf(rankUpWeak));
        summary.put("dualUp", Integer.valueOf(dualUp));
        summary.put("headline", headline(exams.size(), up, down, flat));
        if (dualDown > 0 || rankUpWeak > 0)
        {
            StringBuilder cross = new StringBuilder();
            if (dualDown > 0)
            {
                cross.append(dualDown).append(" \u79d1\u6821\u6b21\u4e0e\u638c\u63e1\u53cc\u964d");
            }
            if (rankUpWeak > 0)
            {
                if (cross.length() > 0)
                {
                    cross.append("\uff1b");
                }
                cross.append(rankUpWeak).append(" \u79d1\u6821\u6b21\u8fdb\u6b65\u4f46\u638c\u63e1\u4ecd\u5f31");
            }
            summary.put("crossHeadline", cross.toString());
        }
        if (subjectId != null)
        {
            summary.put("subjectId", subjectId);
            summary.put("subjectName", filterSubject.getSubjectName());
            summary.put("singleSubject", Boolean.TRUE);
        }
        else
        {
            summary.put("singleSubject", Boolean.FALSE);
        }

        Map<String, Object> stu = new LinkedHashMap<String, Object>();
        stu.put("studentId", student.getStudentId());
        stu.put("studentNo", student.getStudentNo());
        stu.put("studentName", student.getStudentName());
        stu.put("deptName", student.getDeptName());

        Map<String, Object> result = new LinkedHashMap<String, Object>();
        result.put("student", stu);
        result.put("exams", new ArrayList<Map<String, Object>>(exams.values()));
        result.put("subjects", subjects);
        result.put("summary", summary);
        return result;
    }

    public void exportPdf(Long studentId, HttpServletResponse response)
    {
        exportPdf(studentId, null, null, null, response);
    }

    public void exportPdf(Long studentId, String window, String paperIdsCsv, HttpServletResponse response)
    {
        exportPdf(studentId, window, paperIdsCsv, null, response);
    }

    public void exportPdf(Long studentId, String window, String paperIdsCsv, Long subjectId, HttpServletResponse response)
    {
        List<Long> paperIds = null;
        if (StringUtils.isNotEmpty(paperIdsCsv))
        {
            paperIds = new ArrayList<Long>();
            for (String part : paperIdsCsv.split(","))
            {
                String s = part.trim();
                if (!s.isEmpty())
                {
                    paperIds.add(Long.valueOf(s));
                }
            }
            if (paperIds.isEmpty())
            {
                paperIds = null;
            }
        }
        Map<String, Object> data = selectRankTrend(studentId, window, paperIds, subjectId);
        try
        {
            response.setContentType("application/pdf");
            FileUtils.setAttachmentResponseHeader(response, "rank_trend_" + studentId + ".pdf");
            SpasReportPdfWriter.writeRankTrend(response.getOutputStream(), data);
            response.getOutputStream().flush();
        }
        catch (ServiceException e)
        {
            throw e;
        }
        catch (Exception e)
        {
            throw new ServiceException("\u6821\u6b21\u62a5\u544a\u5bfc\u51fa\u5931\u8d25: " + e.getMessage());
        }
    }

    private Map<String, Object> buildSubject(String name, List<Map<String, Object>> points)
    {
        List<Map<String, Object>> ranked = new ArrayList<Map<String, Object>>();
        if (points != null)
        {
            for (Map<String, Object> p : points)
            {
                if (p.get("rank") != null)
                {
                    ranked.add(p);
                }
            }
        }
        Map<String, Object> item = new LinkedHashMap<String, Object>();
        item.put("subjectName", name);
        item.put("points", points == null ? new ArrayList<Map<String, Object>>() : points);
        if (ranked.size() < 2)
        {
            Integer latest = ranked.isEmpty() ? null : toInt(ranked.get(ranked.size() - 1).get("rank"));
            item.put("latestRank", latest);
            item.put("prevRank", null);
            item.put("firstRank", latest);
            item.put("stepDelta", null);
            item.put("overallDelta", null);
            item.put("trend", "insufficient");
            item.put("trendLabel", "\u6837\u672c\u4e0d\u8db3");
            item.put("track", trackText(ranked));
            return item;
        }
        Integer first = toInt(ranked.get(0).get("rank"));
        Integer prev = toInt(ranked.get(ranked.size() - 2).get("rank"));
        Integer latest = toInt(ranked.get(ranked.size() - 1).get("rank"));
        Integer step = prev == null || latest == null ? null : Integer.valueOf(prev.intValue() - latest.intValue());
        Integer overall = first == null || latest == null ? null : Integer.valueOf(first.intValue() - latest.intValue());
        String trend = trendOf(step);
        item.put("latestRank", latest);
        item.put("prevRank", prev);
        item.put("firstRank", first);
        item.put("stepDelta", step);
        item.put("overallDelta", overall);
        item.put("trend", trend);
        item.put("trendLabel", trendLabel(trend));
        item.put("track", trackText(ranked));
        return item;
    }

    /** Positive vsTotal means this subject rank is worse than the total rank. */
    private void annotateBias(List<Map<String, Object>> subjects)
    {
        Integer totalLatest = null;
        for (Map<String, Object> item : subjects)
        {
            if (TOTAL.equals(item.get("subjectName")))
            {
                totalLatest = toInt(item.get("latestRank"));
            }
        }
        for (Map<String, Object> item : subjects)
        {
            if (TOTAL.equals(item.get("subjectName")))
            {
                item.put("vsTotal", null);
                item.put("biasLabel", null);
                continue;
            }
            Integer latest = toInt(item.get("latestRank"));
            if (latest == null || totalLatest == null)
            {
                item.put("vsTotal", null);
                item.put("biasLabel", null);
                continue;
            }
            int gap = latest.intValue() - totalLatest.intValue();
            item.put("vsTotal", Integer.valueOf(gap));
            if (gap >= 20)
            {
                item.put("biasLabel", "偏科");
            }
            else if (gap <= -20)
            {
                item.put("biasLabel", "优势");
            }
            else
            {
                item.put("biasLabel", "接近");
            }
        }
    }

    private static String trendOf(Integer delta)
    {
        if (delta == null || delta.intValue() == 0)
        {
            return "flat";
        }
        return delta.intValue() > 0 ? "up" : "down";
    }

    private static String trendLabel(String trend)
    {
        if ("up".equals(trend))
        {
            return "\u8fdb\u6b65";
        }
        if ("down".equals(trend))
        {
            return "\u9000\u6b65";
        }
        return "\u6301\u5e73";
    }

    private static String trackText(List<Map<String, Object>> ranked)
    {
        if (ranked == null || ranked.isEmpty())
        {
            return "-";
        }
        StringBuilder sb = new StringBuilder();
        for (Map<String, Object> p : ranked)
        {
            if (sb.length() > 0)
            {
                sb.append(" \u2192 ");
            }
            sb.append(p.get("rank"));
        }
        return sb.toString();
    }

    private static String headline(int exams, int up, int down, int flat)
    {
        if (exams < 2)
        {
            return "\u5b9e\u8003\u6821\u6b21\u4e0d\u8db3\u4e24\u6b21\uff0c\u6682\u4e0d\u80fd\u5224\u65ad\u8fdb\u9000\u3002";
        }
        return "\u5171 " + exams + " \u6b21\u5b9e\u8003\u3002\u8f83\u4e0a\u6b21\uff1a\u8fdb\u6b65 " + up
            + " \u79d1\uff0c\u9000\u6b65 " + down + " \u79d1\uff0c\u6301\u5e73 " + flat + " \u79d1\u3002\u6821\u6b21\u6570\u5b57\u53d8\u5c0f\u4e3a\u8fdb\u6b65\u3002";
    }

    private List<String> orderedSubjects(Map<String, List<Map<String, Object>>> series)
    {
        List<String> order = new ArrayList<String>();
        for (String name : PREFERRED)
        {
            if (series.containsKey(name) && !order.contains(name))
            {
                order.add(name);
            }
        }
        for (String name : series.keySet())
        {
            if (!order.contains(name) && !TOTAL.equals(name))
            {
                order.add(name);
            }
        }
        if (series.containsKey(TOTAL) && !order.contains(TOTAL))
        {
            order.add(TOTAL);
        }
        return order;
    }

    /** When subjectId is set, keep only that subject series (exclude 总分 and other subjects). */
    private static boolean matchesSubjectFilter(String label, Long subjectId, Map<String, SpasSubject> alias,
        SpasSubject filterSubject)
    {
        if (subjectId == null)
        {
            return true;
        }
        if (TOTAL.equals(label))
        {
            return false;
        }
        SpasSubject matched = alias == null ? null : alias.get(label);
        if (matched != null && subjectId.equals(matched.getSubjectId()))
        {
            return true;
        }
        if (filterSubject != null && filterSubject.getSubjectName() != null
            && filterSubject.getSubjectName().trim().equals(label == null ? null : label.trim()))
        {
            return true;
        }
        return false;
    }

    private static Integer toInt(Object v)
    {
        if (v == null)
        {
            return null;
        }
        if (v instanceof Number)
        {
            return Integer.valueOf(((Number) v).intValue());
        }
        try
        {
            return Integer.valueOf(String.valueOf(v));
        }
        catch (Exception e)
        {
            return null;
        }
    }

    private static String formatDate(Date date)
    {
        if (date == null)
        {
            return "";
        }
        return new SimpleDateFormat("yyyy-MM-dd").format(date);
    }

    private Map<String, SpasSubject> buildSubjectAliasMap()
    {
        Map<String, SpasSubject> map = new LinkedHashMap<String, SpasSubject>();
        List<SpasSubject> list = subjectMapper.selectSpasSubjectAll();
        if (list == null)
        {
            return map;
        }
        for (SpasSubject subject : list)
        {
            if (subject == null || subject.getSubjectName() == null)
            {
                continue;
            }
            if (subject.getStatus() != null && !"0".equals(subject.getStatus()))
            {
                continue;
            }
            map.put(subject.getSubjectName().trim(), subject);
        }
        SpasSubject biology = map.get("\u751f\u7269\u5b66");
        if (biology != null && !map.containsKey("\u751f\u7269"))
        {
            map.put("\u751f\u7269", biology);
        }
        SpasSubject biologyShort = map.get("\u751f\u7269");
        if (biologyShort != null && !map.containsKey("\u751f\u7269\u5b66"))
        {
            map.put("\u751f\u7269\u5b66", biologyShort);
        }
        aliasIfMissing(map, "\u82f1\u8bed", "\u5916\u8bed");
        aliasIfMissing(map, "\u5916\u8bed", "\u82f1\u8bed");
        return map;
    }

    private static void aliasIfMissing(Map<String, SpasSubject> map, String from, String to)
    {
        SpasSubject source = map.get(from);
        if (source != null && !map.containsKey(to))
        {
            map.put(to, source);
        }
    }

    private void attachWeakExplain(Map<String, Object> item, Long studentId, Map<String, SpasSubject> alias,
        String window, List<Long> paperIds)
    {
        String name = String.valueOf(item.get("subjectName"));
        if (TOTAL.equals(name))
        {
            item.put("explain", "\u603b\u5206\u4e0d\u5bf9\u5e94\u5355\u79d1\u77e5\u8bc6\u70b9");
            return;
        }
        SpasSubject subject = alias == null ? null : alias.get(name);
        if (subject == null || subject.getSubjectId() == null)
        {
            item.put("explain", "\u672a\u5339\u914d\u5b66\u79d1\u6863\uff0c\u65e0\u6cd5\u5173\u8054\u8584\u5f31\u77e5\u8bc6\u70b9");
            return;
        }
        item.put("subjectId", subject.getSubjectId());
        item.put("canonicalName", subject.getSubjectName());
        List<Map<String, Object>> weak = analysisService.studentWeakTop(studentId, subject.getSubjectId(),
            Integer.valueOf(3), window, paperIds);
        List<Map<String, Object>> persist = analysisService.persistentWeak(studentId, subject.getSubjectId(),
            paperIds, window, null, null, null);
        int persistCount = 0;
        if (persist != null)
        {
            for (Map<String, Object> row : persist)
            {
                if ("\u53cd\u590d\u8584\u5f31".equals(String.valueOf(row.get("persistTag"))))
                {
                    persistCount++;
                }
            }
        }
        item.put("weakTop", weak == null ? new ArrayList<Map<String, Object>>() : weak);
        item.put("persistCount", Integer.valueOf(persistCount));
        StringBuilder sb = new StringBuilder();
        if (weak != null)
        {
            int n = 0;
            for (Map<String, Object> row : weak)
            {
                Object kn = row.get("knowledgeName");
                if (kn == null)
                {
                    kn = row.get("name");
                }
                if (kn == null)
                {
                    continue;
                }
                if (n > 0)
                {
                    sb.append("\u3001");
                }
                sb.append(kn);
                n++;
                if (n >= 3)
                {
                    break;
                }
            }
        }
        if (sb.length() == 0)
        {
            item.put("explain", persistCount > 0
                ? ("\u53cd\u590d\u8584\u5f31 " + persistCount + " \u4e2a")
                : "\u7a97\u53e3\u5185\u6682\u65e0\u660e\u663e\u8584\u5f31\u70b9");
            return;
        }
        if (persistCount > 0)
        {
            sb.append("\uff1b\u5176\u4e2d\u53cd\u590d\u8584\u5f31 ").append(persistCount).append(" \u4e2a");
        }
        item.put("explain", sb.toString());
    }

    @SuppressWarnings("unchecked")
    private void attachBoundMastery(Map<String, Object> item, Long studentId, Map<String, SpasSubject> alias)
    {
        if (TOTAL.equals(String.valueOf(item.get("subjectName"))))
        {
            return;
        }
        Object pointsObj = item.get("points");
        if (!(pointsObj instanceof List))
        {
            return;
        }
        List<Map<String, Object>> points = (List<Map<String, Object>>) pointsObj;
        Long latestPaperId = null;
        for (int i = points.size() - 1; i >= 0; i--)
        {
            Object pid = points.get(i).get("paperId");
            if (pid != null)
            {
                try
                {
                    latestPaperId = Long.valueOf(pid.toString());
                    break;
                }
                catch (Exception ignored)
                {
                }
            }
        }
        if (latestPaperId == null)
        {
            return;
        }
        SpasSubject subject = alias == null ? null : alias.get(String.valueOf(item.get("subjectName")));
        Long subjectId = subject == null ? null : subject.getSubjectId();
        if (subjectId == null && item.get("subjectId") != null)
        {
            try
            {
                subjectId = Long.valueOf(String.valueOf(item.get("subjectId")));
            }
            catch (Exception ignored)
            {
            }
        }
        try
        {
            List<Long> one = new ArrayList<Long>();
            one.add(latestPaperId);
            Map<String, Object> summary = analysisService.studentSummary(studentId, subjectId, null, one);
            if (summary != null && summary.get("overallRate") != null)
            {
                item.put("boundPaperId", latestPaperId);
                item.put("boundMasteryRate", summary.get("overallRate"));
            }
        }
        catch (Exception ignored)
        {
            // mastery overlay is best-effort
        }
    }

    /**
     * Cross diagnosis: school-rank trend × bound mastery.
     * Codes: dualDown | dualUp | rankUp+weakMastery | rankDown+solidMastery | neutral
     */
    private void attachCrossDiagnosis(Map<String, Object> item)
    {
        if (item == null || TOTAL.equals(String.valueOf(item.get("subjectName"))))
        {
            return;
        }
        String trend = String.valueOf(item.get("trend"));
        Object masteryObj = item.get("boundMasteryRate");
        if (masteryObj == null || "insufficient".equals(trend) || "null".equals(trend))
        {
            item.put("crossCode", "neutral");
            item.put("crossLabel", "-");
            return;
        }
        double mastery;
        try
        {
            mastery = Double.parseDouble(masteryObj.toString());
        }
        catch (Exception e)
        {
            item.put("crossCode", "neutral");
            item.put("crossLabel", "-");
            return;
        }
        double weakLine = knowledgeStatCalculator.resolveWeakThreshold();
        double solidLine = knowledgeStatCalculator.resolveWatchThreshold();
        Map<String, String> cross = com.ruoyi.spas.analysis.ExamRankCrossDiagnosis.diagnose(
            trend, Double.valueOf(mastery), weakLine, solidLine);
        item.put("crossCode", cross.get("crossCode"));
        item.put("crossLabel", cross.get("crossLabel"));
    }
}
