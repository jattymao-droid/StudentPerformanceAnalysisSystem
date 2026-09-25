package com.ruoyi.spas.qb.support;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDResources;
import org.apache.pdfbox.pdmodel.graphics.PDXObject;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;
import org.apache.pdfbox.text.PDFTextStripper;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import org.apache.pdfbox.rendering.ImageType;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.apache.poi.xwpf.usermodel.IBodyElement;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFPicture;
import org.apache.poi.xwpf.usermodel.XWPFPictureData;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.apache.poi.xwpf.usermodel.XWPFTableCell;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.util.Comparator;
import java.util.stream.Stream;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.config.RuoYiConfig;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.spas.qb.domain.SpasQbParseItem;
import com.ruoyi.spas.qb.domain.SpasQbParseResult;

/**
 * Extract text + embedded images from digital docx/pdf and split into questions.
 */
@Component
public class SpasQbPaperImportHelper
{
    /** Main question start: 1. / 1． / 1、 / 1) / 1） / 第1题 / 【1】 — NOT (1) sub-items or A. options */
    private static final Pattern Q_START = Pattern.compile(
            "^\\s*(?:"
                    + "\\u7b2c\\s*\\d{1,3}\\s*\\u9898\\s*[\\.\\uff0e\\u3001]?|"
                    + "[\\[\\u3010]\\s*\\d{1,3}\\s*[\\]\\u3011]|"
                    + "\\d{1,3}\\s*[\\.\\uff0e\\u3001\\)\\uff09]|"
                    + "[\\u4e00\\u4e8c\\u4e09\\u56db\\u4e94\\u516d\\u4e03\\u516b\\u4e5d\\u5341]{1,3}\\s*[\\.\\uff0e\\u3001]"
                    + ")\\s*(.*)$");

    /** After sentence end punctuation, next "2．题干" glued on same line (fixed-width lookbehind) */
    private static final Pattern INLINE_Q_BREAK_PUNCT = Pattern.compile(
            "(?<=[\\u3002\\uff01\\uff1f\\uff1b;])\\s+(?=\\d{1,3}\\s*[\\.\\uff0e\\u3001\\)\\uff09]\\s*\\S)");

    /** After option letter marker A./A、/A), next question number */
    private static final Pattern INLINE_Q_BREAK_OPT = Pattern.compile(
            "(?<=[A-Ha-h][\\.\\uff0e\\u3001\\)\\uff09])\\s+(?=\\d{1,3}\\s*[\\.\\uff0e\\u3001\\)\\uff09]\\s*\\S)");

    /** Mid-line whitespace before N. / N、 / N) */
    private static final Pattern INLINE_Q_CANDIDATE = Pattern.compile(
            "(?<=\\S)\\s+(?=(\\d{1,3})\\s*[\\.\\uff0e\\u3001\\)\\uff09]\\s*\\S)");

    /**
     * Strong signal in Chinese exam papers: 2.(2025·洛阳市·联考题)
     * Insert break even when glued without space after previous option text.
     */
    private static final Pattern EXAM_SOURCE_Q_BREAK = Pattern.compile(
            "(?<![0-9\\.\\uff0e])(?=\\d{1,3}\\s*[\\.\\uff0e\\u3001\\)\\uff09]\\s*[\\(（]\\s*\\d{4}\\s*[·\\.\\uff0e])");

    private static final Pattern SECTION = Pattern.compile("^\\s*[\u4e00\u4e8c\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d\u5341\u767e]+[\\u3001\\.\\uff0e]\\s*(\u9009\u62e9\u9898|\u586b\u7a7a\u9898|\u89e3\u7b54\u9898|\u8ba1\u7b97\u9898|\u5b9e\u9a8c\u9898|\u4f5c\u56fe\u9898|\u7b80\u7b54\u9898|\u7efc\u5408\u9898|.*\u9898).*$");

    private static final Pattern OPTION_LINE = Pattern.compile("^[A-Ha-h][\\.\\uff0e\\u3001\\)\\uff09]\\s*.+");

    private static final Pattern SUB_ITEM = Pattern.compile("^[\\(（]\\s*\\d{1,2}\\s*[\\)）]");

    private static final Pattern IMG_MARK = Pattern.compile("\\[\\[IMG:(\\d+)\\]\\]");

    public static final String REL_DIR = "qb-import";
    private static final int OCR_MAX_PAGES_DEFAULT = 30;
    private static final int OCR_DPI_DEFAULT = 220;

    @Value("${spas.qb.ocr.max-pages:30}")
    private int ocrMaxPages = OCR_MAX_PAGES_DEFAULT;

    @Value("${spas.qb.ocr.dpi:220}")
    private int ocrDpi = OCR_DPI_DEFAULT;

    @Value("${spas.qb.ocr.session-ttl-hours:24}")
    private int ocrSessionTtlHours = 24;

