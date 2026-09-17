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

        Paragraph p = new Paragraph("\u5b66\u60c5\u5206\u6790\u62a5\u544a", title);
        p.setAlignment(Element.ALIGN_CENTER);
        doc.add(p);
        doc.add(spacer(8));
        doc.add(line(body, "\u5b66\u53f7\uff1a" + str(student.get("studentNo"), "-")
            + "    \u59d3\u540d\uff1a" + str(student.get("studentName"), "-")));
        doc.add(line(body, "\u751f\u6210\u65f6\u95f4\uff1a" + str(data.get("generatedAt"), "-")));
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
        addCell(kpi, body, str(summary.get("confidence"), "-"), false);
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

        addHeading(doc, h2, "\u8584\u5f31\u77e5\u8bc6\u70b9");
        PdfPTable weak = table(6);
        for (String h : new String[] {"\u77e5\u8bc6\u70b9", "\u5f97\u5206\u7387", "\u73ed\u5747", "\u4e0e\u73ed\u5dee", "\u6b21\u6570", "\u7b49\u7ea7"})
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
                addCell(weak, body, str(first(row, "level", "masteryLevel"), "-"), false);
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
        doc.add(spacer(14));
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
        PdfPTable weak = table(3);
        for (String h : new String[] {"\u77e5\u8bc6\u70b9", "\u73ed\u5747", "\u8584\u5f31\u5b66\u751f"})
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
        }
        for (int i = 0; i < wn; i++)
        {
            Map<String, Object> row = weakTop.get(i);
            addCell(weak, body, firstStr(row, "name", "knowledgeName"), false);
            addCell(weak, body, fmtRate(first(row, "avgRate", "classAvgRate", "rate")), false);
            addCell(weak, body, str(first(row, "weakStudentCount", "studentCount"), "0"), false);
        }
        doc.add(weak);
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
}
