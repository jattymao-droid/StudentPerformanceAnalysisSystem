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
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.service.ISpasAnalysisService;
import com.ruoyi.spas.service.ISpasPortfolioService;
import com.ruoyi.spas.service.ISpasReportService;
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

    @Override
    public Map<String, Object> previewStudent(Long studentId, Long subjectId)
    {
        accessService.checkStudentAccess(studentId);
        Map<String, Object> data = portfolioService.getPortfolio(studentId, subjectId);
        data.put("student", normalizeStudent(data.get("student")));
        assertStudentHasData(data);
        data.put("generatedAt", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        return data;
    }

    @Override
    public Map<String, Object> previewClass(Long deptId, Long subjectId)
    {
        accessService.checkDeptAccess(deptId);
        Map<String, Object> overview = analysisService.classOverview(deptId, subjectId);
        if (overview == null || overview.isEmpty())
        {
            throw new ServiceException(MSG_NO_DATA);
        }
        Map<String, Object> data = new HashMap<>();
        data.put("overview", overview);
        data.put("weakTop", analysisService.classWeakTop(deptId, subjectId, 15));
        data.put("generatedAt", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        return data;
    }

    @Override
    public void exportStudent(Long studentId, Long subjectId, String format, HttpServletResponse response)
    {
        Map<String, Object> data = previewStudent(studentId, subjectId);
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
        Map<String, Object> data = previewClass(deptId, subjectId);
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
        r = kv(cover, r, "\u6458\u8981", str(summary.get("headline"), ""));
        r = kv(cover, r, "\u7efc\u5408\u5f97\u5206\u7387", fmtRate(summary.get("overallRate")));
        r = kv(cover, r, "\u73ed\u5747", fmtRate(summary.get("classAvgRate")));
        r = kv(cover, r, "\u4e0e\u73ed\u5dee", fmtGap(summary.get("gap")));
        r = kv(cover, r, "\u4e25\u91cd/\u8584\u5f31/\u5173\u6ce8",
            str(summary.get("severeCount"), "0") + "/" + str(summary.get("weakCount"), "0") + "/" + str(summary.get("watchCount"), "0"));
        r = kv(cover, r, "\u7f6e\u4fe1\u5ea6", str(summary.get("confidence"), ""));
        r = kv(cover, r, "\u751f\u6210\u65f6\u95f4", str(data.get("generatedAt"), ""));

        Sheet weak = wb.createSheet("weak");
        Row h = weak.createRow(0);
        String[] heads = {"\u77e5\u8bc6\u70b9", "\u5f97\u5206\u7387", "\u73ed\u5747", "\u4e0e\u73ed\u5dee", "\u7ec3\u4e60\u6b21\u6570", "\u7b49\u7ea7"};
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
            rr.createCell(5).setCellValue(str(first(row, "level", "masteryLevel"), ""));
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
    }

    @SuppressWarnings("unchecked")
    private void fillClassWorkbook(SXSSFWorkbook wb, Map<String, Object> data)
    {
        Map<String, Object> overview = asMap(data.get("overview"));
        Sheet cover = wb.createSheet("summary");
        int r = 0;
        r = kv(cover, r, "\u6458\u8981", str(overview.get("headline"), ""));
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
        List<Map<String, Object>> weakTop = castList(data.get("weakTop"));
        int wi = 1;
        for (Map<String, Object> row : weakTop)
        {
            Row rr = weak.createRow(wi++);
            rr.createCell(0).setCellValue(firstStr(row, "name", "knowledgeName"));
            rr.createCell(1).setCellValue(fmtRate(first(row, "avgRate", "classAvgRate", "rate")));
            rr.createCell(2).setCellValue(str(first(row, "weakStudentCount", "studentCount"), "0"));
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
}
