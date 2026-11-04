package com.ruoyi.spas.mapper;

import java.util.Date;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasPracticeAssignment;
import com.ruoyi.spas.domain.SpasPracticeCheckout;
import com.ruoyi.spas.domain.SpasPracticeCheckoutItem;

public interface SpasPracticeCheckoutMapper
{
    SpasPracticeAssignment selectAssignmentById(Long assignmentId);

    SpasPracticeAssignment selectAssignmentByDay(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("assignDate") Date assignDate);

    List<SpasPracticeAssignment> selectAssignmentList(SpasPracticeAssignment query);

    SpasPracticeAssignment selectLastAssignment(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("beforeDate") Date beforeDate);

    int insertAssignment(SpasPracticeAssignment row);

    int updateAssignment(SpasPracticeAssignment row);

    SpasPracticeCheckout selectCheckoutById(Long checkoutId);

    SpasPracticeCheckout selectCheckoutByGroupDay(@Param("groupId") Long groupId, @Param("practiceDate") Date practiceDate,
        @Param("assignmentId") Long assignmentId);

    int insertCheckout(SpasPracticeCheckout row);

    int updateCheckout(SpasPracticeCheckout row);

    int deleteItems(Long checkoutId);

    int insertItem(SpasPracticeCheckoutItem item);

    /** Update finish/difficulty/knowledge/ack for pending amend (keeps item_id). */
    int updateItemContent(SpasPracticeCheckoutItem item);

    int updateItemAck(SpasPracticeCheckoutItem item);

    int updateItemSpot(SpasPracticeCheckoutItem item);

    int updateItemFollow(@Param("itemId") Long itemId, @Param("followStatus") String followStatus);

    int countSpotByItemId(@Param("itemId") Long itemId);

    /** Expire pending member acks for practice_date before today → member_ack=3 */
    int expirePendingAcksBefore(@Param("beforeDate") Date beforeDate);

    SpasPracticeCheckoutItem selectItemById(Long itemId);

    List<SpasPracticeCheckoutItem> selectItems(Long checkoutId);

    List<SpasPracticeCheckoutItem> selectMyPendingAck(@Param("studentId") Long studentId, @Param("practiceDate") Date practiceDate);

    List<Map<String, Object>> selectSpotQueue(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("practiceDate") Date practiceDate);

    List<Map<String, Object>> selectMissingCheckout(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("practiceDate") Date practiceDate);

    List<Map<String, Object>> selectPendingAck(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("practiceDate") Date practiceDate);

    List<Map<String, Object>> selectDisputes(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("practiceDate") Date practiceDate);

    List<Map<String, Object>> selectTimeouts(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("practiceDate") Date practiceDate);

    List<Map<String, Object>> selectDifficultySummary(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("practiceDate") Date practiceDate);

    List<Map<String, Object>> selectDifficultyItems(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("practiceDate") Date practiceDate);

    int countWeekCheckout(@Param("groupId") Long groupId, @Param("beginDate") Date beginDate, @Param("endDate") Date endDate);

    int countWeekLoose(@Param("groupId") Long groupId, @Param("beginDate") Date beginDate, @Param("endDate") Date endDate);

    int countUnfollowedDifficulty(@Param("groupId") Long groupId, @Param("beginDate") Date beginDate,
        @Param("endDate") Date endDate);

    int countSpotsThisWeek(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId,
        @Param("beginDate") Date beginDate, @Param("endDate") Date endDate);

    List<Map<String, Object>> selectActiveGroups(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId);

    List<Long> selectLooseCheckerIds(@Param("deptId") Long deptId, @Param("beginDate") Date beginDate);

    int insertSpot(@Param("itemId") Long itemId, @Param("studentId") Long studentId, @Param("groupId") Long groupId,
        @Param("checkerStudentId") Long checkerStudentId, @Param("spotResult") String spotResult,
        @Param("spotBy") String spotBy, @Param("spotRemark") String spotRemark);

    /** Expire pending member ack before a practice date (typically yesterday). */
    int expirePendingAckBefore(@Param("beforeDate") Date beforeDate);
}
