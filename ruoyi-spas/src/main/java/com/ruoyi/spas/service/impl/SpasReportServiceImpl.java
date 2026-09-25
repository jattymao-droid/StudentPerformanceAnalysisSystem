package com.ruoyi.spas.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.file.FileUtils;
import com.ruoyi.spas.analysis.KnowledgeStatCalculator;
import com.ruoyi.spas.domain.SpasPaper;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.mapper.SpasPaperMapper;
import com.ruoyi.spas.service.ISpasAnalysisService;
import com.ruoyi.spas.service.ISpasPortfolioService;
import com.ruoyi.spas.service.ISpasReportService;
import com.ruoyi.spas.service.impl.SpasExamRankTrendService;
import com.ruoyi.spas.support.SpasAccessService;
import com.ruoyi.spas.support.SpasReportPdfWriter;

@Service
public class SpasReportServiceImpl implements ISpasReportService
{
    private static final String MSG_NO_DATA = "\u6682\u65e0\u6210\u7ee9\u6570\u636e\uff0c\u65e0\u6cd5\u5bfc\u51fa\u62a5\u544a";
    private static final String MSG_BAD_FMT = "\u4e0d\u652f\u6301\u7684\u5bfc\u51fa\u683c\u5f0f\uff0c\u8bf7\u4f7f\u7528 pdf / xlsx";

    @Autowired
    private ISpasPortfolioService portfolioService;

    @Autowired
    private ISpasAnalysisService analysisService;

    @Autowired
    private SpasAccessService accessService;

    @Autowired
    private SpasPaperMapper paperMapper;

    @Autowired
    private SpasExamRankTrendService examRankTrendService;

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
        // Portfolio supplies coach / warnings / timeline / errorCause (lifetime, not window-scoped).
        Map<String, Object> data = portfolioService.getPortfolio(studentId, subjectId);
        data.put("student", normalizeStudent(data.get("student")));

        int weakLimit = (limit == null || limit.intValue() <= 0) ? 10 : limit.intValue();
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
        assertStudentHasData(data);
        data.put("generatedAt", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        return data;
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
            rr.createCell(5).setCellValue(fmtWeakLevel(first(row, "weakLevel", "level", "masteryLevel")));
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
