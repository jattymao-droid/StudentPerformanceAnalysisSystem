package com.ruoyi.spas.service;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import com.ruoyi.spas.domain.SpasPracticeLog;
import com.ruoyi.spas.domain.SpasStudentPointAccount;
import com.ruoyi.spas.domain.SpasStudentPointLedger;

public interface ISpasStudentPointService
{
    /**
     * Award points for a practice log. Proxy logs award only when proxyConfirmed=true.
     * @return total points awarded in this call (0 if skipped/capped/idempotent)
     */
    int awardForPracticeLog(SpasPracticeLog log, boolean proxyConfirmed);

    /** 组员当日确认属实后发分（未做/请假/未到为 0） */
    int awardCheckoutAck(Long studentId, Long deptId, Long subjectId, Long itemId, String finishStatus);

    /** 组长按时提交检查单 */
    int awardCheckoutSubmit(Long leaderStudentId, Long deptId, Long subjectId, Long checkoutId);

    /** 抽检一致补发核实分 */
    int awardCheckoutSpotMatch(Long studentId, Long deptId, Long subjectId, Long itemId);

    /** 偏松作废：扣回该 item 的检查确认积分（幂等） */
    int clawbackCheckoutAck(Long studentId, Long deptId, Long subjectId, Long itemId);

    /**
     * Compare before/after mastery rates and award gains for recently practiced knowledge.
     */
    int awardMasteryGains(Collection<Long> studentIds, Map<String, Double> beforeRates);

    Map<String, Double> snapshotRates(Collection<Long> studentIds);

    Map<String, Object> getMine();

    List<SpasStudentPointLedger> getMyLedger(Integer limit);

    Map<String, Object> getLeaderboard(Long deptId, Long subjectId, String range, Integer limit);

    /** 班级成长农场：本班全部学生植物长势（含 0 分） */
    Map<String, Object> getClassFarm(Long deptId);

    /**
     * 演示：为本班学生写入覆盖萌芽/浮叶/花蕾/盛放四阶段的积分（覆盖账户总分，幂等流水）。
     * @return deptId / updated / stages summary
     */
    Map<String, Object> seedFarmGrowthDemo(Long deptId);

    /**
     * 教师对本班多名学生一键发放奖励分（计入日封顶；biz_key 幂等）。
     * @return awardedTotal / successCount / cappedCount / skippedCount / results / batchId
     */
    Map<String, Object> awardTeacherBatch(Long deptId, Long subjectId, List<Long> studentIds,
        int points, String remark, String batchId);

    SpasStudentPointAccount ensureAccount(Long studentId);

    /**
     * 实考导入后：按本班名次赋分（第1名=班级参赛人数分，名次越低分越少）。
     * 覆盖重导时先冲销该考试旧分再重发。
     * @return 本次新发放合计
     */
    int syncExamClassRankPoints(Long examId);

    /** 删除考试或作废时：冲销该考试已发的班级名次积分 */
    int clearExamClassRankPoints(Long examId);
}
