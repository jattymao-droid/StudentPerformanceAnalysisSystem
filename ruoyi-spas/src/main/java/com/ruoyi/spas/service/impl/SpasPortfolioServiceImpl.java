package com.ruoyi.spas.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.spas.domain.SpasCoachLog;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.mapper.SpasCoachLogMapper;
import com.ruoyi.spas.mapper.SpasInterveneMapper;
import com.ruoyi.spas.mapper.SpasStudentMapper;
import com.ruoyi.spas.mapper.SpasWarningRecordMapper;
import com.ruoyi.spas.service.ISpasAnalysisService;
import com.ruoyi.spas.service.ISpasErrorTagService;
import com.ruoyi.spas.service.ISpasInterveneService;
import com.ruoyi.spas.service.ISpasPortfolioService;
import com.ruoyi.spas.support.SpasAccessService;
import com.ruoyi.spas.support.SpasTeacherScopeService;

@Service
public class SpasPortfolioServiceImpl implements ISpasPortfolioService
{
    @Autowired
    private SpasStudentMapper studentMapper;

    @Autowired
    private SpasWarningRecordMapper warningRecordMapper;

    @Autowired
    private SpasCoachLogMapper coachLogMapper;

    @Autowired
    private ISpasAnalysisService analysisService;

    @Autowired
    private ISpasErrorTagService errorTagService;

    @Autowired
    private ISpasInterveneService interveneService;

    @Autowired
    private SpasInterveneMapper interveneMapper;

    @Autowired
    private SpasAccessService accessService;

    @Autowired
    private SpasTeacherScopeService teacherScopeService;

    @Autowired
    private SpasExamRankTrendService examRankTrendService;

    @Override
    public Map<String, Object> getPortfolio(Long studentId, Long subjectId)
    {
        // Do not use SecurityUtils.hasRole("spas_student") here: RuoYi hasRole()
        // returns true for super-admin on any role key, which wrongly blocks admin preview.
        // checkStudentAccess already enforces student self-only / teacher dept scope.
        accessService.checkStudentAccess(studentId);
        SpasStudent student = studentMapper.selectSpasStudentById(studentId);
        if (student == null || "2".equals(student.getDelFlag()))
        {
            throw new ServiceException("学生不存在");
        }
        return buildPortfolio(student, subjectId, true);
    }

    @Override
    public Map<String, Object> getMyPortfolio(Long subjectId)
    {
        Long userId = SecurityUtils.getUserId();
        SpasStudent student = studentMapper.selectSpasStudentByUserId(userId);
        if (student == null)
        {
            Map<String, Object> empty = new HashMap<>();
            empty.put("student", null);
            empty.put("summary", new HashMap<>());
            empty.put("weakTop", java.util.Collections.emptyList());
            empty.put("coachLogs", java.util.Collections.emptyList());
            empty.put("openWarnings", java.util.Collections.emptyList());
            empty.put("radar", java.util.Collections.emptyList());
            empty.put("trend", java.util.Collections.emptyList());
            empty.put("interveneTimeline", java.util.Collections.emptyList());
            empty.put("openWarningCount", 0);
            empty.put("persistentWeak", java.util.Collections.emptyList());
            empty.put("persistentWeakCount", 0);
            empty.put("errorCauseSummary", java.util.Collections.emptyList());
            empty.put("openInterveneCount", 0);
            empty.put("examRank", emptyExamRank());
            return empty;
        }
        return buildPortfolio(student, subjectId, true);
    }

    private Map<String, Object> buildPortfolio(SpasStudent student, Long subjectId, boolean includeCoach)
    {
        Map<String, Object> data = new HashMap<>();
        data.put("student", student);
        data.put("summary", analysisService.studentSummary(student.getStudentId(), subjectId));
        data.put("radar", analysisService.studentRadar(student.getStudentId(), subjectId));
        data.put("trend", analysisService.studentTrend(student.getStudentId(), subjectId));
        data.put("weakTop", analysisService.studentWeakTop(student.getStudentId(), subjectId, 10));
        data.put("openWarnings", warningRecordMapper.selectOpenByStudent(student.getStudentId()));
        data.put("openWarningCount", warningRecordMapper.countOpenByStudent(student.getStudentId()));
        data.put("interveneTimeline", interveneService.studentTimeline(student.getStudentId()));
        data.put("openInterveneCount", interveneMapper.countOpenByStudent(student.getStudentId()));
        // Semester persistent-weak summary (M5)
        List<Map<String, Object>> persist = analysisService.persistentWeak(
            student.getStudentId(), subjectId, null, "semester", null, null, null);
        List<Map<String, Object>> persistOnly = new java.util.ArrayList<>();
        if (persist != null)
        {
            for (Map<String, Object> row : persist)
            {
                if ("\u53cd\u590d\u8584\u5f31".equals(String.valueOf(row.get("persistTag"))))
                {
                    persistOnly.add(row);
                }
            }
        }
        data.put("persistentWeak", persistOnly);
        data.put("persistentWeakCount", persistOnly.size());
        List<Map<String, Object>> causes = errorTagService.selectCauseSummary(student.getStudentId());
        data.put("errorCauseSummary", causes == null ? java.util.Collections.emptyList() : causes);
        data.put("examRank", loadExamRank(student.getStudentId()));
        if (includeCoach)
        {
            SpasCoachLog q = new SpasCoachLog();
            q.setStudentId(student.getStudentId());
            data.put("coachLogs", selectCoachLogList(q));
        }
        return data;
    }

    private Map<String, Object> loadExamRank(Long studentId)
    {
        try
        {
            Map<String, Object> rank = examRankTrendService.selectRankTrend(studentId);
            return rank != null ? rank : emptyExamRank();
        }
        catch (Exception e)
        {
            return emptyExamRank();
        }
    }

    private static Map<String, Object> emptyExamRank()
    {
        Map<String, Object> empty = new HashMap<>();
        empty.put("subjects", java.util.Collections.emptyList());
        empty.put("summary", new HashMap<>());
        empty.put("exams", java.util.Collections.emptyList());
        return empty;
    }

    @Override
    public List<SpasCoachLog> selectCoachLogList(SpasCoachLog log)
    {
        if (teacherScopeService.useTeacherDeptFilter())
        {
            teacherScopeService.applyTeacherDeptFilter(log);
            return coachLogMapper.selectSpasCoachLogList(log);
        }
        return SpringUtils.getAopProxy(this).selectCoachLogListScoped(log);
    }

    @DataScope(deptAlias = "d")
    public List<SpasCoachLog> selectCoachLogListScoped(SpasCoachLog log)
    {
        return coachLogMapper.selectSpasCoachLogList(log);
    }

    @Override
    public int insertCoachLog(SpasCoachLog log)
    {
        accessService.assertCanWrite();
        if (log.getStudentId() == null || StringUtils.isEmpty(log.getContent()))
        {
            throw new ServiceException("学生ID与辅导内容不能为空");
        }
        accessService.checkStudentAccess(log.getStudentId());
        if (StringUtils.isEmpty(log.getCreateBy()))
        {
            log.setCreateBy(SecurityUtils.getUsername());
        }
        return coachLogMapper.insertSpasCoachLog(log);
    }
}
