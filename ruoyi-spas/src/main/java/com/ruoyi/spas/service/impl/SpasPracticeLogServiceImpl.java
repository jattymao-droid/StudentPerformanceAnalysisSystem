package com.ruoyi.spas.service.impl;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.spas.domain.SpasInterveneTask;
import com.ruoyi.spas.domain.SpasPracticeLog;
import com.ruoyi.spas.domain.SpasPracticeLogKnowledge;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.domain.SpasStudyGroup;
import com.ruoyi.spas.domain.SpasStudyGroupMember;
import com.ruoyi.spas.mapper.SpasPracticeLogMapper;
import com.ruoyi.spas.mapper.SpasStudentMapper;
import com.ruoyi.spas.mapper.SpasStudyGroupMapper;
import com.ruoyi.spas.service.ISpasAnalysisService;
import com.ruoyi.spas.service.ISpasInterveneService;
import com.ruoyi.spas.service.ISpasPracticeLogService;
import com.ruoyi.spas.service.ISpasStudentPointService;
import com.ruoyi.spas.support.SpasAccessService;
import com.ruoyi.spas.support.SpasTeacherScopeService;

@Service
public class SpasPracticeLogServiceImpl implements ISpasPracticeLogService
{
    private static final ThreadLocal<Integer> LAST_AWARDED_POINTS = new ThreadLocal<Integer>();

    @Autowired
    private SpasPracticeLogMapper practiceMapper;

    @Autowired
    private SpasStudentMapper studentMapper;

    @Autowired
    private SpasStudyGroupMapper groupMapper;

    @Autowired
    private SpasAccessService accessService;

    @Autowired
    private SpasTeacherScopeService teacherScopeService;

    @Autowired
    private ISpasAnalysisService analysisService;

    @Autowired
    private ISpasInterveneService interveneService;

    @Autowired
    private ISpasStudentPointService pointService;

    @Override
    public List<SpasPracticeLog> selectSpasPracticeLogList(SpasPracticeLog query)
    {
        if (query == null)
        {
            query = new SpasPracticeLog();
        }
        if (teacherScopeService.useTeacherDeptFilter())
        {
            teacherScopeService.applyTeacherDeptFilter(query);
            return practiceMapper.selectSpasPracticeLogList(query);
        }
        return SpringUtils.getAopProxy(this).selectSpasPracticeLogListScoped(query);
    }

    @DataScope(deptAlias = "d")
    public List<SpasPracticeLog> selectSpasPracticeLogListScoped(SpasPracticeLog query)
    {
        return practiceMapper.selectSpasPracticeLogList(query);
    }

    @Override
    public SpasPracticeLog selectSpasPracticeLogById(Long logId)
    {
        SpasPracticeLog log = requireLog(logId);
        accessService.checkStudentAccess(log.getStudentId());
        log.setKnowledgeList(practiceMapper.selectKnowledgeByLogId(logId));
        return log;
    }

    @Override
    @Transactional
    public int insertSelf(SpasPracticeLog log)
    {
        SpasStudent self = requireLoginStudent();
        log.setStudentId(self.getStudentId());
        log.setSubmitByStudentId(self.getStudentId());
        log.setProxyFlag("0");
        log.setConfirmStatus("0");
        return saveLog(log, self);
    }

    @Override
    @Transactional
    public int insertProxy(SpasPracticeLog log)
    {
        throw new ServiceException("日常完成请改用组长检查单提交，不再使用代提");
    }

