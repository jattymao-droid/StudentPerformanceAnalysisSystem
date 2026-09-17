package com.ruoyi.spas.support;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.mapper.SpasStudentMapper;
import com.ruoyi.system.service.ISysDeptService;

/**
 * SPAS data-scope guard for path-parameter access and write protection
 */
@Service
public class SpasAccessService
{
    @Autowired
    private ISysDeptService deptService;

    @Autowired
    private SpasStudentMapper studentMapper;

    @Autowired
    private SpasTeacherScopeService teacherScopeService;

    public void checkDeptAccess(Long deptId)
    {
        if (deptId == null || SecurityUtils.isAdmin())
        {
            return;
        }
        if (SecurityUtils.hasRole("spas_student"))
        {
            throw new ServiceException("学生账号无权访问该部门数据");
        }
        if (teacherScopeService.canAccessDept(deptId))
        {
            return;
        }
        if (teacherScopeService.useTeacherDeptFilter())
        {
            throw new ServiceException("无权限访问该部门数据");
        }
        deptService.checkDeptDataScope(deptId);
    }

    public void checkStudentAccess(Long studentId)
    {
        if (studentId == null || SecurityUtils.isAdmin())
        {
            return;
        }
        SpasStudent student = studentMapper.selectSpasStudentById(studentId);
        if (student == null || "2".equals(student.getDelFlag()))
        {
            throw new ServiceException("学生不存在");
        }
        // Student role: only self
        if (SecurityUtils.hasRole("spas_student"))
        {
            Long userId = SecurityUtils.getUserId();
            SpasStudent self = studentMapper.selectSpasStudentByUserId(userId);
            if (self == null || self.getStudentId() == null || !self.getStudentId().equals(studentId))
            {
                throw new ServiceException("只能查看本人学情数据");
            }
            return;
        }
        checkDeptAccess(student.getDeptId());
    }

    /** School leaders are read-only for SPAS business writes */
    public void assertCanWrite()
    {
        if (SecurityUtils.isAdmin())
        {
            return;
        }
        if (SecurityUtils.hasRole("spas_school_leader"))
        {
            throw new ServiceException("校级领导账号仅可查看，不可修改数据");
        }
        if (SecurityUtils.hasRole("spas_student"))
        {
            throw new ServiceException("学生账号仅可查看，不可修改数据");
        }
    }
}
