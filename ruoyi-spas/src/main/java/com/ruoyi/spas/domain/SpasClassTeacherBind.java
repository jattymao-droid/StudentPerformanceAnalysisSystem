package com.ruoyi.spas.domain;

import java.util.List;

/**
 * Replace homeroom and subject-teacher bindings for one class dept.
 */
public class SpasClassTeacherBind
{
    private Long deptId;

    /** Null clears the homeroom. */
    private Long homeroomTeacherId;

    /** Full set of subject teachers for this class. Null is treated as empty. */
    private List<Long> subjectTeacherIds;

    public Long getDeptId()
    {
        return deptId;
    }

    public void setDeptId(Long deptId)
    {
        this.deptId = deptId;
    }

    public Long getHomeroomTeacherId()
    {
        return homeroomTeacherId;
    }

    public void setHomeroomTeacherId(Long homeroomTeacherId)
    {
        this.homeroomTeacherId = homeroomTeacherId;
    }

    public List<Long> getSubjectTeacherIds()
    {
        return subjectTeacherIds;
    }

    public void setSubjectTeacherIds(List<Long> subjectTeacherIds)
    {
        this.subjectTeacherIds = subjectTeacherIds;
    }
}
