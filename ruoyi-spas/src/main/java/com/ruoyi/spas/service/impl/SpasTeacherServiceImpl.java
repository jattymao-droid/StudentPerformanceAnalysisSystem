package com.ruoyi.spas.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasTeacher;
import com.ruoyi.spas.mapper.SpasTeacherDeptMapper;
import com.ruoyi.spas.mapper.SpasTeacherMapper;
import com.ruoyi.spas.service.ISpasTeacherService;
import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.system.mapper.SysDeptMapper;
import com.ruoyi.system.service.ISysRoleService;
import com.ruoyi.system.service.ISysUserService;

@Service
public class SpasTeacherServiceImpl implements ISpasTeacherService
{
    @Autowired
    private SpasTeacherMapper teacherMapper;

    @Autowired
    private ISysUserService userService;

    @Autowired
    private ISysRoleService roleService;

    @Autowired
    private SpasTeacherDeptMapper teacherDeptMapper;

    @Autowired
    private SysDeptMapper deptMapper;

    @Value("${spas.student.init-password:123456}")
    private String initPassword;

    @Override
    @DataScope(deptAlias = "d")
    public List<SpasTeacher> selectSpasTeacherList(SpasTeacher teacher)
    {
        List<SpasTeacher> list = teacherMapper.selectSpasTeacherList(teacher);
        for (SpasTeacher row : list)
        {
            row.setRoleKey(resolveRoleKey(row.getTeacherType()));
            fillExtraDepts(row);
        }
        return list;
    }

    @Override
    public SpasTeacher selectSpasTeacherById(Long teacherId)
    {
        SpasTeacher teacher = teacherMapper.selectSpasTeacherById(teacherId);
        if (teacher != null)
        {
            teacher.setRoleKey(resolveRoleKey(teacher.getTeacherType()));
            fillExtraDepts(teacher);
        }
        return teacher;
    }

    @Override
    public boolean checkTeacherNoUnique(SpasTeacher teacher)
    {
        Long teacherId = StringUtils.isNull(teacher.getTeacherId()) ? -1L : teacher.getTeacherId();
        SpasTeacher info = teacherMapper.checkTeacherNoUnique(teacher.getTeacherNo());
        if (StringUtils.isNotNull(info) && info.getTeacherId().longValue() != teacherId.longValue())
        {
            return UserConstants.NOT_UNIQUE;
        }
        return UserConstants.UNIQUE;
    }

    @Override
    @Transactional
    public int insertSpasTeacher(SpasTeacher teacher)
    {
        validateTeacherTypeAndDept(teacher);
        Long userId = createTeacherUser(teacher);
        teacher.setUserId(userId);
        if (StringUtils.isEmpty(teacher.getStatus()))
        {
            teacher.setStatus("0");
        }
        teacher.setDelFlag("0");
        int rows = teacherMapper.insertSpasTeacher(teacher);
        saveExtraDepts(teacher);
        return rows;
    }

    @Override
    @Transactional
    public int updateSpasTeacher(SpasTeacher teacher)
    {
        validateTeacherTypeAndDept(teacher);
        SpasTeacher db = teacherMapper.selectSpasTeacherById(teacher.getTeacherId());
        if (db == null)
        {
            throw new ServiceException("Teacher not found");
        }
        int rows = teacherMapper.updateSpasTeacher(teacher);
        if (db.getUserId() != null)
        {
            SysUser user = new SysUser();
            user.setUserId(db.getUserId());
            user.setNickName(StringUtils.isNotEmpty(teacher.getTeacherName()) ? teacher.getTeacherName() : db.getTeacherName());
            if (teacher.getDeptId() != null)
            {
                user.setDeptId(teacher.getDeptId());
            }
            user.setPhonenumber(teacher.getMobile());
            user.setUpdateBy(teacher.getUpdateBy());
            userService.updateUserProfile(user);
            if (StringUtils.isNotEmpty(teacher.getStatus()))
            {
                user.setStatus(teacher.getStatus());
                userService.updateUserStatus(user);
            }
            String newType = StringUtils.isNotEmpty(teacher.getTeacherType()) ? teacher.getTeacherType() : db.getTeacherType();
            syncUserRole(db.getUserId(), newType);
        }
        saveExtraDepts(teacher);
        return rows;
    }