    public SpasQbParseResult parse(MultipartFile file, Long subjectId)
    {
        if (file == null || file.isEmpty())
        {
            throw new ServiceException("\u4e0a\u4f20\u6587\u4ef6\u4e0d\u80fd\u4e3a\u7a7a");
        }
        if (subjectId == null)
        {
            throw new ServiceException("\u8bf7\u5148\u9009\u62e9\u5b66\u79d1");
        }
        String name = file.getOriginalFilename() == null ? "" : file.getOriginalFilename();
        String lower = name.toLowerCase(Locale.ROOT);
        cleanupExpiredSessions();
        String sessionId = IdUtils.fastSimpleUUID();
        Path sessionDir = Paths.get(RuoYiConfig.getProfile(), REL_DIR, sessionId);
        try
        {
            Files.createDirectories(sessionDir);
            byte[] bytes = file.getBytes();
            ExtractedDoc extracted;
            String type;
            if (lower.endsWith(".docx"))
            {
                type = "docx";
                extracted = extractDocxRich(new ByteArrayInputStream(bytes), sessionId, sessionDir);
            }
            else if (lower.endsWith(".pdf"))
            {
                type = "pdf";
                extracted = extractPdfRich(new ByteArrayInputStream(bytes), sessionId, sessionDir);
            }
            else
            {
                throw new ServiceException("\u4ec5\u652f\u6301 .docx / .pdf \u6587\u4ef6");
            }

            String text = preprocessForSplit(normalizeText(extracted.text));
            SpasQbParseResult result = new SpasQbParseResult();
            result.setFileName(name);
            result.setFileType(type);
            if (StringUtils.isEmpty(text) || text.replaceAll("\\s+", "").length() < 10)
            {
                result.setOcrNeeded(Boolean.TRUE);
                result.setOcrSessionId(sessionId);
                List<String> pageUrls = new ArrayList<>();
                try
                {
                    if ("pdf".equals(type))
                    {
                        pageUrls = renderPdfPagesForOcr(bytes, sessionId, sessionDir);
                    }
                    else if ("docx".equals(type) && extracted.imageUrls != null && !extracted.imageUrls.isEmpty())
                    {
                        // Image-only / scanned-like docx: reuse embedded pictures as OCR pages
                        pageUrls = new ArrayList<>(extracted.imageUrls);
                    }
                }
                catch (Exception ex)
                {
                    pageUrls = new ArrayList<>();
                }
                result.setPageImageUrls(pageUrls);
                if (pageUrls == null || pageUrls.isEmpty())
                {
                    result.setWarn("\u672a\u63d0\u53d6\u5230\u53ef\u7528\u6587\u672c\uff0c\u4e14\u65e0\u6cd5\u6e32\u67d3\u9875\u56fe\u4f9b OCR");
                }
                else
                {
                    String kind = "pdf".equals(type) ? "PDF" : "DOCX";
                    result.setWarn("\u68c0\u6d4b\u5230\u626b\u63cf\u4ef6/\u56fe\u7247 " + kind + "\uff08" + pageUrls.size()
                            + " \u9875/\u56fe\uff09\uff0c\u8bf7\u70b9\u51fb\u300cOCR \u8bc6\u522b\u300d\u63d0\u53d6\u6587\u5b57\u540e\u518d\u62c6\u9898");
                }
                result.setRawPreview("");
                result.setItems(new ArrayList<>());
                return result;
            }
            String preview = text.length() > 4000 ? text.substring(0, 4000) + "..." : text;
            // strip markers for human preview readability but keep count note
            String previewClean = IMG_MARK.matcher(preview).replaceAll("[" + "\u914d\u56fe" + "]");
            result.setRawPreview(previewClean);

            List<SpasQbParseItem> items = splitByQuestionNo(text);
            if (items.isEmpty())
            {
                items = splitByParagraph(text);
                result.setWarn("\u672a\u8bc6\u522b\u5230\u660e\u663e\u9898\u53f7\uff0c\u5df2\u6309\u6bb5\u843d\u5207\u5206\uff0c\u8bf7\u4eba\u5de5\u6821\u5bf9");
            }
            attachImages(items, extracted.imageUrls);
            guessTypes(items);
            for (SpasQbParseItem item : items)
            {
                item.setSelected(Boolean.TRUE);
                if (StringUtils.isEmpty(item.getDifficulty()))
                {
                    item.setDifficulty("2");
                }
                // clean markers from content after images attached
                if (item.getContent() != null)
                {
                    String c = IMG_MARK.matcher(item.getContent()).replaceAll("").replaceAll("\n{3,}", "\n\n").trim();
                    item.setContent(c);
                }
            }
            if (!extracted.imageUrls.isEmpty())
            {
                String tip = "\u5df2\u63d0\u53d6 " + extracted.imageUrls.size() + " \u5f20\u914d\u56fe";
                if (StringUtils.isEmpty(result.getWarn()))
                {
                    result.setWarn(tip);
                }
                else
                {
                    result.setWarn(result.getWarn() + "\uff1b" + tip);
                }
            }
            result.setItems(items);
            return result;
        }
        catch (ServiceException e)
        {
            throw e;
        }
        catch (Exception e)
        {
            throw new ServiceException("\u89e3\u6790\u6587\u4ef6\u5931\u8d25: " + e.getMessage());
        }
    }

