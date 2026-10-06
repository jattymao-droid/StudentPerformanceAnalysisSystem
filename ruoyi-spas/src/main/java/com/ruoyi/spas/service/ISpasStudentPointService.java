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

    /**
     * Compare before/after mastery rates and award gains for recently practiced knowledge.
     */
    int awardMasteryGains(Collection<Long> studentIds, Map<String, Double> beforeRates);

    Map<String, Double> snapshotRates(Collection<Long> studentIds);

    Map<String, Object> getMine();

    List<SpasStudentPointLedger> getMyLedger(Integer limit);

    Map<String, Object> getLeaderboard(Long deptId, Long subjectId, String range, Integer limit);

    SpasStudentPointAccount ensureAccount(Long studentId);
}
