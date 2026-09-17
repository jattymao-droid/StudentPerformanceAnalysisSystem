package com.ruoyi.spas.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.spas.analysis.KnowledgeStatCalculator;
import com.ruoyi.spas.config.SpasPaperProperties;
import com.ruoyi.spas.domain.SpasPaper;
import com.ruoyi.spas.domain.SpasPaperQuestion;
import com.ruoyi.spas.domain.SpasQuestionKnowledge;
import com.ruoyi.spas.mapper.SpasPaperMapper;
import com.ruoyi.spas.service.ISpasPaperService;
import com.ruoyi.spas.support.SpasAccessService;
import com.ruoyi.spas.support.SpasTeacherScopeService;
import com.ruoyi.spas.warning.WarningEngine;

/**
 * Paper service implementation
 */
@Service
public class SpasPaperServiceImpl implements ISpasPaperService
{
    private static final BigDecimal WEIGHT_ONE = BigDecimal.ONE;
    private static final BigDecimal WEIGHT_EPS = new BigDecimal("0.0001");

    @Autowired
    private SpasPaperMapper paperMapper;

    @Autowired
    private SpasPaperProperties paperProperties;

    @Autowired
    private SpasTeacherScopeService teacherScopeService;

    @Autowired
    private SpasAccessService accessService;

    @Autowired
    private KnowledgeStatCalculator knowledgeStatCalculator;

    @Autowired
    private WarningEngine warningEngine;

    @Override
    public List<SpasPaper> selectSpasPaperList(SpasPaper paper)
    {
        if (teacherScopeService.useTeacherDeptFilter())
        {
            teacherScopeService.applyTeacherDeptFilter(paper);
            return paperMapper.selectSpasPaperList(paper);
        }
        return SpringUtils.getAopProxy(this).selectSpasPaperListScoped(paper);
    }

    @DataScope(deptAlias = "d")
    public List<SpasPaper> selectSpasPaperListScoped(SpasPaper paper)
    {
        return paperMapper.selectSpasPaperList(paper);
    }

    @Override
    public SpasPaper selectSpasPaperById(Long paperId)
    {
        SpasPaper paper = paperMapper.selectSpasPaperById(paperId);
        if (paper != null)
        {
            accessService.checkDeptAccess(paper.getDeptId());
            List<SpasPaperQuestion> questions = paperMapper.selectQuestionsByPaperId(paperId);
            List<SpasQuestionKnowledge> allLinks = paperMapper.selectKnowledgeByPaperId(paperId);
            for (SpasPaperQuestion q : questions)
            {
                List<SpasQuestionKnowledge> qLinks = new ArrayList<SpasQuestionKnowledge>();
                for (SpasQuestionKnowledge link : allLinks)
                {
                    if (link.getQuestionId().equals(q.getQuestionId()))
                    {
                        qLinks.add(link);
                    }
                }
                q.setKnowledgeList(qLinks);
            }
            paper.setQuestions(questions);
            paper.setScoreCount(paperMapper.countScoreDetailByPaperId(paperId));
            paper.setAllowChangeKnowledgeAfterScore(paperProperties.isAllowChangeKnowledgeAfterScore());
        }
        return paper;
    }

    @Override
    @Transactional
    public int insertSpasPaper(SpasPaper paper)
    {
        if (paper.getDeptId() != null)
        {
            accessService.checkDeptAccess(paper.getDeptId());
        }
        if (StringUtils.isEmpty(paper.getStatus()))
        {
            paper.setStatus("0");
        }
        validateQuestions(paper.getQuestions());
        BigDecimal total = calcTotalScore(paper.getQuestions());
        paper.setTotalScore(total);
        int rows = paperMapper.insertSpasPaper(paper);
        saveQuestionsInternal(paper.getPaperId(), paper.getQuestions(), paper.getCreateBy());
        return rows;
    }

