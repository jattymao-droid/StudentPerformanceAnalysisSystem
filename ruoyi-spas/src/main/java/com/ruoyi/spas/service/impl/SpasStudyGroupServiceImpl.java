package com.ruoyi.spas.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.domain.SpasStudyGroup;
import com.ruoyi.spas.domain.SpasStudyGroupMember;
import com.ruoyi.spas.mapper.SpasStudentMapper;
import com.ruoyi.spas.mapper.SpasStudyGroupMapper;
import com.ruoyi.spas.service.ISpasStudyGroupService;
import com.ruoyi.spas.support.SpasAccessService;
import com.ruoyi.spas.support.SpasTeacherScopeService;

@Service
public class SpasStudyGroupServiceImpl implements ISpasStudyGroupService
{
    @Autowired
    private SpasStudyGroupMapper groupMapper;

    @Autowired
    private SpasStudentMapper studentMapper;

    @Autowired
    private SpasAccessService accessService;

    @Autowired
    private SpasTeacherScopeService teacherScopeService;

    @Override
    public List<SpasStudyGroup> selectSpasStudyGroupList(SpasStudyGroup query)
    {
        if (query == null)
        {
            query = new SpasStudyGroup();
        }
        if (teacherScopeService.useTeacherDeptFilter())
        {
            teacherScopeService.applyTeacherDeptFilter(query);
            return groupMapper.selectSpasStudyGroupList(query);
        }
        return SpringUtils.getAopProxy(this).selectSpasStudyGroupListScoped(query);
    }

    @DataScope(deptAlias = "d")
    public List<SpasStudyGroup> selectSpasStudyGroupListScoped(SpasStudyGroup query)
    {
        return groupMapper.selectSpasStudyGroupList(query);
    }

    @Override
    public SpasStudyGroup selectSpasStudyGroupById(Long groupId)
    {
        SpasStudyGroup group = requireGroup(groupId);
        accessService.checkDeptAccess(group.getDeptId());
        group.setMembers(groupMapper.selectActiveMembers(groupId));
        return group;
    }

    @Override
    @Transactional
    public int insertSpasStudyGroup(SpasStudyGroup group)
    {
        accessService.assertCanWrite();
        if (group.getDeptId() == null)
        {
            throw new ServiceException("请选择班级");
        }
        if (group.getGroupName() == null || group.getGroupName().trim().isEmpty())
        {
            throw new ServiceException("请填写组名");
        }
        accessService.checkDeptAccess(group.getDeptId());
        if (group.getStatus() == null)
        {
            group.setStatus("0");
        }
        int rows = groupMapper.insertSpasStudyGroup(group);
        if (group.getStudentIds() != null && group.getStudentIds().length > 0)
        {
            replaceMembers(group.getGroupId(), group.getStudentIds(), group.getLeaderStudentId());
        }
        else if (group.getLeaderStudentId() != null)
        {
            replaceMembers(group.getGroupId(), new Long[] { group.getLeaderStudentId() }, group.getLeaderStudentId());
        }
        return rows;
    }

    @Override
    @Transactional
    public int updateSpasStudyGroup(SpasStudyGroup group)
    {
        accessService.assertCanWrite();
        SpasStudyGroup db = requireGroup(group.getGroupId());
        accessService.checkDeptAccess(db.getDeptId());
        group.setDeptId(db.getDeptId());
        int rows = groupMapper.updateSpasStudyGroup(group);
        if (group.getStudentIds() != null)
        {
            replaceMembers(group.getGroupId(), group.getStudentIds(),
                group.getLeaderStudentId() != null ? group.getLeaderStudentId() : db.getLeaderStudentId());
        }
        else if (group.getLeaderStudentId() != null)
        {
            applyLeaderRole(group.getGroupId(), group.getLeaderStudentId(), db.getDeptId(), db.getSubjectId());
        }
        return rows;
    }

    @Override
    @Transactional
    public int deleteSpasStudyGroupByIds(Long[] groupIds)
    {
        accessService.assertCanWrite();
        if (groupIds == null || groupIds.length == 0)
        {
            return 0;
        }
        for (Long id : groupIds)
        {
            SpasStudyGroup group = requireGroup(id);
            accessService.checkDeptAccess(group.getDeptId());
            groupMapper.markAllMembersLeft(id);
        }
        return groupMapper.softDisableGroups(groupIds);
    }

