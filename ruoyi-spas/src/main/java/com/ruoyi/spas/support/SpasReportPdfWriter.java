package com.ruoyi.spas.support;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.springframework.core.env.Environment;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.spring.SpringUtils;

/**
 * OpenPDF writer for SPAS student/class reports.
 * Prefer bundled classpath font (fonts/spas-cjk.otf), then config path, then OS fonts.
 */
public final class SpasReportPdfWriter
{
    private static final String CLASSPATH_FONT = "/fonts/spas-cjk.otf";

    private static volatile BaseFont cachedBaseFont;

    private SpasReportPdfWriter()
    {
    }

    public static void writeRankTrend(OutputStream out, Map<String, Object> data) throws Exception
    {
        Font title = font(16, Font.BOLD);
        Font h2 = font(12, Font.BOLD);
        Font body = font(10, Font.NORMAL);
        Font small = font(8, Font.NORMAL);

        Document doc = new Document(PageSize.A4, 36, 36, 42, 42);
        PdfWriter.getInstance(doc, out);
        doc.open();

        Map<String, Object> student = asMap(data.get("student"));
        Map<String, Object> summary = asMap(data.get("summary"));

        Paragraph p = new Paragraph("\u5b9e\u8003\u6821\u6b21\u8fdb\u9000\u62a5\u544a", title);
        p.setAlignment(Element.ALIGN_CENTER);
        doc.add(p);
        doc.add(spacer(8));
        doc.add(line(body, "\u5b66\u53f7\uff1a" + str(student.get("studentNo"), "-")
            + "    \u59d3\u540d\uff1a" + str(student.get("studentName"), "-")
            + "    \u73ed\u7ea7\uff1a" + str(student.get("deptName"), "-")));
        doc.add(line(small, "\u53e3\u5f84\uff1a\u4ee5\u5404\u79d1\u6821\u6b21\u4e3a\u4e3b\uff08\u6570\u5b57\u53d8\u5c0f=\u8fdb\u6b65\uff09\uff1b\u8584\u5f31\u77e5\u8bc6\u70b9\u6765\u81ea\u5c0f\u9898\u638c\u63e1\u5ea6\u5206\u6790\uff0c\u7528\u4e8e\u89e3\u91ca\u6821\u6b21\u53d8\u5316\u3002"));
        doc.add(spacer(8));
        addHeading(doc, h2, "\u7efc\u5408\u5224\u65ad");
        doc.add(line(body, str(summary.get("headline"), "\u6682\u65e0")));
        doc.add(spacer(8));

        addHeading(doc, h2, "\u5404\u79d1\u6821\u6b21\u8fdb\u9000\u4e0e\u8865\u5f31\u89e3\u91ca");
        PdfPTable table = table(5);
        for (String h : new String[] {"\u79d1\u76ee", "\u6821\u6b21\u8f68\u8ff9", "\u8f83\u4e0a\u6b21", "\u7ed3\u8bba", "\u8584\u5f31\u89e3\u91ca"})
        {
            addCell(table, body, h, true);
        }
        List<Map<String, Object>> subjects = castList(data.get("subjects"));
        if (subjects.isEmpty())
        {
            addCell(table, body, "\u6682\u65e0\u5b9e\u8003\u6821\u6b21\u6570\u636e", false);
            addCell(table, body, "-", false);
            addCell(table, body, "-", false);
            addCell(table, body, "-", false);
            addCell(table, body, "-", false);
        }
        else
        {
            for (Map<String, Object> row : subjects)
            {
                addCell(table, body, str(row.get("subjectName"), "-"), false);
                addCell(table, body, str(row.get("track"), "-"), false);
                addCell(table, body, deltaText(row.get("stepDelta")), false);
                addCell(table, body, str(row.get("trendLabel"), "-"), false);
                addCell(table, small, str(row.get("explain"), "-"), false);
            }
        }
        doc.add(table);
        doc.add(spacer(10));

        addHeading(doc, h2, "\u5404\u6b21\u8003\u8bd5");
        PdfPTable exams = table(3);
        addCell(exams, body, "\u8003\u8bd5", true);
        addCell(exams, body, "\u65e5\u671f", true);
        addCell(exams, body, "\u8bf4\u660e", true);
        List<Map<String, Object>> examList = castList(data.get("exams"));
        if (examList.isEmpty())
        {
            addCell(exams, body, "\u6682\u65e0", false);
            addCell(exams, body, "-", false);
            addCell(exams, body, "-", false);
        }
        else
        {
            for (Map<String, Object> exam : examList)
            {
                addCell(exams, body, str(exam.get("examName"), "-"), false);
                addCell(exams, body, str(exam.get("examDate"), "-"), false);
                addCell(exams, body, "\u5b9e\u8003\u6821\u6b21\u5bfc\u5165", false);
            }
        }
        doc.add(exams);
        doc.close();
    }

