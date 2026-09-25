package com.ruoyi.spas.qb.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.analysis.KnowledgeStatCalculator;
import com.ruoyi.spas.domain.SpasPaper;
import com.ruoyi.spas.domain.SpasPaperQuestion;
import com.ruoyi.spas.domain.SpasQuestionKnowledge;
import com.ruoyi.spas.mapper.SpasPaperMapper;
import com.ruoyi.spas.qb.domain.SpasQbPaper;
import com.ruoyi.spas.qb.domain.SpasQbPaperItem;
import com.ruoyi.spas.qb.domain.SpasQbPublishRequest;
import com.ruoyi.spas.qb.domain.SpasQbQuestionKnowledge;
import com.ruoyi.spas.qb.mapper.SpasQbPaperMapper;
import com.ruoyi.spas.qb.mapper.SpasQbQuestionMapper;
import com.ruoyi.spas.qb.service.ISpasQbPaperService;
import com.ruoyi.spas.service.ISpasAnalysisService;
import com.ruoyi.spas.support.PaperAnnotationInspector;
import com.ruoyi.spas.support.SpasAccessService;

@Service
public class SpasQbPaperServiceImpl implements ISpasQbPaperService
{
    @Autowired
    private SpasQbPaperMapper bankPaperMapper;

    @Autowired
    private SpasQbQuestionMapper bankQuestionMapper;

    @Autowired
    private SpasPaperMapper paperMapper;

    @Autowired
    private SpasAccessService accessService;

    @Autowired
    private KnowledgeStatCalculator knowledgeStatCalculator;

    @Autowired
    private ISpasAnalysisService analysisService;

    @Override
    public List<SpasQbPaper> selectSpasQbPaperList(SpasQbPaper query)
    {
        return bankPaperMapper.selectSpasQbPaperList(query);
    }

    @Override
    public SpasQbPaper selectSpasQbPaperById(Long paperId)
    {
        SpasQbPaper paper = bankPaperMapper.selectSpasQbPaperById(paperId);
        if (paper != null)
        {
            paper.setItems(bankPaperMapper.selectItemsByPaperId(paperId));
        }
        return paper;
    }

