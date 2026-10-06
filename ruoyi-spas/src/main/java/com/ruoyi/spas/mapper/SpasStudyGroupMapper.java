package com.ruoyi.spas.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasStudyGroup;
import com.ruoyi.spas.domain.SpasStudyGroupMember;
import com.ruoyi.spas.domain.SpasStudent;

public interface SpasStudyGroupMapper
{
    List<SpasStudyGroup> selectSpasStudyGroupList(SpasStudyGroup query);

    SpasStudyGroup selectSpasStudyGroupById(Long groupId);

    int insertSpasStudyGroup(SpasStudyGroup group);

    int updateSpasStudyGroup(SpasStudyGroup group);

    int softDisableGroups(@Param("groupIds") Long[] groupIds);

    List<SpasStudyGroupMember> selectActiveMembers(Long groupId);

    List<SpasStudyGroupMember> selectActiveMembersByStudent(@Param("studentId") Long studentId,
        @Param("deptId") Long deptId, @Param("subjectId") Long subjectId);

    int markMembersLeft(@Param("groupId") Long groupId, @Param("studentIds") List<Long> keepIds);

    int markAllMembersLeft(Long groupId);

    int upsertMember(SpasStudyGroupMember member);

    int updateMemberRole(@Param("groupId") Long groupId, @Param("studentId") Long studentId,
        @Param("roleInGroup") String roleInGroup);

    List<SpasStudent> selectUnassignedStudents(@Param("deptId") Long deptId, @Param("subjectId") Long subjectId);

    SpasStudyGroup selectActiveGroupOfStudent(@Param("studentId") Long studentId,
        @Param("deptId") Long deptId, @Param("subjectId") Long subjectId);

    int countActiveMembershipElsewhere(@Param("studentId") Long studentId, @Param("deptId") Long deptId,
        @Param("subjectId") Long subjectId, @Param("excludeGroupId") Long excludeGroupId);
}