    private static String deltaText(Object delta)
    {
        if (delta == null || "".equals(String.valueOf(delta)) || "null".equals(String.valueOf(delta)))
        {
            return "-";
        }
        int n;
        try
        {
            n = Integer.parseInt(String.valueOf(delta));
        }
        catch (Exception e)
        {
            return "-";
        }
        if (n > 0)
        {
            return "\u8fdb\u6b65 " + n;
        }
        if (n < 0)
        {
            return "\u9000\u6b65 " + Math.abs(n);
        }
        return "\u6301\u5e73";
    }

    public static void writeStudent(OutputStream out, Map<String, Object> data) throws Exception
    {
        Font title = font(16, Font.BOLD);
        Font h2 = font(12, Font.BOLD);
        Font body = font(10, Font.NORMAL);
        Font small = font(8, Font.NORMAL);

        Document doc = new Document(PageSize.A4, 42, 42, 48, 48);
        PdfWriter.getInstance(doc, out);
        doc.open();

        Map<String, Object> student = asMap(data.get("student"));
        Map<String, Object> summary = asMap(data.get("summary"));

        Paragraph p = new Paragraph(
            Boolean.TRUE.equals(data.get("allSubjects")) ? "\u5168\u79d1\u5b66\u60c5\u5206\u6790\u62a5\u544a" : "\u5b66\u60c5\u5206\u6790\u62a5\u544a",
            title);
        p.setAlignment(Element.ALIGN_CENTER);
        doc.add(p);
        doc.add(spacer(8));
        doc.add(line(body, "\u5b66\u53f7\uff1a" + str(student.get("studentNo"), "-")
            + "    \u59d3\u540d\uff1a" + str(student.get("studentName"), "-")));
        doc.add(line(body, "\u751f\u6210\u65f6\u95f4\uff1a" + str(data.get("generatedAt"), "-")));
        if (data.get("scopeLabel") != null)
        {
            doc.add(line(body, "\u5206\u6790\u53e3\u5f84\uff1a" + str(data.get("scopeLabel"), "-")));
        }
        if (data.get("portfolioScopeNote") != null)
        {
            doc.add(line(body, str(data.get("portfolioScopeNote"), "")));
        }
        if (data.get("dimensionRateNote") != null)
        {
            doc.add(line(body, str(data.get("dimensionRateNote"), "")));
        }
        doc.add(spacer(10));

        addHeading(doc, h2, "\u7efc\u5408\u6458\u8981");
        doc.add(line(body, str(summary.get("headline"), "\u6682\u65e0")));
        doc.add(spacer(6));

        addHeading(doc, h2, "\u5173\u952e\u6307\u6807");
        PdfPTable kpi = table(4);
        addCell(kpi, body, "\u7efc\u5408\u5f97\u5206\u7387", true);
        addCell(kpi, body, fmtRate(summary.get("overallRate")), false);
        addCell(kpi, body, "\u73ed\u5747", true);
        addCell(kpi, body, fmtRate(summary.get("classAvgRate")), false);
        addCell(kpi, body, "\u4e0e\u73ed\u5dee", true);
        addCell(kpi, body, fmtGap(summary.get("gap")), false);
        addCell(kpi, body, "\u7f6e\u4fe1\u5ea6", true);
        addCell(kpi, body, str(first(summary, "confidenceLabel", "confidence"), "-"), false);
        addCell(kpi, body, "\u4e25\u91cd", true);
        addCell(kpi, body, str(summary.get("severeCount"), "0"), false);
        addCell(kpi, body, "\u8584\u5f31", true);
        addCell(kpi, body, str(summary.get("weakCount"), "0"), false);
        addCell(kpi, body, "\u5173\u6ce8", true);
        addCell(kpi, body, str(summary.get("watchCount"), "0"), false);
        addCell(kpi, body, "\u7ec3\u4e60\u6b21\u6570", true);
        addCell(kpi, body, str(summary.get("totalAttempts"), "0"), false);
        doc.add(kpi);
        doc.add(spacer(10));

        List<Map<String, Object>> subjectBreakdown = castList(data.get("subjectBreakdown"));
        if (subjectBreakdown.isEmpty())
        {
            subjectBreakdown = castList(summary.get("subjectBreakdown"));
        }
        if (!subjectBreakdown.isEmpty())
        {
            addHeading(doc, h2, "\u5206\u79d1\u5f97\u5206\u6982\u89c8");
            PdfPTable sub = table(5);
            for (String h : new String[] {"\u5b66\u79d1", "\u5f97\u5206\u7387", "\u73ed\u5747", "\u8584\u5f31", "\u4e25\u91cd"})
            {
                addCell(sub, body, h, true);
            }
            int sn = Math.min(20, subjectBreakdown.size());
            for (int i = 0; i < sn; i++)
            {
                Map<String, Object> row = subjectBreakdown.get(i);
                addCell(sub, body, str(row.get("subjectName"), "-"), false);
                addCell(sub, body, fmtRate(row.get("overallRate")), false);
                addCell(sub, body, fmtRate(row.get("classAvgRate")), false);
                addCell(sub, body, str(row.get("weakCount"), "0"), false);
                addCell(sub, body, str(row.get("severeCount"), "0"), false);
            }
            doc.add(sub);
            doc.add(spacer(10));
        }

        addHeading(doc, h2, "\u8584\u5f31\u77e5\u8bc6\u70b9");
        PdfPTable weak = table(7);
        for (String h : new String[] {"\u77e5\u8bc6\u70b9", "\u5f97\u5206\u7387", "\u73ed\u5747", "\u4e0e\u73ed\u5dee", "\u6b21\u6570", "\u7b49\u7ea7", "\u6839\u56e0"})
        {
            addCell(weak, body, h, true);
        }
        List<Map<String, Object>> weakList = castList(data.get("weakTop"));
        if (weakList.isEmpty())
        {
            addCell(weak, body, "\u6682\u65e0", false);
            addCell(weak, body, "-", false);
            addCell(weak, body, "-", false);
            addCell(weak, body, "-", false);
            addCell(weak, body, "-", false);
            addCell(weak, body, "-", false);
            addCell(weak, body, "-", false);
        }
        else
        {
            int n = Math.min(20, weakList.size());
            for (int i = 0; i < n; i++)
            {
                Map<String, Object> row = weakList.get(i);
                addCell(weak, body, firstStr(row, "name", "knowledgeName"), false);
                addCell(weak, body, fmtRate(first(row, "rate", "weightedRate")), false);
                addCell(weak, body, fmtRate(row.get("classAvgRate")), false);
                addCell(weak, body, fmtGap(row.get("gap")), false);
                addCell(weak, body, str(first(row, "attemptCount", "attempts"), "0"), false);
                addCell(weak, body, fmtWeakLevel(first(row, "weakLevel", "level", "masteryLevel")), false);
                addCell(weak, body, str(row.get("rootHint"), "-"), false);
            }
        }
        doc.add(weak);
        doc.add(spacer(10));

        addHeading(doc, h2, "\u8fd1\u671f\u8d8b\u52bf");
        PdfPTable trend = table(4);
        for (String h : new String[] {"\u8bd5\u5377/\u4f5c\u4e1a", "\u65e5\u671f", "\u5f97\u5206\u7387", "\u73ed\u5747"})
        {
            addCell(trend, body, h, true);
        }
        List<Map<String, Object>> trends = castList(data.get("trend"));
        int tn = Math.min(12, trends.size());
        if (tn == 0)
        {
            addCell(trend, body, "\u6682\u65e0", false);
            addCell(trend, body, "-", false);
            addCell(trend, body, "-", false);
            addCell(trend, body, "-", false);
        }
        for (int i = 0; i < tn; i++)
        {
            Map<String, Object> row = trends.get(i);
            addCell(trend, body, firstStr(row, "paperName", "name"), false);
            addCell(trend, body, str(first(row, "examDate", "paperDate"), "-"), false);
            addCell(trend, body, fmtRate(first(row, "rate", "scoreRate")), false);
            addCell(trend, body, fmtRate(row.get("classAvgRate")), false);
        }
        doc.add(trend);
        doc.add(spacer(10));

        addHeading(doc, h2, "\u5e72\u9884\u4e0e\u8f85\u5bfc");
        PdfPTable iv = table(3);
        for (String h : new String[] {"\u7c7b\u578b", "\u6807\u9898", "\u8bf4\u660e"})
        {
            addCell(iv, body, h, true);
        }
        List<Map<String, Object>> timeline = castList(data.get("interveneTimeline"));
        int in = Math.min(15, timeline.size());
        if (in == 0)
        {
            addCell(iv, body, "-", false);
            addCell(iv, body, "\u6682\u65e0\u8fdb\u884c\u4e2d\u5e72\u9884", false);
            addCell(iv, body, str(data.get("openInterveneCount"), "0"), false);
        }
        for (int i = 0; i < in; i++)
        {
            Map<String, Object> row = timeline.get(i);
            addCell(iv, body, str(row.get("type"), "-"), false);
            addCell(iv, body, str(row.get("title"), "-"), false);
            addCell(iv, body, str(first(row, "content", "status"), "-"), false);
        }
        doc.add(iv);
        doc.add(spacer(10));

        List<Map<String, Object>> persist = castList(data.get("persistentWeak"));
        if (!persist.isEmpty())
        {
            addHeading(doc, h2, "\u53cd\u590d\u8584\u5f31");
            PdfPTable pw = table(4);
            for (String h : new String[] {"\u77e5\u8bc6\u70b9", "\u5f97\u5206\u7387", "\u4f4e\u5206\u573a\u6b21", "\u6807\u7b7e"})
            {
                addCell(pw, body, h, true);
            }
            int pn = Math.min(15, persist.size());
            for (int i = 0; i < pn; i++)
            {
                Map<String, Object> row = persist.get(i);
                addCell(pw, body, firstStr(row, "name", "knowledgeName"), false);
                addCell(pw, body, fmtRate(first(row, "rate", "weightedRate")), false);
                addCell(pw, body, str(row.get("lowPapers"), "0") + "/" + str(row.get("validPapers"), "0"), false);
                addCell(pw, body, str(row.get("persistTag"), "-"), false);
            }
            doc.add(pw);
            doc.add(spacer(10));
        }

        List<Map<String, Object>> causes = castList(data.get("errorCauseSummary"));
        if (!causes.isEmpty())
        {
            addHeading(doc, h2, "\u9519\u56e0\u5206\u5e03");
            doc.add(line(body, "\u8bf4\u660e\uff1a\u9519\u56e0\u4e3a\u5168\u91cf\u6807\u7b7e\u8ba1\u6570\uff0c\u4e0d\u968f\u5206\u6790\u65f6\u95f4\u7a97/\u9009\u5377\u53d8\u5316"));
            doc.add(spacer(4));
            PdfPTable ct = table(2);
            addCell(ct, body, "\u9519\u56e0\u5927\u7c7b", true);
            addCell(ct, body, "\u9898\u6570", true);
            int cn = Math.min(20, causes.size());
            for (int i = 0; i < cn; i++)
            {
                Map<String, Object> row = causes.get(i);
                addCell(ct, body, firstStr(row, "errorCategoryLabel", "errorLabel", "causeLabel"), false);
                addCell(ct, body, str(first(row, "tagCount", "count"), "0"), false);
            }
            doc.add(ct);
            doc.add(spacer(10));
        }

        Map<String, Object> qtype = asMap(data.get("questionType"));
        List<Map<String, Object>> qtypeItems = castList(qtype.get("items"));
        if (!qtypeItems.isEmpty())
        {
            addHeading(doc, h2, "\u9898\u578b\u8868\u73b0");
            doc.add(line(body, "\u53e3\u5f84\uff1a\u5377\u9762 sum(\u5f97\u5206)/sum(\u6ee1\u5206)\uff0c\u975e\u77e5\u8bc6\u70b9\u52a0\u6743\u638c\u63e1\u5ea6"));
            doc.add(spacer(4));
            PdfPTable qt = table(4);
            addCell(qt, body, "\u9898\u578b", true);
            addCell(qt, body, "\u9898\u91cf", true);
            addCell(qt, body, "\u5f97\u5206\u7387", true);
            addCell(qt, body, "\u6837\u672c", true);
            int qn = Math.min(15, qtypeItems.size());
            for (int i = 0; i < qn; i++)
            {
                Map<String, Object> row = qtypeItems.get(i);
                addCell(qt, body, firstStr(row, "typeName", "typeCode"), false);
                addCell(qt, body, str(row.get("questionCount"), "0"), false);
                addCell(qt, body, fmtRate(row.get("avgRate")), false);
                addCell(qt, body, str(row.get("attemptCount"), "0"), false);
            }
            doc.add(qt);
            doc.add(spacer(10));
        }

        Map<String, Object> bloom = asMap(data.get("bloom"));
        List<Map<String, Object>> bloomItems = castList(bloom.get("items"));
        if (!bloomItems.isEmpty())
        {
            addHeading(doc, h2, "\u80fd\u529b\u5c42\u7ea7");
            doc.add(line(body, "\u53e3\u5f84\uff1a\u5377\u9762 sum(\u5f97\u5206)/sum(\u6ee1\u5206)\uff0c\u975e\u77e5\u8bc6\u70b9\u52a0\u6743\u638c\u63e1\u5ea6"));
            doc.add(spacer(4));
            if (bloom.get("insight") != null)
            {
                Paragraph bloomInsight = new Paragraph(String.valueOf(bloom.get("insight")), body);
                doc.add(bloomInsight);
                doc.add(spacer(6));
            }
            PdfPTable bt = table(4);
            addCell(bt, body, "\u5c42\u7ea7", true);
            addCell(bt, body, "\u9898\u91cf", true);
            addCell(bt, body, "\u5f97\u5206\u7387", true);
            addCell(bt, body, "\u6837\u672c", true);
            int bn = Math.min(10, bloomItems.size());
            for (int i = 0; i < bn; i++)
            {
                Map<String, Object> row = bloomItems.get(i);
                addCell(bt, body, firstStr(row, "bloomLabel", "bloomLevel"), false);
                addCell(bt, body, str(row.get("questionCount"), "0"), false);
                addCell(bt, body, fmtRate(row.get("avgRate")), false);
                addCell(bt, body, str(row.get("attemptCount"), "0"), false);
            }
            doc.add(bt);
            doc.add(spacer(10));
        }

        Map<String, Object> chapterDelta = asMap(data.get("chapterDelta"));
        List<Map<String, Object>> improved = castList(chapterDelta.get("improved"));
        List<Map<String, Object>> declined = castList(chapterDelta.get("declined"));
        if (!improved.isEmpty() || !declined.isEmpty())
        {
            addHeading(doc, h2, "\u7ae0\u8282\u8fdb\u9000");
            if (chapterDelta.get("headline") != null)
            {
                Paragraph headlinePara = new Paragraph(String.valueOf(chapterDelta.get("headline")), body);
                doc.add(headlinePara);
                doc.add(spacer(6));
            }
            PdfPTable cdt = table(3);
            addCell(cdt, body, "\u7c7b\u578b", true);
            addCell(cdt, body, "\u7ae0\u8282", true);
            addCell(cdt, body, "\u53d8\u5316", true);
            for (Map<String, Object> row : improved)
            {
                addCell(cdt, body, "\u8fdb\u6b65", false);
                addCell(cdt, body, str(row.get("chapterName"), "-"), false);
                addCell(cdt, body, fmtRate(row.get("deltaRate")), false);
            }
            for (Map<String, Object> row : declined)
            {
                addCell(cdt, body, "\u9000\u6b65", false);
                addCell(cdt, body, str(row.get("chapterName"), "-"), false);
                addCell(cdt, body, fmtRate(row.get("deltaRate")), false);
            }
            doc.add(cdt);
            doc.add(spacer(10));
        }

        Map<String, Object> examRank = asMap(data.get("examRank"));
        List<Map<String, Object>> rankSubjects = castList(examRank.get("subjects"));
        if (!rankSubjects.isEmpty())
        {
            addHeading(doc, h2, "\u5b9e\u8003\u6821\u6b21\u8fdb\u9000");
            Map<String, Object> rankSummary = asMap(examRank.get("summary"));
            if (StringUtils.isNotEmpty(str(rankSummary.get("headline"), "")))
            {
                doc.add(line(body, str(rankSummary.get("headline"), "")));
                doc.add(spacer(4));
            }
            PdfPTable rt = table(5);
            for (String h : new String[] {"\u79d1\u76ee", "\u6821\u6b21\u8f68\u8ff9", "\u8f83\u4e0a\u6b21", "\u7ed3\u8bba", "\u8584\u5f31\u89e3\u91ca"})
            {
                addCell(rt, body, h, true);
            }
            int rn = Math.min(12, rankSubjects.size());
            for (int i = 0; i < rn; i++)
            {
                Map<String, Object> row = rankSubjects.get(i);
                addCell(rt, body, str(row.get("subjectName"), "-"), false);
                addCell(rt, body, str(row.get("track"), "-"), false);
                addCell(rt, body, deltaText(row.get("stepDelta")), false);
                addCell(rt, body, str(row.get("trendLabel"), "-"), false);
                addCell(rt, small, str(row.get("explain"), "-"), false);
            }
            doc.add(rt);
            doc.add(spacer(10));
        }

        List<Map<String, Object>> papers = castList(data.get("examPapers"));
        if (!papers.isEmpty())
        {
            addHeading(doc, h2, "\u8003\u8bd5\u6e05\u5355\uff08\u9009\u5377\u8bca\u65ad\uff09");
            PdfPTable ep = table(3);
            for (String h : new String[] {"\u8bd5\u5377", "\u8003\u8bd5\u65e5", "\u7f16\u53f7"})
            {
                addCell(ep, body, h, true);
            }
            for (Map<String, Object> row : papers)
            {
                addCell(ep, body, firstStr(row, "paperName", "name"), false);
                addCell(ep, body, str(row.get("examDate"), "-"), false);
                addCell(ep, body, str(first(row, "paperId", "id"), "-"), false);
            }
            doc.add(ep);
            doc.add(spacer(10));
        }

        Paragraph foot = new Paragraph(
            "\u7b97\u6cd5\uff1a\u52a0\u6743\u5f97\u5206\u7387 = \u03a3(\u5f97\u5206\u7387\u00d7\u6743\u91cd\u00d7\u96be\u5ea6\u00d7\u8fd1\u56e0) / \u03a3(\u6743\u91cd\u00d7\u96be\u5ea6\u00d7\u8fd1\u56e0)",
            small);
        foot.setAlignment(Element.ALIGN_LEFT);
        doc.add(foot);
        doc.close();
    }

