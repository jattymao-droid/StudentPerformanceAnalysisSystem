package com.ruoyi.spas.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.alibaba.fastjson2.JSON;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.spas.analysis.KnowledgeStatQueryService;
import com.ruoyi.spas.domain.SpasCoachLog;
import com.ruoyi.spas.domain.SpasInterveneAction;
import com.ruoyi.spas.domain.SpasInterveneTask;
import com.ruoyi.spas.domain.SpasStudentKnowledgeStat;
import com.ruoyi.spas.domain.SpasWarningRecord;
import com.ruoyi.spas.mapper.SpasAnalysisMapper;
import com.ruoyi.spas.mapper.SpasCoachLogMapper;
import com.ruoyi.spas.mapper.SpasInterveneActionMapper;
import com.ruoyi.spas.mapper.SpasInterveneMapper;
import com.ruoyi.spas.mapper.SpasWarningRecordMapper;
import com.ruoyi.spas.service.ISpasErrorTagService;
import com.ruoyi.spas.service.ISpasInterveneService;
import com.ruoyi.spas.support.SpasAccessService;
import com.ruoyi.spas.support.SpasTeacherScopeService;

@Service
public class SpasInterveneServiceImpl implements ISpasInterveneService
{
    private static final Logger log = LoggerFactory.getLogger(SpasInterveneServiceImpl.class);

    @Autowired
    private SpasInterveneMapper interveneMapper;

    @Autowired
    private SpasAnalysisMapper analysisMapper;

    @Autowired
    private KnowledgeStatQueryService knowledgeStatQueryService;

    @Autowired
    private SpasWarningRecordMapper warningRecordMapper;

    @Autowired
    private ISpasErrorTagService errorTagService;

    @Autowired
    private SpasCoachLogMapper coachLogMapper;

    @Autowired
    private SpasInterveneActionMapper interveneActionMapper;

    @Autowired
    private SpasAccessService accessService;

    @Autowired
    private SpasTeacherScopeService teacherScopeService;

    @Value("${spas.intervene.default-target-rate:0.60}")
    private double defaultTargetRate;

    @Value("${spas.intervene.effect-after-create:true}")
    private boolean effectAfterCreate;

    @Value("${spas.intervene.close-warning-on-pass:true}")
    private boolean closeWarningOnPass;

    @Value("${spas.intervene.default-due-days:14}")
    private int defaultDueDays;

    /** Dual-gate: require post-create practice sample (or coach/done action) before status=passed. */
    @Value("${spas.intervene.require-process-for-pass:true}")
    private boolean requireProcessForPass;

    @Override
    public List<SpasInterveneTask> selectSpasInterveneTaskList(SpasInterveneTask task)
    {
        List<SpasInterveneTask> list;
        if (teacherScopeService.useTeacherDeptFilter())
        {
            teacherScopeService.applyTeacherDeptFilter(task);
            list = interveneMapper.selectSpasInterveneTaskList(task);
        }
        else
        {
            list = SpringUtils.getAopProxy(this).selectSpasInterveneTaskListScoped(task);
        }
        if (list != null)
        {
            for (SpasInterveneTask row : list)
            {
                applyProcessSummary(row, null, false);
            }
        }
        return list;
    }

    @DataScope(deptAlias = "d")
    public List<SpasInterveneTask> selectSpasInterveneTaskListScoped(SpasInterveneTask task)
    {
        return interveneMapper.selectSpasInterveneTaskList(task);
    }

    @Override
    public SpasInterveneTask selectSpasInterveneTaskById(Long interveneId)
    {
        SpasInterveneTask task = interveneMapper.selectSpasInterveneTaskById(interveneId);
        if (task == null)
        {
            throw new ServiceException("干预任务不存在");
        }
        accessService.checkStudentAccess(task.getStudentId());
        SpasCoachLog q = new SpasCoachLog();
        q.setInterveneId(interveneId);
        // bypass data scope for detail coach logs under same student
        Map<String, Object> params = q.getParams();
        if (params == null)
        {
            params = new HashMap<>();
            q.setParams(params);
        }
        params.put("dataScope", "");
        task.setCoachLogs(coachLogMapper.selectSpasCoachLogList(q));
        List<SpasInterveneAction> actions = interveneActionMapper.selectByInterveneId(interveneId);
        task.setActions(actions == null ? new ArrayList<SpasInterveneAction>() : actions);
        applyProcessSummary(task, actions, true);
        return task;
    }

    @Override
    @Transactional
    public int insertSpasInterveneTask(SpasInterveneTask task)
    {
        accessService.assertCanWrite();
        if (task.getStudentId() == null)
        {
            throw new ServiceException("请选择学生");
        }
        accessService.checkStudentAccess(task.getStudentId());
        List<Long> requireKids = resolveKnowledgeIds(task);
        if (requireKids.isEmpty())
        {
            throw new ServiceException("请至少挂接一个知识点（干预必挂知识点）");
        }
        List<String> actionTypes = normalizeActionTypes(task.getActionTypes());
        if (actionTypes.isEmpty())
        {
            // programmatic create (batch/weak/from-source) defaults to select补弱
            actionTypes = Collections.singletonList(SpasInterveneAction.TYPE_SELECT);
            task.setActionTypes(actionTypes);
        }
        prepareBaseline(task);
        if (StringUtils.isEmpty(task.getKnowledgeIds()))
        {
            throw new ServiceException("请至少挂接一个知识点（干预必挂知识点）");
        }
        if (StringUtils.isEmpty(task.getTitle()))
        {
            task.setTitle("\u5e72\u9884\u4efb\u52a1");
        }
        if (StringUtils.isEmpty(task.getSourceType()))
        {
            task.setSourceType("3");
        }
        if (StringUtils.isEmpty(task.getStatus()))
        {
            task.setStatus("0");
        }
        if (task.getTargetRate() == null)
        {
            task.setTargetRate(BigDecimal.valueOf(defaultTargetRate));
        }
        if (task.getDueDate() == null)
        {
            task.setDueDate(defaultDueDate());
        }
        if (StringUtils.isEmpty(task.getOwnerBy()))
        {
            task.setOwnerBy(SecurityUtils.getUsername());
        }
        if (StringUtils.isEmpty(task.getCreateBy()))
        {
            task.setCreateBy(SecurityUtils.getUsername());
        }
        task.setEffectPassed("0");
        int rows = interveneMapper.insertSpasInterveneTask(task);
        syncInterveneKnowledge(task.getInterveneId(), parseKnowledgeIds(task.getKnowledgeIds()));
        createActionPack(task, actionTypes);
        return rows;
    }

