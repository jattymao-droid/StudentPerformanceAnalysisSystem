package com.ruoyi.spas.service;

import java.util.Date;
import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.spas.domain.SpasExam;
import com.ruoyi.spas.domain.SpasExamScore;

/**
 * Multi-subject exam score + school rank import
 */
public interface ISpasExamScoreService
{
    public List<SpasExam> selectSpasExamList(SpasExam exam);

    public SpasExam selectSpasExamById(Long examId);

    public List<SpasExamScore> selectScoresByExamId(Long examId);

    /** Wide matrix for UI: students x subjects */
    public Map<String, Object> selectExamMatrix(Long examId);

    public void downloadTemplate(Long deptId, HttpServletResponse response);

    /**
     * Import scores. When overwrite is true and same dept+examName exists, replace that batch.
     */
    public SpasExam importScores(String examName, Date examDate, Long deptId, MultipartFile file,
        boolean overwrite, String operName) throws Exception;

    public SpasExam importScores(String examName, Date examDate, Long deptId, Long paperId, MultipartFile file,
        boolean overwrite, String operName) throws Exception;

    /** Export one exam as wide Excel (same layout as template). */
    public void exportExam(Long examId, HttpServletResponse response);

    public int deleteSpasExamByIds(Long[] examIds);
}