    public static void writeClass(OutputStream out, Map<String, Object> data) throws Exception
    {
        Font title = font(16, Font.BOLD);
        Font h2 = font(12, Font.BOLD);
        Font body = font(10, Font.NORMAL);

        Document doc = new Document(PageSize.A4, 42, 42, 48, 48);
        PdfWriter.getInstance(doc, out);
        doc.open();

        Map<String, Object> overview = asMap(data.get("overview"));
        Paragraph p = new Paragraph("\u73ed\u7ea7\u5b66\u60c5\u62a5\u544a", title);
        p.setAlignment(Element.ALIGN_CENTER);
        doc.add(p);
        doc.add(spacer(8));
        doc.add(line(body, "\u751f\u6210\u65f6\u95f4\uff1a" + str(data.get("generatedAt"), "-")));
        if (data.get("scopeLabel") != null)
        {
            doc.add(line(body, "\u5206\u6790\u53e3\u5f84\uff1a" + str(data.get("scopeLabel"), "-")));
        }
        if (data.get("dimensionRateNote") != null)
        {
            doc.add(line(body, str(data.get("dimensionRateNote"), "")));
        }
        doc.add(spacer(8));

        addHeading(doc, h2, "\u7efc\u5408\u6458\u8981");
        doc.add(line(body, str(overview.get("headline"), "\u6682\u65e0")));
        doc.add(spacer(6));

        PdfPTable kpi = table(4);
        addCell(kpi, body, "\u5b66\u751f\u6570", true);
        addCell(kpi, body, str(overview.get("studentCount"), "0"), false);
        addCell(kpi, body, "\u73ed\u5747\u5f97\u5206\u7387", true);
        addCell(kpi, body, fmtRate(first(overview, "avgRate", "classAvgRate")), false);
        addCell(kpi, body, "\u8584\u5f31\u5b66\u751f\u6570", true);
        addCell(kpi, body, str(overview.get("weakStudentCount"), "0"), false);
        addCell(kpi, body, "\u4e25\u91cd\u6570", true);
        addCell(kpi, body, str(overview.get("severeCount"), "0"), false);
        doc.add(kpi);
        doc.add(spacer(10));

        addHeading(doc, h2, "\u8584\u5f31\u5b66\u751f Top");
        PdfPTable rank = table(4);
        for (String h : new String[] {"\u5b66\u53f7", "\u59d3\u540d", "\u5f97\u5206\u7387", "\u8584\u5f31\u6570"})
        {
            addCell(rank, body, h, true);
        }
        List<Map<String, Object>> ranking = castList(overview.get("studentRanking"));
        int rn = Math.min(20, ranking.size());
        if (rn == 0)
        {
            addCell(rank, body, "-", false);
            addCell(rank, body, "\u6682\u65e0", false);
            addCell(rank, body, "-", false);
            addCell(rank, body, "-", false);
        }
        for (int i = 0; i < rn; i++)
        {
            Map<String, Object> row = ranking.get(i);
            addCell(rank, body, str(row.get("studentNo"), "-"), false);
            addCell(rank, body, str(row.get("studentName"), "-"), false);
            addCell(rank, body, fmtRate(first(row, "overallRate", "rate")), false);
            addCell(rank, body, str(first(row, "weakCount", "severeCount"), "0"), false);
        }
        doc.add(rank);
        doc.add(spacer(10));

        addHeading(doc, h2, "\u8584\u5f31\u77e5\u8bc6\u70b9 Top");
        PdfPTable weak = table(4);
        for (String h : new String[] {"\u77e5\u8bc6\u70b9", "\u73ed\u5747", "\u8584\u5f31\u5b66\u751f", "\u6839\u56e0"})
        {
            addCell(weak, body, h, true);
        }
        List<Map<String, Object>> weakTop = castList(data.get("weakTop"));
        int wn = Math.min(15, weakTop.size());
        if (wn == 0)
        {
            addCell(weak, body, "\u6682\u65e0", false);
            addCell(weak, body, "-", false);
            addCell(weak, body, "-", false);
            addCell(weak, body, "-", false);
        }
        for (int i = 0; i < wn; i++)
        {
            Map<String, Object> row = weakTop.get(i);
            addCell(weak, body, firstStr(row, "name", "knowledgeName"), false);
            addCell(weak, body, fmtRate(first(row, "avgRate", "classAvgRate", "rate")), false);
            addCell(weak, body, str(first(row, "weakStudentCount", "studentCount"), "0"), false);
            addCell(weak, body, str(row.get("rootHint"), "-"), false);
        }
        doc.add(weak);
        doc.add(spacer(10));

        Map<String, Object> qtype = asMap(data.get("questionType"));
        List<Map<String, Object>> qtypeItems = castList(qtype.get("items"));
        if (!qtypeItems.isEmpty())
        {
            addHeading(doc, h2, "\u9898\u578b\u8868\u73b0");
            doc.add(line(body, "\u53e3\u5f84\uff1a\u5377\u9762 sum(\u5f97\u5206)/sum(\u6ee1\u5206)\uff0c\u975e\u77e5\u8bc6\u70b9\u52a0\u6743\u638c\u63e1\u5ea6"));
            doc.add(spacer(4));
            PdfPTable qt = table(3);
            addCell(qt, body, "\u9898\u578b", true);
            addCell(qt, body, "\u5f97\u5206\u7387", true);
            addCell(qt, body, "\u6837\u672c", true);
            int qn = Math.min(12, qtypeItems.size());
            for (int i = 0; i < qn; i++)
            {
                Map<String, Object> row = qtypeItems.get(i);
                addCell(qt, body, firstStr(row, "typeName", "typeCode"), false);
                addCell(qt, body, fmtRate(row.get("avgRate")), false);
                addCell(qt, body, str(row.get("attemptCount"), "0"), false);
            }
            doc.add(qt);
            doc.add(spacer(10));
        }

        Map<String, Object> bloom = asMap(data.get("bloom"));
        List<Map<String, Object>> bloomItems = castList(bloom.get("items"));
        if (!bloomItems.isEmpty())
        {
            addHeading(doc, h2, "\u80fd\u529b\u5c42\u7ea7");
            doc.add(line(body, "\u53e3\u5f84\uff1a\u5377\u9762 sum(\u5f97\u5206)/sum(\u6ee1\u5206)\uff0c\u975e\u77e5\u8bc6\u70b9\u52a0\u6743\u638c\u63e1\u5ea6"));
            doc.add(spacer(4));
            if (bloom.get("insight") != null)
            {
                doc.add(line(body, String.valueOf(bloom.get("insight"))));
                doc.add(spacer(4));
            }
            PdfPTable bt = table(3);
            addCell(bt, body, "\u5c42\u7ea7", true);
            addCell(bt, body, "\u5f97\u5206\u7387", true);
            addCell(bt, body, "\u6837\u672c", true);
            int bn = Math.min(8, bloomItems.size());
            for (int i = 0; i < bn; i++)
            {
                Map<String, Object> row = bloomItems.get(i);
                addCell(bt, body, firstStr(row, "bloomLabel", "bloomLevel"), false);
                addCell(bt, body, fmtRate(row.get("avgRate")), false);
                addCell(bt, body, str(row.get("attemptCount"), "0"), false);
            }
            doc.add(bt);
            doc.add(spacer(10));
        }

        Map<String, Object> chapterDelta = asMap(data.get("chapterDelta"));
        List<Map<String, Object>> improved = castList(chapterDelta.get("improved"));
        List<Map<String, Object>> declined = castList(chapterDelta.get("declined"));
        if (!improved.isEmpty() || !declined.isEmpty())
        {
            addHeading(doc, h2, "\u7ae0\u8282\u8fdb\u9000");
            if (chapterDelta.get("headline") != null)
            {
                doc.add(line(body, String.valueOf(chapterDelta.get("headline"))));
                doc.add(spacer(4));
            }
            PdfPTable cdt = table(3);
            addCell(cdt, body, "\u7c7b\u578b", true);
            addCell(cdt, body, "\u7ae0\u8282", true);
            addCell(cdt, body, "\u53d8\u5316", true);
            for (Map<String, Object> row : improved)
            {
                addCell(cdt, body, "\u8fdb\u6b65", false);
                addCell(cdt, body, str(row.get("chapterName"), "-"), false);
                addCell(cdt, body, fmtRate(row.get("deltaRate")), false);
            }
            for (Map<String, Object> row : declined)
            {
                addCell(cdt, body, "\u9000\u6b65", false);
                addCell(cdt, body, str(row.get("chapterName"), "-"), false);
                addCell(cdt, body, fmtRate(row.get("deltaRate")), false);
            }
            doc.add(cdt);
        }

        doc.close();
    }