    @Override
    @Transactional
    public int updateSpasInterveneTask(SpasInterveneTask task)
    {
        accessService.assertCanWrite();
        SpasInterveneTask db = interveneMapper.selectSpasInterveneTaskById(task.getInterveneId());
        if (db == null)
        {
            throw new ServiceException("干预任务不存在");
        }
        accessService.checkStudentAccess(db.getStudentId());
        task.setUpdateBy(SecurityUtils.getUsername());
        if ("2".equals(task.getStatus()) && !"2".equals(db.getStatus()))
        {
            Map<String, Object> prog = buildProgress(db);
            boolean processOk = Boolean.TRUE.equals(prog.get("processOk"));
            if (!processOk && StringUtils.isEmpty(task.getCloseReason()))
            {
                throw new ServiceException("无辅导/新练习/达标证据时关闭须填写关闭原因");
            }
            if (db.getCloseTime() == null)
            {
                task.setCloseTime(new Date());
            }
        }
        int rows = interveneMapper.updateSpasInterveneTask(task);
        if (task.getKnowledgeIds() != null || task.getKnowledgeIdList() != null)
        {
            List<Long> kids = resolveKnowledgeIds(task);
            if (kids.isEmpty() && task.getKnowledgeIds() != null)
            {
                kids = parseKnowledgeIds(task.getKnowledgeIds());
            }
            syncInterveneKnowledge(task.getInterveneId(), kids);
        }
        return rows;
    }

    @Override
    @Transactional
    public SpasInterveneTask createFromWarning(Long warningId, SpasInterveneTask form)
    {
        accessService.assertCanWrite();
        SpasWarningRecord warning = warningRecordMapper.selectSpasWarningRecordById(warningId);
        if (warning == null)
        {
            throw new ServiceException("预警记录不存在");
        }
        accessService.checkStudentAccess(warning.getStudentId());
        SpasInterveneTask task = form == null ? new SpasInterveneTask() : form;
        task.setStudentId(warning.getStudentId());
        if (task.getSubjectId() == null)
        {
            task.setSubjectId(warning.getSubjectId());
        }
        task.setSourceType("1");
        task.setSourceId(warningId);
        if (StringUtils.isEmpty(task.getTitle()))
        {
            // unicode escapes: avoid javac source-encoding turning Chinese into ???
            task.setTitle("\u9884\u8b66\u5e72\u9884\uff1a"
                + (StringUtils.isNotEmpty(warning.getTitle()) ? warning.getTitle() : warning.getRuleName()));
        }
        if (warning.getKnowledgeId() != null && (task.getKnowledgeIdList() == null || task.getKnowledgeIdList().isEmpty())
            && StringUtils.isEmpty(task.getKnowledgeIds()))
        {
            task.setKnowledgeIdList(Arrays.asList(warning.getKnowledgeId()));
        }
        if (resolveKnowledgeIds(task).isEmpty())
        {
            throw new ServiceException("该预警未关联知识点，请手动选择知识点后再创建干预");
        }
        if (task.getRemark() == null)
        {
            task.setRemark("\u7531\u9884\u8b66#" + warningId + "\u521b\u5efa");
        }
        String cause = topCauseText(warning.getStudentId());
        if (StringUtils.isNotEmpty(cause) && task.getRemark().indexOf("\u4e3b\u9519\u56e0") < 0)
        {
            task.setRemark(task.getRemark() + "\u3002\u4e3b\u9519\u56e0\uff1a" + cause);
        }
        insertSpasInterveneTask(task);
        return interveneMapper.selectSpasInterveneTaskById(task.getInterveneId());
    }

    private String topCauseText(Long studentId)
    {
        if (studentId == null)
        {
            return null;
        }
        List<Map<String, Object>> rows = errorTagService.selectCauseSummary(studentId);
        if (rows == null || rows.isEmpty())
        {
            return null;
        }
        Map<String, Object> top = rows.get(0);
        Object label = top.get("errorCategoryLabel");
        if (label == null)
        {
            label = top.get("errorLabel");
        }
        if (label == null)
        {
            label = top.get("errorlabel");
        }
        Object count = top.get("tagCount");
        if (count == null)
        {
            count = top.get("tagcount");
        }
        if (label == null)
        {
            return null;
        }
        return label + (count == null ? "" : "\uff08" + count + "\u9898\uff09");
    }

    @Override
    @Transactional
    public SpasInterveneTask evaluate(Long interveneId)
    {
        accessService.assertCanWrite();
        SpasInterveneTask task = interveneMapper.selectSpasInterveneTaskById(interveneId);
        if (task == null)
        {
            throw new ServiceException("干预任务不存在");
        }
        accessService.checkStudentAccess(task.getStudentId());
        doEvaluate(task);
        return interveneMapper.selectSpasInterveneTaskById(interveneId);
    }

    @Override
    public int evaluateOpenForStudents(Collection<Long> studentIds)
    {
        if (studentIds == null || studentIds.isEmpty())
        {
            return 0;
        }
        List<SpasInterveneTask> open = interveneMapper.selectOpenByStudentIds(studentIds);
        if (open == null || open.isEmpty())
        {
            return 0;
        }
        int n = 0;
        for (SpasInterveneTask task : open)
        {
            try
            {
                doEvaluate(task);
                n++;
            }
            catch (Exception e)
            {
                log.warn("Intervene evaluate failed, id={}: {}", task.getInterveneId(), e.getMessage());
            }
        }
        return n;
    }

    @Override
    public void evaluateOpenForStudentsAsync(Collection<Long> studentIds)
    {
        if (studentIds == null || studentIds.isEmpty())
        {
            return;
        }
        final List<Long> ids = new ArrayList<>(studentIds);
        try
        {
            ScheduledExecutorService executor = SpringUtils.getBean("scheduledExecutorService");
            executor.schedule(() -> {
                try
                {
                    int n = evaluateOpenForStudents(ids);
                    log.info("Async intervene evaluate finished, students={}, evaluated={}", ids.size(), n);
                }
                catch (Exception e)
                {
                    log.warn("Async intervene evaluate failed: {}", e.getMessage());
                }
            }, 10, TimeUnit.MILLISECONDS);
        }
        catch (Exception e)
        {
            log.warn("Async executor unavailable, fallback sync evaluate: {}", e.getMessage());
            evaluateOpenForStudents(ids);
        }
    }