    private void attachImages(List<SpasQbParseItem> items, List<String> allImages)
    {
        if (items == null || items.isEmpty() || allImages == null || allImages.isEmpty())
        {
            return;
        }
        for (SpasQbParseItem item : items)
        {
            String c = item.getContent() == null ? "" : item.getContent();
            Matcher m = IMG_MARK.matcher(c);
            List<String> urls = new ArrayList<>();
            while (m.find())
            {
                int idx = Integer.parseInt(m.group(1));
                if (idx >= 0 && idx < allImages.size())
                {
                    String url = allImages.get(idx);
                    if (!urls.contains(url))
                    {
                        urls.add(url);
                    }
                }
            }
            if (!urls.isEmpty())
            {
                item.setImageUrls(urls);
                item.setStemImage(urls.get(0));
            }
        }
        // fallback: if questions have "\u5982\u56fe" but no marker matched, distribute leftover images by order
        List<String> used = new ArrayList<>();
        for (SpasQbParseItem item : items)
        {
            if (item.getStemImage() != null)
            {
                used.addAll(item.getImageUrls());
            }
        }
        List<String> leftover = new ArrayList<>();
        for (String u : allImages)
        {
            if (!used.contains(u))
            {
                leftover.add(u);
            }
        }
        int li = 0;
        for (SpasQbParseItem item : items)
        {
            if (item.getStemImage() != null)
            {
                continue;
            }
            String c = item.getContent() == null ? "" : item.getContent();
            if ((c.contains("\u5982\u56fe") || c.contains("\u5982\u4e0b\u56fe") || c.contains("\u89c1\u56fe")) && li < leftover.size())
            {
                String url = leftover.get(li++);
                item.setStemImage(url);
                List<String> urls = item.getImageUrls() == null ? new ArrayList<>() : item.getImageUrls();
                urls.add(url);
                item.setImageUrls(urls);
            }
        }
    }

    private ExtractedDoc extractDocxRich(InputStream in, String sessionId, Path sessionDir) throws Exception
    {
        ExtractedDoc out = new ExtractedDoc();
        StringBuilder sb = new StringBuilder();
        try (XWPFDocument doc = new XWPFDocument(in))
        {
            for (IBodyElement el : doc.getBodyElements())
            {
                if (el instanceof XWPFParagraph)
                {
                    appendParagraph((XWPFParagraph) el, sb, out.imageUrls, sessionId, sessionDir);
                    if (sb.length() > 0 && sb.charAt(sb.length() - 1) != '\n')
                    {
                        sb.append('\n');
                    }
                }
                else if (el instanceof XWPFTable)
                {
                    appendTable((XWPFTable) el, sb, out.imageUrls, sessionId, sessionDir);
                    sb.append('\n');
                }
            }
        }
        out.text = sb.toString();
        return out;
    }

    private void appendTable(XWPFTable table, StringBuilder sb, List<String> imageUrls, String sessionId, Path sessionDir)
        throws Exception
    {
        for (XWPFTableRow row : table.getRows())
        {
            for (XWPFTableCell cell : row.getTableCells())
            {
                for (XWPFParagraph p : cell.getParagraphs())
                {
                    appendParagraph(p, sb, imageUrls, sessionId, sessionDir);
                    sb.append(' ');
                }
                sb.append('\t');
            }
            sb.append('\n');
        }
    }

    private void appendParagraph(XWPFParagraph p, StringBuilder sb, List<String> imageUrls, String sessionId,
        Path sessionDir) throws Exception
    {
        if (p == null)
        {
            return;
        }
        String xml = p.getCTP() == null ? "" : p.getCTP().xmlText();
        boolean hasMath = xml.contains("oMath") || xml.contains(":oMath");
        int beforeLen = sb.length();

        for (XWPFRun run : p.getRuns())
        {
            String runText = run.getText(0);
            if (runText != null && !runText.isEmpty())
            {
                sb.append(runText);
            }
            for (XWPFPicture pic : run.getEmbeddedPictures())
            {
                XWPFPictureData data = pic.getPictureData();
                if (data == null || data.getData() == null || data.getData().length < 32)
                {
                    continue;
                }
                String url = saveImageBytes(data.getData(), guessExt(data.suggestFileExtension()), sessionId, sessionDir,
                    imageUrls.size());
                if (url != null)
                {
                    sb.append("[[IMG:").append(imageUrls.size()).append("]]");
                    imageUrls.add(url);
                }
            }
        }
        if (hasMath)
        {
            String mathText = SpasQbOmmlLatexConverter.convert(xml);
            if (StringUtils.isEmpty(mathText))
            {
                mathText = collectOmmlPlainText(xml);
            }
            String appended = sb.substring(beforeLen);
            if (StringUtils.isNotEmpty(mathText))
            {
                String a = appended == null ? "" : appended.replace(" ", "");
                String mtxt = mathText.replace(" ", "").replace("\\", "");
                String aNorm = normalizeStemKey(a);
                String mNorm = normalizeStemKey(mtxt);
                // Incomplete run-text + fuller OMML text: keep only the fuller one
                if (!aNorm.isEmpty() && !mNorm.isEmpty() && mNorm.contains(aNorm) && mNorm.length() > aNorm.length() + 1)
                {
                    sb.setLength(beforeLen);
                    appendMathOrProse(sb, mathText);
                }
                else if (a.isEmpty() || (!a.contains(mtxt) && !aNorm.equals(mNorm)))
                {
                    if (sb.length() > 0 && !Character.isWhitespace(sb.charAt(sb.length() - 1)))
                    {
                        sb.append(' ');
                    }
                    appendMathOrProse(sb, mathText);
                }
            }
            else if (StringUtils.isEmpty(appended) && StringUtils.isEmpty(p.getText()))
            {
                sb.append(" [Math] ");
            }
        }
    }

