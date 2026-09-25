package com.ruoyi.spas.qb.service.impl;

import java.io.ByteArrayInputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.spas.qb.domain.SpasQbAnnotateCommitRequest;
import com.ruoyi.spas.qb.domain.SpasQbAnnotatePage;
import com.ruoyi.spas.qb.domain.SpasQbAnnotateQuestion;
import com.ruoyi.spas.qb.domain.SpasQbAnnotateRecognizeRequest;
import com.ruoyi.spas.qb.domain.SpasQbAnnotateRegion;
import com.ruoyi.spas.qb.domain.SpasQbAnnotateSession;
import com.ruoyi.spas.qb.domain.SpasQbAnnotateUploadResult;
import com.ruoyi.spas.qb.domain.SpasQbQuestion;
import com.ruoyi.spas.qb.mapper.SpasQbAnnotateSessionMapper;
import com.ruoyi.spas.qb.service.ISpasQbAnnotateService;
import com.ruoyi.spas.qb.service.ISpasQbQuestionService;
import com.ruoyi.spas.qb.support.SpasQbAnnotateRenderHelper;

/**
 * Visual annotate service
 */
@Service
public class SpasQbAnnotateServiceImpl implements ISpasQbAnnotateService
{
    private static final String PLACEHOLDER_PREFIX = "\u3010\u53ef\u89c6\u6807\u6ce8\u3011";

    @Autowired
    private SpasQbAnnotateRenderHelper renderHelper;

    @Autowired
    private SpasQbAnnotateSessionMapper sessionMapper;

    @Autowired
    private ISpasQbQuestionService questionService;

    @Override
    public SpasQbAnnotateUploadResult uploadAndRender(MultipartFile file, Long subjectId, String operator)
    {
        if (subjectId == null)
        {
            throw new ServiceException("\u8bf7\u5148\u9009\u62e9\u5b66\u79d1");
        }
        if (file == null || file.isEmpty())
        {
            throw new ServiceException("\u4e0a\u4f20\u6587\u4ef6\u4e0d\u80fd\u4e3a\u7a7a");
        }
        String sessionId = renderHelper.newSessionId();
        String fileName = file.getOriginalFilename() == null ? "paper" : file.getOriginalFilename();
        try
        {
            byte[] bytes = file.getBytes();
            // save original
            java.nio.file.Path dir = renderHelper.sessionDir(sessionId);
            java.nio.file.Files.createDirectories(dir);
            String ext = ".bin";
            if (fileName.contains("."))
            {
                ext = fileName.substring(fileName.lastIndexOf('.'));
            }
            java.nio.file.Files.write(dir.resolve("original" + ext), bytes);

            List<SpasQbAnnotatePage> pages = renderHelper.render(
                new ByteArrayMultipartFile("file", fileName, bytes), sessionId);

            SpasQbAnnotateSession session = new SpasQbAnnotateSession();
            session.setSessionId(sessionId);
            session.setSubjectId(subjectId);
            session.setFileName(fileName);
            session.setFilePath(renderHelper.originalResourcePath(sessionId, fileName));
            session.setPageCount(pages.size());
            session.setStatus("0");
            session.setCreateBy(operator);
            sessionMapper.insertSession(session);

            SpasQbAnnotateUploadResult result = new SpasQbAnnotateUploadResult();
            result.setSessionId(sessionId);
            result.setSubjectId(subjectId);
            result.setFileName(fileName);
            result.setPageCount(pages.size());
            result.setPages(pages);
            return result;
        }
        catch (ServiceException e)
        {
            throw e;
        }
        catch (Exception e)
        {
            throw new ServiceException("\u6e32\u67d3\u5931\u8d25: " + e.getMessage());
        }
    }