    @Override
    public List<Map<String, Object>> studentTimeline(Long studentId)
    {
        accessService.checkStudentAccess(studentId);
        List<SpasInterveneTask> tasks = interveneMapper.selectByStudentId(studentId);
        List<Map<String, Object>> timeline = new ArrayList<>();
        if (tasks == null)
        {
            return timeline;
        }
        for (SpasInterveneTask t : tasks)
        {
            Map<String, Object> createEvt = new LinkedHashMap<>();
            createEvt.put("type", "intervene_create");
            createEvt.put("time", t.getCreateTime());
            createEvt.put("interveneId", t.getInterveneId());
            createEvt.put("title", t.getTitle());
            createEvt.put("baselineRate", t.getBaselineRate());
            createEvt.put("targetRate", t.getTargetRate());
            createEvt.put("status", t.getStatus());
            timeline.add(createEvt);

            SpasCoachLog q = new SpasCoachLog();
            q.setInterveneId(t.getInterveneId());
            Map<String, Object> params = new HashMap<>();
            params.put("dataScope", "");
            q.setParams(params);
            List<SpasCoachLog> logs = coachLogMapper.selectSpasCoachLogList(q);
            if (logs != null)
            {
                for (SpasCoachLog log : logs)
                {
                    Map<String, Object> coachEvt = new LinkedHashMap<>();
                    coachEvt.put("type", "coach");
                    coachEvt.put("time", log.getCreateTime());
                    coachEvt.put("interveneId", t.getInterveneId());
                    coachEvt.put("title", t.getTitle());
                    coachEvt.put("content", log.getContent());
                    coachEvt.put("nextPlan", log.getNextPlan());
                    coachEvt.put("createBy", log.getCreateBy());
                    timeline.add(coachEvt);
                }
            }

            if (t.getEffectRate() != null || "1".equals(t.getStatus()) || "2".equals(t.getStatus()))
            {
                Map<String, Object> effectEvt = new LinkedHashMap<>();
                effectEvt.put("type", "intervene_effect");
                effectEvt.put("time", t.getUpdateTime() != null ? t.getUpdateTime() : t.getCloseTime());
                effectEvt.put("interveneId", t.getInterveneId());
                effectEvt.put("title", t.getTitle());
                effectEvt.put("baselineRate", t.getBaselineRate());
                effectEvt.put("effectRate", t.getEffectRate());
                effectEvt.put("effectDelta", t.getEffectDelta());
                effectEvt.put("effectPassed", t.getEffectPassed());
                effectEvt.put("status", t.getStatus());
                timeline.add(effectEvt);
            }
        }
        timeline.sort((a, b) -> {
            Date da = (Date) a.get("time");
            Date db = (Date) b.get("time");
            if (da == null && db == null) return 0;
            if (da == null) return 1;
            if (db == null) return -1;
            return db.compareTo(da);
        });
        return timeline;
    }

    @Override
    public Map<String, Object> classSummary(Long deptId, Long subjectId)
    {
        accessService.checkClassAnalysisDept(deptId);
        Map<String, Object> row = interveneMapper.selectDeptSummary(deptId, subjectId);
        if (row == null)
        {
            row = new LinkedHashMap<String, Object>();
        }
        String[] keys = new String[] {
            "openCount", "passedCount", "overdueCount", "dueTodayCount",
            "pastDueOpenCount", "noCoachCount", "noActionCount"
        };
        for (String k : keys)
        {
            if (!row.containsKey(k) || row.get(k) == null)
            {
                row.put(k, 0);
            }
        }
        try
        {
            row.put("myOpenCount", interveneMapper.countOpenByOwner(SecurityUtils.getUsername(), deptId));
        }
        catch (Exception e)
        {
            row.put("myOpenCount", 0);
        }
        int open = toInt(row.get("openCount"));
        int passed = toInt(row.get("passedCount"));
        int overdue = toInt(row.get("overdueCount"));
        int noAction = toInt(row.get("noActionCount"));
        int noCoach = toInt(row.get("noCoachCount"));
        int tracked = open + passed + overdue;
        row.put("coverageCount", tracked);
        row.put("actionHangRate", open <= 0 ? 0.0 : roundRate((double) noAction / open));
        row.put("noCoachRate", (open + overdue) <= 0 ? 0.0 : roundRate((double) noCoach / (open + overdue)));
        row.put("passRate", tracked <= 0 ? 0.0 : roundRate((double) passed / tracked));
        return row;
    }

    private static int toInt(Object v)
    {
        if (v == null)
        {
            return 0;
        }
        if (v instanceof Number)
        {
            return ((Number) v).intValue();
        }
        try
        {
            return Integer.parseInt(String.valueOf(v));
        }
        catch (Exception e)
        {
            return 0;
        }
    }

    private static double roundRate(double v)
    {
        return Math.round(v * 10000.0) / 10000.0;
    }

    @Override
    @Transactional
    public Map<String, Object> batchCreateForWeak(Long deptId, Long subjectId, Long knowledgeId, String title,
        java.math.BigDecimal targetRate)
    {
        accessService.assertCanWrite();
        if (deptId == null || knowledgeId == null)
        {
            throw new ServiceException("班级和知识点不能为空");
        }
        accessService.checkClassAnalysisDept(deptId);
        List<Map<String, Object>> students = analysisMapper.selectWeakStudentsByKnowledge(deptId, subjectId, knowledgeId);
        int created = 0;
        int skipped = 0;
        if (students != null)
        {
            for (Map<String, Object> stu : students)
            {
                if (stu.get("studentId") == null)
                {
                    continue;
                }
                Long studentId = Long.valueOf(stu.get("studentId").toString());
                if (hasOpenKnowledge(studentId, knowledgeId))
                {
                    skipped++;
                    continue;
                }
                SpasInterveneTask task = new SpasInterveneTask();
                task.setStudentId(studentId);
                task.setSubjectId(subjectId);
                task.setSourceType("2");
                task.setSourceId(knowledgeId);
                task.setKnowledgeIdList(java.util.Collections.singletonList(knowledgeId));
                String name = stu.get("studentName") == null ? String.valueOf(studentId) : stu.get("studentName").toString();
                task.setTitle(StringUtils.isNotEmpty(title) ? title
                    : ("\u8584\u5f31\u5e72\u9884\uff1a" + name));
                if (targetRate != null)
                {
                    task.setTargetRate(targetRate);
                }
                task.setCreateBy(SecurityUtils.getUsername());
                insertSpasInterveneTask(task);
                created++;
            }
        }
        Map<String, Object> result = new LinkedHashMap<String, Object>();
        result.put("created", created);
        result.put("skipped", skipped);
        result.put("candidates", students == null ? 0 : students.size());
        return result;
    }

    @Override
    public Map<String, Object> progress(Long interveneId)
    {
        SpasInterveneTask task = interveneMapper.selectSpasInterveneTaskById(interveneId);
        if (task == null)
        {
            throw new ServiceException("干预任务不存在");
        }
        accessService.checkStudentAccess(task.getStudentId());
        return buildProgress(task);
    }

