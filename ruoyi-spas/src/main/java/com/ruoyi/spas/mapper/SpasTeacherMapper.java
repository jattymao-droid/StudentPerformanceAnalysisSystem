package com.ruoyi.spas.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasTeacher;

public interface SpasTeacherMapper
{
    List<SpasTeacher> selectSpasTeacherList(SpasTeacher teacher);

    SpasTeacher selectSpasTeacherById(Long teacherId);

    SpasTeacher selectSpasTeacherByUserId(Long userId);

    SpasTeacher checkTeacherNoUnique(String teacherNo);

    List<SpasTeacher> selectSpasTeacherByType(String teacherType);

    List<SpasTeacher> selectByTypeAndDept(@Param("teacherType") String teacherType, @Param("deptId") Long deptId);

    List<SpasTeacher> selectSubjectBoundToDept(Long deptId);

    SpasTeacher selectHomeroomByDept(Long deptId);

    List<SpasTeacher> selectClassroomTeachers();

    int updateHomeroomDeptId(@Param("teacherId") Long teacherId, @Param("homeroomDeptId") Long homeroomDeptId);

    int insertSpasTeacher(SpasTeacher teacher);

    int updateSpasTeacher(SpasTeacher teacher);

    int deleteSpasTeacherByIds(Long[] teacherIds);
}