    @Transactional
    public int insertProxyLegacy(SpasPracticeLog log)
    {
        SpasStudent operator = requireLoginStudent();
        if (log.getStudentId() == null)
        {
            throw new ServiceException("请选择组员");
        }
        if (operator.getStudentId().equals(log.getStudentId()))
        {
            log.setSubmitByStudentId(operator.getStudentId());
            log.setProxyFlag("0");
            log.setConfirmStatus("0");
            return saveLog(log, operator);
        }
        SpasStudent target = studentMapper.selectSpasStudentById(log.getStudentId());
        if (target == null)
        {
            throw new ServiceException("学生不存在");
        }
        SpasStudyGroup group = groupMapper.selectActiveGroupOfStudent(operator.getStudentId(),
            operator.getDeptId(), log.getSubjectId());
        if (group == null)
        {
            group = groupMapper.selectActiveGroupOfStudent(operator.getStudentId(), operator.getDeptId(), null);
        }
        if (group == null || group.getLeaderStudentId() == null
            || !group.getLeaderStudentId().equals(operator.getStudentId()))
        {
            throw new ServiceException("仅组长可代本组成员登记");
        }
        boolean sameGroup = false;
        List<SpasStudyGroupMember> members = groupMapper.selectActiveMembers(group.getGroupId());
        for (SpasStudyGroupMember m : members)
        {
            if (m.getStudentId().equals(target.getStudentId()))
            {
                sameGroup = true;
                break;
            }
        }
        if (!sameGroup)
        {
            throw new ServiceException("只能代提本组成员");
        }
        log.setSubmitByStudentId(operator.getStudentId());
        log.setProxyFlag("1");
        log.setConfirmStatus("1");
        log.setDeptId(target.getDeptId());
        log.setGroupId(group.getGroupId());
        return saveLog(log, target);
    }

    @Override
    @Transactional
    public int updateSpasPracticeLog(SpasPracticeLog log)
    {
        SpasPracticeLog db = requireLog(log.getLogId());
        SpasStudent self = currentStudentOrNull();
        if (self != null)
        {
            if (!self.getStudentId().equals(db.getStudentId())
                && !self.getStudentId().equals(db.getSubmitByStudentId()))
            {
                throw new ServiceException("只能修改本人或自己代提的记录");
            }
            Date today = DateUtils.parseDate(DateUtils.getDate());
            if (db.getPracticeDate() != null && db.getPracticeDate().before(today))
            {
                throw new ServiceException("仅允许修改当天记录");
            }
        }
        else
        {
            accessService.assertCanWrite();
            accessService.checkStudentAccess(db.getStudentId());
        }
        if ("3".equals(log.getFinishStatus()) && StringUtils.isEmpty(log.getDifficultyNote())
            && StringUtils.isEmpty(db.getDifficultyNote()))
        {
            throw new ServiceException("有困难时请填写卡点说明");
        }
        int rows = practiceMapper.updateSpasPracticeLog(log);
        if (log.getKnowledgeIds() != null)
        {
            saveKnowledge(db.getLogId(), log.getKnowledgeIds());
        }
        return rows;
    }

    @Override
    public int deleteSpasPracticeLogById(Long logId)
    {
        SpasPracticeLog db = requireLog(logId);
        SpasStudent self = currentStudentOrNull();
        if (self != null)
        {
            if (!self.getStudentId().equals(db.getStudentId())
                && !self.getStudentId().equals(db.getSubmitByStudentId()))
            {
                throw new ServiceException("只能作废本人或自己代提的记录");
            }
        }
        else
        {
            accessService.assertCanWrite();
            accessService.checkStudentAccess(db.getStudentId());
        }
        return practiceMapper.softDeleteSpasPracticeLog(logId);
    }

    @Override
    public Map<String, Object> mineToday(Long subjectId)
    {
        SpasStudent self = requireLoginStudent();
        Date today = DateUtils.parseDate(DateUtils.getDate());
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("student", self);
        data.put("practiceDate", DateUtils.getDate());
        List<SpasPracticeLog> logs = practiceMapper.selectTodayByStudent(self.getStudentId(), today);
        data.put("logs", logs);
        List<SpasPracticeLog> pending = practiceMapper.selectPendingProxyConfirm(self.getStudentId());
        data.put("pendingConfirm", pending);
        data.put("confirmableCount", Integer.valueOf(countConfirmable(pending, today)));
        SpasStudyGroup group = groupMapper.selectActiveGroupOfStudent(self.getStudentId(), self.getDeptId(), subjectId);
        if (group == null)
        {
            group = groupMapper.selectActiveGroupOfStudent(self.getStudentId(), self.getDeptId(), null);
        }
        data.put("group", group);
        boolean leader = group != null && group.getLeaderStudentId() != null
            && group.getLeaderStudentId().equals(self.getStudentId());
        data.put("leader", Boolean.valueOf(leader));
        if (group != null)
        {
            data.put("groupProgress", practiceMapper.selectGroupTodayProgress(group.getGroupId(), today));
        }
        return data;
    }

