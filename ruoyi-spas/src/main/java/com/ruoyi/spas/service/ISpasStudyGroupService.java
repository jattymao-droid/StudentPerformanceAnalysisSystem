package com.ruoyi.spas.service;

import java.util.List;
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
}