    /** Collect text only inside oMath / oMathPara (not whole-paragraph w:t). */
    private String collectOmmlPlainText(String xml)
    {
        if (StringUtils.isEmpty(xml))
        {
            return "";
        }
        Matcher om = Pattern.compile("<(?:\\w+:)?oMath(?:Para)?\\b[^>]*>([\\s\\S]*?)</(?:\\w+:)?oMath(?:Para)?>",
            Pattern.CASE_INSENSITIVE).matcher(xml);
        StringBuilder sb = new StringBuilder();
        boolean found = false;
        while (om.find())
        {
            found = true;
            Matcher tm = Pattern.compile("<(?:\\w+:)?t\\b[^>]*>([\\s\\S]*?)</(?:\\w+:)?t>", Pattern.CASE_INSENSITIVE)
                .matcher(om.group(1));
            while (tm.find())
            {
                if (sb.length() > 0)
                {
                    sb.append(' ');
                }
                sb.append(tm.group(1));
            }
        }
        if (!found)
        {
            // fallback: m:t only
            Matcher tm = Pattern.compile("<(?:m:)?t\\b[^>]*>([\\s\\S]*?)</(?:m:)?t>", Pattern.CASE_INSENSITIVE).matcher(xml);
            while (tm.find())
            {
                if (sb.length() > 0)
                {
                    sb.append(' ');
                }
                sb.append(tm.group(1));
            }
        }
        return sb.toString().replaceAll("\\s+", " ").trim();
    }

    private void appendMathOrProse(StringBuilder sb, String mathText)
    {
        if (isMostlyChineseProse(mathText))
        {
            // Do NOT wrap Chinese stems in $...$ (causes fake KaTeX + duplicate stems)
            sb.append(mathText.trim());
            return;
        }
        String body = mathText.trim();
        // Already LaTeX from OMML converter — wrap only
        if (body.indexOf('\\') >= 0 || body.indexOf("^{") >= 0 || body.indexOf("_{") >= 0)
        {
            sb.append('$').append(body).append('$');
            return;
        }
        sb.append('$').append(toSimpleLatex(body)).append('$');
    }

    private boolean isMostlyChineseProse(String s)
    {
        if (StringUtils.isEmpty(s))
        {
            return false;
        }
        int cjk = 0;
        int latex = 0;
        for (int i = 0; i < s.length(); i++)
        {
            char c = s.charAt(i);
            if (c >= 0x4e00 && c <= 0x9fff)
            {
                cjk++;
            }
        }
        if (s.indexOf('\\') >= 0)
        {
            latex++;
        }
        // long Chinese, little latex -> prose
        return cjk >= 8 && latex == 0;
    }

    private String normalizeStemKey(String s)
    {
        if (s == null)
        {
            return "";
        }
        return s.replaceAll("[0-9a-zA-Z\\\\_\\^\\{\\}\\[\\]\\(\\)\\uff08\\uff09\\u00b7\\s\\.,:;=\\+\\-\\*/\u3001\u3002\uff0c\uff1b\uff1a\u3000\u00b0\u03b8\u0398]+", "");
    }

    private String toSimpleLatex(String plain)
    {
        if (plain == null)
        {
            return "";
        }
        String s = plain.trim();
        // F1 / F_1 already ok for KaTeX when wrapped
        s = s.replace(" ", "");
        // a/b -> \\frac{a}{b} when simple
        if (s.matches("[A-Za-z0-9_\\-\\+\\.]+/[A-Za-z0-9_\\-\\+\\.]+") && s.indexOf('/') > 0)
        {
            int i = s.indexOf('/');
            return "\\frac{" + s.substring(0, i) + "}{" + s.substring(i + 1) + "}";
        }
        return s;
    }


    /**
     * Build parse result from OCR / pasted plain text (after client OCR).
     */
    public SpasQbParseResult parseText(String rawText, Long subjectId, String fileName)
    {
        if (subjectId == null)
        {
            throw new ServiceException("\u8bf7\u5148\u9009\u62e9\u5b66\u79d1");
        }
        String text = preprocessForSplit(normalizeText(rawText));
        SpasQbParseResult result = new SpasQbParseResult();
        result.setFileName(StringUtils.isEmpty(fileName) ? "ocr.txt" : fileName);
        result.setFileType("ocr");
        result.setOcrNeeded(Boolean.FALSE);
        if (StringUtils.isEmpty(text) || text.replaceAll("\\s+", "").length() < 10)
        {
            result.setWarn("OCR \u6587\u672c\u8fc7\u77ed\uff0c\u8bf7\u68c0\u67e5\u56fe\u7247\u6e05\u6670\u5ea6\u6216\u624b\u5de5\u7c98\u8d34");
            result.setRawPreview("");
            return result;
        }
        String preview = text.length() > 4000 ? text.substring(0, 4000) + "..." : text;
        result.setRawPreview(preview);
        List<SpasQbParseItem> items = splitByQuestionNo(text);
        if (items.isEmpty())
        {
            items = splitByParagraph(text);
            result.setWarn("\u672a\u8bc6\u522b\u5230\u660e\u663e\u9898\u53f7\uff0c\u5df2\u6309\u6bb5\u843d\u5207\u5206\uff0c\u8bf7\u4eba\u5de5\u6821\u5bf9");
        }
        else
        {
            result.setWarn("\u5df2\u7531 OCR \u6587\u672c\u62c6\u9898\uff0c\u8bf7\u6821\u5bf9\u540e\u5165\u5e93");
        }
        guessTypes(items);
        for (SpasQbParseItem item : items)
        {
            item.setSelected(Boolean.TRUE);
            if (StringUtils.isEmpty(item.getDifficulty()))
            {
                item.setDifficulty("2");
            }
        }
        result.setItems(items);
        return result;
    }