    private static void addHeading(Document doc, Font font, String text) throws DocumentException
    {
        Paragraph p = new Paragraph(text, font);
        p.setSpacingBefore(4);
        p.setSpacingAfter(4);
        doc.add(p);
    }

    private static Paragraph line(Font font, String text)
    {
        return new Paragraph(text, font);
    }

    private static Paragraph spacer(float pt) throws DocumentException
    {
        Paragraph p = new Paragraph(" ");
        p.setSpacingAfter(pt);
        return p;
    }

    private static PdfPTable table(int cols)
    {
        PdfPTable t = new PdfPTable(cols);
        t.setWidthPercentage(100);
        t.setSpacingBefore(2);
        t.setSpacingAfter(2);
        return t;
    }

    private static void addCell(PdfPTable table, Font font, String text, boolean header)
    {
        PdfPCell cell = new PdfPCell(new Phrase(text == null ? "" : text, font));
        cell.setPadding(4);
        if (header)
        {
            cell.setGrayFill(0.9f);
        }
        table.addCell(cell);
    }

    private static Font font(float size, int style) throws Exception
    {
        BaseFont bf = resolveChineseFont();
        return new Font(bf, size, style);
    }

    private static BaseFont resolveChineseFont() throws Exception
    {
        BaseFont cached = cachedBaseFont;
        if (cached != null)
        {
            return cached;
        }
        synchronized (SpasReportPdfWriter.class)
        {
            if (cachedBaseFont != null)
            {
                return cachedBaseFont;
            }
            BaseFont loaded = loadChineseFont();
            cachedBaseFont = loaded;
            return loaded;
        }
    }

