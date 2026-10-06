package com.ruoyi.spas.service;

import java.util.Date;
import java.util.List;
import java.util.Map;
import com.ruoyi.spas.domain.SpasPracticeLog;

public interface ISpasPracticeLogService
{
    List<SpasPracticeLog> selectSpasPracticeLogList(SpasPracticeLog query);

    SpasPracticeLog selectSpasPracticeLogById(Long logId);

    int insertSelf(SpasPracticeLog log);

    int insertProxy(SpasPracticeLog log);

    /** Points awarded by the latest insertSelf/insertProxy/confirmProxy on this thread. */
    int consumeLastAwardedPoints();

    int updateSpasPracticeLog(SpasPracticeLog log);

    int deleteSpasPracticeLogById(Long logId);

    Map<String, Object> mineToday(Long subjectId);

    List<SpasPracticeLog> mineRecent(Integer days);

    List<Map<String, Object>> suggestWeak(Long subjectId, Integer limit);

    List<Map<String, Object>> suggestBooks(Long deptId, Long subjectId, String q);

    Map<String, Object> groupToday(Long groupId, Date practiceDate);

    Map<String, Object> dailyStat(Long deptId, Long subjectId, Date practiceDate);

    Map<String, Object> alerts(Long deptId, Long subjectId, Date practiceDate);

    List<Map<String, Object>> weekThemeOverlap(Long deptId, Long subjectId, Date beginDate, Date endDate);

    List<Map<String, Object>> spotSample(Long deptId, Long subjectId, Date beginDate, Date endDate, Integer limit);

    int updateSpot(Long logId, String spotStatus, String spotRemark);

    Long toIntervene(Long logId);

    Map<String, Object> sessionProfile();

    int heartbeatDevice(String deviceCode, String deviceName, Long deptId, String appVersion);

    List<Map<String, Object>> listDevices(Long deptId);

    List<Map<String, Object>> practicedStillWeak(Long deptId, Long subjectId, Date beginDate, Date endDate);

    List<SpasPracticeLog> pendingProxyConfirm();

    int confirmProxy(Long logId, boolean accept);
}
