package com.ruoyi.spas.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
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
import com.ruoyi.spas.domain.SpasCoachLog;
import com.ruoyi.spas.domain.SpasInterveneTask;
import com.ruoyi.spas.domain.SpasStudentKnowledgeStat;
import com.ruoyi.spas.domain.SpasWarningRecord;
import com.ruoyi.spas.mapper.SpasAnalysisMapper;
import com.ruoyi.spas.mapper.SpasCoachLogMapper;
import com.ruoyi.spas.mapper.SpasInterveneMapper;
import com.ruoyi.spas.mapper.SpasWarningRecordMapper;
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
    private SpasWarningRecordMapper warningRecordMapper;

    @Autowired
    private SpasCoachLogMapper coachLogMapper;

    @Autowired
    private SpasAccessService accessService;

    @Autowired
    private SpasTeacherScopeService teacherScopeService;

    @Value("${spas.intervene.default-target-rate:0.60}")
    private double defaultTargetRate;

    @Override
    public List<SpasInterveneTask> selectSpasInterveneTaskList(SpasInterveneTask task)
    {
        if (teacherScopeService.useTeacherDeptFilter())
        {
            teacherScopeService.applyTeacherDeptFilter(task);
            return interveneMapper.selectSpasInterveneTaskList(task);
        }
        return SpringUtils.getAopProxy(this).selectSpasInterveneTaskListScoped(task);
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
            throw new ServiceException("??????????");
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
        return task;
    }

    @Override
    @Transactional
    public int insertSpasInterveneTask(SpasInterveneTask task)
    {
        accessService.assertCanWrite();
        if (task.getStudentId() == null)
        {
            throw new ServiceException("??????????");
        }
        accessService.checkStudentAccess(task.getStudentId());
        prepareBaseline(task);
        if (StringUtils.isEmpty(task.getTitle()))
        {
            task.setTitle("??????");
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
        if (StringUtils.isEmpty(task.getOwnerBy()))
        {
            task.setOwnerBy(SecurityUtils.getUsername());
        }
        if (StringUtils.isEmpty(task.getCreateBy()))
        {
            task.setCreateBy(SecurityUtils.getUsername());
        }
        task.setEffectPassed("0");
        return interveneMapper.insertSpasInterveneTask(task);
    }

    @Override
    @Transactional
    public int updateSpasInterveneTask(SpasInterveneTask task)
    {
        accessService.assertCanWrite();
        SpasInterveneTask db = interveneMapper.selectSpasInterveneTaskById(task.getInterveneId());
        if (db == null)
        {
            throw new ServiceException("??????????");
        }
        accessService.checkStudentAccess(db.getStudentId());
        task.setUpdateBy(SecurityUtils.getUsername());
        if ("2".equals(task.getStatus()) && db.getCloseTime() == null)
        {
            task.setCloseTime(new Date());
        }
        return interveneMapper.updateSpasInterveneTask(task);
    }

    @Override
    @Transactional
    public SpasInterveneTask createFromWarning(Long warningId, SpasInterveneTask form)
    {
        accessService.assertCanWrite();
        SpasWarningRecord warning = warningRecordMapper.selectSpasWarningRecordById(warningId);
        if (warning == null)
        {
            throw new ServiceException("????????????");
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
            task.setTitle("?????" + (StringUtils.isNotEmpty(warning.getTitle()) ? warning.getTitle() : warning.getRuleName()));
        }
        if (warning.getKnowledgeId() != null && (task.getKnowledgeIdList() == null || task.getKnowledgeIdList().isEmpty())
            && StringUtils.isEmpty(task.getKnowledgeIds()))
        {
            task.setKnowledgeIdList(Arrays.asList(warning.getKnowledgeId()));
        }
        if (task.getRemark() == null)
        {
            task.setRemark("????????#" + warningId + "????");
        }
        insertSpasInterveneTask(task);
        return interveneMapper.selectSpasInterveneTaskById(task.getInterveneId());
    }

    @Override
    @Transactional
    public SpasInterveneTask evaluate(Long interveneId)
    {
        accessService.assertCanWrite();
        SpasInterveneTask task = interveneMapper.selectSpasInterveneTaskById(interveneId);
        if (task == null)
        {
            throw new ServiceException("??????????");
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
        List<SpasStudentKnowledgeStat> stats = analysisMapper.selectStudentKnowledgeStats(task.getStudentId(), task.getSubjectId());
        Map<Long, SpasStudentKnowledgeStat> index = new HashMap<>();
        if (stats != null)
        {
            for (SpasStudentKnowledgeStat st : stats)
            {
                index.put(st.getKnowledgeId(), st);
            }
        }
        BigDecimal sumW = BigDecimal.ZERO;
        BigDecimal sumWR = BigDecimal.ZERO;
        if (kids.isEmpty())
        {
            // use all baseline knowledge ids from json
            try
            {
                List<Map> rows = JSON.parseArray(task.getBaselineJson(), Map.class);
                if (rows != null)
                {
                    for (Map row : rows)
                    {
                        if (row.get("knowledgeId") != null)
                        {
                            kids.add(Long.valueOf(row.get("knowledgeId").toString()));
                        }
                    }
                }
            }
            catch (Exception ignored)
            {
            }
        }
        if (kids.isEmpty() && stats != null)
        {
            for (SpasStudentKnowledgeStat st : stats)
            {
                kids.add(st.getKnowledgeId());
            }
        }
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
        }
        BigDecimal effect = BigDecimal.ZERO;
        if (sumW.compareTo(BigDecimal.ZERO) > 0)
        {
            effect = sumWR.divide(sumW, 6, RoundingMode.HALF_UP);
        }
        BigDecimal baseline = task.getBaselineRate() == null ? BigDecimal.ZERO : task.getBaselineRate();
        BigDecimal delta = effect.subtract(baseline);
        BigDecimal target = task.getTargetRate() == null ? BigDecimal.valueOf(defaultTargetRate) : task.getTargetRate();
        boolean passed = effect.compareTo(target) >= 0;

        SpasInterveneTask upd = new SpasInterveneTask();
        upd.setInterveneId(task.getInterveneId());
        upd.setEffectRate(effect);
        upd.setEffectDelta(delta);
        upd.setEffectPassed(passed ? "1" : "0");
        if (passed && "0".equals(task.getStatus()))
        {
            upd.setStatus("1");
        }
        // overdue check
        if (!passed && "0".equals(task.getStatus()) && task.getDueDate() != null
            && task.getDueDate().before(new Date()))
        {
            upd.setStatus("3");
        }
        upd.setUpdateBy("system");
        interveneMapper.updateSpasInterveneTask(upd);
    }

    private List<Long> resolveKnowledgeIds(SpasInterveneTask task)
    {
        if (task.getKnowledgeIdList() != null && !task.getKnowledgeIdList().isEmpty())
        {
            return new ArrayList<>(task.getKnowledgeIdList());
        }
        return parseKnowledgeIds(task.getKnowledgeIds());
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