    @Override
    public List<SpasPracticeLog> mineRecent(Integer days)
    {
        SpasStudent self = requireLoginStudent();
        int d = days == null || days.intValue() < 1 ? 7 : Math.min(days.intValue(), 30);
        Date end = DateUtils.parseDate(DateUtils.getDate());
        Calendar cal = Calendar.getInstance();
        cal.setTime(end);
        cal.add(Calendar.DATE, -(d - 1));
        Date begin = cal.getTime();
        return practiceMapper.selectRecentByStudent(self.getStudentId(), begin, end);
    }

    @Override
    public List<Map<String, Object>> suggestWeak(Long subjectId, Integer limit)
    {
        SpasStudent self = requireLoginStudent();
        return analysisService.studentWeakTop(self.getStudentId(), subjectId, limit == null ? 8 : limit);
    }

    @Override
    public List<Map<String, Object>> suggestBooks(Long deptId, Long subjectId, String q)
    {
        if (subjectId == null)
        {
            return new ArrayList<Map<String, Object>>();
        }
        SpasStudent self = currentStudentOrNull();
        if (self != null)
        {
            deptId = self.getDeptId();
        }
        else if (deptId != null)
        {
            accessService.checkDeptAccess(deptId);
        }
        else
        {
            return new ArrayList<Map<String, Object>>();
        }
        return practiceMapper.suggestBooks(deptId, subjectId, q, Integer.valueOf(8));
    }

    @Override
    public Map<String, Object> groupToday(Long groupId, Date practiceDate)
    {
        SpasStudyGroup group = groupMapper.selectSpasStudyGroupById(groupId);
        if (group == null)
        {
            throw new ServiceException("小组不存在");
        }
        SpasStudent self = currentStudentOrNull();
        if (self != null)
        {
            if (!self.getDeptId().equals(group.getDeptId()))
            {
                throw new ServiceException("无权查看该组");
            }
        }
        else
        {
            accessService.checkDeptAccess(group.getDeptId());
        }
        Date day = practiceDate == null ? DateUtils.parseDate(DateUtils.getDate()) : practiceDate;
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("group", group);
        data.put("progress", practiceMapper.selectGroupTodayProgress(groupId, day));
        return data;
    }

    @Override
    public Map<String, Object> dailyStat(Long deptId, Long subjectId, Date practiceDate)
    {
        requireTeacherDept(deptId);
        Date day = practiceDate == null ? DateUtils.parseDate(DateUtils.getDate()) : practiceDate;
        Map<String, Object> stat = practiceMapper.selectDailyStat(deptId, subjectId, day);
        if (stat == null)
        {
            stat = new HashMap<String, Object>();
        }
        Number total = (Number) stat.get("studentTotal");
        Number submitted = (Number) stat.get("submittedCount");
        double rate = (total == null || total.intValue() == 0 || submitted == null)
            ? 0 : submitted.doubleValue() / total.doubleValue();
        stat.put("submitRate", Double.valueOf(Math.round(rate * 10000) / 10000.0));
        return stat;
    }

    @Override
    public Map<String, Object> alerts(Long deptId, Long subjectId, Date practiceDate)
    {
        requireTeacherDept(deptId);
        Date day = practiceDate == null ? DateUtils.parseDate(DateUtils.getDate()) : practiceDate;
        Calendar cal = Calendar.getInstance();
        cal.setTime(day);
        cal.add(Calendar.DATE, -2);
        Date since = cal.getTime();
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("missing", practiceMapper.selectMissingStudents(deptId, subjectId, day));
        data.put("difficulty", practiceMapper.selectDifficultyLogs(deptId, subjectId, day));
        data.put("proxyHeavy", practiceMapper.selectProxyHeavyStudents(deptId, subjectId, since, Integer.valueOf(3)));
        data.put("continuousMissing", practiceMapper.selectContinuousMissing(deptId, subjectId, day, Integer.valueOf(2)));
        Calendar week = Calendar.getInstance();
        week.setTime(day);
        week.add(Calendar.DATE, -6);
        data.put("stillWeak", practiceMapper.selectPracticedStillWeak(deptId, subjectId, week.getTime(), day, Double.valueOf(0.6)));
        return data;
    }

