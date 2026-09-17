package com.ruoyi.spas.mapper;

import java.util.List;
import com.ruoyi.spas.domain.SpasTeacher;

public interface SpasTeacherMapper
{
    List<SpasTeacher> selectSpasTeacherList(SpasTeacher teacher);

    SpasTeacher selectSpasTeacherById(Long teacherId);

    SpasTeacher selectSpasTeacherByUserId(Long userId);

    SpasTeacher checkTeacherNoUnique(String teacherNo);

    int insertSpasTeacher(SpasTeacher teacher);

    int updateSpasTeacher(SpasTeacher teacher);

    int deleteSpasTeacherByIds(Long[] teacherIds);
}