    private static BaseFont loadChineseFont() throws Exception
    {
        BaseFont fromClasspath = loadClasspathFont();
        if (fromClasspath != null)
        {
            return fromClasspath;
        }

        String configured = readConfiguredFontPath();
        if (StringUtils.isNotEmpty(configured))
        {
            BaseFont fromConfig = tryFileFont(configured);
            if (fromConfig != null)
            {
                return fromConfig;
            }
        }

        String[] candidates = {
            "C:/Windows/Fonts/simsun.ttc,0",
            "C:/Windows/Fonts/msyh.ttc,0",
            "C:/Windows/Fonts/simhei.ttf",
            "C:/Windows/Fonts/simkai.ttf",
            "/usr/share/fonts/truetype/wqy/wqy-microhei.ttc,0",
            "/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc,0",
            "/usr/share/fonts/opentype/noto/NotoSansCJKsc-Regular.otf"
        };
        for (String path : candidates)
        {
            BaseFont bf = tryFileFont(path);
            if (bf != null)
            {
                return bf;
            }
        }
        throw new ServiceException("\u672a\u627e\u5230\u4e2d\u6587\u5b57\u4f53\uff0c\u65e0\u6cd5\u751f\u6210PDF\uff08\u8bf7\u786e\u4fdd classpath:fonts/spas-cjk.otf \u6216\u914d\u7f6e spas.report.pdf-font-path\uff09");
    }