    @Override
    @Transactional
    public SpasInterveneAction addAction(Long interveneId, SpasInterveneAction action)
    {
        accessService.assertCanWrite();
        SpasInterveneTask task = interveneMapper.selectSpasInterveneTaskById(interveneId);
        if (task == null)
        {
            throw new ServiceException("干预任务不存在");
        }
        accessService.checkStudentAccess(task.getStudentId());
        if (action == null || StringUtils.isEmpty(action.getActionType()))
        {
            throw new ServiceException("动作类型不能为空");
        }
        String type = action.getActionType().trim().toLowerCase();
        if (!isSupportedActionType(type))
        {
            throw new ServiceException("不支持的动作类型: " + type);
        }
        action.setActionType(type);
        action.setInterveneId(interveneId);
        if (StringUtils.isEmpty(action.getStatus()))
        {
            action.setStatus(SpasInterveneAction.STATUS_PENDING);
        }
        if (StringUtils.isEmpty(action.getTitle()))
        {
            action.setTitle(defaultActionTitle(type));
        }
        if (StringUtils.isEmpty(action.getCreateBy()))
        {
            action.setCreateBy(SecurityUtils.getUsername());
        }
        interveneActionMapper.insertSpasInterveneAction(action);
        if (SpasInterveneAction.TYPE_COACH.equals(type)
            && SpasInterveneAction.STATUS_DONE.equals(action.getStatus()))
        {
            // optional: no auto coach log here; createActionPack handles create-time coach
        }
        return action;
    }

    @Override
    @Transactional
    public SpasInterveneAction updateAction(SpasInterveneAction action)
    {
        accessService.assertCanWrite();
        if (action == null || action.getActionId() == null || action.getInterveneId() == null)
        {
            throw new ServiceException("动作ID与interveneId不能为空");
        }
        SpasInterveneTask task = interveneMapper.selectSpasInterveneTaskById(action.getInterveneId());
        if (task == null)
        {
            throw new ServiceException("干预任务不存在");
        }
        accessService.checkStudentAccess(task.getStudentId());
        SpasInterveneAction db = null;
        List<SpasInterveneAction> actions = interveneActionMapper.selectByInterveneId(action.getInterveneId());
        if (actions != null)
        {
            for (SpasInterveneAction a : actions)
            {
                if (action.getActionId().equals(a.getActionId()))
                {
                    db = a;
                    break;
                }
            }
        }
        if (db == null)
        {
            throw new ServiceException("干预动作不存在");
        }
        action.setUpdateBy(SecurityUtils.getUsername());
        interveneActionMapper.updateSpasInterveneAction(action);
        List<SpasInterveneAction> refreshed = interveneActionMapper.selectByInterveneId(action.getInterveneId());
        if (refreshed != null)
        {
            for (SpasInterveneAction a : refreshed)
            {
                if (action.getActionId().equals(a.getActionId()))
                {
                    return a;
                }
            }
        }
        return action;
    }

    @Override
    @Transactional
    public int markOverdue()
    {
        return interveneMapper.markOverdueOpenTasks();
    }

    @Override
    @Transactional
    public int linkAssignment(Long interveneId, Long assignmentId)
    {
        accessService.assertCanWrite();
        SpasInterveneTask task = interveneMapper.selectSpasInterveneTaskById(interveneId);
        if (task == null)
        {
            throw new ServiceException("干预任务不存在");
        }
        accessService.checkStudentAccess(task.getStudentId());
        String user = SecurityUtils.getUsername();
        int n = interveneActionMapper.markPendingDoneByType(interveneId, SpasInterveneAction.TYPE_PRACTICE,
            assignmentId, "已关联练习布置#" + assignmentId, user);
        if (n == 0)
        {
            // ensure an action exists so progress shows linkage
            SpasInterveneAction action = new SpasInterveneAction();
            action.setInterveneId(interveneId);
            action.setActionType(SpasInterveneAction.TYPE_PRACTICE);
            action.setStatus(SpasInterveneAction.STATUS_DONE);
            action.setRefId(assignmentId);
            action.setTitle(defaultActionTitle(SpasInterveneAction.TYPE_PRACTICE));
            action.setRemark("\u5df2\u5173\u8054\u7ec3\u4e60\u5e03\u7f6e#" + assignmentId);
            action.setCreateBy(user);
            interveneActionMapper.insertSpasInterveneAction(action);
            n = 1;
        }
        return n;
    }

    @Override
    @Transactional
    public int linkSelect(Long interveneId, Long refId)
    {
        accessService.assertCanWrite();
        SpasInterveneTask task = interveneMapper.selectSpasInterveneTaskById(interveneId);
        if (task == null)
        {
            throw new ServiceException("干预任务不存在");
        }
        accessService.checkStudentAccess(task.getStudentId());
        String user = SecurityUtils.getUsername();
        int n = interveneActionMapper.markPendingDoneByType(interveneId, SpasInterveneAction.TYPE_SELECT,
            refId, "已完成选题补弱", user);
        if (n == 0)
        {
            SpasInterveneAction action = new SpasInterveneAction();
            action.setInterveneId(interveneId);
            action.setActionType(SpasInterveneAction.TYPE_SELECT);
            action.setStatus(SpasInterveneAction.STATUS_DONE);
            action.setRefId(refId);
            action.setTitle(defaultActionTitle(SpasInterveneAction.TYPE_SELECT));
            action.setRemark("\u5df2\u5b8c\u6210\u9009\u9898\u8865\u5f31");
            action.setCreateBy(user);
            interveneActionMapper.insertSpasInterveneAction(action);
            n = 1;
        }
        return n;
    }

    @Override
    public List<Map<String, Object>> listOpenTodos(Long studentId)
    {
        if (studentId == null)
        {
            return new ArrayList<Map<String, Object>>();
        }
        // Open parent API already asserts bind; skip Spring-Security student/dept check
        if (com.ruoyi.spas.open.SpasOpenContext.getParentId() == null)
        {
            accessService.checkStudentAccess(studentId);
        }
        List<SpasInterveneTask> all = interveneMapper.selectByStudentId(studentId);
        List<Map<String, Object>> out = new ArrayList<Map<String, Object>>();
        if (all == null)
        {
            return out;
        }
        for (SpasInterveneTask t : all)
        {
            // open + overdue still need student attention
            if (!"0".equals(t.getStatus()) && !"3".equals(t.getStatus()))
            {
                continue;
            }
            applyProcessSummary(t, null, false);
            Map<String, Object> row = new LinkedHashMap<String, Object>();
            row.put("interveneId", t.getInterveneId());
            row.put("title", t.getTitle());
            row.put("subjectId", t.getSubjectId());
            row.put("subjectName", t.getSubjectName());
            row.put("knowledgeIds", t.getKnowledgeIds());
            row.put("status", t.getStatus());
            row.put("dueDate", t.getDueDate());
            row.put("targetRate", t.getTargetRate());
            row.put("baselineRate", t.getBaselineRate());
            row.put("effectRate", t.getEffectRate());
            row.put("processLabel", t.getProcessLabel());
            row.put("actionCount", t.getActionCount());
            row.put("coachCount", t.getCoachCount());
            row.put("daysLeft", daysLeft(t.getDueDate()));
            out.add(row);
        }
        return out;
    }