    @Override
    @Transactional
    public int deleteSpasTeacherByIds(Long[] teacherIds)
    {
        for (Long teacherId : teacherIds)
        {
            SpasTeacher teacher = teacherMapper.selectSpasTeacherById(teacherId);
            if (teacher != null && teacher.getUserId() != null)
            {
                SysUser user = new SysUser();
                user.setUserId(teacher.getUserId());
                user.setStatus("1");
                userService.updateUserStatus(user);
            }
        }
        return teacherMapper.deleteSpasTeacherByIds(teacherIds);
    }

    @Override
    @Transactional
    public int resetTeacherPwd(Long teacherId)
    {
        SpasTeacher teacher = teacherMapper.selectSpasTeacherById(teacherId);
        if (teacher == null || teacher.getUserId() == null)
        {
            throw new ServiceException("Teacher user not found");
        }
        SysUser user = new SysUser();
        user.setUserId(teacher.getUserId());
        user.setPassword(SecurityUtils.encryptPassword(initPassword));
        return userService.resetPwd(user);
    }

    @Override
    public List<Map<String, Object>> listRoleTypeOptions()
    {
        List<Map<String, Object>> list = new ArrayList<>();
        list.add(option(SpasTeacher.TYPE_SUBJECT, "spas_teacher", "\u4efb\u8bfe\u6559\u5e08", "3",
            "\u672c\u73ed\u4f5c\u4e1a\u3001\u6210\u7ee9\u5bfc\u5165\u3001\u5206\u6790\u3001\u9884\u8b66\u5904\u7406"));
        list.add(option(SpasTeacher.TYPE_HOMEROOM, "spas_bzr", "\u73ed\u4e3b\u4efb", "3",
            "\u672c\u73ed\u5b66\u751f\u7ba1\u7406+\u5bfc\u5165\u3001\u4e00\u751f\u4e00\u518c\u3001\u9884\u8b66\u5904\u7406"));
        list.add(option(SpasTeacher.TYPE_GRADE, "spas_grade_leader", "\u5e74\u7ea7\u8d1f\u8d23\u4eba", "4",
            "\u5e74\u7ea7\u53ca\u4e0b\u7ea7\u73ed\u7ea7\u5206\u6790\u3001\u9884\u8b66\u89c4\u5219\u4e0e\u5904\u7406"));
        list.add(option(SpasTeacher.TYPE_SCHOOL, "spas_school_leader", "\u6821\u7ea7\u9886\u5bfc", "4",
            "\u6821\u7ea7\u5b66\u60c5\u603b\u89c8\u3001\u9884\u8b66\u67e5\u770b\u3001\u4e00\u751f\u4e00\u518c\u67e5\u770b"));
        return list;
    }

    @Override
    public List<Map<String, Object>> listMyTeachingDepts()
    {
        List<Map<String, Object>> result = new ArrayList<>();
        Long userId = SecurityUtils.getUserId();
        SpasTeacher teacher = teacherMapper.selectSpasTeacherByUserId(userId);
        if (teacher != null)
        {
            addDeptOption(result, teacher.getDeptId(), true);
            if (SpasTeacher.TYPE_SUBJECT.equals(teacher.getTeacherType()))
            {
                List<Long> extras = teacherDeptMapper.selectDeptIdsByTeacherId(teacher.getTeacherId());
                if (extras != null)
                {
                    for (Long deptId : extras)
                    {
                        addDeptOption(result, deptId, false);
                    }
                }
            }
            return result;
        }
        Long deptId = SecurityUtils.getDeptId();
        if (deptId != null)
        {
            addDeptOption(result, deptId, true);
        }
        return result;
    }

    private void addDeptOption(List<Map<String, Object>> result, Long deptId, boolean primary)
    {
        if (deptId == null)
        {
            return;
        }
        for (Map<String, Object> row : result)
        {
            if (deptId.equals(row.get("deptId")))
            {
                return;
            }
        }
        Map<String, Object> m = new HashMap<>();
        m.put("deptId", deptId);
        m.put("primary", primary);
        SysDept dept = deptMapper.selectDeptById(deptId);
        m.put("deptName", dept != null ? dept.getDeptName() : String.valueOf(deptId));
        result.add(m);
    }