    @Override
    public int insertSpasQbPaper(SpasQbPaper paper)
    {
        if (StringUtils.isEmpty(paper.getPaperTitle()) || paper.getSubjectId() == null)
        {
            throw new ServiceException("卷名与学科不能为空");
        }
        if (paper.getTotalScore() == null)
        {
            paper.setTotalScore(BigDecimal.ZERO);
        }
        int rows = bankPaperMapper.insertSpasQbPaper(paper);
        if (rows > 0 && paper.getItems() != null && !paper.getItems().isEmpty())
        {
            saveItems(paper);
        }
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateSpasQbPaper(SpasQbPaper paper)
    {
        if (paper.getPaperId() == null)
        {
            throw new ServiceException("题库卷ID不能为空");
        }
        int rows = bankPaperMapper.updateSpasQbPaper(paper);
        if (paper.getItems() != null)
        {
            saveItems(paper);
        }
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteSpasQbPaperByIds(Long[] paperIds)
    {
        for (Long id : paperIds)
        {
            bankPaperMapper.deleteItemsByPaperId(id);
        }
        return bankPaperMapper.deleteSpasQbPaperByIds(paperIds);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int saveItems(SpasQbPaper paper)
    {
        Long paperId = paper.getPaperId();
        if (paperId == null)
        {
            throw new ServiceException("题库卷ID不能为空");
        }
        bankPaperMapper.deleteItemsByPaperId(paperId);
        List<SpasQbPaperItem> items = paper.getItems();
        BigDecimal total = BigDecimal.ZERO;
        if (items != null && !items.isEmpty())
        {
            int order = 1;
            for (SpasQbPaperItem item : items)
            {
                item.setPaperId(paperId);
                if (item.getQuestionId() == null)
                {
                    throw new ServiceException("组卷题目不能为空");
                }
                if (item.getOrderNum() == null)
                {
                    item.setOrderNum(order);
                }
                if (item.getScoreValue() == null)
                {
                    item.setScoreValue(new BigDecimal("5"));
                }
                if (StringUtils.isEmpty(item.getQuestionNo()))
                {
                    item.setQuestionNo(String.valueOf(item.getOrderNum()));
                }
                total = total.add(item.getScoreValue());
                order++;
            }
            bankPaperMapper.batchInsertItems(items);
        }
        SpasQbPaper upd = new SpasQbPaper();
        upd.setPaperId(paperId);
        upd.setTotalScore(total);
        upd.setUpdateBy(paper.getUpdateBy());
        bankPaperMapper.updateSpasQbPaper(upd);
        return 1;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public SpasPaper publishToAnalysis(SpasQbPublishRequest request, String operator)
    {
        if (request == null || request.getBankPaperId() == null || request.getDeptId() == null)
        {
            throw new ServiceException("题库卷与班级不能为空");
        }
        accessService.assertCanWrite();
        accessService.checkClassAnalysisDept(request.getDeptId());

        SpasQbPaper bank = selectSpasQbPaperById(request.getBankPaperId());
        if (bank == null)
        {
            throw new ServiceException("题库卷不存在");
        }
        List<SpasQbPaperItem> items = bank.getItems();
        if (items == null || items.isEmpty())
        {
            throw new ServiceException("请先为题库卷选题");
        }

        Map<String, Object> ann = buildAnnotationCheck(items);
        int issueCount = ((Number) ann.get("issueCount")).intValue();
        if (issueCount > 0 && !Boolean.TRUE.equals(request.getForce()))
        {
            @SuppressWarnings("unchecked")
            List<String> issues = (List<String>) ann.get("issues");
            StringBuilder sb = new StringBuilder("标注未通过，无法发布（可勾选强制发布）：");
            int shown = Math.min(6, issues.size());
            for (int i = 0; i < shown; i++)
            {
                if (i > 0)
                {
                    sb.append("；");
                }
                sb.append(issues.get(i));
            }
            if (issues.size() > shown)
            {
                sb.append("；等共 ").append(issues.size()).append(" 处");
            }
            throw new ServiceException(sb.toString());
        }

        Long subjectId = request.getSubjectId() != null ? request.getSubjectId() : bank.getSubjectId();
        Long existingId = bankPaperMapper.selectAnalysisPaperIdByBank(bank.getPaperId(), request.getDeptId());
        SpasPaper analysis;
        boolean knowledgeOnly = Boolean.TRUE.equals(request.getKnowledgeOnly());
        boolean rebuildQuestions = !knowledgeOnly;
        if (existingId != null)
        {
            analysis = paperMapper.selectSpasPaperById(existingId);
            int scoreCount = paperMapper.countScoreDetailByPaperId(existingId);
            if (scoreCount > 0 && !knowledgeOnly)
            {
                throw new ServiceException("分析卷已有成绩，不可重建小题；请勾选仅同步知识点或换班级新建");
            }
            if (scoreCount > 0)
            {
                rebuildQuestions = false;
            }
        }
        else
        {
            if (knowledgeOnly)
            {
                throw new ServiceException("尚无分析卷，无法仅同步知识点，请先完整发布");
            }
            analysis = new SpasPaper();
            analysis.setCreateBy(operator);
            analysis.setStatus("0");
        }

        analysis.setPaperName(StringUtils.isNotEmpty(request.getPaperName()) ? request.getPaperName() : bank.getPaperTitle());
        analysis.setPaperType(StringUtils.isNotEmpty(request.getPaperType()) ? request.getPaperType() : "1");
        analysis.setSubjectId(subjectId);
        analysis.setDeptId(request.getDeptId());
        analysis.setExamDate(request.getExamDate());
        analysis.setTotalScore(bank.getTotalScore());
        analysis.setBankPaperId(bank.getPaperId());
        analysis.setUpdateBy(operator);
        analysis.setRemark("from bank paper " + bank.getPaperId());

        if (analysis.getPaperId() == null)
        {
            paperMapper.insertSpasPaper(analysis);
        }
        else
        {
            paperMapper.updateSpasPaper(analysis);
        }

        Long analysisPaperId = analysis.getPaperId();
        if (rebuildQuestions)
        {
            paperMapper.deleteQuestionKnowledgeByPaperId(analysisPaperId);
            paperMapper.deleteQuestionsByPaperId(analysisPaperId);
            for (SpasQbPaperItem item : items)
            {
                SpasPaperQuestion pq = new SpasPaperQuestion();
                pq.setPaperId(analysisPaperId);
                pq.setQuestionNo(StringUtils.isNotEmpty(item.getQuestionNo()) ? item.getQuestionNo() : String.valueOf(item.getOrderNum()));
                pq.setQuestionOrder(item.getOrderNum());
                pq.setFullScore(item.getScoreValue());
                pq.setDifficulty(StringUtils.isNotEmpty(item.getDifficulty()) ? item.getDifficulty() : "2");
                pq.setQuestionType(com.ruoyi.spas.support.SpasQuestionTypeAlias.normalize(item.getQuestionType()));
                pq.setBankQuestionId(item.getQuestionId());
                pq.setCreateBy(operator);
                if (StringUtils.isNotEmpty(item.getContentPreview()))
                {
                    pq.setRemark(item.getContentPreview());
                }
                paperMapper.insertSpasPaperQuestion(pq);
                List<SpasQbQuestionKnowledge> bankKs = bankQuestionMapper.selectKnowledgeByQuestionId(item.getQuestionId());
                copyKnowledge(pq.getQuestionId(), bankKs);
            }
        }
        else
        {
            List<SpasPaperQuestion> existingQs = paperMapper.selectQuestionsByPaperId(analysisPaperId);
            paperMapper.deleteQuestionKnowledgeByPaperId(analysisPaperId);
            for (SpasPaperQuestion pq : existingQs)
            {
                if (pq.getBankQuestionId() == null)
                {
                    continue;
                }
                List<SpasQbQuestionKnowledge> bankKs = bankQuestionMapper.selectKnowledgeByQuestionId(pq.getBankQuestionId());
                copyKnowledge(pq.getQuestionId(), bankKs);
            }
        }

        int scoreCount = paperMapper.countScoreDetailByPaperId(analysisPaperId);
        if (scoreCount > 0)
        {
            knowledgeStatCalculator.recalculateByPaper(analysisPaperId);
        }

        return paperMapper.selectSpasPaperById(analysisPaperId);
    }

    @Override
    public Map<String, Object> annotationCheck(Long paperId)
    {
        if (paperId == null)
        {
            throw new ServiceException("题库卷不能为空");
        }
        SpasQbPaper bank = selectSpasQbPaperById(paperId);
        if (bank == null)
        {
            throw new ServiceException("题库卷不存在");
        }
        return buildAnnotationCheck(bank.getItems());
    }

    private Map<String, Object> buildAnnotationCheck(List<SpasQbPaperItem> items)
    {
        List<SpasPaperQuestion> qs = new ArrayList<>();
        List<SpasQuestionKnowledge> links = new ArrayList<>();
        int unbound = 0;
        if (items != null)
        {
            for (SpasQbPaperItem item : items)
            {
                if (item == null || item.getQuestionId() == null)
                {
                    continue;
                }
                SpasPaperQuestion pq = new SpasPaperQuestion();
                pq.setQuestionId(item.getQuestionId());
                pq.setQuestionNo(StringUtils.isNotEmpty(item.getQuestionNo())
                        ? item.getQuestionNo() : String.valueOf(item.getOrderNum()));
                pq.setQuestionType(com.ruoyi.spas.support.SpasQuestionTypeAlias.normalize(item.getQuestionType()));
                qs.add(pq);
                List<SpasQbQuestionKnowledge> bankKs = bankQuestionMapper.selectKnowledgeByQuestionId(item.getQuestionId());
                if (bankKs == null || bankKs.isEmpty())
                {
                    unbound++;
                    continue;
                }
                for (SpasQbQuestionKnowledge bk : bankKs)
                {
                    if (bk == null || bk.getKnowledgeId() == null)
                    {
                        continue;
                    }
                    SpasQuestionKnowledge link = new SpasQuestionKnowledge();
                    link.setQuestionId(item.getQuestionId());
                    link.setKnowledgeId(bk.getKnowledgeId());
                    link.setWeight(bk.getWeight());
                    links.add(link);
                }
            }
        }
        List<String> issues = PaperAnnotationInspector.issues(qs, links);
        int weightBad = 0;
        for (String msg : issues)
        {
            if (msg != null && (msg.contains("\u987b\u7b49\u4e8e") || msg.contains("\u7a7a\u6743\u91cd")))
            {
                weightBad++;
            }
        }
        Map<String, Object> out = new HashMap<>();
        out.put("unbound", unbound);
        out.put("weightBad", weightBad);
        out.put("issueCount", issues.size());
        out.put("issues", issues);
        return out;
    }

    private void copyKnowledge(Long analysisQuestionId, List<SpasQbQuestionKnowledge> bankKs)
    {
        if (bankKs == null || bankKs.isEmpty())
        {
            return;
        }
        List<SpasQuestionKnowledge> links = new ArrayList<>();
        for (SpasQbQuestionKnowledge bk : bankKs)
        {
            SpasQuestionKnowledge link = new SpasQuestionKnowledge();
            link.setQuestionId(analysisQuestionId);
            link.setKnowledgeId(bk.getKnowledgeId());
            link.setWeight(bk.getWeight());
            link.setIsPrimary(bk.getIsPrimary());
            links.add(link);
        }
        paperMapper.batchInsertQuestionKnowledge(links);
    }

    @Override
    public Map<String, Object> weakCover(Long paperId, Long deptId, Long subjectId, Integer limit)
    {
        if (paperId == null || deptId == null)
        {
            throw new ServiceException("题库卷与班级不能为空");
        }
        SpasQbPaper paper = bankPaperMapper.selectSpasQbPaperById(paperId);
        if (paper == null)
        {
            throw new ServiceException("题库卷不存在");
        }
        Long sid = subjectId != null ? subjectId : paper.getSubjectId();
        int lim = limit == null ? 15 : Math.max(1, Math.min(50, limit));
        List<Long> coveredIds = bankPaperMapper.selectKnowledgeIdsByPaperId(paperId);
        Set<Long> covered = new HashSet<>(coveredIds == null ? new ArrayList<>() : coveredIds);
        List<Map<String, Object>> weak = analysisService.classWeakTop(deptId, sid, lim);
        if (weak == null)
        {
            weak = new ArrayList<>();
        }
        List<Map<String, Object>> uncovered = new ArrayList<>();
        int hit = 0;
        for (Map<String, Object> row : weak)
        {
            if (row == null)
            {
                continue;
            }
            Object kidObj = row.get("knowledgeId");
            if (kidObj == null)
            {
                kidObj = row.get("knowledge_id");
            }
            Long kid = null;
            if (kidObj instanceof Number)
            {
                kid = ((Number) kidObj).longValue();
            }
            else if (kidObj != null)
            {
                try
                {
                    kid = Long.parseLong(String.valueOf(kidObj));
                }
                catch (Exception e)
                {
                    /* ignore */
                }
            }
            boolean ok = kid != null && covered.contains(kid);
            if (ok)
            {
                hit++;
            }
            else
            {
                uncovered.add(row);
            }
            row.put("covered", ok);
        }
        Map<String, Object> out = new HashMap<>();
        out.put("weakTotal", weak.size());
        out.put("covered", hit);
        out.put("uncovered", uncovered);
        out.put("weakList", weak);
        out.put("coveredIds", coveredIds);
        out.put("coverageRate", weak.isEmpty() ? 1.0 : (double) hit / (double) weak.size());
        return out;
    }
}
