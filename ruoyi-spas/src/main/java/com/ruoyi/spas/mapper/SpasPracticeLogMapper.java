package com.ruoyi.spas.mapper;

import java.util.Date;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasPracticeLog;
import com.ruoyi.spas.domain.SpasPracticeLogKnowledge;

public interface SpasPracticeLogMapper
{
    List<SpasPracticeLog> selectSpasPracticeLogList(SpasPracticeLog query);

    SpasPracticeLog selectSpasPracticeLogById(Long logId);

    int insertSpasPracticeLog(SpasPracticeLog log);

    int updateSpasPracticeLog(SpasPracticeLog log);

    int softDeleteSpasPracticeLog(Long logId);

    int deleteKnowledgeByLogId(Long logId);

    int insertKnowledge(SpasPracticeLogKnowledge link);

    List<SpasPracticeLogKnowledge> selectKnowledgeByLogId(Long logId);

    int upsertBookStat(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("bookName") String bookName);

    List<Map<String, Object>> suggestBooks(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("q") String q, @Param("limit") Integer limit);

    List<SpasPracticeLog> selectTodayByStudent(@Param("studentId") Long studentId, @Param("practiceDate") Date practiceDate);

    List<SpasPracticeLog> selectRecentByStudent(@Param("studentId") Long studentId,
        @Param("beginDate") Date beginDate, @Param("endDate") Date endDate);

    List<Map<String, Object>> selectGroupTodayProgress(@Param("groupId") Long groupId, @Param("practiceDate") Date practiceDate);

    List<Map<String, Object>> selectMissingStudents(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("practiceDate") Date practiceDate);

    List<Map<String, Object>> selectDifficultyLogs(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("practiceDate") Date practiceDate);

    List<Map<String, Object>> selectProxyHeavyStudents(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("sinceDate") Date sinceDate, @Param("minDays") Integer minDays);

    List<Map<String, Object>> selectContinuousMissing(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("endDate") Date endDate, @Param("days") Integer days);

    Map<String, Object> selectDailyStat(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("practiceDate") Date practiceDate);

    List<Map<String, Object>> selectWeekThemeOverlap(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("beginDate") Date beginDate, @Param("endDate") Date endDate);

    List<Map<String, Object>> selectSpotSample(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("beginDate") Date beginDate, @Param("endDate") Date endDate, @Param("limit") Integer limit);

    int updateSpot(SpasPracticeLog log);

    int upsertKioskDevice(@Param("deviceCode") String deviceCode, @Param("deviceName") String deviceName,
        @Param("deptId") Long deptId, @Param("lastStudentId") Long lastStudentId,
        @Param("appVersion") String appVersion);

    List<Map<String, Object>> selectKioskDevices(@Param("deptId") Long deptId);

    /** Practiced themes in window but still weak in mastery snapshot */
    List<Map<String, Object>> selectPracticedStillWeak(@Param("deptId") Long deptId,
        @Param("subjectId") Long subjectId, @Param("beginDate") Date beginDate,
        @Param("endDate") Date endDate, @Param("weakRate") Double weakRate);

    List<SpasPracticeLog> selectPendingProxyConfirm(@Param("studentId") Long studentId);

    int updateConfirmStatus(@Param("logId") Long logId, @Param("confirmStatus") String confirmStatus);
}