    private Map<String, Object> option(String type, String roleKey, String label, String dataScope, String desc)
    {
        Map<String, Object> m = new HashMap<>();
        m.put("teacherType", type);
        m.put("roleKey", roleKey);
        m.put("label", label);
        m.put("dataScope", dataScope);
        m.put("description", desc);
        return m;
    }

    private void validateTeacherTypeAndDept(SpasTeacher teacher)
    {
        if (StringUtils.isEmpty(teacher.getTeacherType()))
        {
            teacher.setTeacherType(SpasTeacher.TYPE_SUBJECT);
        }
        if (teacher.getDeptId() == null)
        {
            throw new ServiceException("Dept is required");
        }
    }

    private void saveExtraDepts(SpasTeacher teacher)
    {
        if (teacher.getTeacherId() == null)
        {
            return;
        }
        teacherDeptMapper.deleteByTeacherId(teacher.getTeacherId());
        if (!SpasTeacher.TYPE_SUBJECT.equals(teacher.getTeacherType()))
        {
            return;
        }
        List<Long> extraDeptIds = teacher.getExtraDeptIds();
        if (extraDeptIds == null || extraDeptIds.isEmpty())
        {
            return;
        }
        for (Long deptId : extraDeptIds)
        {
            if (deptId == null || deptId.equals(teacher.getDeptId()))
            {
                continue;
            }
            teacherDeptMapper.insertTeacherDept(teacher.getTeacherId(), deptId);
        }
    }

    private void fillExtraDepts(SpasTeacher teacher)
    {
        if (!SpasTeacher.TYPE_SUBJECT.equals(teacher.getTeacherType()))
        {
            return;
        }
        List<Long> deptIds = teacherDeptMapper.selectDeptIdsByTeacherId(teacher.getTeacherId());
        teacher.setExtraDeptIds(deptIds);
        if (deptIds == null || deptIds.isEmpty())
        {
            return;
        }
        StringBuilder names = new StringBuilder();
        for (Long deptId : deptIds)
        {
            SysDept dept = deptMapper.selectDeptById(deptId);
            if (dept != null)
            {
                if (names.length() > 0)
                {
                    names.append("\u3001");
                }
                names.append(dept.getDeptName());
            }
        }
        teacher.setExtraDeptNames(names.toString());
    }

    private Long createTeacherUser(SpasTeacher teacher)
    {
        SysUser user = new SysUser();
        user.setUserName(teacher.getTeacherNo());
        user.setNickName(teacher.getTeacherName());
        user.setDeptId(teacher.getDeptId());
        user.setPhonenumber(teacher.getMobile());
        user.setPassword(SecurityUtils.encryptPassword(initPassword));
        user.setStatus(StringUtils.isEmpty(teacher.getStatus()) ? "0" : teacher.getStatus());
        user.setCreateBy(teacher.getCreateBy());
        user.setSex(teacher.getGender());
        user.setRoleIds(new Long[] { resolveRoleId(teacher.getTeacherType()) });
        userService.insertUser(user);
        return user.getUserId();
    }

    private void syncUserRole(Long userId, String teacherType)
    {
        SysUser user = userService.selectUserById(userId);
        if (user == null)
        {
            return;
        }
        user.setRoleIds(new Long[] { resolveRoleId(teacherType) });
        userService.updateUser(user);
    }

    private String resolveRoleKey(String teacherType)
    {
        if (SpasTeacher.TYPE_HOMEROOM.equals(teacherType))
        {
            return "spas_bzr";
        }
        if (SpasTeacher.TYPE_GRADE.equals(teacherType))
        {
            return "spas_grade_leader";
        }
        if (SpasTeacher.TYPE_SCHOOL.equals(teacherType))
        {
            return "spas_school_leader";
        }
        return "spas_teacher";
    }

    private Long resolveRoleId(String teacherType)
    {
        String roleKey = resolveRoleKey(teacherType);
        SysRole query = new SysRole();
        query.setRoleKey(roleKey);
        List<SysRole> roles = roleService.selectRoleList(query);
        if (roles != null)
        {
            for (SysRole role : roles)
            {
                if (roleKey.equals(role.getRoleKey()))
                {
                    return role.getRoleId();
                }
            }
        }
        throw new ServiceException("Role not found: " + roleKey);
    }
}