    private List<String> renderPdfPagesForOcr(byte[] bytes, String sessionId, Path sessionDir) throws Exception
    {
        List<String> urls = new ArrayList<>();
        try (PDDocument doc = PDDocument.load(new ByteArrayInputStream(bytes)))
        {
            PDFRenderer renderer = new PDFRenderer(doc);
            int maxPages = Math.max(1, Math.min(ocrMaxPages, 80));
            int dpi = Math.max(120, Math.min(ocrDpi, 300));
            int n = Math.min(doc.getNumberOfPages(), maxPages);
            for (int i = 0; i < n; i++)
            {
                BufferedImage img = renderer.renderImageWithDPI(i, dpi, ImageType.RGB);
                String fileName = "ocr-p-" + (i + 1) + ".png";
                Path out = sessionDir.resolve(fileName);
                ImageIO.write(img, "png", out.toFile());
                String url = Constants.RESOURCE_PREFIX + "/" + REL_DIR + "/" + sessionId + "/" + fileName;
                urls.add(url);
            }
        }
        return urls;
    }

    private ExtractedDoc extractPdfRich(InputStream in, String sessionId, Path sessionDir) throws Exception
    {
        ExtractedDoc out = new ExtractedDoc();
        try (PDDocument doc = PDDocument.load(in))
        {
            PDFTextStripper stripper = new PDFTextStripper();
            stripper.setSortByPosition(true);
            out.text = stripper.getText(doc);
            int imgIdx = 0;
            for (PDPage page : doc.getPages())
            {
                PDResources resources = page.getResources();
                if (resources == null)
                {
                    continue;
                }
                for (org.apache.pdfbox.cos.COSName name : resources.getXObjectNames())
                {
                    PDXObject xObject = resources.getXObject(name);
                    if (xObject instanceof PDImageXObject)
                    {
                        PDImageXObject img = (PDImageXObject) xObject;
                        // skip tiny icons
                        if (img.getWidth() < 40 || img.getHeight() < 40)
                        {
                            continue;
                        }
                        java.awt.image.BufferedImage bi = img.getImage();
                        if (bi == null)
                        {
                            continue;
                        }
                        Path file = sessionDir.resolve("pimg-" + (imgIdx++) + ".png");
                        javax.imageio.ImageIO.write(bi, "png", file.toFile());
                        String url = Constants.RESOURCE_PREFIX + "/" + REL_DIR + "/" + sessionId + "/" + file.getFileName();
                        out.imageUrls.add(url);
                    }
                }
            }
            // inject image markers at end of text blocks roughly by page count — better attach later by 如图
            if (!out.imageUrls.isEmpty())
            {
                StringBuilder sb = new StringBuilder(out.text == null ? "" : out.text);
                for (int i = 0; i < out.imageUrls.size(); i++)
                {
                    sb.append("\n[[IMG:").append(i).append("]]\n");
                }
                out.text = sb.toString();
            }
        }
        return out;
    }

    private String saveImageBytes(byte[] data, String ext, String sessionId, Path sessionDir, int index) throws Exception
    {
        if (data == null || data.length == 0)
        {
            return null;
        }
        if (StringUtils.isEmpty(ext))
        {
            ext = "png";
        }
        ext = ext.replace(".", "").toLowerCase(Locale.ROOT);
        if ("jpeg".equals(ext))
        {
            ext = "jpg";
        }
        String fileName = "img-" + index + "-" + IdUtils.fastSimpleUUID().substring(0, 6) + "." + ext;
        Path out = sessionDir.resolve(fileName);
        Files.write(out, data);
        return Constants.RESOURCE_PREFIX + "/" + REL_DIR + "/" + sessionId + "/" + fileName;
    }

    private String guessExt(String suggest)
    {
        if (StringUtils.isEmpty(suggest))
        {
            return "png";
        }
        return suggest;
    }

    private String normalizeText(String text)
    {
        if (text == null)
        {
            return "";
        }
        String t = text.replace("\r\n", "\n").replace('\r', '\n');
        t = t.replace('\u00a0', ' ');
        t = t.replaceAll("\n{3,}", "\n\n");
        return t.trim();
    }


