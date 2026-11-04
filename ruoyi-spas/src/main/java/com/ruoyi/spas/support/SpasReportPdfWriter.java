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

    /**
     * Student report laid out for ~2 A4 pages (one sheet, duplex).
     * Keeps guidance + weak + key dims; drops verbose empty/secondary blocks.
     */
    public static void writeStudent(OutputStream out, Map<String, Object> data) throws Exception
    {
        Font title = font(13, Font.BOLD);
        Font h2 = font(10, Font.BOLD);
        Font body = font(8.5f, Font.NORMAL);
        Font small = font(7.5f, Font.NORMAL);

        // Tight margins for duplex print budget
        Document doc = new Document(PageSize.A4, 28, 28, 30, 28);
        PdfWriter.getInstance(doc, out);
        doc.open();

        Map<String, Object> student = asMap(data.get("student"));
        Map<String, Object> summary = asMap(data.get("summary"));

        Paragraph p = new Paragraph(
            Boolean.TRUE.equals(data.get("allSubjects")) ? "\u5168\u79d1\u5b66\u60c5\u5206\u6790\u62a5\u544a" : "\u5b66\u60c5\u5206\u6790\u62a5\u544a",
            title);
        p.setAlignment(Element.ALIGN_CENTER);
        p.setSpacingAfter(2);
        doc.add(p);

        String meta = "\u5b66\u53f7 " + str(student.get("studentNo"), "-")
            + "  \u59d3\u540d " + str(student.get("studentName"), "-")
            + "  \u751f\u6210 " + str(data.get("generatedAt"), "-");
        if (data.get("scopeLabel") != null)
        {
            meta = meta + "  \u53e3\u5f84 " + str(data.get("scopeLabel"), "-");
        }
        Paragraph metaP = line(small, meta);
        metaP.setSpacingAfter(3);
        doc.add(metaP);

        addCompactHeading(doc, h2, "\u7efc\u5408\u6458\u8981");
        Paragraph headline = line(body, str(summary.get("headline"), "\u6682\u65e0"));
        headline.setSpacingAfter(2);
        doc.add(headline);

        PdfPTable kpi = compactTable(6);
        addCompactCell(kpi, small, "\u5f97\u5206\u7387", true);
        addCompactCell(kpi, body, fmtRate(summary.get("overallRate")), false);
        addCompactCell(kpi, small, "\u73ed\u5747", true);
        addCompactCell(kpi, body, fmtRate(summary.get("classAvgRate")), false);
        addCompactCell(kpi, small, "\u4e0e\u73ed\u5dee", true);
        addCompactCell(kpi, body, fmtGap(summary.get("gap")), false);
        addCompactCell(kpi, small, "\u4e25\u91cd/\u8584\u5f31/\u5173\u6ce8", true);
        addCompactCell(kpi, body,
            str(summary.get("severeCount"), "0") + "/" + str(summary.get("weakCount"), "0") + "/"
                + str(summary.get("watchCount"), "0"), false);
        addCompactCell(kpi, small, "\u4f4e\u5206/\u6837\u672c\u4e0d\u8db3", true);
        addCompactCell(kpi, body,
            str(summary.get("lowRateCount"), "0") + "/" + str(summary.get("thinSampleCount"), "0"), false);
        addCompactCell(kpi, small, "\u7ec3\u4e60\u6b21\u6570", true);
        addCompactCell(kpi, body, str(summary.get("totalAttempts"), "0"), false);
        doc.add(kpi);

        writeStudyGuidanceCompact(doc, h2, body, small, data);

        List<Map<String, Object>> subjectBreakdown = castList(data.get("subjectBreakdown"));
        if (subjectBreakdown.isEmpty())
        {
            subjectBreakdown = castList(summary.get("subjectBreakdown"));
        }
        if (!subjectBreakdown.isEmpty() && Boolean.TRUE.equals(data.get("allSubjects")))
        {
            addCompactHeading(doc, h2, "\u5206\u79d1\u6982\u89c8");
            PdfPTable sub = compactTable(5);
            for (String h : new String[] {"\u5b66\u79d1", "\u5f97\u5206\u7387", "\u73ed\u5747", "\u8584\u5f31", "\u4e25\u91cd"})
            {
                addCompactCell(sub, small, h, true);
            }
            int sn = Math.min(6, subjectBreakdown.size());
            for (int i = 0; i < sn; i++)
            {
                Map<String, Object> row = subjectBreakdown.get(i);
                addCompactCell(sub, body, str(row.get("subjectName"), "-"), false);
                addCompactCell(sub, body, fmtRate(row.get("overallRate")), false);
                addCompactCell(sub, body, fmtRate(row.get("classAvgRate")), false);
                addCompactCell(sub, body, str(row.get("weakCount"), "0"), false);
                addCompactCell(sub, body, str(row.get("severeCount"), "0"), false);
            }
            doc.add(sub);
        }

        addCompactHeading(doc, h2, "\u8584\u5f31\u77e5\u8bc6\u70b9\uff08Top8\uff09");
        if (data.get("weakLevelNote") != null)
        {
            Paragraph note = line(small, truncate(str(data.get("weakLevelNote"), ""), 90));
            note.setSpacingAfter(1);
            doc.add(note);
        }
        PdfPTable weak = compactTable(6);
        for (String h : new String[] {"\u77e5\u8bc6\u70b9", "\u5f97\u5206\u7387", "\u73ed\u5747", "\u5dee", "\u6b21", "\u7b49\u7ea7"})
        {
            addCompactCell(weak, small, h, true);
        }
        List<Map<String, Object>> weakList = castList(data.get("weakTop"));
        if (weakList.isEmpty())
        {
            addCompactCell(weak, body, "\u6682\u65e0", false);
            addCompactCell(weak, body, "-", false);
            addCompactCell(weak, body, "-", false);
            addCompactCell(weak, body, "-", false);
            addCompactCell(weak, body, "-", false);
            addCompactCell(weak, body, "-", false);
        }
        else
        {
            int n = Math.min(8, weakList.size());
            for (int i = 0; i < n; i++)
            {
                Map<String, Object> row = weakList.get(i);
                addCompactCell(weak, body, truncate(firstStr(row, "name", "knowledgeName"), 14), false);
                addCompactCell(weak, body, fmtRate(first(row, "rate", "weightedRate")), false);
                addCompactCell(weak, body, fmtRate(row.get("classAvgRate")), false);
                addCompactCell(weak, body, fmtGap(row.get("gap")), false);
                addCompactCell(weak, body, str(first(row, "attemptCount", "attempts"), "0"), false);
                addCompactCell(weak, body, fmtWeakStatus(row), false);
            }
        }
        doc.add(weak);

        // Page-2 dense block: trend + question type side-by-side via nested table
        PdfPTable twin = compactTable(2);
        twin.setWidths(new float[] {1f, 1f});
        twin.setSpacingBefore(4);

        PdfPTable trend = compactTable(3);
        addCompactCell(trend, small, "\u8fd1\u671f\u8bd5\u5377", true);
        addCompactCell(trend, small, "\u5f97\u5206\u7387", true);
        addCompactCell(trend, small, "\u73ed\u5747", true);
        List<Map<String, Object>> trends = castList(data.get("trend"));
        int tn = Math.min(4, trends.size());
        if (tn == 0)
        {
            addCompactCell(trend, body, "\u6682\u65e0", false);
            addCompactCell(trend, body, "-", false);
            addCompactCell(trend, body, "-", false);
        }
        for (int i = 0; i < tn; i++)
        {
            Map<String, Object> row = trends.get(i);
            addCompactCell(trend, body, truncate(firstStr(row, "paperName", "name"), 12), false);
            Object selfRate = first(row, "rate", "scoreRate");
            addCompactCell(trend, body, selfRate == null ? "\u7f3a\u5206" : fmtRate(selfRate), false);
            addCompactCell(trend, body, fmtRate(row.get("classAvgRate")), false);
        }
        PdfPCell left = new PdfPCell(trend);
        left.setBorder(PdfPCell.NO_BORDER);
        left.setPaddingRight(4);
        twin.addCell(left);

        Map<String, Object> qtype = asMap(data.get("questionType"));
        List<Map<String, Object>> qtypeItems = castList(qtype.get("items"));
        PdfPTable qt = compactTable(3);
        addCompactCell(qt, small, "\u9898\u578b", true);
        addCompactCell(qt, small, "\u5f97\u5206\u7387", true);
        addCompactCell(qt, small, "\u9898\u91cf", true);
        if (qtypeItems.isEmpty())
        {
            addCompactCell(qt, body, "\u6682\u65e0", false);
            addCompactCell(qt, body, "-", false);
            addCompactCell(qt, body, "-", false);
        }
        else
        {
            int qn = Math.min(5, qtypeItems.size());
            for (int i = 0; i < qn; i++)
            {
                Map<String, Object> row = qtypeItems.get(i);
                addCompactCell(qt, body, truncate(firstStr(row, "typeName", "typeCode"), 8), false);
                addCompactCell(qt, body, fmtRate(row.get("avgRate")), false);
                addCompactCell(qt, body, str(row.get("questionCount"), "0"), false);
            }
        }
        PdfPCell right = new PdfPCell(qt);
        right.setBorder(PdfPCell.NO_BORDER);
        right.setPaddingLeft(4);
        twin.addCell(right);
        doc.add(twin);

        List<Map<String, Object>> persist = castList(data.get("persistentWeak"));
        if (!persist.isEmpty())
        {
            addCompactHeading(doc, h2, "\u53cd\u590d\u8584\u5f31");
            PdfPTable pw = compactTable(3);
            addCompactCell(pw, small, "\u77e5\u8bc6\u70b9", true);
            addCompactCell(pw, small, "\u5f97\u5206\u7387", true);
            addCompactCell(pw, small, "\u4f4e\u5206\u573a\u6b21", true);
            int pn = Math.min(3, persist.size());
            for (int i = 0; i < pn; i++)
            {
                Map<String, Object> row = persist.get(i);
                addCompactCell(pw, body, truncate(firstStr(row, "name", "knowledgeName"), 14), false);
                addCompactCell(pw, body, fmtRate(first(row, "rate", "weightedRate")), false);
                addCompactCell(pw, body, str(row.get("lowPapers"), "0") + "/" + str(row.get("validPapers"), "0"), false);
            }
            doc.add(pw);
        }

        List<Map<String, Object>> causes = castList(data.get("errorCauseSummary"));
        if (!causes.isEmpty())
        {
            addCompactHeading(doc, h2, "\u9519\u56e0\u5206\u5e03\uff08\u5168\u91cf\uff09");
            PdfPTable ct = compactTable(4);
            int cn = Math.min(4, causes.size());
            for (int i = 0; i < cn; i++)
            {
                Map<String, Object> row = causes.get(i);
                addCompactCell(ct, body, truncate(firstStr(row, "errorCategoryLabel", "errorLabel", "causeLabel"), 10), false);
                addCompactCell(ct, body, str(first(row, "tagCount", "count"), "0"), false);
            }
            while (cn * 2 < 4)
            {
                addCompactCell(ct, body, "", false);
                addCompactCell(ct, body, "", false);
                cn++;
            }
            doc.add(ct);
        }

        Map<String, Object> bloom = asMap(data.get("bloom"));
        List<Map<String, Object>> bloomItems = castList(bloom.get("items"));
        if (!bloomItems.isEmpty() && Boolean.TRUE.equals(data.get("bloomUseful")))
        {
            addCompactHeading(doc, h2, "\u80fd\u529b\u5c42\u7ea7");
            PdfPTable bt = compactTable(4);
            addCompactCell(bt, small, "\u5c42\u7ea7", true);
            addCompactCell(bt, small, "\u9898\u91cf", true);
            addCompactCell(bt, small, "\u5f97\u5206\u7387", true);
            addCompactCell(bt, small, "\u6837\u672c", true);
            int bn = Math.min(4, bloomItems.size());
            for (int i = 0; i < bn; i++)
            {
                Map<String, Object> row = bloomItems.get(i);
                addCompactCell(bt, body, truncate(firstStr(row, "bloomLabel", "bloomLevel"), 8), false);
                addCompactCell(bt, body, str(row.get("questionCount"), "0"), false);
                addCompactCell(bt, body, fmtRate(row.get("avgRate")), false);
                addCompactCell(bt, body, str(row.get("attemptCount"), "0"), false);
            }
            doc.add(bt);
        }

        Map<String, Object> chapterDelta = asMap(data.get("chapterDelta"));
        List<Map<String, Object>> improved = castList(chapterDelta.get("improved"));
        List<Map<String, Object>> declined = castList(chapterDelta.get("declined"));
        if (!improved.isEmpty() || !declined.isEmpty())
        {
            addCompactHeading(doc, h2, "\u7ae0\u8282\u8fdb\u9000");
            PdfPTable cdt = compactTable(4);
            int shown = 0;
            for (Map<String, Object> row : declined)
            {
                if (shown >= 3)
                {
                    break;
                }
                addCompactCell(cdt, body, "\u9000", false);
                addCompactCell(cdt, body, truncate(str(row.get("chapterName"), "-"), 12), false);
                shown++;
            }
            for (Map<String, Object> row : improved)
            {
                if (shown >= 4)
                {
                    break;
                }
                addCompactCell(cdt, body, "\u8fdb", false);
                addCompactCell(cdt, body, truncate(str(row.get("chapterName"), "-"), 12), false);
                shown++;
            }
            while (shown * 2 < 4)
            {
                addCompactCell(cdt, body, "", false);
                addCompactCell(cdt, body, "", false);
                shown++;
            }
            doc.add(cdt);
        }

        Map<String, Object> examRank = asMap(data.get("examRank"));
        List<Map<String, Object>> rankSubjects = castList(examRank.get("subjects"));
        if (!rankSubjects.isEmpty())
        {
            addCompactHeading(doc, h2, "\u5b9e\u8003\u6821\u6b21");
            Map<String, Object> rankSummary = asMap(examRank.get("summary"));
            if (StringUtils.isNotEmpty(str(rankSummary.get("headline"), "")))
            {
                Paragraph rh = line(small, truncate(str(rankSummary.get("headline"), ""), 80));
                rh.setSpacingAfter(1);
                doc.add(rh);
            }
            PdfPTable rt = compactTable(4);
            for (String h : new String[] {"\u79d1\u76ee", "\u8f68\u8ff9", "\u8f83\u4e0a\u6b21", "\u7ed3\u8bba"})
            {
                addCompactCell(rt, small, h, true);
            }
            int rn = Math.min(4, rankSubjects.size());
            for (int i = 0; i < rn; i++)
            {
                Map<String, Object> row = rankSubjects.get(i);
                addCompactCell(rt, body, truncate(str(row.get("subjectName"), "-"), 8), false);
                addCompactCell(rt, body, truncate(str(row.get("track"), "-"), 12), false);
                addCompactCell(rt, body, deltaText(row.get("stepDelta")), false);
                addCompactCell(rt, body, truncate(str(row.get("trendLabel"), "-"), 8), false);
            }
            doc.add(rt);
        }

        List<Map<String, Object>> timeline = castList(data.get("interveneTimeline"));
        int openIv = 0;
        try
        {
            openIv = Integer.parseInt(str(data.get("openInterveneCount"), "0"));
        }
        catch (Exception ignored)
        {
        }
        if (!timeline.isEmpty() || openIv > 0)
        {
            addCompactHeading(doc, h2, "\u5e72\u9884");
            if (timeline.isEmpty())
            {
                doc.add(line(small, "\u8fdb\u884c\u4e2d\u5e72\u9884 " + openIv + " \u9879"));
            }
            else
            {
                PdfPTable iv = compactTable(2);
                int in = Math.min(3, timeline.size());
                for (int i = 0; i < in; i++)
                {
                    Map<String, Object> row = timeline.get(i);
                    addCompactCell(iv, body, truncate(str(row.get("title"), "-"), 16), false);
                    addCompactCell(iv, body, truncate(str(first(row, "content", "status"), "-"), 16), false);
                }
                doc.add(iv);
            }
        }

        List<Map<String, Object>> papers = castList(data.get("examPapers"));
        if (!papers.isEmpty())
        {
            StringBuilder pb = new StringBuilder("\u9009\u5377\uff1a");
            int pn = Math.min(4, papers.size());
            for (int i = 0; i < pn; i++)
            {
                if (i > 0)
                {
                    pb.append("\u3001");
                }
                pb.append(truncate(firstStr(papers.get(i), "paperName", "name"), 10));
            }
            if (papers.size() > pn)
            {
                pb.append("\u7b49").append(papers.size()).append("\u4efd");
            }
            Paragraph papersP = line(small, pb.toString());
            papersP.setSpacingBefore(3);
            doc.add(papersP);
        }

        Paragraph foot = new Paragraph(
            "\u7248\u5f0f\uff1aA4 \u53cc\u9762\u7d27\u51d1\u7248\u3002\u52a0\u6743\u5f97\u5206\u7387=\u03a3(\u5f97\u5206\u7387\u00d7\u6743\u91cd\u00d7\u96be\u5ea6\u00d7\u8fd1\u56e0)/\u03a3(\u6743\u91cd\u00d7\u96be\u5ea6\u00d7\u8fd1\u56e0)\u3002",
            small);
        foot.setSpacingBefore(4);
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
        addCell(kpi, body, "\u6b63\u5f0f\u8584\u5f31", true);
        addCell(kpi, body, str(overview.get("weakStudentCount"), "0"), false);
        addCell(kpi, body, "\u6b63\u5f0f\u4e25\u91cd", true);
        addCell(kpi, body, str(first(overview, "severeStudentCount", "severeCount"), "0"), false);
        addCell(kpi, body, "\u7efc\u5408\u4f4e\u5206", true);
        addCell(kpi, body, str(overview.get("lowRateStudentCount"), "0"), false);
        addCell(kpi, body, "\u6837\u672c\u4e0d\u8db3", true);
        addCell(kpi, body, str(overview.get("thinSampleStudentCount"), "0"), false);
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

    private static void writeStudyGuidanceCompact(Document doc, Font h2, Font body, Font small, Map<String, Object> data)
        throws DocumentException
    {
        List<String> advice = new ArrayList<>();
        Object adviceObj = data.get("studyAdvice");
        if (adviceObj instanceof List)
        {
            for (Object item : (List<?>) adviceObj)
            {
                if (item != null && StringUtils.isNotEmpty(String.valueOf(item)))
                {
                    advice.add(String.valueOf(item));
                }
            }
        }
        List<Map<String, Object>> priority = castList(data.get("priorityRemediate"));
        String evidenceNote = str(data.get("evidenceNote"), "");
        if (advice.isEmpty() && priority.isEmpty() && StringUtils.isEmpty(evidenceNote))
        {
            return;
        }
        addCompactHeading(doc, h2, "\u5b66\u4e60\u6307\u5bfc\u5efa\u8bae");
        if (StringUtils.isNotEmpty(evidenceNote))
        {
            Paragraph en = line(small, truncate(evidenceNote, 120));
            en.setSpacingAfter(2);
            doc.add(en);
        }
        if (!priority.isEmpty())
        {
            PdfPTable pt = compactTable(4);
            addCompactCell(pt, small, "\u4f18\u5148\u8865", true);
            addCompactCell(pt, small, "\u5f97\u5206\u7387", true);
            addCompactCell(pt, small, "\u7b49\u7ea7", true);
            addCompactCell(pt, small, "\u7406\u7531", true);
            int pn = Math.min(3, priority.size());
            for (int i = 0; i < pn; i++)
            {
                Map<String, Object> row = priority.get(i);
                addCompactCell(pt, body, truncate(firstStr(row, "name", "knowledgeName"), 12), false);
                addCompactCell(pt, body, fmtRate(first(row, "rate", "weightedRate")), false);
                addCompactCell(pt, body, str(row.get("statusLabel"), "-"), false);
                addCompactCell(pt, small, truncate(str(row.get("reason"), "-"), 16), false);
            }
            doc.add(pt);
        }
        int adviceMax = Math.min(4, advice.size());
        for (int i = 0; i < adviceMax; i++)
        {
            Paragraph ap = new Paragraph((i + 1) + ". " + truncate(advice.get(i), 88), body);
            ap.setSpacingAfter(1);
            doc.add(ap);
        }
    }

    private static void addHeading(Document doc, Font font, String text) throws DocumentException
    {
        Paragraph p = new Paragraph(text, font);
        p.setSpacingBefore(4);
        p.setSpacingAfter(4);
        doc.add(p);
    }

    private static void addCompactHeading(Document doc, Font font, String text) throws DocumentException
    {
        Paragraph p = new Paragraph(text, font);
        p.setSpacingBefore(5);
        p.setSpacingAfter(2);
        doc.add(p);
    }

    private static PdfPTable compactTable(int cols)
    {
        PdfPTable t = new PdfPTable(cols);
        t.setWidthPercentage(100);
        t.setSpacingBefore(1);
        t.setSpacingAfter(2);
        t.setKeepTogether(false);
        return t;
    }

    private static void addCompactCell(PdfPTable table, Font font, String text, boolean header)
    {
        PdfPCell cell = new PdfPCell(new Phrase(text == null ? "" : text, font));
        cell.setPadding(2.2f);
        cell.setPaddingTop(1.5f);
        cell.setPaddingBottom(1.5f);
        if (header)
        {
            cell.setGrayFill(0.92f);
        }
        table.addCell(cell);
    }

    private static String truncate(String s, int maxChars)
    {
        if (s == null)
        {
            return "";
        }
        String t = s.trim();
        if (t.length() <= maxChars)
        {
            return t;
        }
        return t.substring(0, Math.max(0, maxChars - 1)) + "\u2026";
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
            "/System/Library/Fonts/PingFang.ttc,0",
            "/System/Library/Fonts/STHeiti Light.ttc,0",
            "/Library/Fonts/Arial Unicode.ttf",
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
        throw new ServiceException(
            "未找到中文字体，无法生成PDF。请将 spas-cjk.otf 放到 classpath:/fonts/，"
                + "或配置 spas.report.pdf-font-path 指向本机 CJK 字体（见 docs/spas-deploy.md §1.5）。");
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

    /** Prefer enriched statusLabel (样本不足 / 正式薄弱…) over raw weak_level. */
    private static String fmtWeakStatus(Map<String, Object> row)
    {
        if (row == null)
        {
            return "-";
        }
        Object label = row.get("statusLabel");
        if (label != null && StringUtils.isNotEmpty(String.valueOf(label)))
        {
            return String.valueOf(label);
        }
        if (Boolean.FALSE.equals(row.get("evidenceOk")))
        {
            return "\u6837\u672c\u4e0d\u8db3";
        }
        return fmtWeakLevel(first(row, "weakLevel", "level", "masteryLevel"));
    }
}
