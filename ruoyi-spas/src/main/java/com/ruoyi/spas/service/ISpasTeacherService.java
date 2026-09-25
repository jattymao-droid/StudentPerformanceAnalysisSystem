package com.ruoyi.spas.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.spas.domain.SpasClassTeacherBind;
import com.ruoyi.spas.domain.SpasTeacher;

public interface ISpasTeacherService
{
    List<SpasTeacher> selectSpasTeacherList(SpasTeacher teacher);

    SpasTeacher selectSpasTeacherById(Long teacherId);

    boolean checkTeacherNoUnique(SpasTeacher teacher);

    int insertSpasTeacher(SpasTeacher teacher);

    int updateSpasTeacher(SpasTeacher teacher);

    int deleteSpasTeacherByIds(Long[] teacherIds);

    int resetTeacherPwd(Long teacherId);

    List<Map<String, Object>> listRoleTypeOptions();

    /** Current login user's teaching depts (primary + extras). */
    List<Map<String, Object>> listMyTeachingDepts();

    Map<String, Object> getClassBinding(Long deptId);

    String saveClassBinding(SpasClassTeacherBind bind, String operator);
}
