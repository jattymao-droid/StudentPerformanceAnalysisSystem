package com.ruoyi.spas.mapper;

import java.util.List;
import com.ruoyi.spas.domain.SpasPaper;
import com.ruoyi.spas.domain.SpasPaperQuestion;
import com.ruoyi.spas.domain.SpasQuestionKnowledge;

/**
 * Paper / question / knowledge link mapper
 */
public interface SpasPaperMapper
{
    public List<SpasPaper> selectSpasPaperList(SpasPaper paper);

    public SpasPaper selectSpasPaperById(Long paperId);

    public int insertSpasPaper(SpasPaper paper);

    public int updateSpasPaper(SpasPaper paper);

    public int deleteSpasPaperByIds(Long[] paperIds);

    public List<SpasPaperQuestion> selectQuestionsByPaperId(Long paperId);

    public SpasPaperQuestion selectQuestionById(Long questionId);

    public int insertSpasPaperQuestion(SpasPaperQuestion question);

    public int updateSpasPaperQuestion(SpasPaperQuestion question);

    public int deleteQuestionsByPaperId(Long paperId);

    public int deleteQuestionKnowledgeByPaperId(Long paperId);

    public int deleteQuestionKnowledgeByQuestionIds(Long[] questionIds);

    public int insertSpasQuestionKnowledge(SpasQuestionKnowledge link);

    public int batchInsertQuestionKnowledge(List<SpasQuestionKnowledge> list);

    public List<SpasQuestionKnowledge> selectKnowledgeByQuestionId(Long questionId);

    public List<SpasQuestionKnowledge> selectKnowledgeByPaperId(Long paperId);

    public int countScoreDetailByPaperId(Long paperId);
}