    private String preprocessForSplit(String text)
    {
        if (text == null || text.isEmpty())
        {
            return "";
        }
        // Highest priority: N.(YYYY·地区·来源) glued after previous question/options
        String s = EXAM_SOURCE_Q_BREAK.matcher(text).replaceAll("\n");
        s = INLINE_Q_BREAK_PUNCT.matcher(s).replaceAll("\n");
        s = INLINE_Q_BREAK_OPT.matcher(s).replaceAll("\n");
        // Also break "…运动2.(2025" / "…)2．(2025" where CJK/paren abut digit
        s = s.replaceAll("(?<=[\\u4e00-\\u9fff\\uff09\\)])(?=\\d{1,3}\\s*[\\.\\uff0e\\u3001]\\s*[\\(（]\\s*\\d{4})", "\n");
        return breakSequentialInline(s);
    }

    /**
     * Insert line breaks before mid-line question numbers that continue the sequence (…1. … 2. …).
     */
    private String breakSequentialInline(String text)
    {
        String[] lines = text.split("\n", -1);
        List<String> out = new ArrayList<>();
        Integer lastNo = null;
        for (String raw : lines)
        {
            String line = raw == null ? "" : raw;
            String trim = line.trim();
            Matcher head = Q_START.matcher(trim);
            if (head.matches() && looksLikeQuestionStart(trim, lastNo, true))
            {
                Integer n = parseArabicNo(extractNo(trim));
                if (n != null)
                {
                    lastNo = n;
                }
                // Still cut if another "2.(2025·" is glued inside this long line
                String expanded = EXAM_SOURCE_Q_BREAK.matcher(line).replaceAll("\n");
                if (expanded.indexOf('\n') >= 0)
                {
                    for (String part : expanded.split("\n", -1))
                    {
                        if (part != null && !part.trim().isEmpty())
                        {
                            Matcher ph = Q_START.matcher(part.trim());
                            if (ph.matches())
                            {
                                Integer pn = parseArabicNo(extractNo(part.trim()));
                                if (pn != null)
                                {
                                    lastNo = pn;
                                }
                            }
                            out.add(part);
                        }
                    }
                    continue;
                }
                out.add(line);
                continue;
            }

            Matcher m = INLINE_Q_CANDIDATE.matcher(line);
            List<Integer> cuts = new ArrayList<>();
            while (m.find())
            {
                int num;
                try
                {
                    num = Integer.parseInt(m.group(1));
                }
                catch (Exception ex)
                {
                    continue;
                }
                if (num < 1 || num > 200)
                {
                    continue;
                }
                boolean ok = (lastNo != null && num == lastNo + 1)
                        || (lastNo != null && num > lastNo && num <= lastNo + 2)
                        || (lastNo == null && num >= 2 && num <= 3 && m.start() > 8);
                if (!ok)
                {
                    continue;
                }
                int digStart = m.end();
                while (digStart < line.length() && !Character.isDigit(line.charAt(digStart)))
                {
                    digStart++;
                }
                if (digStart >= line.length())
                {
                    continue;
                }
                Matcher tail = Pattern.compile("^(\\d{1,3})\\s*([\\.\\uff0e\\u3001\\)\\uff09])\\s*(\\S)")
                        .matcher(line.substring(digStart));
                if (!tail.find())
                {
                    continue;
                }
                // skip decimals: 2.5
                if (tail.group(2).charAt(0) == '.' && Character.isDigit(tail.group(3).charAt(0)))
                {
                    continue;
                }
                cuts.add(digStart);
                lastNo = num;
            }
            if (cuts.isEmpty())
            {
                out.add(line);
                continue;
            }
            int pos = 0;
            for (int cut : cuts)
            {
                String piece = line.substring(pos, cut).replaceAll("[\\s\\u00a0]+$", "");
                if (!piece.isEmpty())
                {
                    out.add(piece);
                }
                pos = cut;
            }
            if (pos < line.length())
            {
                out.add(line.substring(pos));
            }
        }
        return String.join("\n", out).replaceAll("\\n{3,}", "\n\n");
    }