    private static BaseFont loadClasspathFont()
    {
        try (InputStream in = SpasReportPdfWriter.class.getResourceAsStream(CLASSPATH_FONT))
        {
            if (in == null)
            {
                return null;
            }
            byte[] bytes = readAll(in);
            return BaseFont.createFont("spas-cjk.otf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED, true, bytes, null);
        }
        catch (Exception ignored)
        {
            return null;
        }
    }

    private static String readConfiguredFontPath()
    {
        try
        {
            Environment env = SpringUtils.getBean(Environment.class);
            return env.getProperty("spas.report.pdf-font-path");
        }
        catch (Exception ignored)
        {
            return null;
        }
    }

    private static BaseFont tryFileFont(String path)
    {
        try
        {
            String file = path.contains(",") ? path.substring(0, path.indexOf(',')) : path;
            if (!Files.exists(Paths.get(file)))
            {
                return null;
            }
            return BaseFont.createFont(path, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        }
        catch (Exception ignored)
        {
            return null;
        }
    }

    private static byte[] readAll(InputStream in) throws Exception
    {
        ByteArrayOutputStream buf = new ByteArrayOutputStream();
        byte[] chunk = new byte[8192];
        int n;
        while ((n = in.read(chunk)) >= 0)
        {
            buf.write(chunk, 0, n);
        }
        return buf.toByteArray();
    }

    private static Map<String, Object> asMap(Object o)
    {
        if (o instanceof Map)
        {
            return (Map<String, Object>) o;
        }
        return new java.util.HashMap<>();
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
        return str(first(map, keys), "-");
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

    private static String fmtWeakLevel(Object v)
    {
        if (v == null)
        {
            return "-";
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