    @Override
    public int heartbeatDevice(String deviceCode, String deviceName, Long deptId, String appVersion)
    {
        if (StringUtils.isEmpty(deviceCode))
        {
            throw new ServiceException("设备编号不能为空");
        }
        SpasStudent self = currentStudentOrNull();
        Long studentId = self == null ? null : self.getStudentId();
        Long bindDept = deptId;
        if (bindDept == null && self != null)
        {
            bindDept = self.getDeptId();
        }
        return practiceMapper.upsertKioskDevice(deviceCode.trim(), deviceName, bindDept, studentId, appVersion);
    }

    @Override
    public List<Map<String, Object>> listDevices(Long deptId)
    {
        if (deptId != null)
        {
            accessService.checkDeptAccess(deptId);
        }
        return practiceMapper.selectKioskDevices(deptId);
    }

    @Override
    public List<Map<String, Object>> practicedStillWeak(Long deptId, Long subjectId, Date beginDate, Date endDate)
    {
        requireTeacherDept(deptId);
        Date end = endDate == null ? DateUtils.parseDate(DateUtils.getDate()) : endDate;
        Date begin = beginDate;
        if (begin == null)
        {
            Calendar cal = Calendar.getInstance();
            cal.setTime(end);
            cal.add(Calendar.DATE, -6);
            begin = cal.getTime();
        }
        return practiceMapper.selectPracticedStillWeak(deptId, subjectId, begin, end, Double.valueOf(0.6));
    }

    @Override
    public List<SpasPracticeLog> pendingProxyConfirm()
    {
        SpasStudent self = requireLoginStudent();
        return practiceMapper.selectPendingProxyConfirm(self.getStudentId());
    }

    @Override
    @Transactional
    public int confirmProxy(Long logId, boolean accept)
    {
        SpasStudent self = requireLoginStudent();
        SpasPracticeLog db = requireLog(logId);
        if (!self.getStudentId().equals(db.getStudentId()))
        {
            throw new ServiceException("只能确认本人的代提记录");
        }
        if (!"1".equals(db.getProxyFlag()) || !"1".equals(db.getConfirmStatus()))
        {
            throw new ServiceException("该记录无需确认或已处理");
        }
        Date today = DateUtils.parseDate(DateUtils.getDate());
        if (db.getPracticeDate() == null || !db.getPracticeDate().before(today))
        {
            throw new ServiceException("代提记录需次日方可确认");
        }
        int rows = practiceMapper.updateConfirmStatus(logId, accept ? "2" : "3");
        if (rows > 0 && accept)
        {
            SpasPracticeLog fresh = practiceMapper.selectSpasPracticeLogById(logId);
            if (fresh != null)
            {
                List<SpasPracticeLogKnowledge> links = practiceMapper.selectKnowledgeByLogId(logId);
                List<Long> kids = new ArrayList<Long>();
                if (links != null)
                {
                    for (SpasPracticeLogKnowledge k : links)
                    {
                        if (k.getKnowledgeId() != null)
                        {
                            kids.add(k.getKnowledgeId());
                        }
                    }
                }
                fresh.setKnowledgeIds(kids);
                LAST_AWARDED_POINTS.set(Integer.valueOf(pointService.awardForPracticeLog(fresh, true)));
            }
        }
        return rows;
    }

    /** Points awarded in the current request thread (practice submit / proxy confirm). */
    public int consumeLastAwardedPoints()
    {
        Integer v = LAST_AWARDED_POINTS.get();
        LAST_AWARDED_POINTS.remove();
        return v == null ? 0 : v.intValue();
    }

    @Override
    public List<Map<String, Object>> weekThemeOverlap(Long deptId, Long subjectId, Date beginDate, Date endDate)
    {
        requireTeacherDept(deptId);
        Date end = endDate == null ? DateUtils.parseDate(DateUtils.getDate()) : endDate;
        Date begin = beginDate;
        if (begin == null)
        {
            Calendar cal = Calendar.getInstance();
            cal.setTime(end);
            cal.add(Calendar.DATE, -6);
            begin = cal.getTime();
        }
        return practiceMapper.selectWeekThemeOverlap(deptId, subjectId, begin, end);
    }