    @Override
    public Map<String, Object> recognizeRegion(SpasQbAnnotateRecognizeRequest request)
    {
        if (request == null || StringUtils.isEmpty(request.getSessionId()) || request.getPageNo() == null
            || request.getX() == null || request.getY() == null || request.getW() == null || request.getH() == null)
        {
            throw new ServiceException("\u6846\u9009\u53c2\u6570\u4e0d\u5b8c\u6574");
        }
        SpasQbAnnotateSession session = sessionMapper.selectById(request.getSessionId());
        if (session == null)
        {
            throw new ServiceException("\u6807\u6ce8\u4f1a\u8bdd\u4e0d\u5b58\u5728");
        }
        try
        {
            Map<String, Object> result = renderHelper.cropAndClassify(request.getSessionId(), request.getPageNo(),
                request.getX(), request.getY(), request.getW(), request.getH(), request.getRole());
            result.put("role", request.getRole());
            result.put("pageNo", request.getPageNo());
            return result;
        }
        catch (ServiceException e)
        {
            throw e;
        }
        catch (Exception e)
        {
            throw new ServiceException("\u88c1\u526a\u5931\u8d25: " + e.getMessage());
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> commit(SpasQbAnnotateCommitRequest request, String operator)
    {
        Map<String, Object> out = new HashMap<>();
        if (request == null || StringUtils.isEmpty(request.getSessionId()) || request.getSubjectId() == null)
        {
            throw new ServiceException("\u4f1a\u8bdd\u6216\u5b66\u79d1\u7f3a\u5931");
        }
        SpasQbAnnotateSession session = sessionMapper.selectById(request.getSessionId());
        if (session == null)
        {
            throw new ServiceException("\u6807\u6ce8\u4f1a\u8bdd\u4e0d\u5b58\u5728");
        }
        if (!"0".equals(session.getStatus()))
        {
            throw new ServiceException("\u4f1a\u8bdd\u5df2\u63d0\u4ea4\u6216\u5931\u6548");
        }
        List<SpasQbAnnotateQuestion> questions = request.getQuestions();
        if (questions == null || questions.isEmpty())
        {
            throw new ServiceException("\u6ca1\u6709\u53ef\u5165\u5e93\u7684\u9898\u76ee");
        }

        int inserted = 0;
        int failed = 0;
        List<String> messages = new ArrayList<>();
        List<Long> ids = new ArrayList<>();

        for (int i = 0; i < questions.size(); i++)
        {
            SpasQbAnnotateQuestion item = questions.get(i);
            if (item == null)
            {
                continue;
            }
            try
            {
                SpasQbQuestion q = new SpasQbQuestion();
                q.setSubjectId(request.getSubjectId());
                q.setQuestionCode(item.getQuestionCode());
                q.setOptions(item.getOptions());
                q.setCorrectAnswer(item.getCorrectAnswer());
                q.setAnalysis(item.getAnalysis());
                q.setQuestionType(StringUtils.isEmpty(item.getQuestionType()) ? "choice" : item.getQuestionType());
                q.setDifficulty(StringUtils.isEmpty(item.getDifficulty()) ? "2" : item.getDifficulty());
                q.setStatus("0");
                q.setCreateBy(operator);
                q.setKnowledgeList(item.getKnowledgeList());

                applyCrops(request.getSessionId(), item, q);

                String content = item.getContent();
                if (StringUtils.isEmpty(content))
                {
                    content = PLACEHOLDER_PREFIX + IdUtils.fastSimpleUUID().substring(0, 8);
                }
                q.setContent(content.trim());

                questionService.insertSpasQbQuestion(q);
                inserted++;
                ids.add(q.getQuestionId());
            }
            catch (Exception e)
            {
                failed++;
                messages.add("#" + (i + 1) + ":" + e.getMessage());
            }
        }

        if (inserted > 0)
        {
            SpasQbAnnotateSession done = new SpasQbAnnotateSession();
            done.setSessionId(request.getSessionId());
            done.setStatus("1");
            sessionMapper.updateStatus(done);
        }

        out.put("inserted", inserted);
        out.put("failed", failed);
        out.put("questionIds", ids);
        out.put("messages", messages);
        return out;
    }

    private void applyCrops(String sessionId, SpasQbAnnotateQuestion item, SpasQbQuestion q) throws Exception
    {
        if (item.getRegions() == null)
        {
            return;
        }
        for (SpasQbAnnotateRegion r : item.getRegions())
        {
            if (r == null || r.getPageNo() == null || r.getX() == null || r.getY() == null || r.getW() == null
                || r.getH() == null || StringUtils.isEmpty(r.getRole()))
            {
                continue;
            }
            if (r.getW() <= 0 || r.getH() <= 0)
            {
                continue;
            }
            String role = r.getRole().toLowerCase(Locale.ROOT);
            String url = renderHelper.cropRegion(sessionId, r.getPageNo(), r.getX(), r.getY(), r.getW(), r.getH(), role);
            if (url == null)
            {
                continue;
            }
            switch (role)
            {
                case "stem":
                case "diagram":
                    if (StringUtils.isEmpty(q.getStemImage()))
                    {
                        q.setStemImage(url);
                    }
                    break;
                case "options":
                    q.setOptionsImage(url);
                    break;
                case "answer":
                    q.setAnswerImage(url);
                    break;
                case "analysis":
                    q.setAnalysisImage(url);
                    break;
                default:
                    break;
            }
        }
    }

    /**
     * Minimal MultipartFile for reusing render helper without spring-test
     */
    private static class ByteArrayMultipartFile implements MultipartFile
    {
        private final String name;
        private final String originalFilename;
        private final byte[] content;

        ByteArrayMultipartFile(String name, String originalFilename, byte[] content)
        {
            this.name = name;
            this.originalFilename = originalFilename;
            this.content = content;
        }

        @Override
        public String getName() { return name; }

        @Override
        public String getOriginalFilename() { return originalFilename; }

        @Override
        public String getContentType() { return "application/octet-stream"; }

        @Override
        public boolean isEmpty() { return content == null || content.length == 0; }

        @Override
        public long getSize() { return content.length; }

        @Override
        public byte[] getBytes() { return content; }

        @Override
        public java.io.InputStream getInputStream() { return new ByteArrayInputStream(content); }

        @Override
        public void transferTo(java.io.File dest) throws java.io.IOException
        {
            java.nio.file.Files.write(dest.toPath(), content);
        }
    }
}
