package com.ruoyi.spas.service;

import java.util.List;
import com.ruoyi.spas.domain.SpasErrorTag;

public interface ISpasErrorTagService
{
    public SpasErrorTag selectByStudentAndQuestion(Long studentId, Long questionId);

    public List<SpasErrorTag> selectByStudentId(Long studentId);

    /** Upsert or clear when errorCode blank. */
    public int saveTag(SpasErrorTag tag);

    public int deleteByStudentAndQuestion(Long studentId, Long questionId);

    public java.util.List<java.util.Map<String, Object>> selectCauseSummary(Long studentId);

    /** Class-level error-cause heat (dept scope, optional subject via paper). */
    public java.util.List<java.util.Map<String, Object>> selectDeptCauseSummary(Long deptId, Long subjectId);
}
