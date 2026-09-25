package com.ruoyi.spas.support;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasTeacher;
import com.ruoyi.spas.mapper.SpasTeacherDeptMapper;
import com.ruoyi.spas.mapper.SpasTeacherMapper;
import com.ruoyi.system.mapper.SysDeptMapper;

/**
 * Resolves teacher class scope. Papers created at grade/school may be visible
 * to class teachers (ancestor dept), while student data stays class-bound.
 */
@Service
public class SpasTeacherScopeService
{
    @Autowired
    private SpasTeacherMapper teacherMapper;

    @Autowired
    private SpasTeacherDeptMapper teacherDeptMapper;

    @Autowired
    private SysDeptMapper deptMapper;

    @Autowired
    @Lazy
    private SpasAccessService accessService;

    /**
     * Bound teaching class ids for current user, or null when not a bound teacher /
     * full-access admin (standard DataScope applies).
     */
    public List<Long> getSubjectTeacherDeptIds()
    {
        if (accessService.isFullDataAccess())
        {
            return null;
        }
        return SpasPageGuard.withoutPage(() -> {
            SpasTeacher teacher = teacherMapper.selectSpasTeacherByUserId(SecurityUtils.getUserId());
            if (teacher == null)
            {
                return null;
            }
            Set<Long> merged = new LinkedHashSet<>();
            if (teacher.getDeptId() != null)
            {
                merged.add(teacher.getDeptId());
            }
            if (teacher.getHomeroomDeptId() != null)
            {
                merged.add(teacher.getHomeroomDeptId());
            }
            List<Long> extras = teacherDeptMapper.selectDeptIdsByTeacherId(teacher.getTeacherId());
            if (extras != null)
            {
                merged.addAll(extras);
            }
            return merged.isEmpty() ? null : new ArrayList<>(merged);
        });
    }

    public boolean useTeacherDeptFilter()
    {
        if (accessService.isFullDataAccess())
        {
            return false;
        }
        List<Long> deptIds = getSubjectTeacherDeptIds();
        return deptIds != null && !deptIds.isEmpty();
    }

    public void applyTeacherDeptFilter(BaseEntity entity)
    {
        if (accessService.isFullDataAccess())
        {
            return;
        }
        List<Long> deptIds = getSubjectTeacherDeptIds();
        if (deptIds != null && !deptIds.isEmpty())
        {
            entity.getParams().put("teacherDeptIds", deptIds);
        }
    }

    /**
     * For paper dropdowns: allow class dept + ancestor (grade/school) + null dept.
     */
    public void applyTeacherPaperDeptFilter(BaseEntity entity)
    {
        applyTeacherDeptFilter(entity);
        if (entity.getParams().get("teacherDeptIds") != null)
        {
            entity.getParams().put("paperAncestorScope", Boolean.TRUE);
        }
    }

    public boolean canAccessDept(Long deptId)
    {
        if (deptId == null || accessService.isFullDataAccess())
        {
            return true;
        }
        List<Long> deptIds = getSubjectTeacherDeptIds();
        if (deptIds == null || deptIds.isEmpty())
        {
            return false;
        }
        if (deptIds.contains(deptId))
        {
            return true;
        }
        // Grade/school paper or node above the class
        return isAncestorOfTeachingClass(deptId, deptIds);
    }

    private boolean isAncestorOfTeachingClass(Long candidateDeptId, List<Long> teachingDeptIds)
    {
        String needle = String.valueOf(candidateDeptId);
        for (Long classId : teachingDeptIds)
        {
            if (classId == null)
            {
                continue;
            }
            SysDept cls = deptMapper.selectDeptById(classId);
            if (cls == null)
            {
                continue;
            }
            if (candidateDeptId.equals(cls.getParentId()))
            {
                return true;
            }
            String ancestors = cls.getAncestors();
            if (StringUtils.isNotEmpty(ancestors))
            {
                for (String part : ancestors.split(","))
                {
                    if (needle.equals(part.trim()))
                    {
                        return true;
                    }
                }
            }
        }
        return false;
    }
}
