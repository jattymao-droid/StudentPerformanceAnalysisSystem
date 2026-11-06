package com.ruoyi.spas.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.file.FileUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.spas.domain.SpasExam;
import com.ruoyi.spas.domain.SpasExamScore;
import com.ruoyi.spas.domain.SpasGroupWeakExportRow;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.domain.SpasStudyGroup;
import com.ruoyi.spas.domain.SpasStudyGroupMember;
import com.ruoyi.spas.domain.SpasSubject;
import com.ruoyi.spas.analysis.KnowledgeStatQueryService;
import com.ruoyi.spas.mapper.SpasExamScoreMapper;
import com.ruoyi.spas.mapper.SpasStudentMapper;
import com.ruoyi.spas.mapper.SpasStudyGroupMapper;
import com.ruoyi.spas.mapper.SpasSubjectMapper;
import com.ruoyi.spas.service.ISpasStudyGroupService;
import com.ruoyi.spas.support.SpasAccessService;
import com.ruoyi.spas.support.SpasAnalysisWindowHelper;
import com.ruoyi.spas.support.SpasReportPdfWriter;
import com.ruoyi.spas.support.SpasTeacherScopeService;
import com.ruoyi.spas.support.SubjectAlias;

@Service
public class SpasStudyGroupServiceImpl implements ISpasStudyGroupService
{
    @Autowired
    private SpasStudyGroupMapper groupMapper;

    @Autowired
    private SpasStudentMapper studentMapper;

    @Autowired
    private SpasExamScoreMapper examScoreMapper;

    @Autowired
    private SpasSubjectMapper subjectMapper;

    @Autowired
    private SpasAccessService accessService;

    @Autowired
    private SpasTeacherScopeService teacherScopeService;

    @Autowired
    private KnowledgeStatQueryService knowledgeStatQueryService;

    @Autowired
    private SpasAnalysisWindowHelper windowHelper;

    @Override
    public List<SpasStudyGroup> selectSpasStudyGroupList(SpasStudyGroup query)
    {
        if (query == null)
        {
            query = new SpasStudyGroup();
        }
        List<SpasStudyGroup> list;
        if (teacherScopeService.useTeacherDeptFilter())
        {
            teacherScopeService.applyTeacherDeptFilter(query);
            list = groupMapper.selectSpasStudyGroupList(query);
        }
        else
        {
            list = SpringUtils.getAopProxy(this).selectSpasStudyGroupListScoped(query);
        }
        attachGroupStats(list, query);
        return list;
    }

    @DataScope(deptAlias = "d")
    public List<SpasStudyGroup> selectSpasStudyGroupListScoped(SpasStudyGroup query)
    {
        return groupMapper.selectSpasStudyGroupList(query);
    }

    /** Fill avgScore / avgRank / gender counts for list cards. */
    private void attachGroupStats(List<SpasStudyGroup> list, SpasStudyGroup query)
    {
        if (list == null || list.isEmpty())
        {
            return;
        }
        Long deptId = query != null ? query.getDeptId() : null;
        if (deptId == null)
        {
            deptId = list.get(0).getDeptId();
        }
        if (deptId == null)
        {
            return;
        }
        Long examId = null;
        if (query != null && query.getParams() != null && query.getParams().get("examId") != null
            && !"".equals(String.valueOf(query.getParams().get("examId"))))
        {
            examId = Long.valueOf(String.valueOf(query.getParams().get("examId")));
        }
        SpasExam exam = null;
        if (examId != null)
        {
            exam = examScoreMapper.selectSpasExamById(examId);
            if (exam != null && exam.getDeptId() != null && !exam.getDeptId().equals(deptId))
            {
                exam = null;
            }
        }
        else
        {
            exam = examScoreMapper.selectLatestDoneExamByDept(deptId);
        }
        List<SpasExamScore> allScores = exam == null ? null : examScoreMapper.selectScoresByExamId(exam.getExamId());

        List<Long> gids = new ArrayList<Long>(list.size());
        for (SpasStudyGroup g : list)
        {
            if (g.getGroupId() != null)
            {
                gids.add(g.getGroupId());
            }
        }
        Map<Long, List<SpasStudyGroupMember>> membersByGroup = new HashMap<Long, List<SpasStudyGroupMember>>();
        if (!gids.isEmpty())
        {
            List<SpasStudyGroupMember> members = groupMapper.selectActiveMembersByGroupIds(gids);
            if (members != null)
            {
                for (SpasStudyGroupMember m : members)
                {
                    List<SpasStudyGroupMember> bucket = membersByGroup.get(m.getGroupId());
                    if (bucket == null)
                    {
                        bucket = new ArrayList<SpasStudyGroupMember>();
                        membersByGroup.put(m.getGroupId(), bucket);
                    }
                    bucket.add(m);
                }
            }
        }

        Map<Long, String> subjectNameCache = new HashMap<Long, String>();
        for (SpasStudyGroup g : list)
        {
            List<SpasStudyGroupMember> members = membersByGroup.get(g.getGroupId());
            if (members == null)
            {
                members = Collections.emptyList();
            }
            int male = 0;
            int female = 0;
            for (SpasStudyGroupMember m : members)
            {
                if ("0".equals(m.getGender()))
                {
                    male++;
                }
                else if ("1".equals(m.getGender()))
                {
                    female++;
                }
            }
            g.setMaleCount(Integer.valueOf(male));
            g.setFemaleCount(Integer.valueOf(female));

            if (exam == null || allScores == null || allScores.isEmpty() || members.isEmpty())
            {
                continue;
            }
            String subjectName = null;
            Long sid = g.getSubjectId() != null ? g.getSubjectId() : (query == null ? null : query.getSubjectId());
            if (sid != null)
            {
                if (!subjectNameCache.containsKey(sid))
                {
                    SpasSubject sub = subjectMapper.selectSpasSubjectById(sid);
                    subjectNameCache.put(sid, sub == null ? null : sub.getSubjectName());
                }
                subjectName = subjectNameCache.get(sid);
            }
            Map<Long, SpasExamScore> picked = pickScoreRows(allScores, subjectName);
            BigDecimal scoreSum = BigDecimal.ZERO;
            int scoreN = 0;
            BigDecimal rankSum = BigDecimal.ZERO;
            int rankN = 0;
            for (SpasStudyGroupMember m : members)
            {
                SpasExamScore sc = picked.get(m.getStudentId());
                if (sc == null)
                {
                    continue;
                }
                if (sc.getScore() != null)
                {
                    scoreSum = scoreSum.add(sc.getScore());
                    scoreN++;
                }
                if (sc.getSchoolRank() != null)
                {
                    rankSum = rankSum.add(BigDecimal.valueOf(sc.getSchoolRank().intValue()));
                    rankN++;
                }
            }
            g.setStatsExamId(exam.getExamId());
            g.setStatsExamName(exam.getExamName());
            g.setStatsMetric(StringUtils.isNotEmpty(subjectName) ? "subject" : "total");
            g.setScoredCount(Integer.valueOf(Math.max(scoreN, rankN)));
            if (scoreN > 0)
            {
                g.setAvgScore(scoreSum.divide(BigDecimal.valueOf(scoreN), 1, RoundingMode.HALF_UP));
            }
            if (rankN > 0)
            {
                g.setAvgRank(rankSum.divide(BigDecimal.valueOf(rankN), 1, RoundingMode.HALF_UP));
            }
        }
    }

    private Map<Long, SpasExamScore> pickScoreRows(List<SpasExamScore> scores, String subjectName)
    {
        Map<Long, SpasExamScore> picked = new HashMap<Long, SpasExamScore>();
        boolean preferSubject = StringUtils.isNotEmpty(subjectName);
        for (SpasExamScore sc : scores)
        {
            if (sc.getStudentId() == null)
            {
                continue;
            }
            boolean match;
            if (preferSubject)
            {
                match = SpasExamScore.TYPE_SUBJECT.equals(sc.getScoreType())
                    && SubjectAlias.same(subjectName, sc.getSubjectName());
            }
            else
            {
                match = SpasExamScore.TYPE_TOTAL.equals(sc.getScoreType());
            }
            if (!match)
            {
                continue;
            }
            SpasExamScore old = picked.get(sc.getStudentId());
            if (old == null || betterScoreRow(sc, old))
            {
                picked.put(sc.getStudentId(), sc);
            }
        }
        if (preferSubject && picked.isEmpty())
        {
            for (SpasExamScore sc : scores)
            {
                if (sc.getStudentId() == null || !SpasExamScore.TYPE_TOTAL.equals(sc.getScoreType()))
                {
                    continue;
                }
                SpasExamScore old = picked.get(sc.getStudentId());
                if (old == null || betterScoreRow(sc, old))
                {
                    picked.put(sc.getStudentId(), sc);
                }
            }
        }
        return picked;
    }