    @Override
    @Transactional
    public int onPracticeLogged(Long studentId, Long subjectId, Collection<Long> knowledgeIds)
    {
        if (studentId == null || knowledgeIds == null || knowledgeIds.isEmpty())
        {
            return 0;
        }
        Set<Long> kids = new HashSet<Long>();
        for (Long k : knowledgeIds)
        {
            if (k != null)
            {
                kids.add(k);
            }
        }
        if (kids.isEmpty())
        {
            return 0;
        }
        List<SpasInterveneTask> open = interveneMapper.selectOpenByStudentIds(Collections.singletonList(studentId));
        if (open == null || open.isEmpty())
        {
            return 0;
        }
        int updated = 0;
        String user = "system";
        try
        {
            user = SecurityUtils.getUsername();
        }
        catch (Exception ignored)
        {
        }
        for (SpasInterveneTask task : open)
        {
            if (subjectId != null && task.getSubjectId() != null
                && !subjectId.equals(task.getSubjectId()))
            {
                continue;
            }
            List<Long> taskKids = parseKnowledgeIds(task.getKnowledgeIds());
            boolean hit = false;
            for (Long kid : taskKids)
            {
                if (kids.contains(kid))
                {
                    hit = true;
                    break;
                }
            }
            if (!hit)
            {
                continue;
            }
            updated += interveneActionMapper.markPendingDoneByType(task.getInterveneId(),
                SpasInterveneAction.TYPE_PRACTICE, null, "练习打卡命中知识点", user);
            updated += interveneActionMapper.markPendingDoneByType(task.getInterveneId(),
                SpasInterveneAction.TYPE_SELECT, null, "练习打卡命中知识点", user);
        }
        return updated;
    }

    private boolean hasOpenKnowledge(Long studentId, Long knowledgeId)
    {
        List<SpasInterveneTask> open = interveneMapper.selectOpenByStudentIds(java.util.Collections.singletonList(studentId));
        if (open == null)
        {
            return false;
        }
        String needle = String.valueOf(knowledgeId);
        for (SpasInterveneTask task : open)
        {
            if (StringUtils.isEmpty(task.getKnowledgeIds()))
            {
                continue;
            }
            for (String part : task.getKnowledgeIds().split(","))
            {
                if (needle.equals(part.trim()))
                {
                    return true;
                }
            }
        }
        return false;
    }

    private void prepareBaseline(SpasInterveneTask task)
    {
        List<Long> kids = resolveKnowledgeIds(task);
        List<SpasStudentKnowledgeStat> stats = analysisMapper.selectStudentKnowledgeStats(task.getStudentId(), task.getSubjectId());
        if (stats == null)
        {
            stats = new ArrayList<>();
        }
        List<Map<String, Object>> baselineRows = new ArrayList<>();
        BigDecimal sumW = BigDecimal.ZERO;
        BigDecimal sumWR = BigDecimal.ZERO;
        Set<Long> filter = kids.isEmpty() ? null : new HashSet<>(kids);

        for (SpasStudentKnowledgeStat st : stats)
        {
            if (filter != null && !filter.contains(st.getKnowledgeId()))
            {
                continue;
            }
            // if no explicit knowledge selected, prefer weak ones; if none weak, take all
            if (filter == null && kids.isEmpty())
            {
                // collect later - first pass mark
            }
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("knowledgeId", st.getKnowledgeId());
            row.put("knowledgeName", st.getKnowledgeName());
            row.put("weightedRate", st.getWeightedRate());
            row.put("attemptCount", st.getAttemptCount());
            row.put("weakLevel", st.getWeakLevel());
            baselineRows.add(row);
            int att = st.getAttemptCount() == null ? 1 : Math.max(st.getAttemptCount(), 1);
            BigDecimal rate = st.getWeightedRate() == null ? BigDecimal.ZERO : st.getWeightedRate();
            sumW = sumW.add(BigDecimal.valueOf(att));
            sumWR = sumWR.add(rate.multiply(BigDecimal.valueOf(att)));
        }

        if (filter == null && !baselineRows.isEmpty())
        {
            List<Map<String, Object>> weakOnly = baselineRows.stream()
                .filter(r -> {
                    Object wl = r.get("weakLevel");
                    return wl != null && !"0".equals(wl.toString());
                })
                .collect(Collectors.toList());
            if (!weakOnly.isEmpty() && weakOnly.size() <= 10)
            {
                baselineRows = weakOnly;
                sumW = BigDecimal.ZERO;
                sumWR = BigDecimal.ZERO;
                List<Long> autoKids = new ArrayList<>();
                for (Map<String, Object> r : baselineRows)
                {
                    autoKids.add(Long.valueOf(r.get("knowledgeId").toString()));
                    int att = r.get("attemptCount") == null ? 1 : Math.max(Integer.parseInt(r.get("attemptCount").toString()), 1);
                    BigDecimal rate = r.get("weightedRate") == null ? BigDecimal.ZERO : new BigDecimal(r.get("weightedRate").toString());
                    sumW = sumW.add(BigDecimal.valueOf(att));
                    sumWR = sumWR.add(rate.multiply(BigDecimal.valueOf(att)));
                }
                task.setKnowledgeIds(autoKids.stream().map(String::valueOf).collect(Collectors.joining(",")));
            }
        }
        else if (!kids.isEmpty())
        {
            task.setKnowledgeIds(kids.stream().map(String::valueOf).collect(Collectors.joining(",")));
        }

        if (sumW.compareTo(BigDecimal.ZERO) > 0)
        {
            task.setBaselineRate(sumWR.divide(sumW, 6, RoundingMode.HALF_UP));
        }
        else
        {
            task.setBaselineRate(BigDecimal.ZERO);
        }
        task.setBaselineJson(JSON.toJSONString(baselineRows));
    }