    @Override
    @Transactional
    public int updateSpasPaper(SpasPaper paper)
    {
        SpasPaper db = paperMapper.selectSpasPaperById(paper.getPaperId());
        if (db == null)
        {
            throw new ServiceException("\u8bd5\u5377\u4e0d\u5b58\u5728");
        }
        accessService.checkDeptAccess(db.getDeptId());
        int scoreCount = paperMapper.countScoreDetailByPaperId(paper.getPaperId());
        if (scoreCount > 0)
        {
            SpasPaper meta = new SpasPaper();
            meta.setPaperId(paper.getPaperId());
            meta.setPaperName(paper.getPaperName());
            meta.setExamDate(paper.getExamDate());
            meta.setRemark(paper.getRemark());
            meta.setUpdateBy(paper.getUpdateBy());
            if (paper.getQuestions() != null && !paper.getQuestions().isEmpty())
            {
                if (paperProperties.isAllowChangeKnowledgeAfterScore())
                {
                    return updateKnowledgeOnly(paper.getPaperId(), paper.getQuestions(), paper.getUpdateBy());
                }
                throw new ServiceException("\u8bd5\u5377\u5df2\u6709\u6210\u7ee9\uff0c\u7981\u6b62\u4fee\u6539\u9898\u76ee\u7ed3\u6784\uff08\u53ef\u5728\u914d\u7f6e\u4e2d\u5f00\u542f\u4ec5\u6539\u77e5\u8bc6\u70b9\uff09");
            }
            return paperMapper.updateSpasPaper(meta);
        }
        if (paper.getQuestions() != null)
        {
            validateQuestions(paper.getQuestions());
            paper.setTotalScore(calcTotalScore(paper.getQuestions()));
            paperMapper.deleteQuestionKnowledgeByPaperId(paper.getPaperId());
            paperMapper.deleteQuestionsByPaperId(paper.getPaperId());
            saveQuestionsInternal(paper.getPaperId(), paper.getQuestions(), paper.getUpdateBy());
        }
        return paperMapper.updateSpasPaper(paper);
    }

    @Override
    @Transactional
    public int deleteSpasPaperByIds(Long[] paperIds)
    {
        for (Long paperId : paperIds)
        {
            SpasPaper db = paperMapper.selectSpasPaperById(paperId);
            if (db != null)
            {
                accessService.checkDeptAccess(db.getDeptId());
            }
            if (paperMapper.countScoreDetailByPaperId(paperId) > 0)
            {
                throw new ServiceException("\u8bd5\u5377\u5df2\u6709\u6210\u7ee9\u660e\u7ec6\uff0c\u65e0\u6cd5\u5220\u9664");
            }
            paperMapper.deleteQuestionKnowledgeByPaperId(paperId);
            paperMapper.deleteQuestionsByPaperId(paperId);
        }
        return paperMapper.deleteSpasPaperByIds(paperIds);
    }

    @Override
    public int publishPaper(Long paperId)
    {
        SpasPaper paper = paperMapper.selectSpasPaperById(paperId);
        if (paper == null)
        {
            throw new ServiceException("\u8bd5\u5377\u4e0d\u5b58\u5728");
        }
        accessService.checkDeptAccess(paper.getDeptId());
        List<SpasPaperQuestion> questions = paperMapper.selectQuestionsByPaperId(paperId);
        if (questions == null || questions.isEmpty())
        {
            throw new ServiceException("\u8bf7\u5148\u7ef4\u62a4\u9898\u76ee\u540e\u518d\u53d1\u5e03");
        }
        SpasPaper update = new SpasPaper();
        update.setPaperId(paperId);
        update.setStatus("1");
        update.setPublishTime(new Date());
        return paperMapper.updateSpasPaper(update);
    }

    @Override
    public int archivePaper(Long paperId)
    {
        SpasPaper paper = paperMapper.selectSpasPaperById(paperId);
        if (paper != null)
        {
            accessService.checkDeptAccess(paper.getDeptId());
        }
        SpasPaper update = new SpasPaper();
        update.setPaperId(paperId);
        update.setStatus("2");
        return paperMapper.updateSpasPaper(update);
    }

