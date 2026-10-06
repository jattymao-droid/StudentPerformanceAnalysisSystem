package com.ruoyi.spas.service;

import java.util.Date;
import java.util.List;
import java.util.Map;
import com.ruoyi.spas.domain.SpasPracticeAssignment;
import com.ruoyi.spas.domain.SpasPracticeCheckout;

public interface ISpasPracticeCheckoutService
{
    List<SpasPracticeAssignment> listAssignments(SpasPracticeAssignment query);

    SpasPracticeAssignment getAssignment(Long assignmentId);

    int saveAssignment(SpasPracticeAssignment row);

    SpasPracticeAssignment copyLast(Long deptId, Long subjectId, Date assignDate);

    Map<String, Object> todayBundle(Long subjectId);

    int submitCheckout(SpasPracticeCheckout body);

    int ackItem(Long itemId, boolean accept);

    int followItem(Long itemId);

    Long toIntervene(Long itemId);

    int consumeLastAwardedPoints();

    Map<String, Object> alerts(Long deptId, Long subjectId, Date practiceDate);

    List<Map<String, Object>> spotQueue(Long deptId, Long subjectId, Date practiceDate);

    int recordSpot(Long itemId, String spotResult, String spotRemark);
}
