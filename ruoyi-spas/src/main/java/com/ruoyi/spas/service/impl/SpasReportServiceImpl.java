package com.ruoyi.spas.service.impl;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.file.FileUtils;
import com.ruoyi.spas.analysis.KnowledgeStatCalculator;
import com.ruoyi.spas.domain.SpasPaper;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.mapper.SpasAnalysisMapper;
import com.ruoyi.spas.mapper.SpasPaperMapper;
import com.ruoyi.spas.mapper.SpasStudentMapper;
import com.ruoyi.spas.service.ISpasAnalysisService;
import com.ruoyi.spas.service.ISpasPortfolioService;
import com.ruoyi.spas.service.ISpasReportService;
import com.ruoyi.spas.service.impl.SpasExamRankTrendService;
import com.ruoyi.spas.support.SpasAccessService;
import com.ruoyi.spas.support.SpasReportPdfWriter;
import com.ruoyi.system.service.ISysDeptService;

@Service
public class SpasReportServiceImpl implements ISpasReportService
{
    private static final String MSG_NO_DATA = "\u6682\u65e0\u6210\u7ee9\u6570\u636e\uff0c\u65e0\u6cd5\u5bfc\u51fa\u62a5\u544a";
    private static final String MSG_BAD_FMT = "\u4e0d\u652f\u6301\u7684\u5bfc\u51fa\u683c\u5f0f\uff0c\u8bf7\u4f7f\u7528 pdf / xlsx";
    private static final int BATCH_MAX_CLASSES = 40;
    private static final int BATCH_MAX_STUDENTS = 80;
    private static final String BATCH_PROGRESS_KEY = "spas:report:batch:";
    private static final int BATCH_PROGRESS_TTL_MIN = 30;

    @Autowired
    private ISpasPortfolioService portfolioService;

    @Autowired
    private RedisCache redisCache;

    @Autowired
    private ISpasAnalysisService analysisService;

    @Autowired
    private SpasAccessService accessService;

    @Autowired
    private SpasPaperMapper paperMapper;

    @Autowired
    private SpasStudentMapper studentMapper;

    @Autowired
    private SpasAnalysisMapper analysisMapper;

    @Autowired
    private SpasExamRankTrendService examRankTrendService;

    @Autowired
    private ISysDeptService deptService;

    @Override
    public Map<String, Object> previewStudent(Long studentId, Long subjectId)
    {
        return previewStudent(studentId, subjectId, null, null, null, null);
    }

    @Override
    public Map<String, Object> previewStudent(Long studentId, Long subjectId, String window, List<Long> paperIds)
    {
        return previewStudent(studentId, subjectId, window, paperIds, null, null);
    }