    private void doEvaluate(SpasInterveneTask task)
    {
        List<Long> kids = parseKnowledgeIds(task.getKnowledgeIds());
        EffectStatsLoad loaded = loadEffectStatsWithMeta(task, kids);
        List<SpasStudentKnowledgeStat> stats = loaded.stats;
        Map<Long, SpasStudentKnowledgeStat> index = new HashMap<>();
        Map<Long, BigDecimal> baselineByKid = new HashMap<>();
        if (stats != null)
        {
            for (SpasStudentKnowledgeStat st : stats)
            {
                index.put(st.getKnowledgeId(), st);
            }
        }
        try
        {
            List<Map> rows = JSON.parseArray(task.getBaselineJson(), Map.class);
            if (rows != null)
            {
                for (Map row : rows)
                {
                    if (row.get("knowledgeId") == null)
                    {
                        continue;
                    }
                    Long kid = Long.valueOf(row.get("knowledgeId").toString());
                    if (kids.isEmpty())
                    {
                        kids.add(kid);
                    }
                    Object br = row.get("weightedRate");
                    if (br != null)
                    {
                        baselineByKid.put(kid, new BigDecimal(br.toString()));
                    }
                }
            }
        }
        catch (Exception ignored)
        {
        }
        if (kids.isEmpty() && stats != null)
        {
            for (SpasStudentKnowledgeStat st : stats)
            {
                kids.add(st.getKnowledgeId());
            }
        }
        BigDecimal sumW = BigDecimal.ZERO;
        BigDecimal sumWR = BigDecimal.ZERO;
        List<Map<String, Object>> effectRows = new ArrayList<>();
        for (Long kid : kids)
        {
            SpasStudentKnowledgeStat st = index.get(kid);
            if (st == null)
            {
                continue;
            }
            int att = st.getAttemptCount() == null ? 1 : Math.max(st.getAttemptCount(), 1);
            BigDecimal rate = st.getWeightedRate() == null ? BigDecimal.ZERO : st.getWeightedRate();
            sumW = sumW.add(BigDecimal.valueOf(att));
            sumWR = sumWR.add(rate.multiply(BigDecimal.valueOf(att)));
            BigDecimal base = baselineByKid.get(kid);
            if (base == null)
            {
                base = task.getBaselineRate() == null ? BigDecimal.ZERO : task.getBaselineRate();
            }
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("knowledgeId", kid);
            row.put("knowledgeName", st.getKnowledgeName());
            row.put("baselineRate", base);
            row.put("effectRate", rate);
            row.put("delta", rate.subtract(base));
            row.put("attemptCount", st.getAttemptCount());
            effectRows.add(row);
        }
        BigDecimal effect = BigDecimal.ZERO;
        if (sumW.compareTo(BigDecimal.ZERO) > 0)
        {
            effect = sumWR.divide(sumW, 6, RoundingMode.HALF_UP);
        }
        BigDecimal baseline = task.getBaselineRate() == null ? BigDecimal.ZERO : task.getBaselineRate();
        BigDecimal delta = effect.subtract(baseline);
        BigDecimal target = task.getTargetRate() == null ? BigDecimal.valueOf(defaultTargetRate) : task.getTargetRate();
        boolean ratePassed = effect.compareTo(target) >= 0;
        boolean processOk = isProcessEvidenceOk(task, loaded, kids);
        boolean fullyPassed = ratePassed && (!requireProcessForPass || processOk);
        // effectPassed: 1=fully passed, 2=rate ok but watching (缺过程), 0=not passed
        String effectPassedFlag = fullyPassed ? "1" : (ratePassed ? "2" : "0");

        Map<String, Object> effectPayload = new LinkedHashMap<String, Object>();
        effectPayload.put("mode", loaded.mode);
        effectPayload.put("windowDesc", loaded.windowDesc);
        effectPayload.put("windowFrom", loaded.windowFrom);
        effectPayload.put("baselineRate", baseline);
        effectPayload.put("effectRate", effect);
        effectPayload.put("delta", delta);
        effectPayload.put("targetRate", target);
        effectPayload.put("ratePassed", ratePassed);
        effectPayload.put("processOk", processOk);
        effectPayload.put("requireProcessForPass", requireProcessForPass);
        effectPayload.put("passed", fullyPassed);
        effectPayload.put("watching", ratePassed && !fullyPassed);
        effectPayload.put("formula", "各知识点加权得分率按练习次数加权；Δ=当前−基线；通过=达标且（创建后新样本或辅导/已完成动作）");
        effectPayload.put("knowledges", effectRows);

        SpasInterveneTask upd = new SpasInterveneTask();
        upd.setInterveneId(task.getInterveneId());
        upd.setEffectRate(effect);
        upd.setEffectDelta(delta);
        upd.setEffectPassed(effectPassedFlag);
        upd.setEffectJson(JSON.toJSONString(effectPayload));
        if (fullyPassed && ("0".equals(task.getStatus()) || "3".equals(task.getStatus())))
        {
            upd.setStatus("1");
        }
        if (!fullyPassed && "0".equals(task.getStatus()) && task.getDueDate() != null
            && task.getDueDate().before(new Date()))
        {
            upd.setStatus("3");
        }
        upd.setUpdateBy("system");
        interveneMapper.updateSpasInterveneTask(upd);
        if (fullyPassed && closeWarningOnPass)
        {
            closeLinkedWarning(task);
        }
    }

    private boolean isProcessEvidenceOk(SpasInterveneTask task, EffectStatsLoad loaded, List<Long> kids)
    {
        if (loaded != null && "after_create".equals(loaded.mode) && hasMeasuredKnowledge(loaded.stats, kids))
        {
            return true;
        }
        SpasCoachLog q = new SpasCoachLog();
        q.setInterveneId(task.getInterveneId());
        Map<String, Object> params = q.getParams();
        if (params == null)
        {
            params = new HashMap<String, Object>();
            q.setParams(params);
        }
        params.put("dataScope", "");
        List<SpasCoachLog> coaches = coachLogMapper.selectSpasCoachLogList(q);
        if (coaches != null && !coaches.isEmpty())
        {
            return true;
        }
        List<SpasInterveneAction> actions = interveneActionMapper.selectByInterveneId(task.getInterveneId());
        if (actions != null)
        {
            for (SpasInterveneAction a : actions)
            {
                if (SpasInterveneAction.STATUS_DONE.equals(a.getStatus()))
                {
                    return true;
                }
            }
        }
        return false;
    }

    /** Prefer attempts after task creation; fall back to full snapshot when the window is empty. */
    private List<SpasStudentKnowledgeStat> loadEffectStats(SpasInterveneTask task)
    {
        return loadEffectStatsWithMeta(task, parseKnowledgeIds(task.getKnowledgeIds())).stats;
    }

    private EffectStatsLoad loadEffectStatsWithMeta(SpasInterveneTask task, List<Long> kids)
    {
        EffectStatsLoad out = new EffectStatsLoad();
        out.mode = "snapshot";
        out.windowDesc = "全量快照掌握度";
        out.windowFrom = null;
        if (effectAfterCreate && task.getCreateTime() != null)
        {
            List<SpasStudentKnowledgeStat> windowed = knowledgeStatQueryService.computeStudentStats(
                task.getStudentId(), task.getSubjectId(), task.getCreateTime(), null);
            if (hasMeasuredKnowledge(windowed, kids))
            {
                out.stats = windowed;
                out.mode = "after_create";
                out.windowDesc = "干预创建后作答窗口";
                out.windowFrom = task.getCreateTime();
                return out;
            }
        }
        List<SpasStudentKnowledgeStat> full = analysisMapper.selectStudentKnowledgeStats(task.getStudentId(),
            task.getSubjectId());
        out.stats = full == null ? new ArrayList<SpasStudentKnowledgeStat>() : full;
        return out;
    }