    @Override
    public List<Map<String, Object>> spotSample(Long deptId, Long subjectId, Date beginDate, Date endDate, Integer limit)
    {
        requireTeacherDept(deptId);
        Date end = endDate == null ? DateUtils.parseDate(DateUtils.getDate()) : endDate;
        Date begin = beginDate;
        if (begin == null)
        {
            Calendar cal = Calendar.getInstance();
            cal.setTime(end);
            cal.add(Calendar.DATE, -6);
            begin = cal.getTime();
        }
        int lim = limit == null ? 3 : limit.intValue();
        return practiceMapper.selectSpotSample(deptId, subjectId, begin, end, Integer.valueOf(lim));
    }

    @Override
    public int updateSpot(Long logId, String spotStatus, String spotRemark)
    {
        accessService.assertCanWrite();
        SpasPracticeLog db = requireLog(logId);
        accessService.checkStudentAccess(db.getStudentId());
        if (!"1".equals(spotStatus) && !"2".equals(spotStatus))
        {
            throw new ServiceException("抽查结果无效");
        }
        SpasPracticeLog patch = new SpasPracticeLog();
        patch.setLogId(logId);
        patch.setSpotStatus(spotStatus);
        patch.setSpotRemark(spotRemark);
        patch.setSpotBy(SecurityUtils.getUsername());
        return practiceMapper.updateSpot(patch);
    }

    @Override
    @Transactional
    public Long toIntervene(Long logId)
    {
        accessService.assertCanWrite();
        SpasPracticeLog db = requireLog(logId);
        accessService.checkStudentAccess(db.getStudentId());
        List<SpasPracticeLogKnowledge> links = practiceMapper.selectKnowledgeByLogId(logId);
        List<Long> kids = new ArrayList<Long>();
        for (SpasPracticeLogKnowledge k : links)
        {
            if (k.getKnowledgeId() != null)
            {
                kids.add(k.getKnowledgeId());
            }
        }
        if (kids.isEmpty())
        {
            throw new ServiceException("该打卡未关联知识主题，无法转干预");
        }
        StringBuilder csv = new StringBuilder();
        for (int i = 0; i < kids.size(); i++)
        {
            if (i > 0)
            {
                csv.append(',');
            }
            csv.append(kids.get(i));
        }
        SpasInterveneTask task = new SpasInterveneTask();
        task.setStudentId(db.getStudentId());
        task.setSubjectId(db.getSubjectId());
        task.setSourceType("2");
        task.setSourceId(logId);
        task.setKnowledgeIdList(kids);
        task.setKnowledgeIds(csv.toString());
        String title = "自主练困难";
        if (StringUtils.isNotEmpty(db.getDifficultyNote()))
        {
            title = "自主练困难：" + db.getDifficultyNote();
        }
        if (title.length() > 80)
        {
            title = title.substring(0, 80);
        }
        task.setTitle(title);
        task.setCreateBy(SecurityUtils.getUsername());
        interveneService.insertSpasInterveneTask(task);
        return task.getInterveneId();
    }

    @Override
    public Map<String, Object> sessionProfile()
    {
        SpasStudent self = requireLoginStudent();
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("studentId", self.getStudentId());
        data.put("studentNo", self.getStudentNo());
        data.put("studentName", self.getStudentName());
        data.put("deptId", self.getDeptId());
        data.put("deptName", self.getDeptName());
        SpasStudyGroup group = groupMapper.selectActiveGroupOfStudent(self.getStudentId(), self.getDeptId(), null);
        data.put("group", group);
        data.put("leader", Boolean.valueOf(group != null && self.getStudentId().equals(group.getLeaderStudentId())));
        return data;
    }