    @Override
    public SpasStudyGroup selectSpasStudyGroupById(Long groupId)
    {
        SpasStudyGroup group = requireGroup(groupId);
        accessService.checkDeptAccess(group.getDeptId());
        group.setMembers(groupMapper.selectActiveMembers(groupId));
        return group;
    }

    @Override
    public Map<String, Object> selectGroupPerformance(Long groupId, Long subjectId, Long examId)
    {
        SpasStudyGroup group = requireGroup(groupId);
        accessService.checkDeptAccess(group.getDeptId());
        List<SpasStudyGroupMember> members = groupMapper.selectActiveMembers(groupId);
        if (members == null)
        {
            members = Collections.emptyList();
        }

        Long resolveSubjectId = subjectId != null ? subjectId : group.getSubjectId();
        String subjectName = null;
        if (resolveSubjectId != null)
        {
            SpasSubject sub = subjectMapper.selectSpasSubjectById(resolveSubjectId);
            subjectName = sub == null ? null : sub.getSubjectName();
        }

        List<SpasExam> exams = examScoreMapper.selectDoneExamsByDept(group.getDeptId());
        if (exams == null)
        {
            exams = Collections.emptyList();
        }

        SpasExam focusExam = null;
        if (examId != null)
        {
            for (SpasExam e : exams)
            {
                if (examId.equals(e.getExamId()))
                {
                    focusExam = e;
                    break;
                }
            }
            if (focusExam == null)
            {
                focusExam = examScoreMapper.selectSpasExamById(examId);
                if (focusExam != null && focusExam.getDeptId() != null
                    && !focusExam.getDeptId().equals(group.getDeptId()))
                {
                    focusExam = null;
                }
            }
        }
        if (focusExam == null && !exams.isEmpty())
        {
            focusExam = exams.get(exams.size() - 1);
        }

        List<Map<String, Object>> memberRows = new ArrayList<Map<String, Object>>();
        BigDecimal focusScoreSum = BigDecimal.ZERO;
        int focusScoreN = 0;
        BigDecimal focusRankSum = BigDecimal.ZERO;
        int focusRankN = 0;
        String metric = StringUtils.isNotEmpty(subjectName) ? "subject" : "total";

        if (focusExam != null)
        {
            List<SpasExamScore> scores = examScoreMapper.selectScoresByExamId(focusExam.getExamId());
            Map<Long, SpasExamScore> picked = pickScoreRows(scores, subjectName);
            if (StringUtils.isNotEmpty(subjectName) && !picked.isEmpty())
            {
                // detect whether we actually got subject rows or fell back to total
                SpasExamScore sample = picked.values().iterator().next();
                if (SpasExamScore.TYPE_TOTAL.equals(sample.getScoreType()))
                {
                    metric = "total";
                }
            }
            else if (StringUtils.isNotEmpty(subjectName) && picked.isEmpty())
            {
                metric = "total";
            }
            for (SpasStudyGroupMember m : members)
            {
                Map<String, Object> row = new LinkedHashMap<String, Object>();
                row.put("studentId", m.getStudentId());
                row.put("studentNo", m.getStudentNo());
                row.put("studentName", m.getStudentName());
                row.put("gender", m.getGender());
                row.put("roleInGroup", m.getRoleInGroup());
                SpasExamScore sc = picked.get(m.getStudentId());
                if (sc != null)
                {
                    row.put("score", sc.getScore());
                    row.put("schoolRank", sc.getSchoolRank());
                    row.put("subjectName", sc.getSubjectName());
                    row.put("scoreType", sc.getScoreType());
                    if (sc.getScore() != null)
                    {
                        focusScoreSum = focusScoreSum.add(sc.getScore());
                        focusScoreN++;
                    }
                    if (sc.getSchoolRank() != null)
                    {
                        focusRankSum = focusRankSum.add(BigDecimal.valueOf(sc.getSchoolRank().intValue()));
                        focusRankN++;
                    }
                }
                else
                {
                    row.put("score", null);
                    row.put("schoolRank", null);
                }
                memberRows.add(row);
            }
            // leader first, then by rank asc / score desc
            Collections.sort(memberRows, new Comparator<Map<String, Object>>()
            {
                @Override
                public int compare(Map<String, Object> a, Map<String, Object> b)
                {
                    boolean la = "1".equals(String.valueOf(a.get("roleInGroup")));
                    boolean lb = "1".equals(String.valueOf(b.get("roleInGroup")));
                    if (la != lb)
                    {
                        return la ? -1 : 1;
                    }
                    Integer ra = (Integer) a.get("schoolRank");
                    Integer rb = (Integer) b.get("schoolRank");
                    if (ra != null && rb != null && !ra.equals(rb))
                    {
                        return ra.intValue() - rb.intValue();
                    }
                    BigDecimal sa = (BigDecimal) a.get("score");
                    BigDecimal sb = (BigDecimal) b.get("score");
                    if (sa != null && sb != null)
                    {
                        return sb.compareTo(sa);
                    }
                    if (sa != null) return -1;
                    if (sb != null) return 1;
                    String na = a.get("studentName") == null ? "" : String.valueOf(a.get("studentName"));
                    String nb = b.get("studentName") == null ? "" : String.valueOf(b.get("studentName"));
                    return na.compareTo(nb);
                }
            });
        }
        else
        {
            for (SpasStudyGroupMember m : members)
            {
                Map<String, Object> row = new LinkedHashMap<String, Object>();
                row.put("studentId", m.getStudentId());
                row.put("studentNo", m.getStudentNo());
                row.put("studentName", m.getStudentName());
                row.put("gender", m.getGender());
                row.put("roleInGroup", m.getRoleInGroup());
                row.put("score", null);
                row.put("schoolRank", null);
                memberRows.add(row);
            }
        }

        // prev exam deltas
        SpasExam prevExam = null;
        if (focusExam != null && !exams.isEmpty())
        {
            for (int i = 0; i < exams.size(); i++)
            {
                if (focusExam.getExamId().equals(exams.get(i).getExamId()) && i > 0)
                {
                    prevExam = exams.get(i - 1);
                    break;
                }
            }
        }
        if (prevExam != null)
        {
            Map<Long, SpasExamScore> prevPicked = pickScoreRows(
                examScoreMapper.selectScoresByExamId(prevExam.getExamId()), subjectName);
            for (Map<String, Object> row : memberRows)
            {
                Long sid = (Long) row.get("studentId");
                SpasExamScore prev = prevPicked.get(sid);
                BigDecimal curScore = (BigDecimal) row.get("score");
                Integer curRank = (Integer) row.get("schoolRank");
                if (prev != null && curScore != null && prev.getScore() != null)
                {
                    row.put("scoreDelta", curScore.subtract(prev.getScore()).setScale(1, RoundingMode.HALF_UP));
                }
                if (prev != null && curRank != null && prev.getSchoolRank() != null)
                {
                    // positive = improved (rank number decreased)
                    row.put("rankDelta", Integer.valueOf(prev.getSchoolRank().intValue() - curRank.intValue()));
                }
                if (prev != null)
                {
                    row.put("prevScore", prev.getScore());
                    row.put("prevSchoolRank", prev.getSchoolRank());
                }
            }
        }

        List<Map<String, Object>> trend = new ArrayList<Map<String, Object>>();
        Set<Long> memberIds = new LinkedHashSet<Long>();
        for (SpasStudyGroupMember m : members)
        {
            if (m.getStudentId() != null)
            {
                memberIds.add(m.getStudentId());
            }
        }
        for (SpasExam e : exams)
        {
            List<SpasExamScore> scores = examScoreMapper.selectScoresByExamId(e.getExamId());
            Map<Long, SpasExamScore> picked = pickScoreRows(scores, subjectName);
            BigDecimal sSum = BigDecimal.ZERO;
            int sN = 0;
            BigDecimal rSum = BigDecimal.ZERO;
            int rN = 0;
            BigDecimal classSSum = BigDecimal.ZERO;
            int classSN = 0;
            for (Map.Entry<Long, SpasExamScore> en : picked.entrySet())
            {
                SpasExamScore sc = en.getValue();
                if (sc.getScore() != null)
                {
                    classSSum = classSSum.add(sc.getScore());
                    classSN++;
                }
                if (!memberIds.contains(en.getKey()))
                {
                    continue;
                }
                if (sc.getScore() != null)
                {
                    sSum = sSum.add(sc.getScore());
                    sN++;
                }
                if (sc.getSchoolRank() != null)
                {
                    rSum = rSum.add(BigDecimal.valueOf(sc.getSchoolRank().intValue()));
                    rN++;
                }
            }
            Map<String, Object> point = new LinkedHashMap<String, Object>();
            point.put("examId", e.getExamId());
            point.put("examName", e.getExamName());
            point.put("examDate", e.getExamDate());
            point.put("scoredCount", Integer.valueOf(sN));
            point.put("avgScore", sN > 0 ? sSum.divide(BigDecimal.valueOf(sN), 1, RoundingMode.HALF_UP) : null);
            point.put("avgRank", rN > 0 ? rSum.divide(BigDecimal.valueOf(rN), 1, RoundingMode.HALF_UP) : null);
            point.put("classAvgScore", classSN > 0 ? classSSum.divide(BigDecimal.valueOf(classSN), 1, RoundingMode.HALF_UP) : null);
            trend.add(point);
        }

        Map<String, Object> out = new LinkedHashMap<String, Object>();
        out.put("groupId", group.getGroupId());
        out.put("groupName", group.getGroupName());
        out.put("deptId", group.getDeptId());
        out.put("deptName", group.getDeptName());
        out.put("subjectId", resolveSubjectId);
        out.put("subjectName", subjectName);
        out.put("metric", metric);
        out.put("memberCount", Integer.valueOf(members.size()));
        out.put("examId", focusExam == null ? null : focusExam.getExamId());
        out.put("examName", focusExam == null ? null : focusExam.getExamName());
        out.put("examDate", focusExam == null ? null : focusExam.getExamDate());
        out.put("prevExamId", prevExam == null ? null : prevExam.getExamId());
        out.put("prevExamName", prevExam == null ? null : prevExam.getExamName());
        out.put("avgScore", focusScoreN > 0 ? focusScoreSum.divide(BigDecimal.valueOf(focusScoreN), 1, RoundingMode.HALF_UP) : null);
        out.put("avgRank", focusRankN > 0 ? focusRankSum.divide(BigDecimal.valueOf(focusRankN), 1, RoundingMode.HALF_UP) : null);
        out.put("scoredCount", Integer.valueOf(Math.max(focusScoreN, focusRankN)));
        out.put("members", memberRows);
        out.put("trend", trend);
        out.put("exams", exams);

        // Group weak knowledge (semester window; independent of focus exam)
        Date weakFrom = windowHelper == null ? null : windowHelper.resolveExamDateFrom("semester");
        List<Map<String, Object>> weakTop = Collections.emptyList();
        if (!memberIds.isEmpty() && knowledgeStatQueryService != null)
        {
            weakTop = knowledgeStatQueryService.groupWeakTop(group.getDeptId(), memberIds, resolveSubjectId, 10,
                weakFrom, null);
        }
        out.put("weakTop", weakTop);
        out.put("weakWindow", "semester");
        return out;
    }