    private static class EffectStatsLoad
    {
        List<SpasStudentKnowledgeStat> stats;
        String mode;
        String windowDesc;
        Date windowFrom;
    }

    private boolean hasMeasuredKnowledge(List<SpasStudentKnowledgeStat> stats, List<Long> kids)
    {
        if (stats == null || stats.isEmpty())
        {
            return false;
        }
        Set<Long> filter = kids == null || kids.isEmpty() ? null : new HashSet<Long>(kids);
        for (SpasStudentKnowledgeStat st : stats)
        {
            if (st.getKnowledgeId() == null)
            {
                continue;
            }
            if (filter != null && !filter.contains(st.getKnowledgeId()))
            {
                continue;
            }
            int att = st.getAttemptCount() == null ? 0 : st.getAttemptCount().intValue();
            if (att > 0)
            {
                return true;
            }
        }
        return false;
    }

    private Map<String, Object> buildProgress(SpasInterveneTask task)
    {
        Map<String, Object> out = new LinkedHashMap<String, Object>();
        List<SpasInterveneAction> actions = interveneActionMapper.selectByInterveneId(task.getInterveneId());
        if (actions == null)
        {
            actions = new ArrayList<SpasInterveneAction>();
        }
        SpasCoachLog q = new SpasCoachLog();
        q.setInterveneId(task.getInterveneId());
        Map<String, Object> params = q.getParams();
        if (params == null)
        {
            params = new HashMap<String, Object>();
            q.setParams(params);
        }
        params.put("dataScope", "");
        List<SpasCoachLog> coaches = coachLogMapper.selectSpasCoachLogList(q);
        int coachCount = coaches == null ? 0 : coaches.size();
        int actionCount = actions.size();
        int doneActions = 0;
        for (SpasInterveneAction a : actions)
        {
            if (SpasInterveneAction.STATUS_DONE.equals(a.getStatus()))
            {
                doneActions++;
            }
        }
        boolean hasPostCreateSample = false;
        if (effectAfterCreate && task.getCreateTime() != null)
        {
            List<Long> kids = parseKnowledgeIds(task.getKnowledgeIds());
            List<SpasStudentKnowledgeStat> windowed = knowledgeStatQueryService.computeStudentStats(
                task.getStudentId(), task.getSubjectId(), task.getCreateTime(), null);
            hasPostCreateSample = hasMeasuredKnowledge(windowed, kids);
        }
        boolean passed = "1".equals(task.getEffectPassed()) || "1".equals(task.getStatus());
        boolean processOk = passed || coachCount > 0 || hasPostCreateSample || doneActions > 0;
        String label = resolveProcessLabel(task.getStatus(), actionCount, doneActions, coachCount, hasPostCreateSample, passed);

        out.put("interveneId", task.getInterveneId());
        out.put("status", task.getStatus());
        out.put("dueDate", task.getDueDate());
        out.put("ownerBy", task.getOwnerBy());
        out.put("baselineRate", task.getBaselineRate());
        out.put("targetRate", task.getTargetRate());
        out.put("effectRate", task.getEffectRate());
        out.put("effectDelta", task.getEffectDelta());
        out.put("actions", actions);
        out.put("actionCount", actionCount);
        out.put("doneActionCount", doneActions);
        out.put("coachCount", coachCount);
        out.put("hasPostCreateSample", hasPostCreateSample);
        out.put("processOk", processOk);
        out.put("processLabel", label);
        out.put("daysLeft", daysLeft(task.getDueDate()));
        return out;
    }

    private void applyProcessSummary(SpasInterveneTask task, List<SpasInterveneAction> actions, boolean deep)
    {
        if (task == null)
        {
            return;
        }
        int actionCount = task.getActionCount() == null ? 0 : task.getActionCount().intValue();
        int coachCount = task.getCoachCount() == null ? 0 : task.getCoachCount().intValue();
        int doneActions = 0;
        boolean hasPostCreateSample = false;
        if (deep)
        {
            if (actions == null)
            {
                actions = interveneActionMapper.selectByInterveneId(task.getInterveneId());
            }
            if (actions != null)
            {
                actionCount = actions.size();
                for (SpasInterveneAction a : actions)
                {
                    if (SpasInterveneAction.STATUS_DONE.equals(a.getStatus()))
                    {
                        doneActions++;
                    }
                }
            }
            if (task.getCoachLogs() != null)
            {
                coachCount = task.getCoachLogs().size();
            }
            if (effectAfterCreate && task.getCreateTime() != null)
            {
                List<Long> kids = parseKnowledgeIds(task.getKnowledgeIds());
                List<SpasStudentKnowledgeStat> windowed = knowledgeStatQueryService.computeStudentStats(
                    task.getStudentId(), task.getSubjectId(), task.getCreateTime(), null);
                hasPostCreateSample = hasMeasuredKnowledge(windowed, kids);
            }
        }
        boolean passed = "1".equals(task.getEffectPassed()) || "1".equals(task.getStatus());
        boolean processOk = passed || coachCount > 0 || hasPostCreateSample || doneActions > 0
            || (actionCount > 0 && !deep);
        // list view: having planned actions counts as "有动作" for label, but close gate still needs evidence
        if (!deep)
        {
            processOk = passed || coachCount > 0 || "2".equals(task.getEffectPassed());
        }
        task.setActionCount(actionCount);
        task.setCoachCount(coachCount);
        task.setProcessOk(processOk);
        task.setProcessLabel(resolveProcessLabel(task.getStatus(), actionCount, doneActions, coachCount,
            hasPostCreateSample, passed, task.getEffectPassed()));
    }

    private String resolveProcessLabel(String status, int actionCount, int doneActions, int coachCount,
        boolean hasPostCreateSample, boolean passed)
    {
        return resolveProcessLabel(status, actionCount, doneActions, coachCount, hasPostCreateSample, passed, null);
    }

    private String resolveProcessLabel(String status, int actionCount, int doneActions, int coachCount,
        boolean hasPostCreateSample, boolean passed, String effectPassed)
    {
        if ("1".equals(status) || passed || "1".equals(effectPassed))
        {
            return "已达标";
        }
        if ("2".equals(effectPassed))
        {
            return "观察中(缺过程)";
        }
        if ("2".equals(status))
        {
            return "已关闭";
        }
        if ("3".equals(status))
        {
            return "已逾期";
        }
        if (coachCount > 0 && (doneActions > 0 || hasPostCreateSample))
        {
            return "辅导+练习中";
        }
        if (coachCount > 0)
        {
            return "已辅导 " + coachCount + " 次";
        }
        if (doneActions > 0)
        {
            return "动作完成 " + doneActions + "/" + actionCount;
        }
        if (actionCount > 0)
        {
            return "待执行 " + actionCount + " 项";
        }
        return "无动作";
    }

