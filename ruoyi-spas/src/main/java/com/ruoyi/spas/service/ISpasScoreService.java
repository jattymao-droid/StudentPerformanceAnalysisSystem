package com.ruoyi.spas.service;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.spas.domain.SpasScoreBatch;
import com.ruoyi.spas.domain.SpasScoreDetail;

/**
 * Score import service
 */
public interface ISpasScoreService
{
    public List<SpasScoreBatch> selectSpasScoreBatchList(SpasScoreBatch batch);

    public List<SpasScoreDetail> selectSpasScoreDetailList(SpasScoreDetail detail);

    public SpasScoreDetail selectSpasScoreDetailById(Long detailId);

    public int insertSpasScoreDetail(SpasScoreDetail detail);

    public int updateSpasScoreDetail(SpasScoreDetail detail);

    public int deleteSpasScoreDetailByIds(Long[] detailIds);

    public void downloadTemplate(Long paperId, HttpServletResponse response);

    public SpasScoreBatch importScores(Long paperId, MultipartFile file, String operName);

    public void exportScoreDetail(SpasScoreDetail detail, HttpServletResponse response);

    public int revokeBatch(Long batchId);
}
