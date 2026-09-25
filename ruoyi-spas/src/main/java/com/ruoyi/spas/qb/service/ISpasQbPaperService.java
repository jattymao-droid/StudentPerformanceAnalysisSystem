package com.ruoyi.spas.qb.service;

import java.util.List;
import com.ruoyi.spas.domain.SpasPaper;
import com.ruoyi.spas.qb.domain.SpasQbPaper;
import com.ruoyi.spas.qb.domain.SpasQbPublishRequest;

/**
 * Bank paper compose + publish
 */
public interface ISpasQbPaperService
{
    List<SpasQbPaper> selectSpasQbPaperList(SpasQbPaper query);

    SpasQbPaper selectSpasQbPaperById(Long paperId);

    int insertSpasQbPaper(SpasQbPaper paper);

    int updateSpasQbPaper(SpasQbPaper paper);

    int deleteSpasQbPaperByIds(Long[] paperIds);

    /** Replace items and recalc total_score */
    int saveItems(SpasQbPaper paper);

    SpasPaper publishToAnalysis(SpasQbPublishRequest request, String operator);

    /**
     * Pre-publish annotation check: unbound KP and weight sum != 1.
     * @return unbound, weightBad, issueCount, issues
     */
    java.util.Map<String, Object> annotationCheck(Long paperId);

    /**
     * Compare paper knowledge coverage vs class weak-top.
     * @return map: weakTotal, covered, uncovered, coverageRate, weakList, coveredIds
     */
    java.util.Map<String, Object> weakCover(Long paperId, Long deptId, Long subjectId, Integer limit);
}