    @Override
    @Transactional
    public int savePaperQuestions(Long paperId, List<SpasPaperQuestion> questions)
    {
        SpasPaper paper = paperMapper.selectSpasPaperById(paperId);
        if (paper == null)
        {
            throw new ServiceException("\u8bd5\u5377\u4e0d\u5b58\u5728");
        }
        accessService.checkDeptAccess(paper.getDeptId());
        if (paperMapper.countScoreDetailByPaperId(paperId) > 0)
        {
            if (paperProperties.isAllowChangeKnowledgeAfterScore())
            {
                validateQuestions(questions);
                return updateKnowledgeOnly(paperId, questions, null);
            }
            throw new ServiceException("\u8bd5\u5377\u5df2\u6709\u6210\u7ee9\uff0c\u7981\u6b62\u4fee\u6539\u9898\u76ee\u7ed3\u6784\uff08\u53ef\u5728\u914d\u7f6e\u4e2d\u5f00\u542f\u4ec5\u6539\u77e5\u8bc6\u70b9\uff09");
        }
        validateQuestions(questions);
        paperMapper.deleteQuestionKnowledgeByPaperId(paperId);
        paperMapper.deleteQuestionsByPaperId(paperId);
        saveQuestionsInternal(paperId, questions, null);
        SpasPaper update = new SpasPaper();
        update.setPaperId(paperId);
        update.setTotalScore(calcTotalScore(questions));
        return paperMapper.updateSpasPaper(update);
    }

    @Override
    @Transactional
    public int copyPaper(Long paperId, String operName)
    {
        SpasPaper source = selectSpasPaperById(paperId);
        if (source == null)
        {
            throw new ServiceException("\u8bd5\u5377\u4e0d\u5b58\u5728");
        }
        SpasPaper copy = new SpasPaper();
        copy.setPaperName(source.getPaperName() + " (\u526f\u672c)");
        copy.setPaperType(source.getPaperType());
        copy.setSubjectId(source.getSubjectId());
        copy.setDeptId(source.getDeptId());
        copy.setExamDate(source.getExamDate());
        copy.setStatus("0");
        copy.setRemark(source.getRemark());
        copy.setCreateBy(operName);
        List<SpasPaperQuestion> questions = source.getQuestions();
        if (questions != null)
        {
            List<SpasPaperQuestion> cloned = new ArrayList<SpasPaperQuestion>();
            for (SpasPaperQuestion q : questions)
            {
                SpasPaperQuestion nq = new SpasPaperQuestion();
                nq.setQuestionNo(q.getQuestionNo());
                nq.setQuestionOrder(q.getQuestionOrder());
                nq.setFullScore(q.getFullScore());
                nq.setDifficulty(q.getDifficulty());
                nq.setRemark(q.getRemark());
                if (q.getKnowledgeList() != null)
                {
                    List<SpasQuestionKnowledge> links = new ArrayList<SpasQuestionKnowledge>();
                    for (SpasQuestionKnowledge link : q.getKnowledgeList())
                    {
                        SpasQuestionKnowledge nl = new SpasQuestionKnowledge();
                        nl.setKnowledgeId(link.getKnowledgeId());
                        nl.setWeight(link.getWeight());
                        nl.setIsPrimary(link.getIsPrimary());
                        links.add(nl);
                    }
                    nq.setKnowledgeList(links);
                }
                cloned.add(nq);
            }
            copy.setQuestions(cloned);
        }
        return insertSpasPaper(copy);
    }

    private int updateKnowledgeOnly(Long paperId, List<SpasPaperQuestion> questions, String operName)
    {
        List<SpasPaperQuestion> existing = paperMapper.selectQuestionsByPaperId(paperId);
        if (existing == null || questions == null || existing.size() != questions.size())
        {
            throw new ServiceException("\u5df2\u6709\u6210\u7ee9\u65f6\u4ec5\u5141\u8bb8\u8c03\u6574\u77e5\u8bc6\u70b9\u6743\u91cd\uff0c\u4e0d\u80fd\u589e\u5220\u9898\u76ee");
        }
        Map<String, SpasPaperQuestion> existingByNo = new HashMap<String, SpasPaperQuestion>();
        for (SpasPaperQuestion q : existing)
        {
            existingByNo.put(q.getQuestionNo(), q);
        }
        for (SpasPaperQuestion q : questions)
        {
            SpasPaperQuestion old = existingByNo.get(q.getQuestionNo());
            if (old == null)
            {
                throw new ServiceException("\u5df2\u6709\u6210\u7ee9\u65f6\u4e0d\u80fd\u4fee\u6539\u9898\u53f7\u7ed3\u6784");
            }
            validateQuestions(Collections.singletonList(q));
            paperMapper.deleteQuestionKnowledgeByQuestionIds(new Long[] { old.getQuestionId() });
            List<SpasQuestionKnowledge> links = q.getKnowledgeList();
            if (links == null)
            {
                continue;
            }
            for (SpasQuestionKnowledge link : links)
            {
                link.setQuestionId(old.getQuestionId());
            }
            if (!links.isEmpty())
            {
                paperMapper.batchInsertQuestionKnowledge(links);
            }
        }
        knowledgeStatCalculator.recalculateByPaper(paperId);
        warningEngine.evaluateAfterPaper(paperId);
        return 1;
    }