    @Override
    public void exportGroupWeak(Long groupId, Long subjectId, String format, HttpServletResponse response)
    {
        SpasStudyGroup group = requireGroup(groupId);
        accessService.checkDeptAccess(group.getDeptId());
        Long sid = subjectId != null ? subjectId : group.getSubjectId();
        Map<String, Object> payload = buildWeakExportPayload(group.getDeptId(), sid,
            Collections.singletonList(group));
        writeWeakExport(payload, format, response,
            "group_weak_" + (group.getGroupName() == null ? groupId : group.getGroupName()));
    }

    @Override
    public void exportDeptGroupsWeak(Long deptId, Long subjectId, String format, HttpServletResponse response)
    {
        if (deptId == null)
        {
            throw new ServiceException("请选择班级");
        }
        accessService.checkDeptAccess(deptId);
        SpasStudyGroup query = new SpasStudyGroup();
        query.setDeptId(deptId);
        query.setSubjectId(subjectId);
        query.setStatus("0");
        List<SpasStudyGroup> groups = selectSpasStudyGroupList(query);
        if (groups == null)
        {
            groups = Collections.emptyList();
        }
        Map<String, Object> payload = buildWeakExportPayload(deptId, subjectId, groups);
        writeWeakExport(payload, format, response, "class_groups_weak_" + deptId);
    }

