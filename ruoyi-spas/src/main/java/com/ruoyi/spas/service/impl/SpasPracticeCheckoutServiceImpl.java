package com.ruoyi.spas.service.impl;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasInterveneTask;
import com.ruoyi.spas.domain.SpasPracticeAssignment;
import com.ruoyi.spas.domain.SpasPracticeCheckout;
import com.ruoyi.spas.domain.SpasPracticeCheckoutItem;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.domain.SpasStudyGroup;
import com.ruoyi.spas.domain.SpasStudyGroupMember;
import com.ruoyi.spas.mapper.SpasPracticeCheckoutMapper;
import com.ruoyi.spas.mapper.SpasStudentMapper;
import com.ruoyi.spas.mapper.SpasStudyGroupMapper;
import com.ruoyi.spas.service.ISpasInterveneService;
import com.ruoyi.spas.service.ISpasPracticeCheckoutService;
import com.ruoyi.spas.service.ISpasStudentPointService;
import com.ruoyi.spas.support.SpasAccessService;

@Service
public class SpasPracticeCheckoutServiceImpl implements ISpasPracticeCheckoutService
{
    private static final ThreadLocal<Integer> LAST_AWARDED_POINTS = new ThreadLocal<Integer>();

    public static final String DEFAULT_COMPLETE_DEF =
        "指定页有书写痕迹，且抽问 1 道布置题能开口说思路。没看见本子不能点已完成。";

    private static final Set<String> STATUSES;
    static
    {
        Set<String> s = new HashSet<String>();
        s.add("0");
        s.add("1");
        s.add("2");
        s.add("3");
        s.add("L");
        s.add("A");
        STATUSES = Collections.unmodifiableSet(s);
    }

    @Autowired
    private SpasPracticeCheckoutMapper checkoutMapper;

    @Autowired
    private SpasStudyGroupMapper groupMapper;

    @Autowired
    private SpasStudentMapper studentMapper;

    @Autowired
    private SpasAccessService accessService;

    @Autowired
    private ISpasStudentPointService pointService;

    @Autowired
    private ISpasInterveneService interveneService;

    @Override
    public List<SpasPracticeAssignment> listAssignments(SpasPracticeAssignment query)
    {
        if (query.getDeptId() != null)
        {
            accessService.checkDeptAccess(query.getDeptId());
        }
        return checkoutMapper.selectAssignmentList(query);
    }

    @Override
    public SpasPracticeAssignment getAssignment(Long assignmentId)
    {
        SpasPracticeAssignment row = checkoutMapper.selectAssignmentById(assignmentId);
        if (row == null)
        {
            throw new ServiceException("布置不存在");
        }
        accessService.checkDeptAccess(row.getDeptId());
        return row;
    }

    @Override
    public int saveAssignment(SpasPracticeAssignment row)
    {
        accessService.assertCanWrite();
        if (row.getDeptId() == null || row.getSubjectId() == null)
        {
            throw new ServiceException("请选择班级和学科");
        }
        accessService.checkDeptAccess(row.getDeptId());
        if (StringUtils.isEmpty(row.getBookName()) || StringUtils.isEmpty(row.getQuestionText()))
        {
            throw new ServiceException("请填写书名和题号范围");
        }
        if (row.getAssignDate() == null)
        {
            row.setAssignDate(DateUtils.parseDate(DateUtils.getDate()));
        }
        if (StringUtils.isEmpty(row.getCompleteDefinition()))
        {
            row.setCompleteDefinition(DEFAULT_COMPLETE_DEF);
        }
        if (row.getDueCountWeek() == null)
        {
            row.setDueCountWeek(Integer.valueOf(3));
        }
        row.setUpdateBy(SecurityUtils.getUsername());
        SpasPracticeAssignment exist = checkoutMapper.selectAssignmentByDay(row.getDeptId(), row.getSubjectId(),
            row.getAssignDate());
        if (exist != null)
        {
            row.setAssignmentId(exist.getAssignmentId());
            return checkoutMapper.updateAssignment(row);
        }
        row.setCreateBy(SecurityUtils.getUsername());
        return checkoutMapper.insertAssignment(row);
    }