    private void saveQuestionsInternal(Long paperId, List<SpasPaperQuestion> questions, String operName)
    {
        if (questions == null || questions.isEmpty())
        {
            return;
        }
        for (SpasPaperQuestion q : questions)
        {
            q.setPaperId(paperId);
            if (StringUtils.isNotEmpty(operName))
            {
                q.setCreateBy(operName);
            }
            paperMapper.insertSpasPaperQuestion(q);
            List<SpasQuestionKnowledge> links = q.getKnowledgeList();
            if (links == null)
            {
                continue;
            }
            for (SpasQuestionKnowledge link : links)
            {
                link.setQuestionId(q.getQuestionId());
            }
            if (!links.isEmpty())
            {
                paperMapper.batchInsertQuestionKnowledge(links);
            }
        }
    }

    private void validateQuestions(List<SpasPaperQuestion> questions)
    {
        if (questions == null)
        {
            return;
        }
        for (SpasPaperQuestion q : questions)
        {
            if (StringUtils.isEmpty(q.getQuestionNo()))
            {
                throw new ServiceException("\u9898\u53f7\u4e0d\u80fd\u4e3a\u7a7a");
            }
            if (q.getFullScore() == null || q.getFullScore().compareTo(BigDecimal.ZERO) <= 0)
            {
                throw new ServiceException("\u9898\u76ee " + q.getQuestionNo() + " \u6ee1\u5206\u5fc5\u987b\u5927\u4e8e 0");
            }
            List<SpasQuestionKnowledge> links = q.getKnowledgeList();
            if (links == null || links.isEmpty())
            {
                throw new ServiceException("\u9898\u76ee " + q.getQuestionNo() + " \u81f3\u5c11\u7ed1\u5b9a\u4e00\u4e2a\u77e5\u8bc6\u70b9");
            }
            BigDecimal sum = BigDecimal.ZERO;
            for (SpasQuestionKnowledge link : links)
            {
                if (link.getKnowledgeId() == null)
                {
                    throw new ServiceException("\u9898\u76ee " + q.getQuestionNo() + " \u77e5\u8bc6\u70b9ID\u4e0d\u80fd\u4e3a\u7a7a");
                }
                if (link.getWeight() == null)
                {
                    throw new ServiceException("\u9898\u76ee " + q.getQuestionNo() + " \u77e5\u8bc6\u70b9\u6743\u91cd\u4e0d\u80fd\u4e3a\u7a7a");
                }
                sum = sum.add(link.getWeight());
            }
            if (sum.subtract(WEIGHT_ONE).abs().compareTo(WEIGHT_EPS) > 0)
            {
                throw new ServiceException("\u9898\u76ee " + q.getQuestionNo() + " \u77e5\u8bc6\u70b9\u6743\u91cd\u4e4b\u548c\u5fc5\u987b\u7b49\u4e8e 1");
            }
        }
    }

    private BigDecimal calcTotalScore(List<SpasPaperQuestion> questions)
    {
        BigDecimal total = BigDecimal.ZERO;
        if (questions != null)
        {
            for (SpasPaperQuestion q : questions)
            {
                if (q.getFullScore() != null)
                {
                    total = total.add(q.getFullScore());
                }
            }
        }
        return total.setScale(2, RoundingMode.HALF_UP);
    }
}
