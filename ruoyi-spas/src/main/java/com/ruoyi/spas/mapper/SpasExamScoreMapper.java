package com.ruoyi.spas.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasExam;
import com.ruoyi.spas.domain.SpasExamRankPoint;
import com.ruoyi.spas.domain.SpasExamScore;

/**
 * Exam score / school rank mapper
 */
public interface SpasExamScoreMapper
{
    public List<SpasExam> selectSpasExamList(SpasExam exam);

    public SpasExam selectSpasExamById(Long examId);

    public SpasExam selectSpasExamByDeptAndName(@Param("deptId") Long deptId, @Param("examName") String examName);

    public int insertSpasExam(SpasExam exam);

    public int updateSpasExam(SpasExam exam);

    public int deleteSpasExamById(Long examId);

    public int deleteSpasExamByIds(Long[] examIds);

    public List<SpasExamScore> selectSpasExamScoreList(SpasExamScore score);

    public int insertSpasExamScore(SpasExamScore score);

    public int deleteSpasExamScoreByExamId(Long examId);

    public int deleteSpasExamScoreByExamAndStudent(@Param("examId") Long examId, @Param("studentId") Long studentId);

    public int deleteSpasExamScoreByExamIds(Long[] examIds);

    public List<SpasExamScore> selectScoresByExamId(@Param("examId") Long examId);

    public List<SpasExamScore> selectScoresByStudentId(@Param("studentId") Long studentId);

    public List<SpasExamRankPoint> selectRankPoints();
}