    @Override
    @Transactional
    public int replaceMembers(Long groupId, Long[] studentIds, Long leaderStudentId)
    {
        accessService.assertCanWrite();
        SpasStudyGroup group = requireGroup(groupId);
        accessService.checkDeptAccess(group.getDeptId());
        Set<Long> ids = new LinkedHashSet<Long>();
        if (studentIds != null)
        {
            ids.addAll(Arrays.asList(studentIds));
        }
        ids.remove(null);
        if (leaderStudentId != null)
        {
            ids.add(leaderStudentId);
        }
        List<Long> keep = new ArrayList<Long>(ids);
        groupMapper.markMembersLeft(groupId, keep);
        for (Long studentId : keep)
        {
            SpasStudent student = studentMapper.selectSpasStudentById(studentId);
            if (student == null || "2".equals(student.getDelFlag()))
            {
                throw new ServiceException("学生不存在");
            }
            if (student.getDeptId() == null || !student.getDeptId().equals(group.getDeptId()))
            {
                throw new ServiceException("只能选择本班学生：" + student.getStudentName());
            }
            int elsewhere = groupMapper.countActiveMembershipElsewhere(studentId, group.getDeptId(),
                group.getSubjectId(), groupId);
            if (elsewhere > 0)
            {
                throw new ServiceException(student.getStudentName() + " 已在同班同学科的其他组中");
            }
            SpasStudyGroupMember member = new SpasStudyGroupMember();
            member.setGroupId(groupId);
            member.setStudentId(studentId);
            member.setRoleInGroup(studentId.equals(leaderStudentId) ? "1" : "0");
            groupMapper.upsertMember(member);
        }
        if (leaderStudentId != null && !ids.contains(leaderStudentId))
        {
            throw new ServiceException("组长必须是组内成员");
        }
        SpasStudyGroup patch = new SpasStudyGroup();
        patch.setGroupId(groupId);
        patch.setLeaderStudentId(leaderStudentId);
        if (leaderStudentId == null)
        {
            patch.getParams().put("clearLeader", Boolean.TRUE);
        }
        return groupMapper.updateSpasStudyGroup(patch);
    }

    @Override
    public List<SpasStudent> selectUnassignedStudents(Long deptId, Long subjectId)
    {
        if (deptId == null)
        {
            throw new ServiceException("请选择班级");
        }
        accessService.checkDeptAccess(deptId);
        return groupMapper.selectUnassignedStudents(deptId, subjectId);
    }

    @Override
    public List<SpasStudyGroupMember> selectActiveMembers(Long groupId)
    {
        SpasStudyGroup group = requireGroup(groupId);
        accessService.checkDeptAccess(group.getDeptId());
        return groupMapper.selectActiveMembers(groupId);
    }

    @Override
    public SpasStudyGroup selectActiveGroupOfStudent(Long studentId, Long deptId, Long subjectId)
    {
        return groupMapper.selectActiveGroupOfStudent(studentId, deptId, subjectId);
    }

    private void applyLeaderRole(Long groupId, Long leaderStudentId, Long deptId, Long subjectId)
    {
        List<SpasStudyGroupMember> members = groupMapper.selectActiveMembers(groupId);
        boolean inGroup = false;
        for (SpasStudyGroupMember m : members)
        {
            groupMapper.updateMemberRole(groupId, m.getStudentId(),
                m.getStudentId().equals(leaderStudentId) ? "1" : "0");
            if (m.getStudentId().equals(leaderStudentId))
            {
                inGroup = true;
            }
        }
        if (!inGroup)
        {
            throw new ServiceException("组长必须是组内成员");
        }
    }

    private SpasStudyGroup requireGroup(Long groupId)
    {
        if (groupId == null)
        {
            throw new ServiceException("小组不存在");
        }
        SpasStudyGroup group = groupMapper.selectSpasStudyGroupById(groupId);
        if (group == null)
        {
            throw new ServiceException("小组不存在");
        }
        return group;
    }
}