    private Integer daysLeft(Date dueDate)
    {
        if (dueDate == null)
        {
            return null;
        }
        Calendar due = Calendar.getInstance();
        due.setTime(dueDate);
        clearTime(due);
        Calendar today = Calendar.getInstance();
        clearTime(today);
        long diff = (due.getTimeInMillis() - today.getTimeInMillis()) / (24L * 3600L * 1000L);
        return (int) diff;
    }

    private void clearTime(Calendar c)
    {
        c.set(Calendar.HOUR_OF_DAY, 0);
        c.set(Calendar.MINUTE, 0);
        c.set(Calendar.SECOND, 0);
        c.set(Calendar.MILLISECOND, 0);
    }

    private Date defaultDueDate()
    {
        Calendar c = Calendar.getInstance();
        c.add(Calendar.DAY_OF_MONTH, Math.max(defaultDueDays, 1));
        clearTime(c);
        return c.getTime();
    }

    private List<String> normalizeActionTypes(List<String> raw)
    {
        LinkedHashSet<String> set = new LinkedHashSet<String>();
        if (raw != null)
        {
            for (String t : raw)
            {
                if (StringUtils.isEmpty(t))
                {
                    continue;
                }
                String v = t.trim().toLowerCase();
                if (isSupportedActionType(v))
                {
                    set.add(v);
                }
            }
        }
        return new ArrayList<String>(set);
    }

    private boolean isSupportedActionType(String type)
    {
        return SpasInterveneAction.TYPE_PRACTICE.equals(type)
            || SpasInterveneAction.TYPE_SELECT.equals(type)
            || SpasInterveneAction.TYPE_COACH.equals(type)
            || SpasInterveneAction.TYPE_CUSTOM.equals(type);
    }

    private String defaultActionTitle(String type)
    {
        if (SpasInterveneAction.TYPE_PRACTICE.equals(type))
        {
            return "\u5e03\u7f6e\u7ec3\u4e60\u4e3b\u9898";
        }
        if (SpasInterveneAction.TYPE_SELECT.equals(type))
        {
            return "\u9009\u9898\u8865\u5f31";
        }
        if (SpasInterveneAction.TYPE_COACH.equals(type))
        {
            return "\u8f85\u5bfc\u8ba1\u5212";
        }
        return "\u5176\u5b83\u52a8\u4f5c";
    }

    private void createActionPack(SpasInterveneTask task, List<String> actionTypes)
    {
        if (task.getInterveneId() == null || actionTypes == null || actionTypes.isEmpty())
        {
            return;
        }
        String username = StringUtils.isNotEmpty(task.getCreateBy()) ? task.getCreateBy() : SecurityUtils.getUsername();
        for (String type : actionTypes)
        {
            SpasInterveneAction action = new SpasInterveneAction();
            action.setInterveneId(task.getInterveneId());
            action.setActionType(type);
            action.setTitle(defaultActionTitle(type));
            action.setCreateBy(username);
            if (SpasInterveneAction.TYPE_COACH.equals(type))
            {
                action.setStatus(SpasInterveneAction.STATUS_DONE);
                String content = StringUtils.isNotEmpty(task.getCoachContent())
                    ? task.getCoachContent()
                    : ("创建干预：" + (StringUtils.isNotEmpty(task.getTitle()) ? task.getTitle() : "跟进薄弱点"));
                String plan = StringUtils.isNotEmpty(task.getCoachPlan())
                    ? task.getCoachPlan()
                    : "安排一对一辅导，并督促完成相关练习";
                SpasCoachLog coach = new SpasCoachLog();
                coach.setStudentId(task.getStudentId());
                coach.setInterveneId(task.getInterveneId());
                List<Long> kids = parseKnowledgeIds(task.getKnowledgeIds());
                if (!kids.isEmpty())
                {
                    coach.setKnowledgeId(kids.get(0));
                }
                coach.setContent(content);
                coach.setNextPlan(plan);
                coach.setCreateBy(username);
                coachLogMapper.insertSpasCoachLog(coach);
                action.setRemark("\u5df2\u5199\u5165\u8f85\u5bfc\u8ba1\u5212");
            }
            else
            {
                action.setStatus(SpasInterveneAction.STATUS_PENDING);
            }
            interveneActionMapper.insertSpasInterveneAction(action);
        }
    }

    private void closeLinkedWarning(SpasInterveneTask task)
    {
        if (task == null || !"1".equals(task.getSourceType()) || task.getSourceId() == null)
        {
            return;
        }
        SpasWarningRecord warning = warningRecordMapper.selectSpasWarningRecordById(task.getSourceId());
        if (warning == null || !"0".equals(warning.getStatus()))
        {
            return;
        }
        warning.setStatus("1");
        warning.setHandleBy("system");
        warning.setHandleTime(new Date());
        warning.setHandleRemark("干预达标自动关闭 #" + task.getInterveneId());
        warningRecordMapper.updateSpasWarningRecord(warning);
    }

    private void syncInterveneKnowledge(Long interveneId, List<Long> knowledgeIds)
    {
        if (interveneId == null)
        {
            return;
        }
        interveneMapper.deleteInterveneKnowledge(interveneId);
        if (knowledgeIds == null || knowledgeIds.isEmpty())
        {
            return;
        }
        Set<Long> seen = new HashSet<>();
        for (Long kid : knowledgeIds)
        {
            if (kid == null || !seen.add(kid))
            {
                continue;
            }
            interveneMapper.insertInterveneKnowledge(interveneId, kid);
        }
    }

    private List<Long> resolveKnowledgeIds(SpasInterveneTask task)
    {
        if (task.getKnowledgeIdList() != null && !task.getKnowledgeIdList().isEmpty())
        {
            return new ArrayList<>(task.getKnowledgeIdList());
        }
        List<Long> fromCsv = parseKnowledgeIds(task.getKnowledgeIds());
        if (!fromCsv.isEmpty())
        {
            return fromCsv;
        }
        if (task.getInterveneId() != null)
        {
            List<Long> fromJoin = interveneMapper.selectInterveneKnowledgeIds(task.getInterveneId());
            if (fromJoin != null && !fromJoin.isEmpty())
            {
                return fromJoin;
            }
        }
        return fromCsv;
    }

    private List<Long> parseKnowledgeIds(String raw)
    {
        List<Long> list = new ArrayList<>();
        if (StringUtils.isEmpty(raw))
        {
            return list;
        }
        for (String p : raw.split("[,??\\s]+"))
        {
            if (StringUtils.isEmpty(p))
            {
                continue;
            }
            try
            {
                list.add(Long.parseLong(p.trim()));
            }
            catch (NumberFormatException ignored)
            {
            }
        }
        return list;
    }
}
