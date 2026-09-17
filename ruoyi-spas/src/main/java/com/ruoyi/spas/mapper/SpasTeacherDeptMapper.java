package com.ruoyi.spas.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;

/**
 * Teacher extra class dept assignments
 */
public interface SpasTeacherDeptMapper
{
    List<Long> selectDeptIdsByTeacherId(Long teacherId);

    int deleteByTeacherId(Long teacherId);

    int insertTeacherDept(@Param("teacherId") Long teacherId, @Param("deptId") Long deptId);
}
