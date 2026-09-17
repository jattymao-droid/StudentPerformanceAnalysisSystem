package com.ruoyi.spas.service;

import java.util.List;
import com.ruoyi.spas.domain.SpasPaper;
import com.ruoyi.spas.domain.SpasPaperQuestion;

/**
 * Paper service
 */
public interface ISpasPaperService
{
    public List<SpasPaper> selectSpasPaperList(SpasPaper paper);

    public SpasPaper selectSpasPaperById(Long paperId);

    public int insertSpasPaper(SpasPaper paper);

    public int updateSpasPaper(SpasPaper paper);

    public int deleteSpasPaperByIds(Long[] paperIds);

    public int publishPaper(Long paperId);

    public int archivePaper(Long paperId);

    public int savePaperQuestions(Long paperId, List<SpasPaperQuestion> questions);

    public int copyPaper(Long paperId, String operName);
}