    @Override
    public SpasPracticeAssignment copyLast(Long deptId, Long subjectId, Date assignDate)
    {
        accessService.assertCanWrite();
        accessService.checkDeptAccess(deptId);
        Date day = assignDate == null ? DateUtils.parseDate(DateUtils.getDate()) : assignDate;
        SpasPracticeAssignment last = checkoutMapper.selectLastAssignment(deptId, subjectId, day);
        if (last == null)
        {
            throw new ServiceException("没有可复制的历史布置");
        }
        last.setAssignmentId(null);
        last.setAssignDate(day);
        last.setCreateBy(SecurityUtils.getUsername());
        saveAssignment(last);
        return checkoutMapper.selectAssignmentByDay(deptId, subjectId, day);
    }

    @Override
    public Map<String, Object> todayBundle(Long subjectId)
    {
        SpasStudent self = requireStudent();
        Date today = DateUtils.parseDate(DateUtils.getDate());
        Map<String, Object> data = new HashMap<String, Object>();
        SpasStudyGroup group = resolveGroup(self, subjectId);
        boolean leader = group != null && self.getStudentId().equals(group.getLeaderStudentId());
        data.put("studentId", self.getStudentId());
        data.put("leader", Boolean.valueOf(leader));
        data.put("group", group);
        SpasPracticeAssignment assignment = resolveAssignment(self.getDeptId(), subjectId, group, today);
        data.put("assignment", assignment);
        if (assignment == null)
        {
            data.put("hint", "今日教师尚未布置，不能提交检查单");
            data.put("members", Collections.emptyList());
            data.put("checkout", null);
            data.put("myItem", null);
            data.put("pendingAck", checkoutMapper.selectMyPendingAck(self.getStudentId(), today));
            return data;
        }
        SpasPracticeCheckout checkout = null;
        List<SpasPracticeCheckoutItem> items = Collections.emptyList();
        if (group != null)
        {
            checkout = checkoutMapper.selectCheckoutByGroupDay(group.getGroupId(), today, assignment.getAssignmentId());
            if (checkout != null)
            {
                items = checkoutMapper.selectItems(checkout.getCheckoutId());
                checkout.setItems(items);
            }
        }
        data.put("checkout", checkout);
        List<Map<String, Object>> members = new ArrayList<Map<String, Object>>();
        if (group != null)
        {
            List<SpasStudyGroupMember> raw = groupMapper.selectActiveMembers(group.getGroupId());
            for (SpasStudyGroupMember m : raw)
            {
                Map<String, Object> row = new HashMap<String, Object>();
                row.put("studentId", m.getStudentId());
                row.put("studentNo", m.getStudentNo());
                row.put("studentName", m.getStudentName());
                row.put("roleInGroup", m.getRoleInGroup());
                SpasPracticeCheckoutItem hit = findItem(items, m.getStudentId());
                if (hit != null)
                {
                    row.put("itemId", hit.getItemId());
                    row.put("finishStatus", hit.getFinishStatus());
                    row.put("difficultyNote", hit.getDifficultyNote());
                    row.put("memberAck", hit.getMemberAck());
                    row.put("voided", hit.getVoided());
                    row.put("spotResult", hit.getSpotResult());
                }
                members.add(row);
            }
        }
        data.put("members", members);
        SpasPracticeCheckoutItem mine = findItem(items, self.getStudentId());
        data.put("myItem", mine);
        data.put("pendingAck", checkoutMapper.selectMyPendingAck(self.getStudentId(), today));
        if (group != null)
        {
            data.put("weekQualify", weekQualify(group.getGroupId(), assignment, today));
        }
        return data;
    }

