package com.ruoyi.spas.support;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.core.domain.entity.SysRole;
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

    /**
     * Super admin (userId=1), role admin / spas_admin, or wildcard permission.
     * Full access users see all departments and are not limited by teacher class binding.
     */
    public boolean isFullDataAccess()
    {
        if (SecurityUtils.isAdmin())
        {
            return true;
        }
        if (hasExactRole("admin") || hasExactRole("spas_admin"))
        {
            return true;
        }
        try
        {
            return SecurityUtils.hasPermi("*:*:*");
        }
        catch (Exception ignored)
        {
            return false;
        }
    }

    public void checkDeptAccess(Long deptId)
    {
        if (deptId == null || isFullDataAccess())
        {
            return;
        }
        if (hasExactRole("spas_student"))
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

    /**
     * Class / grade analysis entry: bound subject teachers may open ancestor depts for
     * paper visibility, but must not aggregate sibling classes under a grade node.
     * Grade/school/教务 roles keep dept+descendants semantics.
     */
    public void checkClassAnalysisDept(Long deptId)
    {
        checkDeptAccess(deptId);
        if (deptId == null || isFullDataAccess())
        {
            return;
        }
        if (hasExactRole("spas_grade_leader") || hasExactRole("spas_school_leader")
            || hasExactRole("spas_jw") || hasExactRole("spas_admin"))
        {
            return;
        }
        if (!teacherScopeService.useTeacherDeptFilter())
        {
            return;
        }
        java.util.List<Long> bound = teacherScopeService.getSubjectTeacherDeptIds();
        if (bound != null && bound.contains(deptId))
        {
            return;
        }
        throw new ServiceException("任课教师请选择所绑定的班级查看学情；年级汇总请使用年级负责人或教务账号");
    }

    public void checkStudentAccess(Long studentId)
    {
        if (studentId == null || isFullDataAccess())
        {
            return;
        }
        SpasStudent student = studentMapper.selectSpasStudentById(studentId);
        if (student == null || "2".equals(student.getDelFlag()))
        {
            throw new ServiceException("学生不存在");
        }
        // Student role: only self (exact role key — do not use SecurityUtils.hasRole which matches admin)
        if (hasExactRole("spas_student"))
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
        if (isFullDataAccess())
        {
            return;
        }
        if (hasExactRole("spas_school_leader"))
        {
            throw new ServiceException("校级领导账号仅可查看，不可修改数据");
        }
        if (hasExactRole("spas_student"))
        {
            throw new ServiceException("学生账号仅可查看，不可修改数据");
        }
    }

    /**
     * Exact roleKey match. Unlike {@link SecurityUtils#hasRole}, this does NOT treat
     * super-admin roleKey as matching every role check.
     */
    public boolean hasExactRole(String roleKey)
    {
        if (roleKey == null || roleKey.isEmpty())
        {
            return false;
        }
        try
        {
            List<SysRole> roles = SecurityUtils.getLoginUser().getUser().getRoles();
            if (roles == null)
            {
                return false;
            }
            for (SysRole r : roles)
            {
                if (r != null && roleKey.equals(r.getRoleKey()))
                {
                    return true;
                }
            }
        }
        catch (Exception ignored)
        {
        }
        return false;
    }
}