    private int saveLog(SpasPracticeLog log, SpasStudent owner)
    {
        if (log.getSubjectId() == null)
        {
            throw new ServiceException("请选择学科");
        }
        if (StringUtils.isEmpty(log.getBookName()))
        {
            throw new ServiceException("请填写书本名称");
        }
        if (StringUtils.isEmpty(log.getQuestionText()))
        {
            throw new ServiceException("请填写题号");
        }
        if (StringUtils.isEmpty(log.getFinishStatus()))
        {
            throw new ServiceException("请选择完成情况");
        }
        if ("3".equals(log.getFinishStatus()) && StringUtils.isEmpty(log.getDifficultyNote()))
        {
            throw new ServiceException("有困难时请填写卡点说明");
        }
        List<Long> kids = log.getKnowledgeIds();
        if (kids == null || kids.isEmpty())
        {
            throw new ServiceException("请至少选择一个知识主题");
        }
        Date today = DateUtils.parseDate(DateUtils.getDate());
        Date day = log.getPracticeDate() == null ? today : DateUtils.parseDate(DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD, log.getPracticeDate()));
        log.setPracticeDate(day);
        Calendar yest = Calendar.getInstance();
        yest.setTime(today);
        yest.add(Calendar.DATE, -1);
        Date yesterday = DateUtils.parseDate(DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD, yest.getTime()));
        if (day.before(yesterday))
        {
            throw new ServiceException("仅允许补打昨天或今天的记录");
        }
        log.setDeptId(owner.getDeptId());
        if (log.getGroupId() == null)
        {
            SpasStudyGroup g = groupMapper.selectActiveGroupOfStudent(owner.getStudentId(), owner.getDeptId(),
                log.getSubjectId());
            if (g == null)
            {
                g = groupMapper.selectActiveGroupOfStudent(owner.getStudentId(), owner.getDeptId(), null);
            }
            if (g != null)
            {
                log.setGroupId(g.getGroupId());
            }
        }
        log.setSubmitSlot(DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD, day)
            .equals(DateUtils.getDate()) ? "0" : "1");
        if (StringUtils.isEmpty(log.getClientType()))
        {
            log.setClientType("web");
        }
        log.setStatus("0");
        int rows = practiceMapper.insertSpasPracticeLog(log);
        saveKnowledge(log.getLogId(), kids);
        practiceMapper.upsertBookStat(log.getDeptId(), log.getSubjectId(), log.getBookName().trim());
        // 本人打卡立即发分；代提待确认后再发
        int awarded = 0;
        if (!"1".equals(log.getProxyFlag()))
        {
            log.setKnowledgeIds(kids);
            awarded = pointService.awardForPracticeLog(log, true);
        }
        LAST_AWARDED_POINTS.set(Integer.valueOf(awarded));
        return rows;
    }

    private void saveKnowledge(Long logId, List<Long> knowledgeIds)
    {
        practiceMapper.deleteKnowledgeByLogId(logId);
        boolean primary = true;
        for (Long kid : knowledgeIds)
        {
            if (kid == null)
            {
                continue;
            }
            SpasPracticeLogKnowledge link = new SpasPracticeLogKnowledge();
            link.setLogId(logId);
            link.setKnowledgeId(kid);
            link.setIsPrimary(primary ? "1" : "0");
            practiceMapper.insertKnowledge(link);
            primary = false;
        }
    }

    private SpasPracticeLog requireLog(Long logId)
    {
        if (logId == null)
        {
            throw new ServiceException("记录不存在");
        }
        SpasPracticeLog log = practiceMapper.selectSpasPracticeLogById(logId);
        if (log == null || "1".equals(log.getStatus()))
        {
            throw new ServiceException("记录不存在");
        }
        return log;
    }

    private SpasStudent requireLoginStudent()
    {
        SpasStudent self = currentStudentOrNull();
        if (self == null)
        {
            throw new ServiceException("请使用学生账号登录");
        }
        return self;
    }

    private SpasStudent currentStudentOrNull()
    {
        try
        {
            Long userId = SecurityUtils.getUserId();
            if (userId == null)
            {
                return null;
            }
            return studentMapper.selectSpasStudentByUserId(userId);
        }
        catch (Exception e)
        {
            return null;
        }
    }

    private void requireTeacherDept(Long deptId)
    {
        if (deptId == null)
        {
            throw new ServiceException("请选择班级");
        }
        accessService.checkDeptAccess(deptId);
    }

    private int countConfirmable(List<SpasPracticeLog> pending, Date today)
    {
        int n = 0;
        if (pending == null)
        {
            return 0;
        }
        for (SpasPracticeLog p : pending)
        {
            if (p.getPracticeDate() != null && p.getPracticeDate().before(today))
            {
                n++;
            }
        }
        return n;
    }
}
