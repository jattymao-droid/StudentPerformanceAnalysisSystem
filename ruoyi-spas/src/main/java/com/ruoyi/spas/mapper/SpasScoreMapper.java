package com.ruoyi.spas.mapper;

import java.util.List;
import com.ruoyi.spas.domain.SpasScoreBatch;
import com.ruoyi.spas.domain.SpasScoreDetail;

/**
 * Score batch / detail mapper
 */
public interface SpasScoreMapper
{
    public List<SpasScoreBatch> selectSpasScoreBatchList(SpasScoreBatch batch);

    public SpasScoreBatch selectSpasScoreBatchById(Long batchId);

    public int insertSpasScoreBatch(SpasScoreBatch batch);

    public int updateSpasScoreBatch(SpasScoreBatch batch);

    public List<SpasScoreDetail> selectSpasScoreDetailList(SpasScoreDetail detail);

    public int upsertSpasScoreDetail(SpasScoreDetail detail);

    public int countScoreDetailByPaperId(Long paperId);

    public int restoreDetailFromPrevByBatchId(Long batchId);

    public int deleteDetailByBatchId(Long batchId);

    public List<Long> selectStudentIdsByBatchId(Long batchId);

    public int countDetailByBatchId(Long batchId);

    public int deleteBatchById(Long batchId);
}
