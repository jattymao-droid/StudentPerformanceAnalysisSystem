package com.ruoyi.spas.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.domain.SpasStudyGroup;
import com.ruoyi.spas.domain.SpasStudyGroupMember;

public interface ISpasStudyGroupService
{
    List<SpasStudyGroup> selectSpasStudyGroupList(SpasStudyGroup query);

    SpasStudyGroup selectSpasStudyGroupById(Long groupId);

    int insertSpasStudyGroup(SpasStudyGroup group);

    int updateSpasStudyGroup(SpasStudyGroup group);

    int deleteSpasStudyGroupByIds(Long[] groupIds);

    int replaceMembers(Long groupId, Long[] studentIds, Long leaderStudentId);

    List<SpasStudent> selectUnassignedStudents(Long deptId, Long subjectId);

    List<SpasStudyGroupMember> selectActiveMembers(Long groupId);

    SpasStudyGroup selectActiveGroupOfStudent(Long studentId, Long deptId, Long subjectId);

    /**
     * Smart assign students into groups of given size.
     * @param mode unassigned = only free students; rebuild = dissolve current scope then regroup all
     * @param examId optional exam for score balance; null = latest done exam of the class
     */
    Map<String, Object> smartAssign(Long deptId, Long subjectId, Integer groupSize, String mode, Long examId, String operName);

    /**
     * Group member scores for one exam + avg score/rank trend across class exams.
     * @param subjectId prefer this subject; null falls back to group's subject then total
     * @param examId focus exam for member table; null = latest done
     */
    Map<String, Object> selectGroupPerformance(Long groupId, Long subjectId, Long examId);

    /** Export one group's weak knowledge as pdf|xlsx. */
    void exportGroupWeak(Long groupId, Long subjectId, String format, jakarta.servlet.http.HttpServletResponse response);

    /** Export all active groups under a class (optional subject) as pdf|xlsx. */
    void exportDeptGroupsWeak(Long deptId, Long subjectId, String format, jakarta.servlet.http.HttpServletResponse response);
}
