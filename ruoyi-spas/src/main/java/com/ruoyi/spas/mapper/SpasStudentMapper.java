package com.ruoyi.spas.mapper;

import java.util.List;
import com.ruoyi.spas.domain.SpasStudent;

/**
 * Student mapper
 */
public interface SpasStudentMapper
{
    public List<SpasStudent> selectSpasStudentList(SpasStudent student);

    public SpasStudent selectSpasStudentById(Long studentId);

    public SpasStudent selectSpasStudentByStudentNo(String studentNo);

    public SpasStudent selectSpasStudentByUserId(Long userId);

    public SpasStudent checkStudentNoUnique(String studentNo);

    public int insertSpasStudent(SpasStudent student);

    public int updateSpasStudent(SpasStudent student);

    public int deleteSpasStudentByIds(Long[] studentIds);
}