    private List<SpasQbParseItem> splitByQuestionNo(String text)
    {
        String[] lines = text.split("\n");
        List<SpasQbParseItem> items = new ArrayList<>();
        StringBuilder buf = new StringBuilder();
        String currentNo = null;
        String sectionType = null;
        Integer lastArabic = null;
        int hit = 0;
        for (String line : lines)
        {
            String trim = line == null ? "" : line.trim();
            if (trim.isEmpty())
            {
                if (buf.length() > 0)
                {
                    buf.append('\n');
                }
                continue;
            }
            if (SECTION.matcher(trim).matches())
            {
                flush(items, currentNo, buf, sectionType);
                currentNo = null;
                buf.setLength(0);
                lastArabic = null;
                sectionType = inferSectionType(trim);
                continue;
            }
            Matcher m = Q_START.matcher(trim);
            if (m.matches() && looksLikeQuestionStart(trim, lastArabic, false))
            {
                Integer arabic = parseArabicNo(extractNo(trim));
                if (arabic != null && lastArabic != null && arabic <= lastArabic && arabic != 1)
                {
                    // e.g. "见图3．" inside stem — keep as body
                    if (buf.length() > 0)
                    {
                        buf.append('\n');
                    }
                    buf.append(trim);
                    continue;
                }
                hit++;
                flush(items, currentNo, buf, sectionType);
                currentNo = extractNo(trim);
                if (arabic != null)
                {
                    lastArabic = arabic;
                }
                String rest = m.group(1) == null ? "" : m.group(1).trim();
                buf.setLength(0);
                if (!rest.isEmpty())
                {
                    buf.append(rest);
                }
                else
                {
                    buf.append(trim);
                }
            }
            else
            {
                // Glued next question inside option/stem line: "...D.xxx 2.(2025·联考题)"
                if (EXAM_SOURCE_Q_BREAK.matcher(trim).find() || trim.matches(".*\\d{1,3}\\s*[\\.\\uff0e\\u3001]\\s*[\\(（]\\s*\\d{4}.*"))
                {
                    String expanded = EXAM_SOURCE_Q_BREAK.matcher(trim).replaceAll("\n");
                    // also no-space abut form
                    expanded = expanded.replaceAll(
                            "(?<=[\\u4e00-\\u9fff\\uff09\\)])(?=\\d{1,3}\\s*[\\.\\uff0e\\u3001]\\s*[\\(（]\\s*\\d{4})",
                            "\n");
                    String[] parts = expanded.split("\n");
                    for (String part : parts)
                    {
                        String pt = part == null ? "" : part.trim();
                        if (pt.isEmpty())
                        {
                            continue;
                        }
                        Matcher pm = Q_START.matcher(pt);
                        if (pm.matches() && looksLikeQuestionStart(pt, lastArabic, false))
                        {
                            Integer arabic2 = parseArabicNo(extractNo(pt));
                            hit++;
                            flush(items, currentNo, buf, sectionType);
                            currentNo = extractNo(pt);
                            if (arabic2 != null)
                            {
                                lastArabic = arabic2;
                            }
                            String rest2 = pm.group(1) == null ? "" : pm.group(1).trim();
                            buf.setLength(0);
                            if (!rest2.isEmpty())
                            {
                                buf.append(rest2);
                            }
                            else
                            {
                                buf.append(pt);
                            }
                        }
                        else
                        {
                            if (buf.length() > 0)
                            {
                                buf.append('\n');
                            }
                            buf.append(pt);
                        }
                    }
                }
                else
                {
                    if (buf.length() > 0)
                    {
                        buf.append('\n');
                    }
                    buf.append(trim);
                }
            }
        }
        flush(items, currentNo, buf, sectionType);
        if (hit < 2)
        {
            return new ArrayList<>();
        }
        return items;
    }

    /** Map section title like 「一、选择题」 to catalog typeCode */
    private String inferSectionType(String title)
    {
        if (title == null)
        {
            return null;
        }
        if (title.contains("\u9009\u62e9") || title.contains("\u5355\u9009") || title.contains("\u591a\u9009")
                || title.contains("\u5224\u65ad"))
        {
            return "choice";
        }
        if (title.contains("\u586b\u7a7a"))
        {
            return "blank";
        }
        if (title.contains("\u89e3\u7b54") || title.contains("\u8ba1\u7b97") || title.contains("\u7b80\u7b54")
                || title.contains("\u7efc\u5408") || title.contains("\u5b9e\u9a8c") || title.contains("\u4f5c\u56fe")
                || title.contains("\u8bc1\u660e") || title.contains("\u8bba\u8ff0"))
        {
            return "short";
        }
        return null;
    }

    private boolean looksLikeQuestionStart(String trim, Integer lastArabic, boolean soft)
    {
        if (trim == null || trim.length() < 2)
        {
            return false;
        }
        if (OPTION_LINE.matcher(trim).matches())
        {
            return false;
        }
        if (trim.matches("^[\\(（]\\s*\\d{1,2}\\s*[\\)）].*"))
        {
            return false;
        }
        if (trim.matches("^\\d{4}\\s*[\\u5e74.].*"))
        {
            return false;
        }
        if (IMG_MARK.matcher(trim).matches())
        {
            return false;
        }
        Integer arabic = parseArabicNo(extractNo(trim));
        // bare "1．" / "2)" — allow (stem often on next line)
        if (trim.matches("^\\d{1,3}\\s*[\\.\\uff0e\\u3001\\)\\uff09]\\s*$"))
        {
            if (soft || lastArabic == null)
            {
                return true;
            }
            return arabic != null && (arabic == lastArabic + 1 || arabic == 1);
        }
        if (arabic != null && lastArabic != null && !soft)
        {
            if (arabic == lastArabic + 1 || arabic == 1)
            {
                return true;
            }
            if (arabic > lastArabic && arabic <= lastArabic + 3)
            {
                return true;
            }
            if (arabic > lastArabic + 5 && trim.length() < 14)
            {
                return false;
            }
        }
        return true;
    }

    private Integer parseArabicNo(String no)
    {
        if (no == null || no.isEmpty())
        {
            return null;
        }
        try
        {
            return Integer.parseInt(no.trim());
        }
        catch (Exception e)
        {
            return chineseToInt(no.trim());
        }
    }

    private Integer chineseToInt(String s)
    {
        if ("\u4e00".equals(s)) return 1;
        if ("\u4e8c".equals(s)) return 2;
        if ("\u4e09".equals(s)) return 3;
        if ("\u56db".equals(s)) return 4;
        if ("\u4e94".equals(s)) return 5;
        if ("\u516d".equals(s)) return 6;
        if ("\u4e03".equals(s)) return 7;
        if ("\u516b".equals(s)) return 8;
        if ("\u4e5d".equals(s)) return 9;
        if ("\u5341".equals(s)) return 10;
        return null;
    }

