package com.ruoyi.spas.qb.support;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import javax.imageio.ImageIO;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.ImageType;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.config.RuoYiConfig;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.spas.qb.domain.SpasQbAnnotatePage;

/**
 * Render PDF/images to page PNGs under profile/qb-annotate/{sessionId}
 */
@Component
public class SpasQbAnnotateRenderHelper
{
    public static final String REL_DIR = "qb-annotate";
    private static final float PDF_DPI = 200f;

    public String newSessionId()
    {
        return IdUtils.fastSimpleUUID();
    }

    public Path sessionDir(String sessionId)
    {
        return Paths.get(RuoYiConfig.getProfile(), REL_DIR, sessionId);
    }

    public String toResourceUrl(String sessionId, String fileName)
    {
        return Constants.RESOURCE_PREFIX + "/" + REL_DIR + "/" + sessionId + "/" + fileName;
    }

    public Path resolvePageFile(String sessionId, int pageNo)
    {
        return sessionDir(sessionId).resolve("p-" + pageNo + ".png");
    }

    public List<SpasQbAnnotatePage> render(MultipartFile file, String sessionId) throws IOException
    {
        if (file == null || file.isEmpty())
        {
            throw new ServiceException("\u4e0a\u4f20\u6587\u4ef6\u4e0d\u80fd\u4e3a\u7a7a");
        }
        String name = file.getOriginalFilename() == null ? "" : file.getOriginalFilename();
        String lower = name.toLowerCase(Locale.ROOT);
        Path dir = sessionDir(sessionId);
        Files.createDirectories(dir);

        List<SpasQbAnnotatePage> pages;
        if (lower.endsWith(".pdf"))
        {
            pages = renderPdf(file.getInputStream(), sessionId);
        }
        else if (lower.endsWith(".png") || lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".webp")
            || lower.endsWith(".bmp"))
        {
            pages = renderImage(file.getInputStream(), sessionId, lower);
        }
        else
        {
            throw new ServiceException("\u53ef\u89c6\u6807\u6ce8\u4ec5\u652f\u6301 PDF / JPG / PNG");
        }
        if (pages.isEmpty())
        {
            throw new ServiceException("\u672a\u6e32\u67d3\u51fa\u9875\u56fe");
        }
        return pages;
    }

    private List<SpasQbAnnotatePage> renderPdf(InputStream in, String sessionId) throws IOException
    {
        List<SpasQbAnnotatePage> pages = new ArrayList<>();
        try (PDDocument doc = PDDocument.load(in))
        {
            PDFRenderer renderer = new PDFRenderer(doc);
            int n = doc.getNumberOfPages();
            for (int i = 0; i < n; i++)
            {
                BufferedImage img = renderer.renderImageWithDPI(i, PDF_DPI, ImageType.RGB);
                int pageNo = i + 1;
                Path out = resolvePageFile(sessionId, pageNo);
                ImageIO.write(img, "png", out.toFile());
                pages.add(pageMeta(sessionId, pageNo, img.getWidth(), img.getHeight()));
            }
        }
        return pages;
    }

    private List<SpasQbAnnotatePage> renderImage(InputStream in, String sessionId, String lower) throws IOException
    {
        BufferedImage img = ImageIO.read(in);
        if (img == null)
        {
            throw new ServiceException("\u65e0\u6cd5\u8bfb\u53d6\u56fe\u7247");
        }
        Path out = resolvePageFile(sessionId, 1);
        ImageIO.write(img, "png", out.toFile());
        List<SpasQbAnnotatePage> pages = new ArrayList<>();
        pages.add(pageMeta(sessionId, 1, img.getWidth(), img.getHeight()));
        return pages;
    }

    private SpasQbAnnotatePage pageMeta(String sessionId, int pageNo, int w, int h)
    {
        SpasQbAnnotatePage p = new SpasQbAnnotatePage();
        p.setPageNo(pageNo);
        p.setUrl(toResourceUrl(sessionId, "p-" + pageNo + ".png"));
        p.setWidth(w);
        p.setHeight(h);
        return p;
    }

    /**
     * Crop region and classify as text / diagram / formula-like image.
     * Returns map: imageUrl, kind, width, height, edgeDensity, hint
     */
    public Map<String, Object> cropAndClassify(String sessionId, int pageNo, double x, double y, double w, double h,
        String role) throws IOException
    {
        Map<String, Object> out = new HashMap<>();
        Path pageFile = resolvePageFile(sessionId, pageNo);
        if (!Files.isRegularFile(pageFile))
        {
            throw new ServiceException("\u9875\u56fe\u4e0d\u5b58\u5728: p-" + pageNo);
        }
        BufferedImage src = ImageIO.read(pageFile.toFile());
        if (src == null)
        {
            throw new ServiceException("\u9875\u56fe\u8bfb\u53d6\u5931\u8d25");
        }
        int iw = src.getWidth();
        int ih = src.getHeight();
        int rx = clamp((int) Math.floor(x * iw), 0, iw - 1);
        int ry = clamp((int) Math.floor(y * ih), 0, ih - 1);
        int rw = clamp((int) Math.ceil(w * iw), 1, iw - rx);
        int rh = clamp((int) Math.ceil(h * ih), 1, ih - ry);
        if (rw < 2 || rh < 2)
        {
            throw new ServiceException("\u6846\u9009\u533a\u57df\u8fc7\u5c0f");
        }
        BufferedImage crop = src.getSubimage(rx, ry, rw, rh);
        // upscale small crops for clearer display / OCR
        BufferedImage saved = crop;
        if (rw < 400 && rh < 400)
        {
            int scale = Math.min(3, Math.max(2, 600 / Math.max(rw, rh)));
            int nw = rw * scale;
            int nh = rh * scale;
            BufferedImage scaled = new BufferedImage(nw, nh, BufferedImage.TYPE_INT_RGB);
            java.awt.Graphics2D g = scaled.createGraphics();
            g.setRenderingHint(java.awt.RenderingHints.KEY_INTERPOLATION,
                java.awt.RenderingHints.VALUE_INTERPOLATION_BICUBIC);
            g.drawImage(crop, 0, 0, nw, nh, null);
            g.dispose();
            saved = scaled;
        }
        String roleTag = StringUtils.isEmpty(role) ? "region" : role.toLowerCase(Locale.ROOT);
        String fileName = "crop-" + roleTag + "-" + IdUtils.fastSimpleUUID().substring(0, 8) + ".png";
        Path outFile = sessionDir(sessionId).resolve(fileName);
        ImageIO.write(saved, "png", outFile.toFile());
        String url = toResourceUrl(sessionId, fileName);

        double edgeDensity = estimateEdgeDensity(crop);
        String kind = classifyKind(roleTag, edgeDensity, rw, rh);
        out.put("imageUrl", url);
        out.put("kind", kind);
        out.put("width", saved.getWidth());
        out.put("height", saved.getHeight());
        out.put("edgeDensity", Math.round(edgeDensity * 1000) / 1000.0);
        out.put("hint", kindHint(kind));
        return out;
    }

    private static String classifyKind(String role, double edgeDensity, int rw, int rh)
    {
        if ("diagram".equals(role))
        {
            return "diagram";
        }
        double aspect = rw * 1.0 / Math.max(1, rh);
        // Dense line art / schematic: prefer diagram or formula image
        if (edgeDensity > 0.18 && aspect > 0.4 && aspect < 2.5 && (rw > 80 || rh > 80))
        {
            if ("stem".equals(role) || "analysis".equals(role))
            {
                return edgeDensity > 0.28 ? "diagram" : "formula";
            }
            return "formula";
        }
        if (edgeDensity > 0.22)
        {
            return "formula";
        }
        return "text";
    }

    private static String kindHint(String kind)
    {
        if ("diagram".equals(kind))
        {
            return "\u5224\u4e3a\u914d\u56fe/\u7ebf\u6846\u793a\u610f\u56fe\uff0c\u5efa\u8bae\u4fdd\u7559\u56fe\u7247\u5c55\u793a";
        }
        if ("formula".equals(kind))
        {
            return "\u53ef\u80fd\u542b\u516c\u5f0f\uff0cOCR \u4ec5\u4f5c\u53c2\u8003\uff0c\u5efa\u8bae\u6838\u5bf9\u6216\u4fdd\u7559\u914d\u56fe";
        }
        return "\u504f\u6587\u5b57\u533a\uff0c\u53ef\u8bd5 OCR \u586b\u5145\u9898\u5e72/\u7b54\u6848";
    }

    /** Rough Sobel-like edge density in [0,1] */
    private static double estimateEdgeDensity(BufferedImage img)
    {
        int w = img.getWidth();
        int h = img.getHeight();
        int step = Math.max(1, Math.min(w, h) / 80);
        long edges = 0;
        long total = 0;
        for (int y = 1; y < h - 1; y += step)
        {
            for (int x = 1; x < w - 1; x += step)
            {
                int c = gray(img.getRGB(x, y));
                int dx = Math.abs(gray(img.getRGB(x + 1, y)) - gray(img.getRGB(x - 1, y)));
                int dy = Math.abs(gray(img.getRGB(x, y + 1)) - gray(img.getRGB(x, y - 1)));
                if (dx + dy > 40)
                {
                    edges++;
                }
                total++;
            }
        }
        return total == 0 ? 0 : (edges * 1.0 / total);
    }

    private static int gray(int rgb)
    {
        int r = (rgb >> 16) & 0xff;
        int g = (rgb >> 8) & 0xff;
        int b = rgb & 0xff;
        return (r * 30 + g * 59 + b * 11) / 100;
    }

    /**
     * Crop region (normalized 0..1) from page PNG; returns resource URL or null
     */
    public String cropRegion(String sessionId, int pageNo, double x, double y, double w, double h, String roleTag)
        throws IOException
    {
        Path pageFile = resolvePageFile(sessionId, pageNo);
        if (!Files.isRegularFile(pageFile))
        {
            throw new ServiceException("\u9875\u56fe\u4e0d\u5b58\u5728: p-" + pageNo);
        }
        BufferedImage src = ImageIO.read(pageFile.toFile());
        if (src == null)
        {
            throw new ServiceException("\u9875\u56fe\u8bfb\u53d6\u5931\u8d25");
        }
        int iw = src.getWidth();
        int ih = src.getHeight();
        int rx = clamp((int) Math.floor(x * iw), 0, iw - 1);
        int ry = clamp((int) Math.floor(y * ih), 0, ih - 1);
        int rw = clamp((int) Math.ceil(w * iw), 1, iw - rx);
        int rh = clamp((int) Math.ceil(h * ih), 1, ih - ry);
        if (rw < 2 || rh < 2)
        {
            return null;
        }
        BufferedImage crop = src.getSubimage(rx, ry, rw, rh);
        String fileName = "crop-" + roleTag + "-" + IdUtils.fastSimpleUUID().substring(0, 8) + ".png";
        Path out = sessionDir(sessionId).resolve(fileName);
        ImageIO.write(crop, "png", out.toFile());
        return toResourceUrl(sessionId, fileName);
    }

    public void saveOriginal(MultipartFile file, String sessionId) throws IOException
    {
        String name = file.getOriginalFilename();
        String ext = ".bin";
        if (StringUtils.isNotEmpty(name) && name.contains("."))
        {
            ext = name.substring(name.lastIndexOf('.'));
        }
        Path out = sessionDir(sessionId).resolve("original" + ext);
        file.transferTo(out.toFile());
    }

    public String originalResourcePath(String sessionId, String originalFileName)
    {
        String ext = ".bin";
        if (StringUtils.isNotEmpty(originalFileName) && originalFileName.contains("."))
        {
            ext = originalFileName.substring(originalFileName.lastIndexOf('.'));
        }
        return toResourceUrl(sessionId, "original" + ext);
    }

    private static int clamp(int v, int min, int max)
    {
        return Math.max(min, Math.min(max, v));
    }
}
