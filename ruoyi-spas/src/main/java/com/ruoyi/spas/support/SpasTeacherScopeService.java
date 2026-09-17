package com.ruoyi.spas.support;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.spas.domain.SpasTeacher;
import com.ruoyi.spas.mapper.SpasTeacherDeptMapper;
import com.ruoyi.spas.mapper.SpasTeacherMapper;

/**
 * Resolves subject-teacher multi-class dept scope
 */
@Service
public class SpasTeacherScopeService
{
    @Autowired
    private SpasTeacherMapper teacherMapper;

    @Autowired
    private SpasTeacherDeptMapper teacherDeptMapper;

    /**
     * Returns merged primary + extra class dept ids for current subject teacher,
     * or null when standard {@link com.ruoyi.common.annotation.DataScope} should apply.
     */
    public List<Long> getSubjectTeacherDeptIds()
    {
        if (SecurityUtils.isAdmin())
        {
            return null;
        }
        SpasTeacher teacher = teacherMapper.selectSpasTeacherByUserId(SecurityUtils.getUserId());
        if (teacher == null || !SpasTeacher.TYPE_SUBJECT.equals(teacher.getTeacherType()))
        {
            return null;
        }
        List<Long> extras = teacherDeptMapper.selectDeptIdsByTeacherId(teacher.getTeacherId());
        if (extras == null || extras.isEmpty())
        {
            return null;
        }
        Set<Long> merged = new LinkedHashSet<>();
        merged.add(teacher.getDeptId());
        merged.addAll(extras);
        return new ArrayList<>(merged);
    }

    public boolean useTeacherDeptFilter()
    {
        List<Long> deptIds = getSubjectTeacherDeptIds();
        return deptIds != null && !deptIds.isEmpty();
    }

    public void applyTeacherDeptFilter(BaseEntity entity)
    {
        List<Long> deptIds = getSubjectTeacherDeptIds();
        if (deptIds != null && !deptIds.isEmpty())
        {
            entity.getParams().put("teacherDeptIds", deptIds);
        }
    }

    public boolean canAccessDept(Long deptId)
    {
        if (deptId == null || SecurityUtils.isAdmin())
        {
            return true;
        }
        List<Long> deptIds = getSubjectTeacherDeptIds();
        if (deptIds != null && !deptIds.isEmpty())
        {
            return deptIds.contains(deptId);
        }
        return false;
    }
}