    @Override
    public Map<String, Object> previewStudent(Long studentId, Long subjectId, String window, List<Long> paperIds,
        Boolean useRecency, Integer limit)
    {
        accessService.checkStudentAccess(studentId);
        applyRecencyOverride(useRecency);
        try
        {
            return buildStudentPreview(studentId, subjectId, window, paperIds, useRecency, limit);
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    private Map<String, Object> buildStudentPreview(Long studentId, Long subjectId, String window, List<Long> paperIds,
        Boolean useRecency, Integer limit)
    {
        // Portfolio supplies coach / warnings / timeline / errorCause (lifetime).
        // Window-scoped radar/trend/weak below override slices from getAnalysisSlices / getPortfolio.
        Map<String, Object> data = portfolioService.getPortfolio(studentId, subjectId);
        data.put("student", normalizeStudent(data.get("student")));

        // PDF 双面版最多展示 Top8；接口仍可传更大 limit，导出侧再截断
        int weakLimit = (limit == null || limit.intValue() <= 0) ? 8 : Math.min(limit.intValue(), 12);
        Map<String, Object> summary = analysisService.studentSummary(studentId, subjectId, window, paperIds);
        data.put("summary", summary);
        data.put("weakTop", analysisService.studentWeakTop(studentId, subjectId, weakLimit, window, paperIds));
        data.put("radar", analysisService.studentRadar(studentId, subjectId, window, paperIds));
        // Align trend / examRank with analysis page (same window / paperIds)
        data.put("trend", analysisService.studentTrend(studentId, subjectId, window, paperIds));
        data.put("examRank", examRankTrendService.selectRankTrend(studentId, window, paperIds, subjectId));
        data.put("questionType", analysisService.studentQuestionType(studentId, subjectId, window, paperIds));
        data.put("bloom", analysisService.studentBloom(studentId, subjectId, window, paperIds));
        data.put("chapterDelta", analysisService.studentChapterDelta(studentId, subjectId, window, paperIds, "prev_semester"));

        List<Map<String, Object>> persist = analysisService.persistentWeak(studentId, subjectId, paperIds,
            window, null, null, null);
        List<Map<String, Object>> persistOnly = new ArrayList<>();
        if (persist != null)
        {
            for (Map<String, Object> row : persist)
            {
                if ("\u53cd\u590d\u8584\u5f31".equals(String.valueOf(row.get("persistTag"))))
                {
                    persistOnly.add(row);
                }
            }
        }
        data.put("persistentWeak", persistOnly);
        data.put("persistentWeakCount", persistOnly.size());
        boolean papers = paperIds != null && !paperIds.isEmpty();
        String scopeMode = papers ? "papers" : (window != null && !window.trim().isEmpty() ? window.trim() : "all");
        data.put("scopeMode", scopeMode);
        data.put("window", window);
        data.put("useRecency", useRecency == null ? Boolean.TRUE : useRecency);
        data.put("weakTopLimit", Integer.valueOf(weakLimit));
        if (summary != null)
        {
            data.put("dataMode", summary.get("dataMode"));
        }
        data.put("examPapers", buildExamPapers(paperIds));
        data.put("allSubjects", summary != null && Boolean.TRUE.equals(summary.get("allSubjects")));
        if (summary != null && summary.get("subjectBreakdown") != null)
        {
            data.put("subjectBreakdown", summary.get("subjectBreakdown"));
        }
        data.put("scopeLabel", buildScopeLabel(scopeMode, paperIds, useRecency, summary, subjectId));
        // Lifetime blocks from portfolio (not filtered by analysis window)
        data.put("portfolioScopeNote",
            "\u8f85\u5bfc\u8bb0\u5f55\u3001\u9884\u8b66\u4e0e\u9519\u56e0\u6458\u8981\u4e3a\u5168\u91cf\u5386\u53f2\uff0c\u4e0d\u968f\u5206\u6790\u65f6\u95f4\u7a97/\u9009\u5377\u53d8\u5316");
        data.put("dimensionRateNote",
            "\u9898\u578b/\u80fd\u529b\u5c42\u7ea7\u5f97\u5206\u7387\u4e3a\u5377\u9762 sum(\u5f97\u5206)/sum(\u6ee1\u5206)\uff0c\u4e0e\u77e5\u8bc6\u70b9\u52a0\u6743\u638c\u63e1\u5ea6\u4e0d\u540c\u53e3\u5f84");
        enrichStudyGuidance(data);
        assertStudentHasData(data);
        data.put("generatedAt", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        return data;
    }

    /**
     * Build actionable study guidance: clarify sample-vs-formal weak, priority list, advice bullets.
     */
    @SuppressWarnings("unchecked")
    private void enrichStudyGuidance(Map<String, Object> data)
    {
        Map<String, Object> summary = asMap(data.get("summary"));
        List<Map<String, Object>> weakTop = castList(data.get("weakTop"));
        int minAttempts = 3;
        Object minObj = summary.get("minAttempts");
        if (minObj != null)
        {
            try
            {
                int m = Integer.parseInt(String.valueOf(minObj));
                if (m > 0)
                {
                    minAttempts = m;
                }
            }
            catch (Exception ignored)
            {
            }
        }
        int formalN = 0;
        int thinN = 0;
        for (Map<String, Object> row : weakTop)
        {
            if (row == null)
            {
                continue;
            }
            boolean evidenceOk = resolveEvidenceOk(row, minAttempts);
            boolean formal = Boolean.TRUE.equals(row.get("formalWeak"));
            if (!formal)
            {
                String wl = String.valueOf(first(row, "weakLevel", "level", "masteryLevel"));
                formal = "1".equals(wl) || "2".equals(wl) || "3".equals(wl);
            }
            if (evidenceOk && formal)
            {
                formalN++;
                row.put("statusLabel", fmtWeakLevel(first(row, "weakLevel", "level", "masteryLevel")));
                row.put("statusKind", "formal");
            }
            else if (!evidenceOk)
            {
                thinN++;
                row.put("statusLabel", "\u6837\u672c\u4e0d\u8db3");
                row.put("statusKind", "thin");
            }
            else
            {
                row.put("statusLabel", "\u4f4e\u5206\u5f85\u89c2\u5bdf");
                row.put("statusKind", "watch");
            }
            row.put("evidenceOk", Boolean.valueOf(evidenceOk));
            row.put("formalWeak", Boolean.valueOf(evidenceOk && formal));
        }

        List<Map<String, Object>> priority = new ArrayList<Map<String, Object>>();
        for (Map<String, Object> row : weakTop)
        {
            if (row == null || !"formal".equals(row.get("statusKind")))
            {
                continue;
            }
            priority.add(copyPriorityRow(row, "\u6b63\u5f0f\u8584\u5f31\uff0c\u4f18\u5148\u8865\u4e60"));
            if (priority.size() >= 5)
            {
                break;
            }
        }
        if (priority.size() < 5)
        {
            for (Map<String, Object> row : weakTop)
            {
                if (row == null || !"thin".equals(row.get("statusKind")))
                {
                    continue;
                }
                priority.add(copyPriorityRow(row, "\u6837\u672c\u4e0d\u8db3\uff0c\u5148\u52a0\u7ec3\u518d\u5b9a\u7ea7"));
                if (priority.size() >= 5)
                {
                    break;
                }
            }
        }
        data.put("priorityRemediate", priority);

        StringBuilder evidence = new StringBuilder();
        int severe = toIntSafe(summary.get("severeCount"));
        int weak = toIntSafe(summary.get("weakCount"));
        int watch = toIntSafe(summary.get("watchCount"));
        int thinSample = toIntSafe(summary.get("thinSampleCount"));
        if (thinSample <= 0)
        {
            thinSample = thinN;
        }
        evidence.append("\u5b9a\u7ea7\u8bf4\u660e\uff1a\u6b63\u5f0f\u4e25\u91cd/\u8584\u5f31/\u5173\u6ce8\u9700\u6ee1\u8db3\u6700\u4f4e\u4f5c\u7b54\u6b21\u6570\uff08\u5f53\u524d\u9608\u503c ")
            .append(minAttempts).append("\uff09\uff1b\u6b21\u6570\u4e0d\u8db3\u4ec5\u6807\u300c\u6837\u672c\u4e0d\u8db3\u300d\uff0c\u4e0d\u80fd\u5f53\u4f5c\u6b63\u5f0f\u8584\u5f31\u3002");
        evidence.append(" \u672c\u62a5\u544a\u6b63\u5f0f\u5b9a\u7ea7 ")
            .append(severe + weak + watch).append(" \u9879\uff08\u4e25\u91cd").append(severe)
            .append("/\u8584\u5f31").append(weak).append("/\u5173\u6ce8").append(watch).append("\uff09");
        if (thinSample > 0)
        {
            evidence.append("\uff0c\u6837\u672c\u4e0d\u8db3\u4f4e\u5206\u70b9 ").append(thinSample).append(" \u9879");
        }
        evidence.append("\u3002");
        data.put("evidenceNote", evidence.toString());
        data.put("weakLevelNote",
            "\u7b49\u7ea7\u680f\uff1a\u6b63\u5f0f\u4e25\u91cd/\u8584\u5f31/\u5173\u6ce8 = \u8fbe\u6807\u5b9a\u7ea7\uff1b\u6837\u672c\u4e0d\u8db3 = \u4f5c\u7b54\u6b21\u6570\u672a\u8fbe\u9608\u503c\uff1b\u4f4e\u5206\u5f85\u89c2\u5bdf = \u5f97\u5206\u504f\u4f4e\u4f46\u672a\u8fbe\u6b63\u5f0f\u8584\u5f31\u3002");

        List<String> advice = new ArrayList<String>();
        if (!priority.isEmpty())
        {
            StringBuilder names = new StringBuilder();
            int show = Math.min(3, priority.size());
            for (int i = 0; i < show; i++)
            {
                if (i > 0)
                {
                    names.append("\u3001");
                }
                names.append(str(priority.get(i).get("name"), ""));
            }
            if (formalN > 0)
            {
                advice.add("\u672c\u5468\u4f18\u5148\u8865\uff1a" + names
                    + "\u3002\u5efa\u8bae\u6bcf\u70b9\u5148\u505a 3\uff5e5 \u9053\u57fa\u7840\u9898\uff0c\u518d\u505a 2\uff5e3 \u9053\u53d8\u5f0f\u9898\uff0c\u8bb0\u5f55\u9519\u56e0\u3002");
            }
            else
            {
                advice.add("\u5f53\u524d\u4e3a\u300c\u6837\u672c\u4e0d\u8db3\u300d\u4e3b\u5bfc\uff0c\u5148\u5bf9 " + names
                    + " \u5404\u52a0\u7ec3\u81f3\u6bcf\u70b9\u81f3\u5c11 " + minAttempts
                    + " \u9898\uff0c\u518d\u770b\u662f\u5426\u5b9a\u4e3a\u6b63\u5f0f\u8584\u5f31\u3002");
            }
        }
        else
        {
            advice.add("\u672c\u53e3\u5f84\u4e0b\u6682\u65e0\u663e\u8457\u4f18\u5148\u8865\u5f31\u70b9\uff0c\u5efa\u8bae\u4fdd\u6301\u5e38\u89c4\u7ec3\u4e60\u5e76\u5173\u6ce8\u4e0b\u6b21\u8003\u8bd5\u8d8b\u52bf\u3002");
        }

        LinkedHashSet<String> clusters = new LinkedHashSet<String>();
        for (Map<String, Object> row : priority)
        {
            String hint = str(row.get("rootHint"), "");
            if (hint.startsWith("\u540c\u7ae0\u5171\u5f31"))
            {
                clusters.add(hint);
            }
        }
        if (!clusters.isEmpty())
        {
            StringBuilder cb = new StringBuilder("\u540c\u7ae0\u8054\u52a8\uff1a");
            int i = 0;
            for (String c : clusters)
            {
                if (i++ > 0)
                {
                    cb.append("\uff1b");
                }
                cb.append(c);
                if (i >= 2)
                {
                    break;
                }
            }
            cb.append("\u3002\u5efa\u8bae\u6309\u7ae0\u8282\u6574\u4f53\u590d\u4e60\uff0c\u907f\u514d\u53ea\u7ec3\u5355\u70b9\u3002");
            advice.add(cb.toString());
        }

        Map<String, Object> qtype = asMap(data.get("questionType"));
        List<Map<String, Object>> qItems = castList(qtype.get("items"));
        Map<String, Object> worstType = null;
        Map<String, Object> bestType = null;
        double worstRate = 2;
        double bestRate = -1;
        for (Map<String, Object> row : qItems)
        {
            Double rate = toRate01(row.get("avgRate"));
            if (rate == null)
            {
                continue;
            }
            if (rate < worstRate)
            {
                worstRate = rate;
                worstType = row;
            }
            if (rate > bestRate)
            {
                bestRate = rate;
                bestType = row;
            }
        }
        if (worstType != null && worstRate < 0.55)
        {
            advice.add("\u9898\u578b\u7a81\u7834\uff1a\u4f18\u5148\u7ec3\u300c"
                + firstStr(worstType, "typeName", "typeCode") + "\u300d\uff08\u5f97\u5206\u7387 "
                + fmtRate(worstType.get("avgRate")) + "\uff09\uff0c\u5148\u638c\u63e1\u9898\u578b\u89e3\u6cd5\u518d\u63d0\u901f\u3002");
        }
        if (bestType != null && bestRate >= 0.7 && bestType != worstType)
        {
            advice.add("\u4f18\u52bf\u4fdd\u6301\uff1a\u300c" + firstStr(bestType, "typeName", "typeCode")
                + "\u300d\u8868\u73b0\u8f83\u597d\uff08" + fmtRate(bestType.get("avgRate"))
                + "\uff09\uff0c\u53ef\u7528\u4f5c\u7a33\u5b9a\u5206\u6761\u5e26\u3002");
        }

        List<Map<String, Object>> persist = castList(data.get("persistentWeak"));
        if (!persist.isEmpty())
        {
            advice.add("\u5b58\u5728\u53cd\u590d\u8584\u5f31 " + persist.size()
                + " \u9879\uff0c\u5efa\u8bae\u5728\u7cfb\u7edf\u5efa\u7acb\u5e72\u9884\u4efb\u52a1\u5e76\u5728\u4e0b\u6b21\u8003\u8bd5\u9a8c\u6536\u3002");
        }
        Map<String, Object> chapterDelta = asMap(data.get("chapterDelta"));
        List<Map<String, Object>> declined = castList(chapterDelta.get("declined"));
        if (!declined.isEmpty())
        {
            StringBuilder db = new StringBuilder("\u7ae0\u8282\u9000\u6b65\u9700\u56de\u987e\uff1a");
            int n = Math.min(2, declined.size());
            for (int i = 0; i < n; i++)
            {
                if (i > 0)
                {
                    db.append("\u3001");
                }
                db.append(str(declined.get(i).get("chapterName"), ""));
            }
            db.append("\u3002");
            advice.add(db.toString());
        }
        int openIv = toIntSafe(data.get("openInterveneCount"));
        if (openIv > 0)
        {
            advice.add("\u5f53\u524d\u6709 " + openIv + " \u9879\u8fdb\u884c\u4e2d\u5e72\u9884\uff0c\u8bf7\u5148\u5b8c\u6210\u5e76\u56de\u586b\u6548\u679c\u3002");
        }
        advice.add("\u9a8c\u6536\uff1a\u8865\u7ec3\u540e\u91cd\u7b97\u6216\u5bf9\u7167\u4e0b\u6b21\u6708\u8003\u73ed\u5747\u3002");
        // Cap for duplex PDF budget
        if (advice.size() > 4)
        {
            data.put("studyAdvice", new ArrayList<String>(advice.subList(0, 4)));
        }
        else
        {
            data.put("studyAdvice", advice);
        }

        Map<String, Object> bloom = asMap(data.get("bloom"));
        List<Map<String, Object>> bloomItems = castList(bloom.get("items"));
        boolean bloomUseful = false;
        for (Map<String, Object> row : bloomItems)
        {
            String label = firstStr(row, "bloomLabel", "bloomLevel");
            if (StringUtils.isNotEmpty(label) && label.indexOf("\u672a\u6807\u6ce8") < 0)
            {
                bloomUseful = true;
                break;
            }
        }
        data.put("bloomUseful", Boolean.valueOf(bloomUseful));
    }

    private Map<String, Object> copyPriorityRow(Map<String, Object> row, String reason)
    {
        Map<String, Object> p = new HashMap<String, Object>();
        p.put("name", firstStr(row, "name", "knowledgeName"));
        p.put("knowledgeId", first(row, "knowledgeId", "id"));
        p.put("rate", first(row, "rate", "weightedRate"));
        p.put("gap", row.get("gap"));
        p.put("attemptCount", first(row, "attemptCount", "attempts"));
        p.put("statusLabel", row.get("statusLabel"));
        p.put("rootHint", row.get("rootHint"));
        p.put("reason", reason);
        return p;
    }

    private static boolean resolveEvidenceOk(Map<String, Object> row, int minAttempts)
    {
        if (row.get("evidenceOk") instanceof Boolean)
        {
            return Boolean.TRUE.equals(row.get("evidenceOk"));
        }
        int attempts = toIntSafe(first(row, "attemptCount", "attempts"));
        return attempts >= minAttempts;
    }

    private static int toIntSafe(Object v)
    {
        if (v == null)
        {
            return 0;
        }
        try
        {
            return Integer.parseInt(String.valueOf(v).trim().replaceAll("\\.0$", ""));
        }
        catch (Exception e)
        {
            return 0;
        }
    }

    private static Double toRate01(Object v)
    {
        if (v == null)
        {
            return null;
        }
        try
        {
            BigDecimal bd = new BigDecimal(String.valueOf(v));
            if (bd.compareTo(BigDecimal.ONE) > 0)
            {
                bd = bd.divide(BigDecimal.valueOf(100), 6, RoundingMode.HALF_UP);
            }
            return Double.valueOf(bd.doubleValue());
        }
        catch (Exception e)
        {
            return null;
        }
    }

    private void applyRecencyOverride(Boolean useRecency)
    {
        if (useRecency == null)
        {
            return;
        }
        if (Boolean.FALSE.equals(useRecency))
        {
            KnowledgeStatCalculator.setRecencyOverride(Integer.valueOf(0));
        }
        else
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    private String buildScopeLabel(String scopeMode, List<Long> paperIds, Boolean useRecency,
        Map<String, Object> summary, Long subjectId)
    {
        StringBuilder sb = new StringBuilder();
        if (subjectId == null || (summary != null && Boolean.TRUE.equals(summary.get("allSubjects"))))
        {
            sb.append("\u6240\u6709\u79d1\u76ee");
        }
        else
        {
            sb.append("\u5355\u79d1");
        }
        sb.append(" / ");
        if ("papers".equals(scopeMode))
        {
            int n = paperIds == null ? 0 : paperIds.size();
            sb.append("\u9009\u5377\u8bca\u65ad\u00b7").append(n).append("\u573a");
        }
        else if ("semester".equals(scopeMode))
        {
            sb.append("\u672c\u5b66\u671f");
        }
        else if ("prev_semester".equals(scopeMode))
        {
            sb.append("\u4e0a\u5b66\u671f");
        }
        else if ("last30d".equals(scopeMode))
        {
            sb.append("\u8fd130\u5929");
        }
        else if ("last90d".equals(scopeMode))
        {
            sb.append("\u8fd190\u5929");
        }
        else
        {
            sb.append("\u5168\u90e8\u5feb\u7167");
        }
        if (summary != null && summary.get("dataMode") != null)
        {
            sb.append(" / ").append(summary.get("dataMode"));
        }
        if (Boolean.FALSE.equals(useRecency))
        {
            sb.append(" / \u5173\u95ed\u8fd1\u56e0");
        }
        else
        {
            sb.append(" / \u8fd1\u56e0\u5f00");
        }
        return sb.toString();
    }

    @Override
    public Map<String, Object> previewClass(Long deptId, Long subjectId)
    {
        return previewClass(deptId, subjectId, null, null);
    }

    @Override
    public Map<String, Object> previewClass(Long deptId, Long subjectId, String window, List<Long> paperIds)
    {
        accessService.checkClassAnalysisDept(deptId);
        Map<String, Object> overview = analysisService.classOverview(deptId, subjectId, window, paperIds);
        if (overview == null || overview.isEmpty())
        {
            throw new ServiceException(MSG_NO_DATA);
        }
        Map<String, Object> data = new HashMap<>();
        data.put("overview", overview);
        data.put("weakTop", analysisService.classWeakTop(deptId, subjectId, 15, window, paperIds));
        data.put("questionType", analysisService.classQuestionType(deptId, subjectId, window, paperIds));
        data.put("bloom", analysisService.classBloom(deptId, subjectId, window, paperIds));
        data.put("chapterDelta", analysisService.classChapterDelta(deptId, subjectId, window, paperIds, "prev_semester"));
        data.put("examPapers", buildExamPapers(paperIds));
        boolean papers = paperIds != null && !paperIds.isEmpty();
        String scopeMode = papers ? "papers" : (window != null && !window.trim().isEmpty() ? window.trim() : "all");
        data.put("scopeMode", scopeMode);
        data.put("window", window);
        data.put("scopeLabel", buildScopeLabel(scopeMode, paperIds, null, overview, subjectId));
        data.put("dimensionRateNote",
            "\u9898\u578b/\u80fd\u529b\u5c42\u7ea7\u5f97\u5206\u7387\u4e3a\u5377\u9762 sum(\u5f97\u5206)/sum(\u6ee1\u5206)\uff0c\u4e0e\u77e5\u8bc6\u70b9\u52a0\u6743\u638c\u63e1\u5ea6\u4e0d\u540c\u53e3\u5f84");
        data.put("generatedAt", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        return data;
    }

    @Override
    public void exportStudent(Long studentId, Long subjectId, String format, HttpServletResponse response)
    {
        exportStudent(studentId, subjectId, null, null, null, null, format, response);
    }

    @Override
    public void exportStudent(Long studentId, Long subjectId, String window, List<Long> paperIds, String format,
        HttpServletResponse response)
    {
        exportStudent(studentId, subjectId, window, paperIds, null, null, format, response);
    }

    @Override
    public void exportStudent(Long studentId, Long subjectId, String window, List<Long> paperIds, Boolean useRecency,
        Integer limit, String format, HttpServletResponse response)
    {
        Map<String, Object> data = previewStudent(studentId, subjectId, window, paperIds, useRecency, limit);
        String base = buildStudentFileName(data);
        try
        {
            if (isPdf(format))
            {
                writePdf(response, base + ".pdf", out -> SpasReportPdfWriter.writeStudent(out, data));
            }
            else if (isXlsx(format))
            {
                writeXlsx(response, base + ".xlsx", wb -> fillStudentWorkbook(wb, data));
            }
            else
            {
                throw new ServiceException(MSG_BAD_FMT);
            }
        }
        catch (ServiceException e)
        {
            throw e;
        }
        catch (Exception e)
        {
            throw new ServiceException(e.getMessage());
        }
    }

    @Override
    public void exportClass(Long deptId, Long subjectId, String format, HttpServletResponse response)
    {
        exportClass(deptId, subjectId, null, null, format, response);
    }

    @Override
    public void exportClass(Long deptId, Long subjectId, String window, List<Long> paperIds, String format,
        HttpServletResponse response)
    {
        Map<String, Object> data = previewClass(deptId, subjectId, window, paperIds);
        String base = "class_report_" + deptId + "_" + System.currentTimeMillis();
        try
        {
            if (isPdf(format))
            {
                writePdf(response, base + ".pdf", out -> SpasReportPdfWriter.writeClass(out, data));
            }
            else if (isXlsx(format))
            {
                writeXlsx(response, base + ".xlsx", wb -> fillClassWorkbook(wb, data));
            }
            else
            {
                throw new ServiceException(MSG_BAD_FMT);
            }
        }
        catch (ServiceException e)
        {
            throw e;
        }
        catch (Exception e)
        {
            throw new ServiceException(e.getMessage());
        }
    }

    @Override
    public void exportClassBatch(Long parentDeptId, List<Long> deptIds, Long subjectId, String window,
        List<Long> paperIds, String format, HttpServletResponse response)
    {
        if (!isPdf(format) && !isXlsx(format))
        {
            throw new ServiceException(MSG_BAD_FMT);
        }
        LinkedHashSet<Long> ids = new LinkedHashSet<Long>();
        if (deptIds != null)
        {
            for (Long id : deptIds)
            {
                if (id != null)
                {
                    ids.add(id);
                }
            }
        }
        if (ids.isEmpty() && parentDeptId != null)
        {
            SysDept query = new SysDept();
            query.setParentId(parentDeptId);
            List<SysDept> children = deptService.selectDeptList(query);
            if (children != null)
            {
                for (SysDept child : children)
                {
                    if (child != null && child.getDeptId() != null && !"1".equals(child.getStatus()))
                    {
                        ids.add(child.getDeptId());
                    }
                }
            }
            if (ids.isEmpty())
            {
                ids.add(parentDeptId);
            }
        }
        if (ids.isEmpty())
        {
            throw new ServiceException("请选择年级或班级");
        }
        if (ids.size() > BATCH_MAX_CLASSES)
        {
            throw new ServiceException("一次最多导出 " + BATCH_MAX_CLASSES + " 个班级");
        }
        String ext = isPdf(format) ? "pdf" : "xlsx";
        String zipName = "class_reports_" + System.currentTimeMillis() + ".zip";
        response.setContentType("application/zip");
        try
        {
            FileUtils.setAttachmentResponseHeader(response, zipName);
        }
        catch (Exception e)
        {
            throw new ServiceException(e.getMessage());
        }
        int written = 0;
        try (ZipOutputStream zip = new ZipOutputStream(response.getOutputStream()))
        {
            for (Long deptId : ids)
            {
                Map<String, Object> data;
                try
                {
                    accessService.checkClassAnalysisDept(deptId);
                    data = previewClass(deptId, subjectId, window, paperIds);
                }
                catch (ServiceException ex)
                {
                    continue;
                }
                ByteArrayOutputStream bos = new ByteArrayOutputStream();
                if ("pdf".equals(ext))
                {
                    SpasReportPdfWriter.writeClass(bos, data);
                }
                else
                {
                    try (SXSSFWorkbook wb = new SXSSFWorkbook(100))
                    {
                        fillClassWorkbook(wb, data);
                        wb.write(bos);
                        wb.dispose();
                    }
                }
                SysDept dept = deptService.selectDeptById(deptId);
                String label = dept != null && StringUtils.isNotEmpty(dept.getDeptName())
                    ? dept.getDeptName() : String.valueOf(deptId);
                String entry = label.replaceAll("[\\\\/:*?\"<>|]", "_") + "_" + deptId + "." + ext;
                zip.putNextEntry(new ZipEntry(entry));
                zip.write(bos.toByteArray());
                zip.closeEntry();
                written++;
            }
            zip.finish();
        }
        catch (ServiceException e)
        {
            throw e;
        }
        catch (Exception e)
        {
            throw new ServiceException(e.getMessage());
        }
        if (written == 0)
        {
            throw new ServiceException(MSG_NO_DATA);
        }
    }

    @Override
    public void exportClassStudents(Long deptId, Long subjectId, String window, List<Long> paperIds,
        Boolean useRecency, Integer limit, String format, String jobId, HttpServletResponse response)
    {
        String progressJobId = sanitizeJobId(jobId);
        if (deptId == null)
        {
            putBatchProgress(progressJobId, "error", 0, 0, 0, "", "请选择班级");
            throw new ServiceException("请选择班级");
        }
        if (!isPdf(format) && !isXlsx(format))
        {
            putBatchProgress(progressJobId, "error", 0, 0, 0, "", MSG_BAD_FMT);
            throw new ServiceException(MSG_BAD_FMT);
        }
        accessService.checkClassAnalysisDept(deptId);
        // Prefer students who already have score rows (and optional subject filter).
        List<Long> studentIds = analysisMapper.selectStudentIdsForRecalc(deptId, subjectId);
        if (studentIds == null || studentIds.isEmpty())
        {
            putBatchProgress(progressJobId, "error", 0, 0, 0, "", "该班级在当前范围内暂无成绩数据");
            throw new ServiceException("该班级在当前范围内暂无成绩数据");
        }
        if (studentIds.size() > BATCH_MAX_STUDENTS)
        {
            String msg = "一次最多导出 " + BATCH_MAX_STUDENTS + " 名学生报告，请缩小学科/时间范围或分批导出";
            putBatchProgress(progressJobId, "error", studentIds.size(), 0, 0, "", msg);
            throw new ServiceException(msg);
        }
        List<SpasStudent> loaded = studentMapper.selectSpasStudentByIds(studentIds);
        Map<Long, SpasStudent> byId = new HashMap<Long, SpasStudent>();
        if (loaded != null)
        {
            for (SpasStudent st : loaded)
            {
                if (st != null && st.getStudentId() != null)
                {
                    byId.put(st.getStudentId(), st);
                }
            }
        }
        String ext = isPdf(format) ? "pdf" : "xlsx";
        SysDept dept = deptService.selectDeptById(deptId);
        String deptLabel = dept != null && StringUtils.isNotEmpty(dept.getDeptName())
            ? dept.getDeptName() : String.valueOf(deptId);
        String zipName = "class_students_" + deptLabel.replaceAll("[\\\\/:*?\"<>|]", "_") + "_"
            + System.currentTimeMillis() + ".zip";
        response.setContentType("application/zip");
        try
        {
            FileUtils.setAttachmentResponseHeader(response, zipName);
        }
        catch (Exception e)
        {
            putBatchProgress(progressJobId, "error", studentIds.size(), 0, 0, "", e.getMessage());
            throw new ServiceException(e.getMessage());
        }
        int total = studentIds.size();
        int written = 0;
        int skipped = 0;
        int processed = 0;
        putBatchProgress(progressJobId, "running", total, 0, 0, "准备打包…", null);
        Set<String> usedNames = new LinkedHashSet<String>();
        applyRecencyOverride(useRecency);
        try (ZipOutputStream zip = new ZipOutputStream(response.getOutputStream()))
        {
            for (Long studentId : studentIds)
            {
                if (studentId == null)
                {
                    processed++;
                    skipped++;
                    putBatchProgress(progressJobId, "running", total, processed, written, "跳过空学号", null);
                    continue;
                }
                SpasStudent st = byId.get(studentId);
                String label = st != null && StringUtils.isNotEmpty(st.getStudentName())
                    ? st.getStudentName()
                    : (st != null && StringUtils.isNotEmpty(st.getStudentNo()) ? st.getStudentNo()
                        : String.valueOf(studentId));
                putBatchProgress(progressJobId, "running", total, processed, written, "正在生成：" + label, null);
                Map<String, Object> data;
                try
                {
                    data = buildStudentPreview(studentId, subjectId, window, paperIds, useRecency, limit);
                }
                catch (ServiceException ex)
                {
                    // Skip students with no score data under current window / papers
                    processed++;
                    skipped++;
                    putBatchProgress(progressJobId, "running", total, processed, written, "跳过无成绩：" + label, null);
                    continue;
                }
                ByteArrayOutputStream bos = new ByteArrayOutputStream();
                if ("pdf".equals(ext))
                {
                    SpasReportPdfWriter.writeStudent(bos, data);
                }
                else
                {
                    try (SXSSFWorkbook wb = new SXSSFWorkbook(100))
                    {
                        fillStudentWorkbook(wb, data);
                        wb.write(bos);
                        wb.dispose();
                    }
                }
                String no = st != null && StringUtils.isNotEmpty(st.getStudentNo())
                    ? st.getStudentNo() : String.valueOf(studentId);
                String name = st != null && StringUtils.isNotEmpty(st.getStudentName()) ? st.getStudentName() : "";
                String entry = (no + (name.isEmpty() ? "" : ("_" + name))).replaceAll("[\\\\/:*?\"<>|]", "_");
                if (!usedNames.add(entry))
                {
                    entry = entry + "_" + studentId;
                }
                entry = entry + "." + ext;
                zip.putNextEntry(new ZipEntry(entry));
                zip.write(bos.toByteArray());
                zip.closeEntry();
                written++;
                processed++;
                putBatchProgress(progressJobId, "running", total, processed, written, "已完成：" + label, null);
            }
            zip.finish();
            if (written == 0)
            {
                putBatchProgress(progressJobId, "error", total, processed, 0, "", MSG_NO_DATA);
                throw new ServiceException(MSG_NO_DATA);
            }
            putBatchProgress(progressJobId, "done", total, processed, written,
                "打包完成，共 " + written + " 份" + (skipped > 0 ? ("（跳过 " + skipped + "）") : ""), null);
        }
        catch (ServiceException e)
        {
            putBatchProgress(progressJobId, "error", total, processed, written, "", e.getMessage());
            throw e;
        }
        catch (Exception e)
        {
            putBatchProgress(progressJobId, "error", total, processed, written, "", e.getMessage());
            throw new ServiceException(e.getMessage());
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @Override
    public Map<String, Object> getClassStudentsExportProgress(String jobId)
    {
        String id = sanitizeJobId(jobId);
        if (id == null)
        {
            Map<String, Object> empty = new HashMap<String, Object>();
            empty.put("status", "idle");
            empty.put("percent", Integer.valueOf(0));
            empty.put("total", Integer.valueOf(0));
            empty.put("processed", Integer.valueOf(0));
            empty.put("written", Integer.valueOf(0));
            empty.put("current", "");
            return empty;
        }
        Map<String, Object> cached = redisCache.getCacheObject(BATCH_PROGRESS_KEY + id);
        if (cached == null || cached.isEmpty())
        {
            Map<String, Object> pending = new HashMap<String, Object>();
            pending.put("status", "pending");
            pending.put("percent", Integer.valueOf(0));
            pending.put("total", Integer.valueOf(0));
            pending.put("processed", Integer.valueOf(0));
            pending.put("written", Integer.valueOf(0));
            pending.put("current", "排队中…");
            return pending;
        }
        return cached;
    }

    private String sanitizeJobId(String jobId)
    {
        if (StringUtils.isEmpty(jobId))
        {
            return null;
        }
        String id = jobId.trim();
        if (id.length() > 64 || !id.matches("[A-Za-z0-9_-]+"))
        {
            return null;
        }
        return id;
    }

    private void putBatchProgress(String jobId, String status, int total, int processed, int written,
        String current, String message)
    {
        if (jobId == null)
        {
            return;
        }
        Map<String, Object> prog = new HashMap<String, Object>();
        prog.put("status", status);
        prog.put("total", Integer.valueOf(Math.max(total, 0)));
        prog.put("processed", Integer.valueOf(Math.max(processed, 0)));
        prog.put("written", Integer.valueOf(Math.max(written, 0)));
        prog.put("current", current == null ? "" : current);
        if (StringUtils.isNotEmpty(message))
        {
            prog.put("message", message);
        }
        int pct = 0;
        if (total > 0)
        {
            pct = (int) Math.min(100, Math.round(processed * 100.0 / total));
        }
        if ("done".equals(status))
        {
            pct = 100;
        }
        prog.put("percent", Integer.valueOf(pct));
        redisCache.setCacheObject(BATCH_PROGRESS_KEY + jobId, prog, BATCH_PROGRESS_TTL_MIN, TimeUnit.MINUTES);
    }

    private List<Map<String, Object>> buildExamPapers(List<Long> paperIds)
    {
        List<Map<String, Object>> list = new ArrayList<>();
        if (paperIds == null || paperIds.isEmpty())
        {
            return list;
        }
        for (Long id : paperIds)
        {
            if (id == null)
            {
                continue;
            }
            SpasPaper paper = paperMapper.selectSpasPaperById(id);
            if (paper == null)
            {
                continue;
            }
            Map<String, Object> row = new HashMap<>();
            row.put("paperId", paper.getPaperId());
            row.put("paperName", paper.getPaperName());
            row.put("examDate", paper.getExamDate());
            list.add(row);
        }
        return list;
    }

    private Map<String, Object> normalizeStudent(Object studentObj)
    {
        if (studentObj instanceof Map)
        {
            return (Map<String, Object>) studentObj;
        }
        Map<String, Object> map = new HashMap<>();
        if (studentObj instanceof SpasStudent)
        {
            SpasStudent s = (SpasStudent) studentObj;
            map.put("studentId", s.getStudentId());
            map.put("studentNo", s.getStudentNo());
            map.put("studentName", s.getStudentName());
            map.put("deptId", s.getDeptId());
            map.put("deptName", s.getDeptName());
        }
        return map;
    }

    @SuppressWarnings("unchecked")
    private void assertStudentHasData(Map<String, Object> data)
    {
        Map<String, Object> summary = asMap(data.get("summary"));
        Object rate = summary.get("overallRate");
        List<?> weak = asList(data.get("weakTop"));
        List<?> trend = asList(data.get("trend"));
        if (rate == null && (weak == null || weak.isEmpty()) && (trend == null || trend.isEmpty()))
        {
            throw new ServiceException(MSG_NO_DATA);
        }
    }

    @SuppressWarnings("unchecked")
    private String buildStudentFileName(Map<String, Object> data)
    {
        Map<String, Object> student = asMap(data.get("student"));
        String no = str(student.get("studentNo"), "student");
        return "student_report_" + no + "_" + System.currentTimeMillis();
    }

    private boolean isPdf(String format)
    {
        return format == null || "pdf".equalsIgnoreCase(format.trim());
    }

    private boolean isXlsx(String format)
    {
        String f = format == null ? "" : format.trim().toLowerCase();
        return "xlsx".equals(f) || "excel".equals(f) || "xls".equals(f);
    }

    private interface PdfWriter
    {
        void write(java.io.OutputStream out) throws Exception;
    }

    private interface XlsxWriter
    {
        void write(SXSSFWorkbook wb) throws Exception;
    }

    private void writePdf(HttpServletResponse response, String fileName, PdfWriter writer) throws Exception
    {
        response.setContentType("application/pdf");
        FileUtils.setAttachmentResponseHeader(response, fileName);
        writer.write(response.getOutputStream());
        response.getOutputStream().flush();
    }

    private void writeXlsx(HttpServletResponse response, String fileName, XlsxWriter writer) throws Exception
    {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        FileUtils.setAttachmentResponseHeader(response, fileName);
        try (SXSSFWorkbook wb = new SXSSFWorkbook(100))
        {
            writer.write(wb);
            wb.write(response.getOutputStream());
        }
        response.getOutputStream().flush();
    }

    @SuppressWarnings("unchecked")
    private void fillStudentWorkbook(SXSSFWorkbook wb, Map<String, Object> data)
    {
        Map<String, Object> student = asMap(data.get("student"));
        Map<String, Object> summary = asMap(data.get("summary"));

        Sheet cover = wb.createSheet("summary");
        int r = 0;
        r = kv(cover, r, "\u5b66\u53f7", str(student.get("studentNo"), ""));
        r = kv(cover, r, "\u59d3\u540d", str(student.get("studentName"), ""));
        r = kv(cover, r, "\u5206\u6790\u53e3\u5f84", str(data.get("scopeLabel"), ""));
        r = kv(cover, r, "\u6458\u8981", str(summary.get("headline"), ""));
        r = kv(cover, r, "\u7efc\u5408\u5f97\u5206\u7387", fmtRate(summary.get("overallRate")));
        r = kv(cover, r, "\u73ed\u5747", fmtRate(summary.get("classAvgRate")));
        r = kv(cover, r, "\u4e0e\u73ed\u5dee", fmtGap(summary.get("gap")));
        r = kv(cover, r, "\u4e25\u91cd/\u8584\u5f31/\u5173\u6ce8",
            str(summary.get("severeCount"), "0") + "/" + str(summary.get("weakCount"), "0") + "/" + str(summary.get("watchCount"), "0"));
        r = kv(cover, r, "\u7f6e\u4fe1\u5ea6",
            str(first(summary, "confidenceLabel", "confidence"), ""));
        r = kv(cover, r, "\u751f\u6210\u65f6\u95f4", str(data.get("generatedAt"), ""));
        r = kv(cover, r, "\u5b9a\u7ea7\u8bf4\u660e", str(data.get("evidenceNote"), ""));
        List<String> adviceLines = new ArrayList<String>();
        Object adviceObj = data.get("studyAdvice");
        if (adviceObj instanceof List)
        {
            for (Object item : (List<?>) adviceObj)
            {
                if (item != null)
                {
                    adviceLines.add(String.valueOf(item));
                }
            }
        }
        for (int ai = 0; ai < adviceLines.size(); ai++)
        {
            r = kv(cover, r, "\u5efa\u8bae" + (ai + 1), adviceLines.get(ai));
        }

        Sheet guide = wb.createSheet("guidance");
        Row gh = guide.createRow(0);
        gh.createCell(0).setCellValue("\u4f18\u5148\u8865\u5f31");
        gh.createCell(1).setCellValue("\u5f97\u5206\u7387");
        gh.createCell(2).setCellValue("\u7b49\u7ea7");
        gh.createCell(3).setCellValue("\u7406\u7531");
        List<Map<String, Object>> priority = castList(data.get("priorityRemediate"));
        int gi = 1;
        for (Map<String, Object> row : priority)
        {
            Row rr = guide.createRow(gi++);
            rr.createCell(0).setCellValue(firstStr(row, "name", "knowledgeName"));
            rr.createCell(1).setCellValue(fmtRate(first(row, "rate", "weightedRate")));
            rr.createCell(2).setCellValue(str(row.get("statusLabel"), ""));
            rr.createCell(3).setCellValue(str(row.get("reason"), ""));
        }

        Sheet weak = wb.createSheet("weak");
        Row h = weak.createRow(0);
        String[] heads = {"\u77e5\u8bc6\u70b9", "\u5f97\u5206\u7387", "\u73ed\u5747", "\u4e0e\u73ed\u5dee", "\u7ec3\u4e60\u6b21\u6570", "\u7b49\u7ea7", "\u6839\u56e0\u63d0\u793a"};
        for (int i = 0; i < heads.length; i++)
        {
            h.createCell(i).setCellValue(heads[i]);
        }
        List<Map<String, Object>> weakList = castList(data.get("weakTop"));
        int wi = 1;
        for (Map<String, Object> row : weakList)
        {
            Row rr = weak.createRow(wi++);
            rr.createCell(0).setCellValue(firstStr(row, "name", "knowledgeName"));
            rr.createCell(1).setCellValue(fmtRate(first(row, "rate", "weightedRate")));
            rr.createCell(2).setCellValue(fmtRate(row.get("classAvgRate")));
            rr.createCell(3).setCellValue(fmtGap(row.get("gap")));
            rr.createCell(4).setCellValue(str(first(row, "attemptCount", "attempts"), "0"));
            rr.createCell(5).setCellValue(str(row.get("statusLabel"),
                fmtWeakLevel(first(row, "weakLevel", "level", "masteryLevel"))));
            rr.createCell(6).setCellValue(str(row.get("rootHint"), ""));
        }

        Sheet trend = wb.createSheet("trend");
        Row th = trend.createRow(0);
        th.createCell(0).setCellValue("\u8bd5\u5377/\u4f5c\u4e1a");
        th.createCell(1).setCellValue("\u8003\u8bd5\u65e5\u671f");
        th.createCell(2).setCellValue("\u5f97\u5206\u7387");
        th.createCell(3).setCellValue("\u73ed\u5747");
        List<Map<String, Object>> trends = castList(data.get("trend"));
        int ti = 1;
        for (Map<String, Object> row : trends)
        {
            Row rr = trend.createRow(ti++);
            rr.createCell(0).setCellValue(firstStr(row, "paperName", "name"));
            rr.createCell(1).setCellValue(str(first(row, "examDate", "paperDate"), ""));
            rr.createCell(2).setCellValue(fmtRate(first(row, "rate", "scoreRate")));
            rr.createCell(3).setCellValue(fmtRate(row.get("classAvgRate")));
        }

        Sheet coach = wb.createSheet("intervene");
        Row ch = coach.createRow(0);
        ch.createCell(0).setCellValue("\u7c7b\u578b");
        ch.createCell(1).setCellValue("\u6807\u9898");
        ch.createCell(2).setCellValue("\u72b6\u6001/\u5185\u5bb9");
        ch.createCell(3).setCellValue("\u65f6\u95f4");
        List<Map<String, Object>> timeline = castList(data.get("interveneTimeline"));
        int ci = 1;
        for (Map<String, Object> row : timeline)
        {
            Row rr = coach.createRow(ci++);
            rr.createCell(0).setCellValue(str(row.get("type"), ""));
            rr.createCell(1).setCellValue(str(row.get("title"), ""));
            rr.createCell(2).setCellValue(str(first(row, "content", "status"), ""));
            rr.createCell(3).setCellValue(str(first(row, "time", "createTime"), ""));
        }

        List<Map<String, Object>> causes = castList(data.get("errorCauseSummary"));
        if (!causes.isEmpty())
        {
            Sheet cause = wb.createSheet("error_cause");
            Row eh = cause.createRow(0);
            eh.createCell(0).setCellValue("\u9519\u56e0\u5927\u7c7b");
            eh.createCell(1).setCellValue("\u9898\u6570");
            int ei = 1;
            for (Map<String, Object> row : causes)
            {
                Row rr = cause.createRow(ei++);
                rr.createCell(0).setCellValue(firstStr(row, "errorCategoryLabel", "errorLabel", "causeLabel"));
                rr.createCell(1).setCellValue(str(first(row, "tagCount", "count"), "0"));
            }
        }

        Map<String, Object> examRank = asMap(data.get("examRank"));
        List<Map<String, Object>> rankSubjects = castList(examRank.get("subjects"));
        if (!rankSubjects.isEmpty())
        {
            Sheet rank = wb.createSheet("exam_rank");
            Row rh = rank.createRow(0);
            rh.createCell(0).setCellValue("\u79d1\u76ee");
            rh.createCell(1).setCellValue("\u6821\u6b21\u8f68\u8ff9");
            rh.createCell(2).setCellValue("\u8f83\u4e0a\u6b21");
            rh.createCell(3).setCellValue("\u7ed3\u8bba");
            rh.createCell(4).setCellValue("\u8584\u5f31\u89e3\u91ca");
            int ri = 1;
            for (Map<String, Object> row : rankSubjects)
            {
                Row rr = rank.createRow(ri++);
                rr.createCell(0).setCellValue(str(row.get("subjectName"), ""));
                rr.createCell(1).setCellValue(str(row.get("track"), ""));
                rr.createCell(2).setCellValue(str(row.get("stepDelta"), ""));
                rr.createCell(3).setCellValue(str(row.get("trendLabel"), ""));
                rr.createCell(4).setCellValue(str(row.get("explain"), ""));
            }
        }

        writeDimensionSheets(wb, data);
    }

    @SuppressWarnings("unchecked")
    private void fillClassWorkbook(SXSSFWorkbook wb, Map<String, Object> data)
    {
        Map<String, Object> overview = asMap(data.get("overview"));
        Sheet cover = wb.createSheet("summary");
        int r = 0;
        r = kv(cover, r, "\u6458\u8981", str(overview.get("headline"), ""));
        r = kv(cover, r, "\u5206\u6790\u53e3\u5f84", str(data.get("scopeLabel"), ""));
        r = kv(cover, r, "\u5b66\u751f\u6570", str(overview.get("studentCount"), "0"));
        r = kv(cover, r, "\u73ed\u5747\u5f97\u5206\u7387", fmtRate(first(overview, "avgRate", "classAvgRate")));
        r = kv(cover, r, "\u8584\u5f31\u5b66\u751f\u6570", str(overview.get("weakStudentCount"), "0"));
        r = kv(cover, r, "\u751f\u6210\u65f6\u95f4", str(data.get("generatedAt"), ""));

        Sheet rank = wb.createSheet("ranking");
        Row rh = rank.createRow(0);
        rh.createCell(0).setCellValue("\u5b66\u53f7");
        rh.createCell(1).setCellValue("\u59d3\u540d");
        rh.createCell(2).setCellValue("\u5f97\u5206\u7387");
        rh.createCell(3).setCellValue("\u8584\u5f31\u6570");
        List<Map<String, Object>> ranking = castList(overview.get("studentRanking"));
        int i = 1;
        int limit = Math.min(50, ranking.size());
        for (int idx = 0; idx < limit; idx++)
        {
            Map<String, Object> row = ranking.get(idx);
            Row rr = rank.createRow(i++);
            rr.createCell(0).setCellValue(str(row.get("studentNo"), ""));
            rr.createCell(1).setCellValue(str(row.get("studentName"), ""));
            rr.createCell(2).setCellValue(fmtRate(first(row, "overallRate", "rate")));
            rr.createCell(3).setCellValue(str(first(row, "weakCount", "severeCount"), "0"));
        }

        Sheet weak = wb.createSheet("weak");
        Row wh = weak.createRow(0);
        wh.createCell(0).setCellValue("\u77e5\u8bc6\u70b9");
        wh.createCell(1).setCellValue("\u73ed\u5747");
        wh.createCell(2).setCellValue("\u8584\u5f31\u5b66\u751f\u6570");
        wh.createCell(3).setCellValue("\u6839\u56e0\u63d0\u793a");
        List<Map<String, Object>> weakTop = castList(data.get("weakTop"));
        int wi = 1;
        for (Map<String, Object> row : weakTop)
        {
            Row rr = weak.createRow(wi++);
            rr.createCell(0).setCellValue(firstStr(row, "name", "knowledgeName"));
            rr.createCell(1).setCellValue(fmtRate(first(row, "avgRate", "classAvgRate", "rate")));
            rr.createCell(2).setCellValue(str(first(row, "weakStudentCount", "studentCount"), "0"));
            rr.createCell(3).setCellValue(str(row.get("rootHint"), ""));
        }

        writeDimensionSheets(wb, data);
    }

    /** D1/D4/D3 sheets shared by student & class Excel export. */
    private void writeDimensionSheets(SXSSFWorkbook wb, Map<String, Object> data)
    {
        Map<String, Object> qtype = asMap(data.get("questionType"));
        List<Map<String, Object>> qItems = castList(qtype.get("items"));
        if (!qItems.isEmpty())
        {
            Sheet sheet = wb.createSheet("question_type");
            Row h = sheet.createRow(0);
            h.createCell(0).setCellValue("\u9898\u578b");
            h.createCell(1).setCellValue("\u9898\u91cf");
            h.createCell(2).setCellValue("\u6837\u672c");
            h.createCell(3).setCellValue("\u5f97\u5206\u7387");
            int ri = 1;
            for (Map<String, Object> row : qItems)
            {
                Row rr = sheet.createRow(ri++);
                rr.createCell(0).setCellValue(firstStr(row, "typeName", "typeCode"));
                rr.createCell(1).setCellValue(str(row.get("questionCount"), "0"));
                rr.createCell(2).setCellValue(str(row.get("attemptCount"), "0"));
                rr.createCell(3).setCellValue(fmtRate(row.get("avgRate")));
            }
        }

        Map<String, Object> bloom = asMap(data.get("bloom"));
        List<Map<String, Object>> bItems = castList(bloom.get("items"));
        if (!bItems.isEmpty())
        {
            Sheet sheet = wb.createSheet("bloom");
            int start = 0;
            if (bloom.get("insight") != null)
            {
                start = kv(sheet, 0, "\u89e3\u8bfb", str(bloom.get("insight"), ""));
                start++;
            }
            Row h = sheet.createRow(start);
            h.createCell(0).setCellValue("\u5c42\u7ea7");
            h.createCell(1).setCellValue("\u9898\u91cf");
            h.createCell(2).setCellValue("\u6837\u672c");
            h.createCell(3).setCellValue("\u5f97\u5206\u7387");
            int ri = start + 1;
            for (Map<String, Object> row : bItems)
            {
                Row rr = sheet.createRow(ri++);
                rr.createCell(0).setCellValue(firstStr(row, "bloomLabel", "bloomLevel"));
                rr.createCell(1).setCellValue(str(row.get("questionCount"), "0"));
                rr.createCell(2).setCellValue(str(row.get("attemptCount"), "0"));
                rr.createCell(3).setCellValue(fmtRate(row.get("avgRate")));
            }
        }

        Map<String, Object> chapterDelta = asMap(data.get("chapterDelta"));
        List<Map<String, Object>> improved = castList(chapterDelta.get("improved"));
        List<Map<String, Object>> declined = castList(chapterDelta.get("declined"));
        if (!improved.isEmpty() || !declined.isEmpty())
        {
            Sheet sheet = wb.createSheet("chapter_delta");
            int r = 0;
            if (chapterDelta.get("headline") != null)
            {
                r = kv(sheet, r, "\u6458\u8981", str(chapterDelta.get("headline"), ""));
                r++;
            }
            Row h = sheet.createRow(r);
            h.createCell(0).setCellValue("\u7c7b\u578b");
            h.createCell(1).setCellValue("\u7ae0\u8282");
            h.createCell(2).setCellValue("\u53d8\u5316");
            int ri = r + 1;
            for (Map<String, Object> row : improved)
            {
                Row rr = sheet.createRow(ri++);
                rr.createCell(0).setCellValue("\u8fdb\u6b65");
                rr.createCell(1).setCellValue(str(row.get("chapterName"), ""));
                rr.createCell(2).setCellValue(fmtRate(row.get("deltaRate")));
            }
            for (Map<String, Object> row : declined)
            {
                Row rr = sheet.createRow(ri++);
                rr.createCell(0).setCellValue("\u9000\u6b65");
                rr.createCell(1).setCellValue(str(row.get("chapterName"), ""));
                rr.createCell(2).setCellValue(fmtRate(row.get("deltaRate")));
            }
        }
    }

    private int kv(Sheet sheet, int rowIdx, String k, String v)
    {
        Row row = sheet.createRow(rowIdx);
        row.createCell(0).setCellValue(k);
        row.createCell(1).setCellValue(v);
        return rowIdx + 1;
    }

    private static Map<String, Object> asMap(Object o)
    {
        if (o instanceof Map)
        {
            return (Map<String, Object>) o;
        }
        return new HashMap<>();
    }

    private static List<?> asList(Object o)
    {
        if (o instanceof List)
        {
            return (List<?>) o;
        }
        return new ArrayList<>();
    }

    @SuppressWarnings("unchecked")
    private static List<Map<String, Object>> castList(Object o)
    {
        List<Map<String, Object>> list = new ArrayList<>();
        if (!(o instanceof List))
        {
            return list;
        }
        for (Object item : (List<?>) o)
        {
            if (item instanceof Map)
            {
                list.add((Map<String, Object>) item);
            }
        }
        return list;
    }

    private static Object first(Map<String, Object> map, String... keys)
    {
        for (String k : keys)
        {
            Object v = map.get(k);
            if (v != null)
            {
                return v;
            }
        }
        return null;
    }

    private static String firstStr(Map<String, Object> map, String... keys)
    {
        return str(first(map, keys), "");
    }

    private static String str(Object v, String def)
    {
        return v == null ? def : String.valueOf(v);
    }

    private static String fmtRate(Object v)
    {
        if (v == null)
        {
            return "-";
        }
        try
        {
            BigDecimal bd = new BigDecimal(String.valueOf(v));
            if (bd.compareTo(BigDecimal.ONE) <= 0)
            {
                bd = bd.multiply(BigDecimal.valueOf(100));
            }
            return bd.setScale(1, RoundingMode.HALF_UP).toPlainString() + "%";
        }
        catch (Exception e)
        {
            return String.valueOf(v);
        }
    }

    private static String fmtGap(Object v)
    {
        if (v == null)
        {
            return "-";
        }
        try
        {
            BigDecimal bd = new BigDecimal(String.valueOf(v));
            if (bd.abs().compareTo(BigDecimal.ONE) <= 0)
            {
                bd = bd.multiply(BigDecimal.valueOf(100));
            }
            String s = bd.setScale(1, RoundingMode.HALF_UP).toPlainString() + "%";
            return bd.compareTo(BigDecimal.ZERO) > 0 ? "+" + s : s;
        }
        catch (Exception e)
        {
            return String.valueOf(v);
        }
    }

    /** Map weak_level code to Chinese label used on analysis page. */
    private static String fmtWeakLevel(Object v)
    {
        if (v == null)
        {
            return "";
        }
        String s = String.valueOf(v).trim();
        if ("3".equals(s))
        {
            return "\u4e25\u91cd";
        }
        if ("2".equals(s))
        {
            return "\u8584\u5f31";
        }
        if ("1".equals(s))
        {
            return "\u5173\u6ce8";
        }
        if ("0".equals(s))
        {
            return "\u6b63\u5e38";
        }
        return s;
    }
}
