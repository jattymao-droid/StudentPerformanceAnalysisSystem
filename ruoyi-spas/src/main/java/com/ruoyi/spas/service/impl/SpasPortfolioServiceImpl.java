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
    private ISpasInterveneService interveneService;

    @Autowired
    private SpasInterveneMapper interveneMapper;

    @Autowired
    private SpasAccessService accessService;

    @Autowired
    private SpasTeacherScopeService teacherScopeService;

    @Override
    public Map<String, Object> getPortfolio(Long studentId, Long subjectId)
    {
        if (SecurityUtils.hasRole("spas_student"))
        {
            throw new ServiceException("学生账号仅可查看本人学情");
        }
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
            throw new ServiceException("当前账号未绑定学生档案");
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
        if (includeCoach)
        {
            SpasCoachLog q = new SpasCoachLog();
            q.setStudentId(student.getStudentId());
            data.put("coachLogs", selectCoachLogList(q));
        }
        return data;
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