    private String extractNo(String trim)
    {
        Matcher m = Pattern.compile(
                "^\\s*(?:\\u7b2c\\s*)?(\\d{1,3}|[\\u4e00\\u4e8c\\u4e09\\u56db\\u4e94\\u516d\\u4e03\\u516b\\u4e5d\\u5341]{1,3})")
                .matcher(trim);
        if (m.find())
        {
            return m.group(1);
        }
        Matcher m2 = Pattern.compile("[\\[\\u3010]\\s*(\\d{1,3})\\s*[\\]\\u3011]").matcher(trim);
        if (m2.find())
        {
            return m2.group(1);
        }
        return null;
    }

    private void flush(List<SpasQbParseItem> items, String no, StringBuilder buf, String sectionType)
    {
        String content = buf.toString().trim();
        if (content.length() < 4 && !IMG_MARK.matcher(content).find())
        {
            return;
        }
        if (content.length() < 1)
        {
            return;
        }
        SpasQbParseItem item = new SpasQbParseItem();
        item.setQuestionNo(no);
        item.setContent(content);
        if (StringUtils.isNotEmpty(sectionType))
        {
            item.setQuestionType(sectionType);
        }
        items.add(item);
    }

    private List<SpasQbParseItem> splitByParagraph(String text)
    {
        List<SpasQbParseItem> items = new ArrayList<>();
        String[] blocks = text.split("\n\\s*\n");
        int i = 1;
        for (String block : blocks)
        {
            String c = block.trim();
            if (c.length() < 8 && !IMG_MARK.matcher(c).find())
            {
                continue;
            }
            SpasQbParseItem item = new SpasQbParseItem();
            item.setQuestionNo(String.valueOf(i++));
            item.setContent(c);
            items.add(item);
        }
        return items;
    }

    private void guessTypes(List<SpasQbParseItem> items)
    {
        for (SpasQbParseItem item : items)
        {
            if (StringUtils.isNotEmpty(item.getQuestionType()))
            {
                continue;
            }
            item.setQuestionType(guessTypeFromContent(item.getContent()));
        }
    }

    /**
     * Heuristic type from stem text. Prefer section title when available.
     */
    public static String guessTypeFromContent(String content)
    {
        String c = content == null ? "" : content;
        if (hasChoiceOptions(c)
                || (c.contains("\u4e0b\u5217") && (c.contains("\u9009\u9879") || c.contains("\u6b63\u786e")
                || c.contains("\u4e0d\u6b63\u786e") || c.contains("\u9519\u8bef"))))
        {
            return "choice";
        }
        if (c.contains("____") || c.contains("\u2014\u2014") || c.contains("\uff08\u3000\uff09")
                || c.contains("\uff08  \uff09") || c.contains("(  )") || c.contains("\uff08\uff09")
                || c.contains("\u586b\u7a7a"))
        {
            return "blank";
        }
        return "short";
    }

    private static boolean hasChoiceOptions(String c)
    {
        if (c == null || c.isEmpty())
        {
            return false;
        }
        return c.contains("A.") || c.contains("A\uff0e") || c.contains("A\u3001") || c.contains("A)")
                || c.contains("\uff08A\uff09") || c.contains("(A)") || c.contains("A\uff09")
                || (c.contains("A.") && c.contains("B.")) || (c.contains("A\u3001") && c.contains("B\u3001"));
    }

    private static class ExtractedDoc
    {
        private String text = "";
        private List<String> imageUrls = new ArrayList<>();
    }
    public void cleanupExpiredSessions()
    {
        Path root = Paths.get(RuoYiConfig.getProfile(), REL_DIR);
        if (!Files.isDirectory(root))
        {
            return;
        }
        long ttlMs = Math.max(1, ocrSessionTtlHours) * 3600L * 1000L;
        long cutoff = System.currentTimeMillis() - ttlMs;
        try (DirectoryStream<Path> ds = Files.newDirectoryStream(root))
        {
            for (Path child : ds)
            {
                if (!Files.isDirectory(child))
                {
                    continue;
                }
                try
                {
                    long mt = Files.getLastModifiedTime(child).toMillis();
                    if (mt > 0 && mt < cutoff)
                    {
                        deleteRecursively(child);
                    }
                }
                catch (Exception ignore)
                {
                }
            }
        }
        catch (Exception ignore)
        {
        }
    }

    public void cleanupSession(String sessionId)
    {
        if (StringUtils.isEmpty(sessionId) || sessionId.contains("..") || sessionId.contains("/") || sessionId.contains("\\"))
        {
            return;
        }
        Path dir = Paths.get(RuoYiConfig.getProfile(), REL_DIR, sessionId);
        try
        {
            if (Files.isDirectory(dir))
            {
                deleteRecursively(dir);
            }
        }
        catch (Exception ignore)
        {
        }
    }

    private static void deleteRecursively(Path root) throws IOException
    {
        if (root == null || !Files.exists(root))
        {
            return;
        }
        try (Stream<Path> walk = Files.walk(root))
        {
            walk.sorted(Comparator.reverseOrder()).forEach(p -> {
                try
                {
                    Files.deleteIfExists(p);
                }
                catch (IOException ignore)
                {
                }
            });
        }
    }

}
