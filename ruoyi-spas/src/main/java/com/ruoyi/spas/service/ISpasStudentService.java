package com.ruoyi.spas.service;

import java.util.List;
import com.ruoyi.spas.domain.SpasStudent;

/**
 * Student service
 */
public interface ISpasStudentService
{
    public List<SpasStudent> selectSpasStudentList(SpasStudent student);

    public SpasStudent selectSpasStudentById(Long studentId);

    public boolean checkStudentNoUnique(SpasStudent student);

    public int insertSpasStudent(SpasStudent student);

    public int updateSpasStudent(SpasStudent student);

    public int deleteSpasStudentByIds(Long[] studentIds);

    public String importStudent(List<SpasStudent> studentList, boolean updateSupport, String operName);

    /**
     * Build sample rows for import template. When deptId is set, fill class names under that node.
     */
    public List<SpasStudent> buildImportTemplateRows(Long deptId);

    public int resetStudentPwd(Long studentId);
}