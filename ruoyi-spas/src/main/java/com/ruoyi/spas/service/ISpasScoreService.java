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

    public void downloadTemplate(Long paperId, HttpServletResponse response);

    public SpasScoreBatch importScores(Long paperId, MultipartFile file, String operName);

    public void exportScoreDetail(SpasScoreDetail detail, HttpServletResponse response);

    public int revokeBatch(Long batchId);
}
