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
import java.util.Objects;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasInterveneTask;
import com.ruoyi.spas.domain.SpasKnowledge;
import com.ruoyi.spas.domain.SpasPracticeAssignment;
import com.ruoyi.spas.domain.SpasPracticeCheckout;
import com.ruoyi.spas.domain.SpasPracticeCheckoutItem;
import com.ruoyi.spas.domain.SpasPracticeLog;
import com.ruoyi.spas.domain.SpasPracticeLogKnowledge;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.domain.SpasStudyGroup;
import com.ruoyi.spas.domain.SpasStudyGroupMember;
import com.ruoyi.spas.mapper.SpasKnowledgeMapper;
import com.ruoyi.spas.mapper.SpasPracticeCheckoutMapper;
import com.ruoyi.spas.mapper.SpasPracticeLogMapper;
import com.ruoyi.spas.mapper.SpasStudentMapper;
import com.ruoyi.spas.mapper.SpasStudyGroupMapper;
import com.ruoyi.spas.service.ISpasInterveneService;
import com.ruoyi.spas.service.ISpasPracticeCheckoutService;
import com.ruoyi.spas.service.ISpasPracticeLogService;
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
    private SpasKnowledgeMapper knowledgeMapper;

    @Autowired
    private SpasPracticeLogMapper practiceLogMapper;

    @Autowired
    private SpasAccessService accessService;

    @Autowired
    private ISpasStudentPointService pointService;

    @Autowired
    private ISpasInterveneService interveneService;

    @Autowired
    private ISpasPracticeLogService practiceLogService;

    @Override
    public List<SpasPracticeAssignment> listAssignments(SpasPracticeAssignment query)
    {
        if (query.getDeptId() != null)
        {
            accessService.checkDeptAccess(query.getDeptId());
        }
        List<SpasPracticeAssignment> list = checkoutMapper.selectAssignmentList(query);
        if (list != null)
        {
            for (SpasPracticeAssignment a : list)
            {
                fillAssignmentKnowledgeList(a);
            }
        }
        return list;
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
        fillAssignmentKnowledgeList(row);
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
        if (row.getAssignDate() == null)
        {
            row.setAssignDate(DateUtils.parseDate(DateUtils.getDate()));
        }
        if (StringUtils.isEmpty(row.getBookName()))
        {
            throw new ServiceException("请填写书名/教辅，作为组长检查与教师抽检标准");
        }
        if (StringUtils.isEmpty(row.getQuestionText()))
        {
            throw new ServiceException("请填写题号范围，作为组长检查与教师抽检标准");
        }
        if (row.getPageFrom() != null && row.getPageTo() != null
            && row.getPageTo().intValue() < row.getPageFrom().intValue())
        {
            throw new ServiceException("结束页不能小于起始页");
        }
        if (StringUtils.isEmpty(row.getCompleteDefinition()))
        {
            throw new ServiceException("请填写「已完成」操作定义，供组长座位检查与教师抽检对照");
        }
        if (row.getDueCountWeek() == null)
        {
            row.setDueCountWeek(Integer.valueOf(3));
        }
        normalizeAssignmentKnowledge(row);
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

    private void normalizeAssignmentKnowledge(SpasPracticeAssignment row)
    {
        List<Long> kids = row.getKnowledgeIdList();
        if (kids == null || kids.isEmpty())
        {
            kids = parseKnowledgeIds(row.getKnowledgeIds());
        }
        if ((kids == null || kids.isEmpty()) && row.getKnowledgeId() != null)
        {
            kids = new ArrayList<Long>();
            kids.add(row.getKnowledgeId());
        }
        if (kids == null)
        {
            kids = new ArrayList<Long>();
        }
        // dedupe
        List<Long> uniq = new ArrayList<Long>();
        for (Long id : kids)
        {
            if (id != null && !uniq.contains(id))
            {
                uniq.add(id);
            }
        }
        row.setKnowledgeIdList(uniq);
        row.setKnowledgeIds(joinKnowledgeIds(uniq));
        row.setKnowledgeId(uniq.isEmpty() ? null : uniq.get(0));
    }

    private void fillAssignmentKnowledgeList(SpasPracticeAssignment row)
    {
        if (row == null)
        {
            return;
        }
        List<Long> kids = parseKnowledgeIds(row.getKnowledgeIds());
        if (kids.isEmpty() && row.getKnowledgeId() != null)
        {
            kids.add(row.getKnowledgeId());
        }
        row.setKnowledgeIdList(kids);
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
        fillAssignmentKnowledgeList(last);
        // 旧布置可能缺书名/题号/完成定义：不落库，交前端补全后再保存
        if (StringUtils.isEmpty(last.getBookName()) || StringUtils.isEmpty(last.getQuestionText())
            || StringUtils.isEmpty(last.getCompleteDefinition()))
        {
            if (StringUtils.isEmpty(last.getCompleteDefinition()))
            {
                last.setCompleteDefinition(DEFAULT_COMPLETE_DEF);
            }
            last.getParams().put("needFill", Boolean.TRUE);
            return last;
        }
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
            data.put("knowledgeIds", Collections.emptyList());
            data.put("weakKnowledge", Collections.emptyList());
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
        List<Long> sheetKnow = parseKnowledgeIds(checkout == null ? null : checkout.getKnowledgeIds());
        if (sheetKnow.isEmpty() && assignment != null)
        {
            fillAssignmentKnowledgeList(assignment);
            sheetKnow = assignment.getKnowledgeIdList() == null
                ? new ArrayList<Long>() : new ArrayList<Long>(assignment.getKnowledgeIdList());
        }
        data.put("knowledgeIds", sheetKnow);
        if (assignment != null)
        {
            fillAssignmentKnowledgeList(assignment);
        }
        try
        {
            data.put("weakKnowledge", practiceLogService.suggestWeak(assignment == null ? subjectId : assignment.getSubjectId(),
                Integer.valueOf(8)));
        }
        catch (Exception e)
        {
            data.put("weakKnowledge", Collections.emptyList());
        }
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
                    List<Long> kids = parseKnowledgeIds(hit.getKnowledgeIds());
                    row.put("knowledgeIds", kids);
                    row.put("knowledgeNames", resolveKnowledgeNames(kids));
                    row.put("memberAck", hit.getMemberAck());
                    row.put("voided", hit.getVoided());
                    row.put("spotResult", hit.getSpotResult());
                }
                members.add(row);
            }
        }
        data.put("members", members);
        SpasPracticeCheckoutItem mine = findItem(items, self.getStudentId());
        if (mine != null)
        {
            List<Long> mineKids = parseKnowledgeIds(mine.getKnowledgeIds());
            mine.setKnowledgeIdList(mineKids);
        }
        data.put("myItem", mine);
        data.put("myKnowledgeNames", mine == null ? Collections.emptyList()
            : resolveKnowledgeNames(parseKnowledgeIds(mine.getKnowledgeIds())));
        List<SpasPracticeCheckoutItem> pendingAck = checkoutMapper.selectMyPendingAck(self.getStudentId(), today);
        List<Map<String, Object>> pendingRows = new ArrayList<Map<String, Object>>();
        for (SpasPracticeCheckoutItem p : pendingAck)
        {
            Map<String, Object> pr = new HashMap<String, Object>();
            pr.put("itemId", p.getItemId());
            pr.put("checkoutId", p.getCheckoutId());
            pr.put("studentId", p.getStudentId());
            pr.put("studentName", p.getStudentName());
            pr.put("finishStatus", p.getFinishStatus());
            pr.put("difficultyNote", p.getDifficultyNote());
            List<Long> pk = parseKnowledgeIds(p.getKnowledgeIds());
            pr.put("knowledgeIds", pk);
            pr.put("knowledgeNames", resolveKnowledgeNames(pk));
            pr.put("memberAck", p.getMemberAck());
            pendingRows.add(pr);
        }
        data.put("pendingAck", pendingRows);
        if (group != null)
        {
            int spots = 0;
            if (assignment != null)
            {
                Date[] week = weekBounds(today);
                spots = checkoutMapper.countSpotsThisWeek(assignment.getDeptId(), assignment.getSubjectId(),
                    week[0], week[1]);
            }
            data.put("weekQualify", weekQualify(group.getGroupId(), assignment, today, spots));
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
        if (assignment.getDeptId() != null && self.getDeptId() != null
            && !assignment.getDeptId().equals(self.getDeptId()))
        {
            throw new ServiceException("布置班级与当前学生不一致");
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
        // Always treat leader as checker — ignore client checkerStudentId to prevent self-complete bypass
        Long checkerId = self.getStudentId();
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
            // 组长本人禁止自评完成类（已完成/部分）；可报有困难/未做/请假/未到
            if (m.getStudentId().equals(checkerId)
                && ("1".equals(it.getFinishStatus()) || "2".equals(it.getFinishStatus())))
            {
                throw new ServiceException("禁止自检自评为已完成或部分，请改选有困难/未做/请假/未到，或由教师抽检");
            }
            String itemKnow = normalizeItemKnowledgeIds(it);
            String st = it.getFinishStatus();
            if (("1".equals(st) || "2".equals(st) || "3".equals(st)) && StringUtils.isEmpty(itemKnow))
            {
                throw new ServiceException("请为「" + m.getStudentName() + "」选择知识主题");
            }
            it.setStudentId(m.getStudentId());
            it.setKnowledgeIds(itemKnow);
            // 请假/未到/未做无需组员确认
            if ("0".equals(st) || "L".equals(st) || "A".equals(st))
            {
                it.setMemberAck("1");
                it.setKnowledgeIds(null);
                it.setDifficultyNote(null);
            }
            else
            {
                it.setMemberAck("0");
            }
            it.setVoided("0");
            normalized.add(it);
        }
        // sheet-level = union of member themes (compat / analytics)
        List<Long> union = new ArrayList<Long>();
        for (SpasPracticeCheckoutItem it : normalized)
        {
            for (Long id : parseKnowledgeIds(it.getKnowledgeIds()))
            {
                if (!union.contains(id))
                {
                    union.add(id);
                }
            }
        }
        String knowledgeCsv = joinKnowledgeIds(union);
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
            c.setKnowledgeIds(knowledgeCsv);
            c.setStatus("0");
            rows = checkoutMapper.insertCheckout(c);
            checkoutId = c.getCheckoutId();
            for (SpasPracticeCheckoutItem it : normalized)
            {
                it.setCheckoutId(checkoutId);
                checkoutMapper.insertItem(it);
            }
        }
        else
        {
            // Upsert by student_id — never delete items (preserves ack/spot/log idempotency keys)
            List<SpasPracticeCheckoutItem> oldItems = checkoutMapper.selectItems(exist.getCheckoutId());
            Map<Long, SpasPracticeCheckoutItem> oldByStu = new HashMap<Long, SpasPracticeCheckoutItem>();
            if (oldItems != null)
            {
                for (SpasPracticeCheckoutItem oi : oldItems)
                {
                    oldByStu.put(oi.getStudentId(), oi);
                }
            }
            for (SpasPracticeCheckoutItem it : normalized)
            {
                SpasPracticeCheckoutItem old = oldByStu.get(it.getStudentId());
                if (old != null)
                {
                    String ack = old.getMemberAck() == null ? "0" : old.getMemberAck();
                    String oldSt = old.getFinishStatus();
                    // 请假/未到/未做的自动确认仍可改正；属实过的完成类、异议/超时、抽检后锁定
                    boolean productiveAck = "1".equals(ack)
                        && ("1".equals(oldSt) || "2".equals(oldSt) || "3".equals(oldSt));
                    boolean locked = "1".equals(old.getVoided())
                        || StringUtils.isNotEmpty(old.getSpotResult())
                        || "2".equals(ack) || "3".equals(ack) || productiveAck;
                    if (locked)
                    {
                        boolean same = Objects.equals(old.getFinishStatus(), it.getFinishStatus())
                            && Objects.equals(StringUtils.trimToEmpty(old.getDifficultyNote()),
                                StringUtils.trimToEmpty(it.getDifficultyNote()))
                            && Objects.equals(StringUtils.trimToEmpty(old.getKnowledgeIds()),
                                StringUtils.trimToEmpty(it.getKnowledgeIds()));
                        if (!same)
                        {
                            throw new ServiceException("「"
                                + (old.getStudentName() != null ? old.getStudentName() : String.valueOf(it.getStudentId()))
                                + "」已确认或已抽检，不能改正；请联系老师处理");
                        }
                        continue;
                    }
                    it.setItemId(old.getItemId());
                    it.setCheckoutId(exist.getCheckoutId());
                    checkoutMapper.updateItemContent(it);
                }
                else
                {
                    it.setCheckoutId(exist.getCheckoutId());
                    checkoutMapper.insertItem(it);
                }
            }
            exist.setCheckerStudentId(checkerId);
            exist.setDeviceCode(body.getDeviceCode());
            exist.setKnowledgeIds(knowledgeCsv);
            rows = checkoutMapper.updateCheckout(exist);
            checkoutId = exist.getCheckoutId();
        }
        int awarded = pointService.awardCheckoutSubmit(self.getStudentId(), assignment.getDeptId(),
            assignment.getSubjectId(), checkoutId);
        LAST_AWARDED_POINTS.set(Integer.valueOf(awarded));
        return rows;
    }

    @Override
    @Transactional
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
        if ("1".equals(item.getVoided()))
        {
            throw new ServiceException("该记录已作废，无法确认");
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
        String st = item.getFinishStatus();
        if ("0".equals(st) || "L".equals(st) || "A".equals(st))
        {
            throw new ServiceException("请假/未到/未做无需确认");
        }
        item.setMemberAck(accept ? "1" : "2");
        int rows = checkoutMapper.updateItemAck(item);
        int awarded = 0;
        if (accept)
        {
            SpasPracticeAssignment a = checkoutMapper.selectAssignmentById(checkout.getAssignmentId());
            Long deptId = a == null ? self.getDeptId() : a.getDeptId();
            Long subjectId = a == null ? null : a.getSubjectId();
            // 自检自评（检查员=本人）完成/部分不计确认分；有困难仍奖励如实上报
            boolean selfCheck = checkout.getCheckerStudentId() != null
                && checkout.getCheckerStudentId().equals(item.getStudentId());
            String fs = item.getFinishStatus();
            if (!(selfCheck && ("1".equals(fs) || "2".equals(fs))))
            {
                awarded = pointService.awardCheckoutAck(item.getStudentId(), deptId, subjectId,
                    item.getItemId(), item.getFinishStatus());
            }
            // 属实后写入练习流水（不重复发打卡积分）
            createPracticeLogFromAck(self, checkout, a, item);
        }
        LAST_AWARDED_POINTS.set(Integer.valueOf(awarded));
        return rows;
    }

    @Override
    public int expirePendingAcks()
    {
        Date today = DateUtils.parseDate(DateUtils.getDate());
        // Prefer the variant that also stamps ack_time
        return checkoutMapper.expirePendingAcksBefore(today);
    }

    @Override
    @Transactional
    public int resolveItem(Long itemId, String action)
    {
        accessService.assertCanWrite();
        if (!"ack".equals(action) && !"void".equals(action) && !"dismiss".equals(action))
        {
            throw new ServiceException("处置动作只能是补确认/作废/已阅");
        }
        SpasPracticeCheckoutItem item = checkoutMapper.selectItemById(itemId);
        if (item == null)
        {
            throw new ServiceException("检查记录不存在");
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
        if ("1".equals(item.getVoided()))
        {
            throw new ServiceException("记录已作废");
        }
        String ack = item.getMemberAck() == null ? "0" : item.getMemberAck();
        if ("void".equals(action))
        {
            if (StringUtils.isEmpty(item.getSpotResult()))
            {
                item.setSpotResult("0");
            }
            item.setVoided("1");
            checkoutMapper.updateItemSpot(item);
            practiceLogMapper.voidByRemark("checkoutItem:" + itemId);
            pointService.clawbackCheckoutAck(item.getStudentId(), a.getDeptId(), a.getSubjectId(), itemId);
            return 1;
        }
        if ("dismiss".equals(action))
        {
            if (!"3".equals(ack) && !"2".equals(ack))
            {
                throw new ServiceException("仅超时或异议可标记已阅");
            }
            return checkoutMapper.updateItemFollow(itemId, "1");
        }
        // ack = 教师补确认
        if (!"0".equals(ack) && !"3".equals(ack) && !"2".equals(ack))
        {
            throw new ServiceException("当前状态无需补确认");
        }
        // 异议须先抽检，避免绕过风险抽检直接发分
        if ("2".equals(ack) && StringUtils.isEmpty(item.getSpotResult()))
        {
            throw new ServiceException("异议须先在抽检队列判定（一致/偏松/偏严），再补确认或作废");
        }
        String st = item.getFinishStatus();
        if (!"1".equals(st) && !"2".equals(st) && !"3".equals(st))
        {
            throw new ServiceException("请假/未到/未做无需补确认，可作废或已阅");
        }
        item.setMemberAck("1");
        checkoutMapper.updateItemAck(item);
        SpasStudent stu = studentMapper.selectSpasStudentById(item.getStudentId());
        if (stu == null)
        {
            throw new ServiceException("学生不存在");
        }
        int awarded = pointService.awardCheckoutAck(item.getStudentId(), a.getDeptId(), a.getSubjectId(),
            item.getItemId(), item.getFinishStatus());
        createPracticeLogFromAck(stu, checkout, a, item);
        LAST_AWARDED_POINTS.set(Integer.valueOf(awarded));
        return 1;
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
        List<Long> kids = parseKnowledgeIds(item.getKnowledgeIds());
        if (kids.isEmpty() && a.getKnowledgeId() != null)
        {
            kids.add(a.getKnowledgeId());
        }
        if (kids.isEmpty())
        {
            throw new ServiceException("该记录未关联知识主题，无法转干预");
        }
        SpasInterveneTask task = new SpasInterveneTask();
        task.setStudentId(item.getStudentId());
        task.setSubjectId(a.getSubjectId());
        task.setSourceType("4");
        task.setSourceId(itemId);
        task.setKnowledgeIdList(kids);
        task.setKnowledgeIds(joinKnowledgeIds(kids));
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
        SpasPracticeAssignment dayAssign = null;
        if (subjectId != null)
        {
            dayAssign = checkoutMapper.selectAssignmentByDay(deptId, subjectId, day);
        }
        // 未布置时不报「未结账」，避免全班误催
        if (dayAssign == null)
        {
            data.put("missingCheckout", new ArrayList<Map<String, Object>>());
        }
        else
        {
            data.put("missingCheckout", checkoutMapper.selectMissingCheckout(deptId, subjectId, day));
        }
        data.put("pendingAck", checkoutMapper.selectPendingAck(deptId, subjectId, day));
        data.put("disputes", checkoutMapper.selectDisputes(deptId, subjectId, day));
        // Overnight job marks yesterday as timeout; merge day + previous day so "今日"看板仍可见
        List<Map<String, Object>> timeouts = new ArrayList<Map<String, Object>>();
        Set<Long> timeoutIds = new HashSet<Long>();
        List<Map<String, Object>> dayTimeouts = checkoutMapper.selectTimeouts(deptId, subjectId, day);
        if (dayTimeouts != null)
        {
            for (Map<String, Object> r : dayTimeouts)
            {
                Long iid = toLong(r.get("itemId"));
                if (iid == null || timeoutIds.add(iid))
                {
                    timeouts.add(r);
                }
            }
        }
        Calendar prevCal = Calendar.getInstance();
        prevCal.setTime(day);
        prevCal.add(Calendar.DATE, -1);
        Date prevDay = DateUtils.parseDate(DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD, prevCal.getTime()));
        List<Map<String, Object>> prevTimeouts = checkoutMapper.selectTimeouts(deptId, subjectId, prevDay);
        if (prevTimeouts != null)
        {
            for (Map<String, Object> r : prevTimeouts)
            {
                Long iid = toLong(r.get("itemId"));
                if (iid == null || timeoutIds.add(iid))
                {
                    timeouts.add(r);
                }
            }
        }
        data.put("timeouts", timeouts);
        data.put("difficultySummary", checkoutMapper.selectDifficultySummary(deptId, subjectId, day));
        data.put("difficultyItems", checkoutMapper.selectDifficultyItems(deptId, subjectId, day));
        int spots = checkoutMapper.countSpotsThisWeek(deptId, subjectId, week[0], week[1]);
        data.put("weekSpotCount", Integer.valueOf(spots));
        List<Map<String, Object>> groups = checkoutMapper.selectActiveGroups(deptId, subjectId);
        List<Map<String, Object>> qualify = new ArrayList<Map<String, Object>>();
        Integer due = Integer.valueOf(3);
        SpasPracticeAssignment asg = dayAssign;
        if (asg != null && asg.getDueCountWeek() != null)
        {
            due = asg.getDueCountWeek();
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
                    row.putAll(weekQualify(gid, asg, day, spots));
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
            String ack = String.valueOf(r.get("memberAck"));
            if ("2".equals(ack))
            {
                w += 1000;
            }
            else if ("3".equals(ack))
            {
                w += 800;
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
            String ack = String.valueOf(r.get("memberAck"));
            if ("2".equals(ack) || "3".equals(ack))
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
        if (checkoutMapper.countSpotByItemId(itemId) > 0 || StringUtils.isNotEmpty(item.getSpotResult()))
        {
            throw new ServiceException("该记录已抽检，请勿重复操作");
        }
        item.setSpotResult(spotResult);
        item.setVoided("2".equals(spotResult) ? "1" : "0");
        checkoutMapper.updateItemSpot(item);
        int rows = checkoutMapper.insertSpot(itemId, item.getStudentId(), checkout.getGroupId(),
            checkout.getCheckerStudentId(), spotResult, SecurityUtils.getUsername(), spotRemark);
        if ("2".equals(spotResult))
        {
            // 偏松：作废检查项关联的练习流水，并扣回确认积分
            practiceLogMapper.voidByRemark("checkoutItem:" + itemId);
            pointService.clawbackCheckoutAck(item.getStudentId(), a.getDeptId(), a.getSubjectId(), itemId);
        }
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
        int spots = 0;
        if (assignment != null && assignment.getDeptId() != null && assignment.getSubjectId() != null)
        {
            Date[] week = weekBounds(day);
            spots = checkoutMapper.countSpotsThisWeek(assignment.getDeptId(), assignment.getSubjectId(),
                week[0], week[1]);
        }
        return weekQualify(groupId, assignment, day, spots);
    }

    private Map<String, Object> weekQualify(Long groupId, SpasPracticeAssignment assignment, Date day, int weekSpotCount)
    {
        Date[] week = weekBounds(day);
        int due = assignment != null && assignment.getDueCountWeek() != null ? assignment.getDueCountWeek().intValue() : 3;
        int submitted = checkoutMapper.countWeekCheckout(groupId, week[0], week[1]);
        int loose = checkoutMapper.countWeekLoose(groupId, week[0], week[1]);
        int unfollowed = checkoutMapper.countUnfollowedDifficulty(groupId, week[0], week[1]);
        boolean ok = submitted >= due && loose == 0 && unfollowed == 0;
        String reason = null;
        if (ok && weekSpotCount <= 0)
        {
            ok = false;
            reason = "本周尚未抽检，达标灯不亮";
        }
        else if (!ok && submitted < due)
        {
            reason = "本周检查次数不足";
        }
        else if (!ok && loose > 0)
        {
            reason = "本周存在偏松抽检";
        }
        else if (!ok && unfollowed > 0)
        {
            reason = "困难未跟进";
        }
        Map<String, Object> m = new HashMap<String, Object>();
        m.put("submittedCount", Integer.valueOf(submitted));
        m.put("dueCount", Integer.valueOf(due));
        m.put("looseCount", Integer.valueOf(loose));
        m.put("unfollowedDifficulty", Integer.valueOf(unfollowed));
        m.put("weekSpotCount", Integer.valueOf(weekSpotCount));
        m.put("qualified", Boolean.valueOf(ok));
        if (reason != null)
        {
            m.put("reason", reason);
        }
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

    private void createPracticeLogFromAck(SpasStudent self, SpasPracticeCheckout checkout,
        SpasPracticeAssignment assignment, SpasPracticeCheckoutItem item)
    {
        if (item == null || self == null || checkout == null)
        {
            return;
        }
        String st = item.getFinishStatus();
        // only productive statuses become practice traces
        if (!"1".equals(st) && !"2".equals(st) && !"3".equals(st))
        {
            return;
        }
        String remarkKey = "checkoutItem:" + item.getItemId();
        if (practiceLogMapper.countByRemark(remarkKey) > 0)
        {
            return;
        }
        List<Long> kids = parseKnowledgeIds(item.getKnowledgeIds());
        if (kids.isEmpty() && assignment != null && assignment.getKnowledgeId() != null)
        {
            kids.add(assignment.getKnowledgeId());
        }
        if (kids.isEmpty())
        {
            return;
        }
        SpasPracticeLog log = new SpasPracticeLog();
        log.setPracticeDate(checkout.getPracticeDate());
        log.setDeptId(assignment != null ? assignment.getDeptId() : self.getDeptId());
        log.setGroupId(checkout.getGroupId());
        log.setStudentId(self.getStudentId());
        log.setSubjectId(assignment != null ? assignment.getSubjectId() : null);
        log.setBookName(assignment != null && StringUtils.isNotEmpty(assignment.getBookName())
            ? assignment.getBookName() : "检查单登记");
        log.setPageFrom(assignment == null ? null : assignment.getPageFrom());
        log.setPageTo(assignment == null ? null : assignment.getPageTo());
        log.setQuestionText(assignment != null && StringUtils.isNotEmpty(assignment.getQuestionText())
            ? assignment.getQuestionText() : "座位检查确认");
        log.setFinishStatus(st);
        log.setDifficultyNote(item.getDifficultyNote());
        log.setSubmitSlot("0");
        log.setSubmitByStudentId(checkout.getCheckerStudentId());
        log.setProxyFlag("0");
        log.setConfirmStatus("2");
        log.setClientType("checkout");
        log.setDeviceCode(checkout.getDeviceCode());
        log.setSpotStatus("0");
        log.setStatus("0");
        log.setRemark(remarkKey);
        practiceLogMapper.insertSpasPracticeLog(log);
        boolean primary = true;
        for (Long kid : kids)
        {
            SpasPracticeLogKnowledge link = new SpasPracticeLogKnowledge();
            link.setLogId(log.getLogId());
            link.setKnowledgeId(kid);
            link.setIsPrimary(primary ? "1" : "0");
            practiceLogMapper.insertKnowledge(link);
            primary = false;
        }
        try
        {
            practiceLogMapper.upsertBookStat(log.getDeptId(), log.getSubjectId(), log.getBookName().trim());
        }
        catch (Exception ignored)
        {
            /* book stat is best-effort */
        }
    }

    private List<Long> parseKnowledgeIds(String csv)
    {
        List<Long> out = new ArrayList<Long>();
        if (StringUtils.isEmpty(csv))
        {
            return out;
        }
        String[] parts = csv.split(",");
        for (String p : parts)
        {
            Long id = toLong(p == null ? null : p.trim());
            if (id != null && !out.contains(id))
            {
                out.add(id);
            }
        }
        return out;
    }

    private List<String> resolveKnowledgeNames(List<Long> ids)
    {
        List<String> names = new ArrayList<String>();
        if (ids == null || ids.isEmpty())
        {
            return names;
        }
        for (Long id : ids)
        {
            SpasKnowledge k = knowledgeMapper.selectSpasKnowledgeById(id);
            if (k != null && StringUtils.isNotEmpty(k.getKnowledgeName()))
            {
                names.add(k.getKnowledgeName());
            }
        }
        return names;
    }

    private String normalizeKnowledgeIds(SpasPracticeCheckout body)
    {
        List<Long> ids = new ArrayList<Long>();
        if (body.getKnowledgeIdList() != null)
        {
            for (Long id : body.getKnowledgeIdList())
            {
                if (id != null && !ids.contains(id))
                {
                    ids.add(id);
                }
            }
        }
        if (ids.isEmpty() && StringUtils.isNotEmpty(body.getKnowledgeIds()))
        {
            ids.addAll(parseKnowledgeIds(body.getKnowledgeIds()));
        }
        return joinKnowledgeIds(ids);
    }

    private String normalizeItemKnowledgeIds(SpasPracticeCheckoutItem item)
    {
        List<Long> ids = new ArrayList<Long>();
        if (item.getKnowledgeIdList() != null)
        {
            for (Long id : item.getKnowledgeIdList())
            {
                if (id != null && !ids.contains(id))
                {
                    ids.add(id);
                }
            }
        }
        if (ids.isEmpty() && StringUtils.isNotEmpty(item.getKnowledgeIds()))
        {
            ids.addAll(parseKnowledgeIds(item.getKnowledgeIds()));
        }
        return joinKnowledgeIds(ids);
    }

    private String joinKnowledgeIds(List<Long> ids)
    {
        if (ids == null || ids.isEmpty())
        {
            return null;
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < ids.size(); i++)
        {
            if (i > 0)
            {
                sb.append(',');
            }
            sb.append(ids.get(i));
        }
        return sb.toString();
    }

    private int nvl(Integer v)
    {
        return v == null ? 0 : v.intValue();
    }
}
