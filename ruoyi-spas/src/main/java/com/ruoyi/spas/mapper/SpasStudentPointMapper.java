package com.ruoyi.spas.mapper;

import java.util.Date;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasStudentPointAccount;
import com.ruoyi.spas.domain.SpasStudentPointLedger;

public interface SpasStudentPointMapper
{
    SpasStudentPointAccount selectAccount(Long studentId);

    int upsertAccount(SpasStudentPointAccount account);

    int insertLedger(SpasStudentPointLedger ledger);

    SpasStudentPointLedger selectLedgerByBizKey(String bizKey);

    int sumPointsToday(@Param("studentId") Long studentId, @Param("day") Date day);

    /** 计入日封顶的今日分（不含考试名次发分/冲销） */
    int sumCapPointsToday(@Param("studentId") Long studentId, @Param("day") Date day);

    /** 原子增减账户积分并重算等级/周积分 */
    int applyAccountDelta(@Param("studentId") Long studentId, @Param("delta") int delta,
        @Param("weekStart") Date weekStart, @Param("lastPracticeDate") Date lastPracticeDate,
        @Param("dayStreak") Integer dayStreak);

    int countReasonToday(@Param("studentId") Long studentId, @Param("reasonCode") String reasonCode,
        @Param("day") Date day, @Param("subjectId") Long subjectId);

    int countLogsOnDay(@Param("studentId") Long studentId, @Param("subjectId") Long subjectId,
        @Param("practiceDate") Date practiceDate);

    List<SpasStudentPointLedger> selectLedgerByStudent(@Param("studentId") Long studentId,
        @Param("limit") Integer limit);

    List<SpasStudentPointAccount> selectLeaderboardAll(@Param("deptId") Long deptId,
        @Param("limit") Integer limit);

    List<SpasStudentPointAccount> selectLeaderboardWeek(@Param("deptId") Long deptId,
        @Param("weekStart") Date weekStart, @Param("limit") Integer limit);

    /** 班级成长农场：本班全部在读学生（含 0 分） */
    List<SpasStudentPointAccount> selectClassFarm(@Param("deptId") Long deptId);

    Integer selectRankAll(@Param("deptId") Long deptId, @Param("studentId") Long studentId);

    Integer selectRankWeek(@Param("deptId") Long deptId, @Param("weekStart") Date weekStart,
        @Param("studentId") Long studentId);

    List<Map<String, Object>> selectRatesByStudents(@Param("studentIds") List<Long> studentIds);

    List<Long> selectPracticedKnowledgeIds(@Param("studentId") Long studentId,
        @Param("beginDate") Date beginDate, @Param("endDate") Date endDate);

    /** 某考试已发放的班级名次积分流水（正分，不含冲销） */
    List<SpasStudentPointLedger> selectExamClassRankLedgers(@Param("examId") Long examId);
}