    private Map<String, Object> buildWeakExportPayload(Long deptId, Long subjectId, List<SpasStudyGroup> groups)
    {
        Date weakFrom = windowHelper == null ? null : windowHelper.resolveExamDateFrom("semester");
        String subjectName = null;
        if (subjectId != null)
        {
            SpasSubject sub = subjectMapper.selectSpasSubjectById(subjectId);
            subjectName = sub == null ? null : sub.getSubjectName();
        }
        String deptName = null;
        List<Map<String, Object>> groupBlocks = new ArrayList<Map<String, Object>>();
        List<SpasGroupWeakExportRow> excelRows = new ArrayList<SpasGroupWeakExportRow>();

        for (SpasStudyGroup g : groups == null ? Collections.<SpasStudyGroup>emptyList() : groups)
        {
            if (g == null || g.getGroupId() == null)
            {
                continue;
            }
            if (deptName == null)
            {
                deptName = g.getDeptName();
            }
            Long sid = subjectId != null ? subjectId : g.getSubjectId();
            String rowSubjectName = subjectName;
            if (rowSubjectName == null && sid != null)
            {
                SpasSubject sub = subjectMapper.selectSpasSubjectById(sid);
                rowSubjectName = sub == null ? null : sub.getSubjectName();
            }
            List<SpasStudyGroupMember> members = groupMapper.selectActiveMembers(g.getGroupId());
            if (members == null)
            {
                members = Collections.emptyList();
            }
            List<Long> memberIds = new ArrayList<Long>();
            String leaderName = g.getLeaderStudentName();
            for (SpasStudyGroupMember m : members)
            {
                if (m.getStudentId() != null)
                {
                    memberIds.add(m.getStudentId());
                }
                if (leaderName == null && "1".equals(m.getRoleInGroup()))
                {
                    leaderName = m.getStudentName();
                }
            }
            List<Map<String, Object>> weakTop = Collections.emptyList();
            if (!memberIds.isEmpty() && knowledgeStatQueryService != null)
            {
                weakTop = knowledgeStatQueryService.groupWeakTop(deptId, memberIds, sid, 15, weakFrom, null);
            }
            Map<String, Object> block = new LinkedHashMap<String, Object>();
            block.put("groupId", g.getGroupId());
            block.put("groupName", g.getGroupName());
            block.put("memberCount", Integer.valueOf(members.size()));
            block.put("leaderName", leaderName);
            block.put("weakTop", weakTop);
            groupBlocks.add(block);

            for (Map<String, Object> w : weakTop)
            {
                SpasGroupWeakExportRow row = new SpasGroupWeakExportRow();
                row.setGroupName(g.getGroupName());
                row.setSubjectName(rowSubjectName == null ? "不限/总分" : rowSubjectName);
                Object kn = w.get("knowledgeName");
                if (kn == null)
                {
                    kn = w.get("name");
                }
                row.setKnowledgeName(kn == null ? "-" : String.valueOf(kn));
                row.setGroupRatePct(toPct(w.get("rate")));
                row.setClassRatePct(toPct(w.get("classAvgRate")));
                Object wn = w.get("weakStudentCount");
                Object sn = w.get("studentCount");
                row.setWeakCountLabel(String.valueOf(wn == null ? 0 : wn) + "/" + String.valueOf(sn == null ? 0 : sn));
                Object names = w.get("weakStudentNames");
                if (names instanceof List)
                {
                    StringBuilder sb = new StringBuilder();
                    for (Object n : (List<?>) names)
                    {
                        if (n == null)
                        {
                            continue;
                        }
                        if (sb.length() > 0)
                        {
                            sb.append("、");
                        }
                        sb.append(String.valueOf(n));
                    }
                    row.setWeakStudentNames(sb.length() == 0 ? "-" : sb.toString());
                }
                else
                {
                    row.setWeakStudentNames(names == null ? "-" : String.valueOf(names));
                }
                Object formalN = w.get("formalWeakStudentCount");
                if (formalN instanceof Number)
                {
                    row.setFormalWeakStudentCount(Integer.valueOf(((Number) formalN).intValue()));
                }
                else
                {
                    row.setFormalWeakStudentCount(Integer.valueOf(0));
                }
                row.setJudgeLabel(judgeLabel(w));
                Object att = w.get("attemptCount");
                if (att instanceof Number)
                {
                    row.setAttemptCount(Integer.valueOf(((Number) att).intValue()));
                }
                excelRows.add(row);
            }
        }

        Map<String, Object> payload = new LinkedHashMap<String, Object>();
        payload.put("title", "小组薄弱知识点");
        payload.put("deptId", deptId);
        payload.put("deptName", deptName == null ? String.valueOf(deptId) : deptName);
        payload.put("subjectId", subjectId);
        payload.put("subjectName", subjectName == null ? "不限/总分" : subjectName);
        payload.put("weakWindow", "本学期");
        payload.put("generatedAt", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        payload.put("groups", groupBlocks);
        payload.put("excelRows", excelRows);
        return payload;
    }

    @SuppressWarnings("unchecked")
    private void writeWeakExport(Map<String, Object> payload, String format, HttpServletResponse response, String baseName)
    {
        String fmt = format == null ? "xlsx" : format.trim().toLowerCase();
        String safeBase = sanitizeFileName(baseName);
        try
        {
            if ("pdf".equals(fmt))
            {
                response.setContentType("application/pdf");
                FileUtils.setAttachmentResponseHeader(response, safeBase + ".pdf");
                SpasReportPdfWriter.writeGroupWeak(response.getOutputStream(), payload);
                response.getOutputStream().flush();
                return;
            }
            if ("xlsx".equals(fmt) || "excel".equals(fmt) || "xls".equals(fmt))
            {
                List<SpasGroupWeakExportRow> rows = (List<SpasGroupWeakExportRow>) payload.get("excelRows");
                if (rows == null)
                {
                    rows = Collections.emptyList();
                }
                // Prefer annotated ExcelUtil for consistent styling
                ExcelUtil<SpasGroupWeakExportRow> util = new ExcelUtil<SpasGroupWeakExportRow>(SpasGroupWeakExportRow.class);
                util.exportExcel(response, rows, "小组薄弱知识点");
                return;
            }
            throw new ServiceException("不支持的导出格式，请使用 pdf 或 xlsx");
        }
        catch (ServiceException e)
        {
            throw e;
        }
        catch (Exception e)
        {
            throw new ServiceException("导出失败：" + e.getMessage());
        }
    }

    private static BigDecimal toPct(Object rate)
    {
        if (rate == null)
        {
            return null;
        }
        try
        {
            BigDecimal bd = new BigDecimal(String.valueOf(rate));
            if (bd.compareTo(BigDecimal.ONE) <= 0)
            {
                bd = bd.multiply(BigDecimal.valueOf(100));
            }
            return bd.setScale(1, RoundingMode.HALF_UP);
        }
        catch (Exception e)
        {
            return null;
        }
    }

    private static String judgeLabel(Map<String, Object> row)
    {
        if (row == null)
        {
            return "-";
        }
        if (Boolean.TRUE.equals(row.get("formalWeak")))
        {
            return "正式薄弱";
        }
        int weakN = 0;
        try
        {
            weakN = Integer.parseInt(String.valueOf(row.get("weakStudentCount") == null ? "0" : row.get("weakStudentCount")));
        }
        catch (Exception ignored)
        {
        }
        if (weakN > 0 && Boolean.FALSE.equals(row.get("evidenceOk")))
        {
            return "样本不足";
        }
        if (weakN > 0)
        {
            return "偏低";
        }
        return "正常";
    }

    private static String sanitizeFileName(String name)
    {
        if (name == null || name.trim().isEmpty())
        {
            return "group_weak";
        }
        return name.replaceAll("[\\\\/:*?\"<>|\\s]+", "_");
    }

    @Override
    @Transactional
    public int insertSpasStudyGroup(SpasStudyGroup group)
    {
        accessService.assertCanWrite();
        if (group.getDeptId() == null)
        {
            throw new ServiceException("请选择班级");
        }
        if (group.getGroupName() == null || group.getGroupName().trim().isEmpty())
        {
            throw new ServiceException("请填写组名");
        }
        accessService.checkDeptAccess(group.getDeptId());
        group.setGroupName(group.getGroupName().trim());
        if (group.getStatus() == null)
        {
            group.setStatus("0");
        }
        if (group.getSortOrder() == null)
        {
            boolean nullSubject = group.getSubjectId() == null;
            group.setSortOrder(Integer.valueOf(groupMapper.maxSortOrder(group.getDeptId(), group.getSubjectId(), nullSubject) + 1));
        }
        int rows = groupMapper.insertSpasStudyGroup(group);
        if (group.getStudentIds() != null && group.getStudentIds().length > 0)
        {
            replaceMembers(group.getGroupId(), group.getStudentIds(), group.getLeaderStudentId());
        }
        else if (group.getLeaderStudentId() != null)
        {
            replaceMembers(group.getGroupId(), new Long[] { group.getLeaderStudentId() }, group.getLeaderStudentId());
        }
        return rows;
    }

    @Override
    @Transactional
    public int updateSpasStudyGroup(SpasStudyGroup group)
    {
        accessService.assertCanWrite();
        SpasStudyGroup db = requireGroup(group.getGroupId());
        accessService.checkDeptAccess(db.getDeptId());
        group.setDeptId(db.getDeptId());
        if (group.getGroupName() != null)
        {
            group.setGroupName(group.getGroupName().trim());
        }
        // allow clearing subject (通用组)
        if (group.getSubjectId() == null && group.getParams() != null
            && Boolean.TRUE.equals(group.getParams().get("clearSubject")))
        {
            // mapper handles clearSubject
        }
        else if (group.getSubjectId() == null)
        {
            // keep existing subject unless explicit clear
            group.setSubjectId(db.getSubjectId());
        }
        int rows = groupMapper.updateSpasStudyGroup(group);
        if (group.getStudentIds() != null)
        {
            Long leader = group.getLeaderStudentId() != null ? group.getLeaderStudentId() : db.getLeaderStudentId();
            if (group.getStudentIds().length == 0)
            {
                leader = null;
            }
            replaceMembers(group.getGroupId(), group.getStudentIds(), leader);
        }
        else if (group.getLeaderStudentId() != null)
        {
            applyLeaderRole(group.getGroupId(), group.getLeaderStudentId(), db.getDeptId(),
                group.getSubjectId() != null ? group.getSubjectId() : db.getSubjectId());
            SpasStudyGroup patch = new SpasStudyGroup();
            patch.setGroupId(group.getGroupId());
            patch.setLeaderStudentId(group.getLeaderStudentId());
            groupMapper.updateSpasStudyGroup(patch);
        }
        return rows;
    }

    @Override
    @Transactional
    public int deleteSpasStudyGroupByIds(Long[] groupIds)
    {
        accessService.assertCanWrite();
        if (groupIds == null || groupIds.length == 0)
        {
            return 0;
        }
        for (Long id : groupIds)
        {
            SpasStudyGroup group = requireGroup(id);
            accessService.checkDeptAccess(group.getDeptId());
            groupMapper.markAllMembersLeft(id);
        }
        return groupMapper.softDisableGroups(groupIds);
    }

    @Override
    @Transactional
    public int replaceMembers(Long groupId, Long[] studentIds, Long leaderStudentId)
    {
        accessService.assertCanWrite();
        SpasStudyGroup group = requireGroup(groupId);
        accessService.checkDeptAccess(group.getDeptId());
        Set<Long> ids = new LinkedHashSet<Long>();
        if (studentIds != null)
        {
            ids.addAll(Arrays.asList(studentIds));
        }
        ids.remove(null);
        if (leaderStudentId != null)
        {
            ids.add(leaderStudentId);
        }
        List<Long> keep = new ArrayList<Long>(ids);
        groupMapper.markMembersLeft(groupId, keep);
        for (Long studentId : keep)
        {
            SpasStudent student = studentMapper.selectSpasStudentById(studentId);
            if (student == null || "2".equals(student.getDelFlag()))
            {
                throw new ServiceException("学生不存在");
            }
            if (student.getDeptId() == null || !student.getDeptId().equals(group.getDeptId()))
            {
                throw new ServiceException("只能选择本班学生：" + student.getStudentName());
            }
            int elsewhere = groupMapper.countActiveMembershipElsewhere(studentId, group.getDeptId(),
                group.getSubjectId(), groupId);
            if (elsewhere > 0)
            {
                throw new ServiceException(student.getStudentName() + " 已在同班同学科的其他组中");
            }
            SpasStudyGroupMember member = new SpasStudyGroupMember();
            member.setGroupId(groupId);
            member.setStudentId(studentId);
            member.setRoleInGroup(studentId.equals(leaderStudentId) ? "1" : "0");
            groupMapper.upsertMember(member);
        }
        if (leaderStudentId != null && !ids.contains(leaderStudentId))
        {
            throw new ServiceException("组长必须是组内成员");
        }
        SpasStudyGroup patch = new SpasStudyGroup();
        patch.setGroupId(groupId);
        patch.setLeaderStudentId(leaderStudentId);
        if (leaderStudentId == null)
        {
            patch.getParams().put("clearLeader", Boolean.TRUE);
        }
        return groupMapper.updateSpasStudyGroup(patch);
    }

    @Override
    public List<SpasStudent> selectUnassignedStudents(Long deptId, Long subjectId)
    {
        if (deptId == null)
        {
            throw new ServiceException("请选择班级");
        }
        accessService.checkDeptAccess(deptId);
        return groupMapper.selectUnassignedStudents(deptId, subjectId);
    }

    @Override
    public List<SpasStudyGroupMember> selectActiveMembers(Long groupId)
    {
        SpasStudyGroup group = requireGroup(groupId);
        accessService.checkDeptAccess(group.getDeptId());
        return groupMapper.selectActiveMembers(groupId);
    }

    @Override
    public SpasStudyGroup selectActiveGroupOfStudent(Long studentId, Long deptId, Long subjectId)
    {
        return groupMapper.selectActiveGroupOfStudent(studentId, deptId, subjectId);
    }

    @Override
    @Transactional
    public Map<String, Object> smartAssign(Long deptId, Long subjectId, Integer groupSize, String mode, Long examId,
        String operName)
    {
        accessService.assertCanWrite();
        if (deptId == null)
        {
            throw new ServiceException("请选择班级");
        }
        accessService.checkDeptAccess(deptId);
        int size = groupSize == null ? 5 : groupSize.intValue();
        if (size < 3 || size > 8)
        {
            throw new ServiceException("每组人数请在 3～8 之间（建议 4～6）");
        }
        boolean rebuild = "rebuild".equalsIgnoreCase(mode);
        boolean nullSubject = subjectId == null;

        int dissolved = 0;
        if (rebuild)
        {
            List<Long> oldIds = groupMapper.selectActiveGroupIdsByDeptSubject(deptId, subjectId, nullSubject);
            if (oldIds != null)
            {
                for (Long gid : oldIds)
                {
                    groupMapper.markAllMembersLeft(gid);
                    dissolved++;
                }
            }
            groupMapper.softDisableByDeptSubject(deptId, subjectId, nullSubject);
        }

        List<SpasStudent> pool;
        if (rebuild)
        {
            SpasStudent q = new SpasStudent();
            q.setDeptId(deptId);
            q.setStatus("0");
            pool = studentMapper.selectSpasStudentList(q);
            if (pool == null)
            {
                pool = new ArrayList<SpasStudent>();
            }
            List<SpasStudent> exact = new ArrayList<SpasStudent>();
            for (SpasStudent s : pool)
            {
                if (s.getDeptId() != null && s.getDeptId().equals(deptId) && !"2".equals(s.getDelFlag()))
                {
                    exact.add(s);
                }
            }
            pool = exact;
        }
        else
        {
            pool = groupMapper.selectUnassignedStudents(deptId, subjectId);
            if (pool == null)
            {
                pool = new ArrayList<SpasStudent>();
            }
        }
        if (pool.isEmpty())
        {
            throw new ServiceException(rebuild ? "本班暂无在读学生可分组" : "没有未入组学生，可改用「重新分组」");
        }

        AbilityContext ability = resolveAbility(deptId, subjectId, examId, pool);
        List<List<SpasStudent>> chunks = balanceByScoreAndGender(pool, ability.abilityByStudent, size);
        refineScoreBalance(chunks, ability.abilityByStudent);
        refineGenderBalance(chunks, ability.abilityByStudent);

        int sortBase = groupMapper.maxSortOrder(deptId, subjectId, nullSubject);
        List<Map<String, Object>> created = new ArrayList<Map<String, Object>>();
        int idx = 0;
        for (List<SpasStudent> chunk : chunks)
        {
            idx++;
            SpasStudyGroup group = new SpasStudyGroup();
            group.setDeptId(deptId);
            group.setSubjectId(subjectId);
            group.setGroupName(chineseGroupName(idx));
            group.setStatus("0");
            group.setSortOrder(Integer.valueOf(sortBase + idx));
            group.setCreateBy(StringUtils.isEmpty(operName) ? "system" : operName);
            group.setRemark(ability.usedScore
                ? ("智能分组·成绩性别均衡/" + (ability.examName == null ? "" : ability.examName))
                : "智能分组·性别均衡(无成绩)");
            Long leaderId = pickLeader(chunk, ability.abilityByStudent);
            group.setLeaderStudentId(leaderId);
            groupMapper.insertSpasStudyGroup(group);
            Long[] ids = new Long[chunk.size()];
            for (int i = 0; i < chunk.size(); i++)
            {
                ids[i] = chunk.get(i).getStudentId();
            }
            replaceMembers(group.getGroupId(), ids, leaderId);
            Map<String, Object> row = new LinkedHashMap<String, Object>();
            row.put("groupId", group.getGroupId());
            row.put("groupName", group.getGroupName());
            row.put("memberCount", Integer.valueOf(chunk.size()));
            row.put("leaderStudentId", leaderId);
            String leaderName = null;
            for (SpasStudent s : chunk)
            {
                if (s.getStudentId().equals(leaderId))
                {
                    leaderName = s.getStudentName();
                    break;
                }
            }
            row.put("leaderStudentName", leaderName);
            row.put("avgAbility", round2(avgAbility(chunk, ability.abilityByStudent)));
            created.add(row);
        }

        Map<String, Object> result = new LinkedHashMap<String, Object>();
        result.put("mode", rebuild ? "rebuild" : "unassigned");
        result.put("groupSize", Integer.valueOf(size));
        result.put("studentCount", Integer.valueOf(pool.size()));
        result.put("createdCount", Integer.valueOf(created.size()));
        result.put("dissolvedCount", Integer.valueOf(dissolved));
        result.put("scoreBalanced", Boolean.valueOf(ability.usedScore));
        result.put("scoreMetric", ability.metric);
        result.put("scoredStudentCount", Integer.valueOf(ability.scoredCount));
        result.put("examId", ability.examId);
        result.put("examName", ability.examName);
        result.put("groups", created);
        return result;
    }

    /**
     * Snake males and females separately by score so both genders spread across groups,
     * while score tiers stay mixed. Ability must be higher=better.
     */
    private List<List<SpasStudent>> balanceByScoreAndGender(List<SpasStudent> pool,
        final Map<Long, Double> ability, int size)
    {
        int n = pool.size();
        int groupCount = (n + size - 1) / size;
        if (groupCount < 1)
        {
            groupCount = 1;
        }
        if (groupCount >= 2 && n - (groupCount - 1) * size == 1 && size >= 4)
        {
            groupCount--;
        }

        List<List<SpasStudent>> chunks = new ArrayList<List<SpasStudent>>(groupCount);
        for (int g = 0; g < groupCount; g++)
        {
            chunks.add(new ArrayList<SpasStudent>());
        }

        List<SpasStudent> males = new ArrayList<SpasStudent>();
        List<SpasStudent> females = new ArrayList<SpasStudent>();
        List<SpasStudent> other = new ArrayList<SpasStudent>();
        for (SpasStudent s : pool)
        {
            if ("0".equals(s.getGender()))
            {
                males.add(s);
            }
            else if ("1".equals(s.getGender()))
            {
                females.add(s);
            }
            else
            {
                other.add(s);
            }
        }
        sortByAbilityDesc(males, ability);
        sortByAbilityDesc(females, ability);
        sortByAbilityDesc(other, ability);

        // snake each gender so no group is starved of girls/boys when pool allows
        snakeIntoGroups(chunks, males, groupCount);
        snakeIntoGroups(chunks, females, groupCount);
        snakeIntoGroups(chunks, other, groupCount);

        // rebalance headcount to differ by at most 1 (score refine keeps 1-for-1)
        evenGroupSizes(chunks);
        return chunks;
    }

    private void sortByAbilityDesc(List<SpasStudent> list, final Map<Long, Double> ability)
    {
        Collections.sort(list, new Comparator<SpasStudent>()
        {
            @Override
            public int compare(SpasStudent a, SpasStudent b)
            {
                double aa = abilityValueFinite(a.getStudentId(), ability);
                double bb = abilityValueFinite(b.getStudentId(), ability);
                boolean aMiss = Double.isNaN(aa);
                boolean bMiss = Double.isNaN(bb);
                if (aMiss && bMiss)
                {
                    return compareStudentNo(a, b);
                }
                if (aMiss)
                {
                    return 1;
                }
                if (bMiss)
                {
                    return -1;
                }
                int c = Double.compare(bb, aa);
                return c != 0 ? c : compareStudentNo(a, b);
            }
        });
    }

    private void snakeIntoGroups(List<List<SpasStudent>> chunks, List<SpasStudent> ordered, int groupCount)
    {
        if (ordered == null || ordered.isEmpty() || groupCount < 1)
        {
            return;
        }
        for (int i = 0; i < ordered.size(); i++)
        {
            int row = i / groupCount;
            int col = i % groupCount;
            if (row % 2 == 1)
            {
                col = groupCount - 1 - col;
            }
            chunks.get(col).add(ordered.get(i));
        }
    }

    /** Move students from oversized to undersized groups (prefer similar ability). */
    private void evenGroupSizes(List<List<SpasStudent>> chunks)
    {
        if (chunks == null || chunks.size() < 2)
        {
            return;
        }
        int total = 0;
        for (List<SpasStudent> c : chunks)
        {
            total += c.size();
        }
        int base = total / chunks.size();
        int rem = total % chunks.size();
        int[] targets = new int[chunks.size()];
        for (int g = 0; g < chunks.size(); g++)
        {
            targets[g] = base + (g < rem ? 1 : 0);
        }
        for (int guard = 0; guard < total; guard++)
        {
            int from = -1;
            int to = -1;
            for (int g = 0; g < chunks.size(); g++)
            {
                if (chunks.get(g).size() > targets[g] && (from < 0 || chunks.get(g).size() > chunks.get(from).size()))
                {
                    from = g;
                }
                if (chunks.get(g).size() < targets[g] && (to < 0 || chunks.get(g).size() < chunks.get(to).size()))
                {
                    to = g;
                }
            }
            if (from < 0 || to < 0)
            {
                break;
            }
            // move last member (already score-sorted within gender drafts)
            List<SpasStudent> src = chunks.get(from);
            chunks.get(to).add(src.remove(src.size() - 1));
        }
    }

    /**
     * Pairwise swaps to shrink max-min group average gap (prefer same-gender swaps).
     */
    private void refineScoreBalance(List<List<SpasStudent>> chunks, Map<Long, Double> ability)
    {
        if (chunks == null || chunks.size() < 2 || ability == null || ability.isEmpty())
        {
            return;
        }
        for (int pass = 0; pass < 40; pass++)
        {
            int hi = -1;
            int lo = -1;
            double hiAvg = Double.NEGATIVE_INFINITY;
            double loAvg = Double.POSITIVE_INFINITY;
            for (int g = 0; g < chunks.size(); g++)
            {
                double avg = avgAbilityFinite(chunks.get(g), ability);
                if (avg > hiAvg)
                {
                    hiAvg = avg;
                    hi = g;
                }
                if (avg < loAvg)
                {
                    loAvg = avg;
                    lo = g;
                }
            }
            if (hi < 0 || lo < 0 || hi == lo)
            {
                break;
            }
            double gap = hiAvg - loAvg;
            if (gap < 0.3)
            {
                break;
            }
            if (!tryScoreSwap(chunks.get(hi), chunks.get(lo), ability, gap))
            {
                boolean any = false;
                for (int i = 0; i < chunks.size() && !any; i++)
                {
                    for (int j = i + 1; j < chunks.size(); j++)
                    {
                        double ai = avgAbilityFinite(chunks.get(i), ability);
                        double aj = avgAbilityFinite(chunks.get(j), ability);
                        if (Math.abs(ai - aj) < 0.3)
                        {
                            continue;
                        }
                        List<SpasStudent> high = ai >= aj ? chunks.get(i) : chunks.get(j);
                        List<SpasStudent> low = ai >= aj ? chunks.get(j) : chunks.get(i);
                        if (tryScoreSwap(high, low, ability, Math.abs(ai - aj)))
                        {
                            any = true;
                            break;
                        }
                    }
                }
                if (!any)
                {
                    break;
                }
            }
        }
    }

    /**
     * Move strength out of the high-avg group: swap a stronger student from high
     * with a weaker student from low, so both averages converge.
     */
    private boolean tryScoreSwap(List<SpasStudent> high, List<SpasStudent> low, Map<Long, Double> ability,
        double gapBefore)
    {
        int bestHi = -1;
        int bestLo = -1;
        double bestGap = gapBefore;
        boolean bestSameGender = false;
        double highAvg = avgAbilityFinite(high, ability);
        double lowAvg = avgAbilityFinite(low, ability);
        int nH = Math.max(1, countScored(high, ability));
        int nL = Math.max(1, countScored(low, ability));
        for (int i = 0; i < high.size(); i++)
        {
            double hiVal = abilityValueFinite(high.get(i).getStudentId(), ability);
            if (Double.isNaN(hiVal))
            {
                continue;
            }
            for (int j = 0; j < low.size(); j++)
            {
                double loVal = abilityValueFinite(low.get(j).getStudentId(), ability);
                // need stronger student leaving high, weaker leaving low
                if (Double.isNaN(loVal) || hiVal <= loVal)
                {
                    continue;
                }
                // keep gender mix: only same-gender swaps during score refine
                if (!sameGender(high.get(i), low.get(j)))
                {
                    continue;
                }
                double newHigh = (highAvg * nH - hiVal + loVal) / nH;
                double newLow = (lowAvg * nL - loVal + hiVal) / nL;
                double newGap = Math.abs(newHigh - newLow);
                if (newGap >= bestGap - 1e-9)
                {
                    continue;
                }
                if (bestHi < 0 || newGap < bestGap - 1e-9)
                {
                    bestGap = newGap;
                    bestHi = i;
                    bestLo = j;
                    bestSameGender = true;
                }
            }
        }
        if (bestHi < 0)
        {
            return false;
        }
        SpasStudent tmp = high.get(bestHi);
        high.set(bestHi, low.get(bestLo));
        low.set(bestLo, tmp);
        return true;
    }

    private static boolean sameGender(SpasStudent a, SpasStudent b)
    {
        String ga = a.getGender();
        String gb = b.getGender();
        return ga != null && ga.equals(gb);
    }

    private static int countScored(List<SpasStudent> list, Map<Long, Double> ability)
    {
        int n = 0;
        for (SpasStudent s : list)
        {
            if (!Double.isNaN(abilityValueFinite(s.getStudentId(), ability)))
            {
                n++;
            }
        }
        return n == 0 ? list.size() : n;
    }

    private static double avgAbilityFinite(List<SpasStudent> chunk, Map<Long, Double> ability)
    {
        double sum = 0;
        int n = 0;
        for (SpasStudent s : chunk)
        {
            double v = abilityValueFinite(s.getStudentId(), ability);
            if (!Double.isNaN(v))
            {
                sum += v;
                n++;
            }
        }
        return n == 0 ? 0 : sum / n;
    }

    private static double abilityValueFinite(Long studentId, Map<Long, Double> ability)
    {
        if (studentId == null || ability == null)
        {
            return Double.NaN;
        }
        Double v = ability.get(studentId);
        if (v == null || v.isInfinite() || v.isNaN())
        {
            return Double.NaN;
        }
        return v.doubleValue();
    }

    /**
     * Fix single-gender groups first, then reduce male/female skew.
     * Does not require the donor group to be "female-heavy" (class may be male-majority).
     */
    private void refineGenderBalance(List<List<SpasStudent>> chunks, Map<Long, Double> ability)
    {
        if (chunks == null || chunks.size() < 2)
        {
            return;
        }
        for (int pass = 0; pass < 8; pass++)
        {
            if (!fixZeroGenderGroups(chunks, ability))
            {
                break;
            }
        }
        for (int pass = 0; pass < 6; pass++)
        {
            boolean swapped = false;
            for (int i = 0; i < chunks.size(); i++)
            {
                for (int j = i + 1; j < chunks.size(); j++)
                {
                    if (tryGenderSwap(chunks.get(i), chunks.get(j), ability))
                    {
                        swapped = true;
                    }
                }
            }
            if (!swapped)
            {
                break;
            }
        }
    }

    /** Ensure no group is all-male or all-female when the other gender exists elsewhere. */
    private boolean fixZeroGenderGroups(List<List<SpasStudent>> chunks, Map<Long, Double> ability)
    {
        boolean any = false;
        for (int i = 0; i < chunks.size(); i++)
        {
            List<SpasStudent> g = chunks.get(i);
            int males = countGender(g, "0");
            int females = countGender(g, "1");
            if (g.isEmpty() || (males > 0 && females > 0))
            {
                continue;
            }
            // all male → need a female from a group that can spare one
            if (females == 0 && males > 0)
            {
                if (pullOppositeGender(g, chunks, i, "1", "0", ability))
                {
                    any = true;
                }
            }
            else if (males == 0 && females > 0)
            {
                if (pullOppositeGender(g, chunks, i, "0", "1", ability))
                {
                    any = true;
                }
            }
        }
        return any;
    }

    /**
     * Swap: take needGender from a donor group (that has ≥2 of that gender, or ≥1 if only option)
     * and give giveGender from the needy group.
     */
    private boolean pullOppositeGender(List<SpasStudent> needy, List<List<SpasStudent>> chunks, int needyIdx,
        String needGender, String giveGender, Map<Long, Double> ability)
    {
        int bestDonor = -1;
        int bestNeedIdx = -1;
        int bestGiveIdx = -1;
        double bestDiff = Double.MAX_VALUE;
        double needyAvg = avgAbilityFinite(needy, ability);
        for (int j = 0; j < chunks.size(); j++)
        {
            if (j == needyIdx)
            {
                continue;
            }
            List<SpasStudent> donor = chunks.get(j);
            int donorHas = countGender(donor, needGender);
            if (donorHas < 1)
            {
                continue;
            }
            // prefer donors that keep at least one of needGender after swap
            boolean canSpare = donorHas >= 2;
            double donorAvg = avgAbilityFinite(donor, ability);
            double gapBefore = Math.abs(needyAvg - donorAvg);
            for (int gi = 0; gi < needy.size(); gi++)
            {
                if (!giveGender.equals(needy.get(gi).getGender()))
                {
                    continue;
                }
                double va = abilityValueFinite(needy.get(gi).getStudentId(), ability);
                for (int di = 0; di < donor.size(); di++)
                {
                    if (!needGender.equals(donor.get(di).getGender()))
                    {
                        continue;
                    }
                    double vb = abilityValueFinite(donor.get(di).getStudentId(), ability);
                    if (Double.isNaN(va) || Double.isNaN(vb))
                    {
                        continue;
                    }
                    double da = Math.abs(va - vb);
                    int nA = Math.max(1, countScored(needy, ability));
                    int nB = Math.max(1, countScored(donor, ability));
                    double newNeedy = (needyAvg * nA - va + vb) / nA;
                    double newDonor = (donorAvg * nB - vb + va) / nB;
                    if (Math.abs(newNeedy - newDonor) > gapBefore + 2.0)
                    {
                        continue;
                    }
                    // prefer spareable donors, then closest ability
                    double score = da + (canSpare ? 0 : 1000);
                    if (score < bestDiff)
                    {
                        bestDiff = score;
                        bestDonor = j;
                        bestGiveIdx = gi;
                        bestNeedIdx = di;
                    }
                }
            }
        }
        if (bestDonor < 0)
        {
            return false;
        }
        List<SpasStudent> donor = chunks.get(bestDonor);
        SpasStudent tmp = needy.get(bestGiveIdx);
        needy.set(bestGiveIdx, donor.get(bestNeedIdx));
        donor.set(bestNeedIdx, tmp);
        return true;
    }

    private boolean tryGenderSwap(List<SpasStudent> a, List<SpasStudent> b, Map<Long, Double> ability)
    {
        int ma = countGender(a, "0");
        int fa = countGender(a, "1");
        int mb = countGender(b, "0");
        int fb = countGender(b, "1");
        int imbalanceBefore = Math.abs(ma - fa) + Math.abs(mb - fb);
        if (imbalanceBefore <= 2)
        {
            return false;
        }
        // A gives its surplus gender, B gives the other — works even when both are male-leaning
        int skewA = ma - fa;
        int skewB = mb - fb;
        if (skewA == 0 && skewB == 0)
        {
            return false;
        }
        // A should give male if skewA > skewB (more male-heavy than B)
        boolean aGivesMale = skewA > skewB;
        String fromAGender = aGivesMale ? "0" : "1";
        String fromBGender = aGivesMale ? "1" : "0";
        if (countGender(a, fromAGender) < 1 || countGender(b, fromBGender) < 1)
        {
            return false;
        }
        double avgA = avgAbilityFinite(a, ability);
        double avgB = avgAbilityFinite(b, ability);
        double gapBefore = Math.abs(avgA - avgB);
        int bestAi = -1;
        int bestBi = -1;
        double bestAbilityDiff = Double.MAX_VALUE;
        for (int ai = 0; ai < a.size(); ai++)
        {
            if (!fromAGender.equals(a.get(ai).getGender()))
            {
                continue;
            }
            double va = abilityValueFinite(a.get(ai).getStudentId(), ability);
            for (int bi = 0; bi < b.size(); bi++)
            {
                if (!fromBGender.equals(b.get(bi).getGender()))
                {
                    continue;
                }
                double vb = abilityValueFinite(b.get(bi).getStudentId(), ability);
                if (Double.isNaN(va) || Double.isNaN(vb))
                {
                    continue;
                }
                double da = Math.abs(va - vb);
                if (da > 20.0 && da > Math.max(1.0, Math.abs(va)) * 0.12)
                {
                    continue;
                }
                int nA = Math.max(1, countScored(a, ability));
                int nB = Math.max(1, countScored(b, ability));
                double newAvgA = (avgA * nA - va + vb) / nA;
                double newAvgB = (avgB * nB - vb + va) / nB;
                if (Math.abs(newAvgA - newAvgB) > gapBefore + 1.0)
                {
                    continue;
                }
                if (da < bestAbilityDiff)
                {
                    bestAbilityDiff = da;
                    bestAi = ai;
                    bestBi = bi;
                }
            }
        }
        if (bestAi < 0 || bestBi < 0)
        {
            return false;
        }
        SpasStudent tmp = a.get(bestAi);
        a.set(bestAi, b.get(bestBi));
        b.set(bestBi, tmp);
        int imbalanceAfter = Math.abs(countGender(a, "0") - countGender(a, "1"))
            + Math.abs(countGender(b, "0") - countGender(b, "1"));
        if (imbalanceAfter >= imbalanceBefore)
        {
            tmp = a.get(bestAi);
            a.set(bestAi, b.get(bestBi));
            b.set(bestBi, tmp);
            return false;
        }
        return true;
    }

    private int countGender(List<SpasStudent> list, String gender)
    {
        int n = 0;
        for (SpasStudent s : list)
        {
            if (gender.equals(s.getGender()))
            {
                n++;
            }
        }
        return n;
    }

    private AbilityContext resolveAbility(Long deptId, Long subjectId, Long examId, List<SpasStudent> pool)
    {
        AbilityContext ctx = new AbilityContext();
        ctx.abilityByStudent = new HashMap<Long, Double>();
        ctx.metric = "none";
        SpasExam exam = null;
        if (examId != null)
        {
            exam = examScoreMapper.selectSpasExamById(examId);
            if (exam == null || exam.getDeptId() == null || !exam.getDeptId().equals(deptId))
            {
                throw new ServiceException("所选考试不存在或不属于本班");
            }
        }
        else
        {
            exam = examScoreMapper.selectLatestDoneExamByDept(deptId);
        }
        if (exam == null)
        {
            return ctx;
        }
        ctx.examId = exam.getExamId();
        ctx.examName = exam.getExamName();
        List<SpasExamScore> scores = examScoreMapper.selectScoresByExamId(exam.getExamId());
        if (scores == null || scores.isEmpty())
        {
            return ctx;
        }

        String subjectName = null;
        if (subjectId != null)
        {
            SpasSubject sub = subjectMapper.selectSpasSubjectById(subjectId);
            if (sub != null)
            {
                subjectName = sub.getSubjectName();
            }
        }

        Map<Long, SpasExamScore> picked = new HashMap<Long, SpasExamScore>();
        boolean preferSubject = StringUtils.isNotEmpty(subjectName);
        for (SpasExamScore sc : scores)
        {
            if (sc.getStudentId() == null)
            {
                continue;
            }
            boolean match;
            if (preferSubject)
            {
                match = SpasExamScore.TYPE_SUBJECT.equals(sc.getScoreType())
                    && SubjectAlias.same(subjectName, sc.getSubjectName());
            }
            else
            {
                match = SpasExamScore.TYPE_TOTAL.equals(sc.getScoreType());
            }
            if (!match)
            {
                continue;
            }
            SpasExamScore old = picked.get(sc.getStudentId());
            if (old == null || betterScoreRow(sc, old))
            {
                picked.put(sc.getStudentId(), sc);
            }
        }
        // fallback to total if subject rows missing for this exam
        if (preferSubject && picked.isEmpty())
        {
            preferSubject = false;
            for (SpasExamScore sc : scores)
            {
                if (sc.getStudentId() == null || !SpasExamScore.TYPE_TOTAL.equals(sc.getScoreType()))
                {
                    continue;
                }
                SpasExamScore old = picked.get(sc.getStudentId());
                if (old == null || betterScoreRow(sc, old))
                {
                    picked.put(sc.getStudentId(), sc);
                }
            }
        }

        boolean anyRank = false;
        boolean anyScore = false;
        for (SpasExamScore sc : picked.values())
        {
            if (sc.getSchoolRank() != null)
            {
                anyRank = true;
            }
            if (sc.getScore() != null)
            {
                anyScore = true;
            }
        }
        // Prefer raw score (higher=better, works with min-avg draft). Rank only if no scores:
        // convert to positive ability = maxRank - rank + 1 so stronger students have higher values.
        if (anyScore)
        {
            ctx.metric = preferSubject ? "subjectScore" : "totalScore";
            for (Map.Entry<Long, SpasExamScore> e : picked.entrySet())
            {
                BigDecimal sc = e.getValue().getScore();
                if (sc != null)
                {
                    ctx.abilityByStudent.put(e.getKey(), Double.valueOf(sc.doubleValue()));
                    ctx.scoredCount++;
                }
            }
        }
        else if (anyRank)
        {
            int maxRank = 0;
            for (SpasExamScore sc : picked.values())
            {
                if (sc.getSchoolRank() != null && sc.getSchoolRank().intValue() > maxRank)
                {
                    maxRank = sc.getSchoolRank().intValue();
                }
            }
            ctx.metric = preferSubject ? "subjectRank" : "totalRank";
            for (Map.Entry<Long, SpasExamScore> e : picked.entrySet())
            {
                Integer rank = e.getValue().getSchoolRank();
                if (rank != null)
                {
                    ctx.abilityByStudent.put(e.getKey(), Double.valueOf(maxRank - rank.intValue() + 1));
                    ctx.scoredCount++;
                }
            }
        }
        ctx.usedScore = ctx.scoredCount > 0;
        Set<Long> poolIds = new LinkedHashSet<Long>();
        for (SpasStudent s : pool)
        {
            poolIds.add(s.getStudentId());
        }
        int inPool = 0;
        for (Long id : ctx.abilityByStudent.keySet())
        {
            if (poolIds.contains(id))
            {
                inPool++;
            }
        }
        ctx.scoredCount = inPool;
        ctx.usedScore = inPool > 0;
        return ctx;
    }

    private static boolean betterScoreRow(SpasExamScore a, SpasExamScore b)
    {
        if (a.getSchoolRank() != null && b.getSchoolRank() != null)
        {
            return a.getSchoolRank().intValue() < b.getSchoolRank().intValue();
        }
        if (a.getScore() != null && b.getScore() != null)
        {
            return a.getScore().compareTo(b.getScore()) > 0;
        }
        return a.getSchoolRank() != null || a.getScore() != null;
    }

    private Long pickLeader(List<SpasStudent> chunk, Map<Long, Double> ability)
    {
        if (chunk == null || chunk.isEmpty())
        {
            return null;
        }
        SpasStudent best = chunk.get(0);
        double bestA = abilityValue(best.getStudentId(), ability);
        for (int i = 1; i < chunk.size(); i++)
        {
            SpasStudent s = chunk.get(i);
            double a = abilityValue(s.getStudentId(), ability);
            if (a > bestA)
            {
                best = s;
                bestA = a;
            }
        }
        return best.getStudentId();
    }

    private static double abilityValue(Long studentId, Map<Long, Double> ability)
    {
        if (studentId == null || ability == null)
        {
            return Double.NEGATIVE_INFINITY;
        }
        Double v = ability.get(studentId);
        return v == null ? Double.NEGATIVE_INFINITY : v.doubleValue();
    }

    private static double avgAbility(List<SpasStudent> chunk, Map<Long, Double> ability)
    {
        double sum = 0;
        int n = 0;
        for (SpasStudent s : chunk)
        {
            Double v = ability == null ? null : ability.get(s.getStudentId());
            if (v != null && !v.isInfinite() && !v.isNaN())
            {
                sum += v.doubleValue();
                n++;
            }
        }
        return n == 0 ? 0 : sum / n;
    }

    private static Double round2(double v)
    {
        return Double.valueOf(BigDecimal.valueOf(v).setScale(2, RoundingMode.HALF_UP).doubleValue());
    }

    private static int compareStudentNo(SpasStudent a, SpasStudent b)
    {
        String na = a.getStudentNo() == null ? "" : a.getStudentNo();
        String nb = b.getStudentNo() == null ? "" : b.getStudentNo();
        int c = na.compareTo(nb);
        if (c != 0)
        {
            return c;
        }
        long ia = a.getStudentId() == null ? 0L : a.getStudentId().longValue();
        long ib = b.getStudentId() == null ? 0L : b.getStudentId().longValue();
        return Long.compare(ia, ib);
    }

    private static final class AbilityContext
    {
        Map<Long, Double> abilityByStudent;
        boolean usedScore;
        String metric;
        int scoredCount;
        Long examId;
        String examName;
    }

    private String chineseGroupName(int index)
    {
        String[] cn = new String[] {
            "一", "二", "三", "四", "五", "六", "七", "八", "九", "十",
            "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十"
        };
        if (index >= 1 && index <= cn.length)
        {
            return cn[index - 1] + "\u7ec4";
        }
        return index + "\u7ec4";
    }

    private void applyLeaderRole(Long groupId, Long leaderStudentId, Long deptId, Long subjectId)
    {
        List<SpasStudyGroupMember> members = groupMapper.selectActiveMembers(groupId);
        boolean inGroup = false;
        for (SpasStudyGroupMember m : members)
        {
            groupMapper.updateMemberRole(groupId, m.getStudentId(),
                m.getStudentId().equals(leaderStudentId) ? "1" : "0");
            if (m.getStudentId().equals(leaderStudentId))
            {
                inGroup = true;
            }
        }
        if (!inGroup)
        {
            throw new ServiceException("组长必须是组内成员");
        }
    }

    private SpasStudyGroup requireGroup(Long groupId)
    {
        if (groupId == null)
        {
            throw new ServiceException("小组不存在");
        }
        SpasStudyGroup group = groupMapper.selectSpasStudyGroupById(groupId);
        if (group == null)
        {
            throw new ServiceException("小组不存在");
        }
        return group;
    }
}