    @Override
    @Transactional
    public int submitCheckout(SpasPracticeCheckout body)
    {
        SpasStudent self = requireStudent();
        if (body == null || body.getAssignmentId() == null)
        {
            throw new ServiceException("缺少布置");
        }
        SpasPracticeAssignment assignment = checkoutMapper.selectAssignmentById(body.getAssignmentId());
        if (assignment == null)
        {
            throw new ServiceException("布置不存在");
        }
        Date today = DateUtils.parseDate(DateUtils.getDate());
        if (assignment.getAssignDate() != null && !DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD, assignment.getAssignDate())
            .equals(DateUtils.getDate()))
        {
            throw new ServiceException("只能提交当日布置的检查单");
        }
        SpasStudyGroup group = resolveGroup(self, assignment.getSubjectId());
        if (group == null)
        {
            throw new ServiceException("你尚未加入学习小组");
        }
        if (!self.getStudentId().equals(group.getLeaderStudentId()))
        {
            throw new ServiceException("仅组长可提交本组检查单");
        }
        List<SpasStudyGroupMember> members = groupMapper.selectActiveMembers(group.getGroupId());
        if (members == null || members.isEmpty())
        {
            throw new ServiceException("本组没有成员");
        }
        Map<Long, SpasPracticeCheckoutItem> byStu = new HashMap<Long, SpasPracticeCheckoutItem>();
        if (body.getItems() != null)
        {
            for (SpasPracticeCheckoutItem it : body.getItems())
            {
                if (it.getStudentId() != null)
                {
                    byStu.put(it.getStudentId(), it);
                }
            }
        }
        Long checkerId = body.getCheckerStudentId() == null ? self.getStudentId() : body.getCheckerStudentId();
        List<SpasPracticeCheckoutItem> normalized = new ArrayList<SpasPracticeCheckoutItem>();
        for (SpasStudyGroupMember m : members)
        {
            SpasPracticeCheckoutItem it = byStu.get(m.getStudentId());
            if (it == null || StringUtils.isEmpty(it.getFinishStatus()))
            {
                throw new ServiceException("请为全员选择状态（含请假/未到）后再提交：" + m.getStudentName());
            }
            if (!STATUSES.contains(it.getFinishStatus()))
            {
                throw new ServiceException("状态不合法：" + m.getStudentName());
            }
            if ("3".equals(it.getFinishStatus()) && StringUtils.isEmpty(it.getDifficultyNote()))
            {
                throw new ServiceException("有困难必须填写卡点：" + m.getStudentName());
            }
            if ("1".equals(it.getFinishStatus()) && m.getStudentId().equals(checkerId))
            {
                throw new ServiceException("禁止自检自评为已完成，请邻组检查或教师抽检");
            }
            it.setStudentId(m.getStudentId());
            it.setMemberAck("0");
            it.setVoided("0");
            normalized.add(it);
        }
        SpasPracticeCheckout exist = checkoutMapper.selectCheckoutByGroupDay(group.getGroupId(), today,
            assignment.getAssignmentId());
        int rows;
        Long checkoutId;
        if (exist == null)
        {
            SpasPracticeCheckout c = new SpasPracticeCheckout();
            c.setAssignmentId(assignment.getAssignmentId());
            c.setGroupId(group.getGroupId());
            c.setPracticeDate(today);
            c.setLeaderStudentId(self.getStudentId());
            c.setCheckerStudentId(checkerId);
            c.setDeviceCode(body.getDeviceCode());
            c.setStatus("0");
            rows = checkoutMapper.insertCheckout(c);
            checkoutId = c.getCheckoutId();
        }
        else
        {
            exist.setCheckerStudentId(checkerId);
            exist.setDeviceCode(body.getDeviceCode());
            rows = checkoutMapper.updateCheckout(exist);
            checkoutId = exist.getCheckoutId();
            checkoutMapper.deleteItems(checkoutId);
        }
        for (SpasPracticeCheckoutItem it : normalized)
        {
            it.setCheckoutId(checkoutId);
            checkoutMapper.insertItem(it);
        }
        int awarded = pointService.awardCheckoutSubmit(self.getStudentId(), assignment.getDeptId(),
            assignment.getSubjectId(), checkoutId);
        LAST_AWARDED_POINTS.set(Integer.valueOf(awarded));
        return rows;
    }

    @Override
    public int ackItem(Long itemId, boolean accept)
    {
        SpasStudent self = requireStudent();
        SpasPracticeCheckoutItem item = checkoutMapper.selectItemById(itemId);
        if (item == null)
        {
            throw new ServiceException("检查记录不存在");
        }
        if (!self.getStudentId().equals(item.getStudentId()))
        {
            throw new ServiceException("只能确认本人的检查结果");
        }
        SpasPracticeCheckout checkout = checkoutMapper.selectCheckoutById(item.getCheckoutId());
        if (checkout == null || "1".equals(checkout.getStatus()))
        {
            throw new ServiceException("检查单已作废");
        }
        String day = DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD, checkout.getPracticeDate());
        if (!DateUtils.getDate().equals(day))
        {
            throw new ServiceException("仅允许当日确认，隔夜请找老师处理");
        }
        if (!"0".equals(item.getMemberAck()) && item.getMemberAck() != null && !"".equals(item.getMemberAck()))
        {
            throw new ServiceException("已经确认过");
        }
        item.setMemberAck(accept ? "1" : "2");
        int rows = checkoutMapper.updateItemAck(item);
        int awarded = 0;
        if (accept)
        {
            SpasPracticeAssignment a = checkoutMapper.selectAssignmentById(checkout.getAssignmentId());
            Long deptId = a == null ? self.getDeptId() : a.getDeptId();
            Long subjectId = a == null ? null : a.getSubjectId();
            awarded = pointService.awardCheckoutAck(item.getStudentId(), deptId, subjectId,
                item.getItemId(), item.getFinishStatus());
        }
        LAST_AWARDED_POINTS.set(Integer.valueOf(awarded));
        return rows;
    }

    @Override
    public int consumeLastAwardedPoints()
    {
        Integer v = LAST_AWARDED_POINTS.get();
        LAST_AWARDED_POINTS.remove();
        return v == null ? 0 : v.intValue();
    }

    @Override
    public int followItem(Long itemId)
    {
        accessService.assertCanWrite();
        SpasPracticeCheckoutItem item = checkoutMapper.selectItemById(itemId);
        if (item == null)
        {
            throw new ServiceException("记录不存在");
        }
        SpasPracticeCheckout checkout = checkoutMapper.selectCheckoutById(item.getCheckoutId());
        SpasPracticeAssignment a = checkoutMapper.selectAssignmentById(checkout.getAssignmentId());
        accessService.checkDeptAccess(a.getDeptId());
        return checkoutMapper.updateItemFollow(itemId, "1");
    }

    @Override
    public Long toIntervene(Long itemId)
    {
        accessService.assertCanWrite();
        SpasPracticeCheckoutItem item = checkoutMapper.selectItemById(itemId);
        if (item == null)
        {
            throw new ServiceException("记录不存在");
        }
        if (!"3".equals(item.getFinishStatus()))
        {
            throw new ServiceException("仅困难记录可转干预");
        }
        SpasPracticeCheckout checkout = checkoutMapper.selectCheckoutById(item.getCheckoutId());
        if (checkout == null)
        {
            throw new ServiceException("检查单不存在");
        }
        SpasPracticeAssignment a = checkoutMapper.selectAssignmentById(checkout.getAssignmentId());
        if (a == null)
        {
            throw new ServiceException("布置不存在");
        }
        accessService.checkDeptAccess(a.getDeptId());
        if (a.getKnowledgeId() == null)
        {
            throw new ServiceException("布置未关联知识主题，无法转干预");
        }
        List<Long> kids = new ArrayList<Long>();
        kids.add(a.getKnowledgeId());
        SpasInterveneTask task = new SpasInterveneTask();
        task.setStudentId(item.getStudentId());
        task.setSubjectId(a.getSubjectId());
        task.setSourceType("4");
        task.setSourceId(itemId);
        task.setKnowledgeIdList(kids);
        task.setKnowledgeIds(String.valueOf(a.getKnowledgeId()));
        String title = "检查单困难";
        if (StringUtils.isNotEmpty(item.getDifficultyNote()))
        {
            title = "检查单困难：" + item.getDifficultyNote();
        }
        if (title.length() > 80)
        {
            title = title.substring(0, 80);
        }
        task.setTitle(title);
        task.setCreateBy(SecurityUtils.getUsername());
        interveneService.insertSpasInterveneTask(task);
        checkoutMapper.updateItemFollow(itemId, "1");
        return task.getInterveneId();
    }

    @Override
    public Map<String, Object> alerts(Long deptId, Long subjectId, Date practiceDate)
    {
        accessService.checkDeptAccess(deptId);
        Date day = practiceDate == null ? DateUtils.parseDate(DateUtils.getDate()) : practiceDate;
        Date[] week = weekBounds(day);
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("missingCheckout", checkoutMapper.selectMissingCheckout(deptId, subjectId, day));
        data.put("pendingAck", checkoutMapper.selectPendingAck(deptId, subjectId, day));
        data.put("disputes", checkoutMapper.selectDisputes(deptId, subjectId, day));
        data.put("difficultySummary", checkoutMapper.selectDifficultySummary(deptId, subjectId, day));
        data.put("difficultyItems", checkoutMapper.selectDifficultyItems(deptId, subjectId, day));
        int spots = checkoutMapper.countSpotsThisWeek(deptId, subjectId, week[0], week[1]);
        data.put("weekSpotCount", Integer.valueOf(spots));
        List<Map<String, Object>> groups = checkoutMapper.selectActiveGroups(deptId, subjectId);
        List<Map<String, Object>> qualify = new ArrayList<Map<String, Object>>();
        Integer due = Integer.valueOf(3);
        SpasPracticeAssignment asg = null;
        if (subjectId != null)
        {
            asg = checkoutMapper.selectAssignmentByDay(deptId, subjectId, day);
            if (asg != null && asg.getDueCountWeek() != null)
            {
                due = asg.getDueCountWeek();
            }
        }
        if (groups != null)
        {
            for (Map<String, Object> g : groups)
            {
                Map<String, Object> row = new HashMap<String, Object>();
                row.put("groupId", g.get("groupId"));
                row.put("groupName", g.get("groupName"));
                Long gid = toLong(g.get("groupId"));
                if (gid != null)
                {
                    row.putAll(weekQualify(gid, asg, day));
                }
                if (spots <= 0)
                {
                    row.put("qualified", Boolean.FALSE);
                    row.put("reason", "本周尚未抽检，达标灯不亮");
                }
                qualify.add(row);
            }
        }
        data.put("groupWeek", qualify);
        data.put("dueCountWeek", due);
        return data;
    }

    @Override
    public List<Map<String, Object>> spotQueue(Long deptId, Long subjectId, Date practiceDate)
    {
        accessService.checkDeptAccess(deptId);
        Date day = practiceDate == null ? DateUtils.parseDate(DateUtils.getDate()) : practiceDate;
        List<Map<String, Object>> rows = checkoutMapper.selectSpotQueue(deptId, subjectId, day);
        if (rows == null)
        {
            return Collections.emptyList();
        }
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE, -120);
        Date since = DateUtils.parseDate(DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD, cal.getTime()));
        Set<Long> looseCheckers = new HashSet<Long>(checkoutMapper.selectLooseCheckerIds(deptId, since));
        Map<Long, Integer> groupSize = new HashMap<Long, Integer>();
        Map<Long, Integer> groupDone = new HashMap<Long, Integer>();
        for (Map<String, Object> r : rows)
        {
            Long gid = toLong(r.get("groupId"));
            if (gid == null)
            {
                continue;
            }
            groupSize.put(gid, Integer.valueOf(nvl(groupSize.get(gid)) + 1));
            if ("1".equals(String.valueOf(r.get("finishStatus"))))
            {
                groupDone.put(gid, Integer.valueOf(nvl(groupDone.get(gid)) + 1));
            }
        }
        for (Map<String, Object> r : rows)
        {
            int w = 0;
            if ("2".equals(String.valueOf(r.get("memberAck"))))
            {
                w += 1000;
            }
            Number hist = (Number) r.get("spotHistCount");
            if (hist == null || hist.intValue() == 0)
            {
                w += 20;
            }
            Long gid = toLong(r.get("groupId"));
            if (gid != null && nvl(groupSize.get(gid)) > 0
                && nvl(groupSize.get(gid)) == nvl(groupDone.get(gid)))
            {
                w += 15;
            }
            Long checker = toLong(r.get("checkerStudentId"));
            if (checker != null && looseCheckers.contains(checker))
            {
                w += 25;
            }
            if ("3".equals(String.valueOf(r.get("finishStatus"))) && (hist == null || hist.intValue() == 0))
            {
                w += 8;
            }
            r.put("weight", Integer.valueOf(w));
        }
        Collections.sort(rows, new Comparator<Map<String, Object>>()
        {
            @Override
            public int compare(Map<String, Object> a, Map<String, Object> b)
            {
                int wa = nvl((Integer) a.get("weight"));
                int wb = nvl((Integer) b.get("weight"));
                return wb - wa;
            }
        });
        Map<Long, Integer> taken = new HashMap<Long, Integer>();
        List<Map<String, Object>> out = new ArrayList<Map<String, Object>>();
        for (Map<String, Object> r : rows)
        {
            if ("2".equals(String.valueOf(r.get("memberAck"))))
            {
                out.add(r);
                continue;
            }
            Long gid = toLong(r.get("groupId"));
            int n = nvl(taken.get(gid));
            if (n >= 2)
            {
                continue;
            }
            taken.put(gid, Integer.valueOf(n + 1));
            out.add(r);
        }
        return out;
    }

    @Override
    @Transactional
    public int recordSpot(Long itemId, String spotResult, String spotRemark)
    {
        accessService.assertCanWrite();
        if (!"1".equals(spotResult) && !"2".equals(spotResult) && !"3".equals(spotResult))
        {
            throw new ServiceException("抽检结果只能是一致/偏松/偏严");
        }
        SpasPracticeCheckoutItem item = checkoutMapper.selectItemById(itemId);
        if (item == null)
        {
            throw new ServiceException("检查记录不存在");
        }
        SpasPracticeCheckout checkout = checkoutMapper.selectCheckoutById(item.getCheckoutId());
        SpasPracticeAssignment a = checkoutMapper.selectAssignmentById(checkout.getAssignmentId());
        accessService.checkDeptAccess(a.getDeptId());
        item.setSpotResult(spotResult);
        item.setVoided("2".equals(spotResult) ? "1" : "0");
        checkoutMapper.updateItemSpot(item);
        int rows = checkoutMapper.insertSpot(itemId, item.getStudentId(), checkout.getGroupId(),
            checkout.getCheckerStudentId(), spotResult, SecurityUtils.getUsername(), spotRemark);
        int awarded = 0;
        if ("1".equals(spotResult))
        {
            awarded = pointService.awardCheckoutSpotMatch(item.getStudentId(), a.getDeptId(), a.getSubjectId(),
                item.getItemId());
        }
        LAST_AWARDED_POINTS.set(Integer.valueOf(awarded));
        return rows;
    }

    private Map<String, Object> weekQualify(Long groupId, SpasPracticeAssignment assignment, Date day)
    {
        Date[] week = weekBounds(day);
        int due = assignment != null && assignment.getDueCountWeek() != null ? assignment.getDueCountWeek().intValue() : 3;
        int submitted = checkoutMapper.countWeekCheckout(groupId, week[0], week[1]);
        int loose = checkoutMapper.countWeekLoose(groupId, week[0], week[1]);
        int unfollowed = checkoutMapper.countUnfollowedDifficulty(groupId, week[0], week[1]);
        boolean ok = submitted >= due && loose == 0 && unfollowed == 0;
        Map<String, Object> m = new HashMap<String, Object>();
        m.put("submittedCount", Integer.valueOf(submitted));
        m.put("dueCount", Integer.valueOf(due));
        m.put("looseCount", Integer.valueOf(loose));
        m.put("unfollowedDifficulty", Integer.valueOf(unfollowed));
        m.put("qualified", Boolean.valueOf(ok));
        return m;
    }

    private Date[] weekBounds(Date day)
    {
        Calendar c = Calendar.getInstance();
        c.setTime(day == null ? new Date() : day);
        c.setFirstDayOfWeek(Calendar.MONDAY);
        int dow = c.get(Calendar.DAY_OF_WEEK);
        int delta = (dow == Calendar.SUNDAY) ? -6 : Calendar.MONDAY - dow;
        c.add(Calendar.DATE, delta);
        Date begin = DateUtils.parseDate(DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD, c.getTime()));
        c.add(Calendar.DATE, 6);
        Date end = DateUtils.parseDate(DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD, c.getTime()));
        return new Date[] { begin, end };
    }

    private SpasPracticeAssignment resolveAssignment(Long deptId, Long subjectId, SpasStudyGroup group, Date day)
    {
        if (subjectId == null && group != null)
        {
            subjectId = group.getSubjectId();
        }
        if (subjectId != null)
        {
            return checkoutMapper.selectAssignmentByDay(deptId, subjectId, day);
        }
        SpasPracticeAssignment q = new SpasPracticeAssignment();
        q.setDeptId(deptId);
        q.setAssignDate(day);
        List<SpasPracticeAssignment> list = checkoutMapper.selectAssignmentList(q);
        return (list == null || list.isEmpty()) ? null : list.get(0);
    }

    private SpasStudyGroup resolveGroup(SpasStudent self, Long subjectId)
    {
        SpasStudyGroup g = groupMapper.selectActiveGroupOfStudent(self.getStudentId(), self.getDeptId(), subjectId);
        if (g == null)
        {
            g = groupMapper.selectActiveGroupOfStudent(self.getStudentId(), self.getDeptId(), null);
        }
        return g;
    }

    private SpasPracticeCheckoutItem findItem(List<SpasPracticeCheckoutItem> items, Long studentId)
    {
        if (items == null || studentId == null)
        {
            return null;
        }
        for (SpasPracticeCheckoutItem it : items)
        {
            if (studentId.equals(it.getStudentId()))
            {
                return it;
            }
        }
        return null;
    }

    private SpasStudent requireStudent()
    {
        Long userId = SecurityUtils.getUserId();
        SpasStudent self = studentMapper.selectSpasStudentByUserId(userId);
        if (self == null)
        {
            throw new ServiceException("请使用学生账号登录");
        }
        return self;
    }

    private Long toLong(Object v)
    {
        if (v == null)
        {
            return null;
        }
        if (v instanceof Number)
        {
            return Long.valueOf(((Number) v).longValue());
        }
        try
        {
            return Long.valueOf(String.valueOf(v));
        }
        catch (Exception e)
        {
            return null;
        }
    }

    private int nvl(Integer v)
    {
        return v == null ? 0 : v.intValue();
    }
}
