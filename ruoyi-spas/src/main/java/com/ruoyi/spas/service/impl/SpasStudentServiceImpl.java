package com.ruoyi.spas.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.mapper.SpasStudentMapper;
import com.ruoyi.spas.service.ISpasStudentService;
import com.ruoyi.spas.support.SpasTeacherScopeService;
import com.ruoyi.system.service.ISysDeptService;
import com.ruoyi.system.service.ISysRoleService;
import com.ruoyi.system.service.ISysUserService;

/**
 * Student service implementation
 */
@Service
public class SpasStudentServiceImpl implements ISpasStudentService
{
    @Autowired
    private SpasStudentMapper studentMapper;

    @Autowired
    private ISysUserService userService;

    @Autowired
    private ISysRoleService roleService;

    @Autowired
    private ISysDeptService deptService;

    @Autowired
    private SpasTeacherScopeService teacherScopeService;

    @Value("${spas.student.init-password:123456}")
    private String initPassword;

    @Override
    public List<SpasStudent> selectSpasStudentList(SpasStudent student)
    {
        if (teacherScopeService.useTeacherDeptFilter())
        {
            teacherScopeService.applyTeacherDeptFilter(student);
            return studentMapper.selectSpasStudentList(student);
        }
        return SpringUtils.getAopProxy(this).selectSpasStudentListScoped(student);
    }

    @DataScope(deptAlias = "d")
    public List<SpasStudent> selectSpasStudentListScoped(SpasStudent student)
    {
        return studentMapper.selectSpasStudentList(student);
    }

    @Override
    public SpasStudent selectSpasStudentById(Long studentId)
    {
        return studentMapper.selectSpasStudentById(studentId);
    }

    @Override
    public boolean checkStudentNoUnique(SpasStudent student)
    {
        Long studentId = StringUtils.isNull(student.getStudentId()) ? -1L : student.getStudentId();
        SpasStudent info = studentMapper.checkStudentNoUnique(student.getStudentNo());
        if (StringUtils.isNotNull(info) && info.getStudentId().longValue() != studentId.longValue())
        {
            return UserConstants.NOT_UNIQUE;
        }
        return UserConstants.UNIQUE;
    }

    @Override
    @Transactional
    public int insertSpasStudent(SpasStudent student)
    {
        return insertSpasStudent(student, resolveStudentRoleIds());
    }

    @Transactional
    public int insertSpasStudent(SpasStudent student, Long[] roleIds)
    {
        Long userId = createStudentUser(student, roleIds);
        student.setUserId(userId);
        if (StringUtils.isEmpty(student.getStatus()))
        {
            student.setStatus("0");
        }
        student.setDelFlag("0");
        return studentMapper.insertSpasStudent(student);
    }

    @Override
    @Transactional
    public int updateSpasStudent(SpasStudent student)
    {
        int rows = studentMapper.updateSpasStudent(student);
        SpasStudent db = studentMapper.selectSpasStudentById(student.getStudentId());
        if (db != null && db.getUserId() != null)
        {
            SysUser user = new SysUser();
            user.setUserId(db.getUserId());
            user.setNickName(StringUtils.isNotEmpty(student.getStudentName()) ? student.getStudentName() : db.getStudentName());
            user.setDeptId(student.getDeptId() != null ? student.getDeptId() : db.getDeptId());
            user.setUpdateBy(student.getUpdateBy());
            userService.updateUserProfile(user);
            if (StringUtils.isNotEmpty(student.getStatus()))
            {
                user.setStatus(student.getStatus());
                userService.updateUserStatus(user);
            }
        }
        return rows;
    }

    @Override
    @Transactional
    public int deleteSpasStudentByIds(Long[] studentIds)
    {
        for (Long studentId : studentIds)
        {
            SpasStudent student = studentMapper.selectSpasStudentById(studentId);
            if (student != null && student.getUserId() != null)
            {
                SysUser user = new SysUser();
                user.setUserId(student.getUserId());
                user.setStatus("1");
                userService.updateUserStatus(user);
            }
        }
        return studentMapper.deleteSpasStudentByIds(studentIds);
    }

    @Override
    public String importStudent(List<SpasStudent> studentList, boolean updateSupport, String operName)
    {
        if (StringUtils.isNull(studentList) || studentList.size() == 0)
        {
            throw new ServiceException("导入学生数据不能为空");
        }
        // resolve once; avoid PG concat LIKE + aborting whole batch on first SQL error
        final Long[] studentRoleIds = resolveStudentRoleIds();
        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();
        for (SpasStudent student : studentList)
        {
            try
            {
                // template hint rows: only class name filled
                if (StringUtils.isEmpty(student.getStudentNo()) && StringUtils.isEmpty(student.getStudentName())
                    && StringUtils.isNotEmpty(student.getDeptName()))
                {
                    continue;
                }
                if (StringUtils.isEmpty(student.getStudentNo()) || StringUtils.isEmpty(student.getStudentName()))
                {
                    failureNum++;
                    failureMsg.append("<br/>").append(failureNum).append(". 学号或姓名为空");
                    continue;
                }
                resolveDeptIdFromName(student);
                if (student.getDeptId() == null)
                {
                    failureNum++;
                    failureMsg.append("<br/>").append(failureNum).append(". ").append(student.getStudentNo())
                        .append(" 班级名称为空或无法匹配");
                    continue;
                }
                SpasStudent exist = studentMapper.selectSpasStudentByStudentNo(student.getStudentNo());
                if (exist != null)
                {
                    if (!updateSupport)
                    {
                        failureNum++;
                        failureMsg.append("<br/>").append(failureNum).append(". ").append(student.getStudentNo()).append(" 已存在");
                        continue;
                    }
                    student.setStudentId(exist.getStudentId());
                    student.setUserId(exist.getUserId());
                    student.setUpdateBy(operName);
                    if (StringUtils.isEmpty(student.getStatus()))
                    {
                        student.setStatus(exist.getStatus());
                    }
                    SpringUtils.getAopProxy(this).updateSpasStudent(student);
                    successNum++;
                    successMsg.append("<br/>").append(successNum).append(". ").append(student.getStudentNo()).append(" 更新成功");
                }
                else
                {
                    student.setCreateBy(operName);
                    SpringUtils.getAopProxy(this).insertSpasStudent(student, studentRoleIds);
                    successNum++;
                    successMsg.append("<br/>").append(successNum).append(". ").append(student.getStudentNo()).append(" 导入成功");
                }
            }
            catch (Exception e)
            {
                failureNum++;
                String msg = "<br/>" + failureNum + ". " + student.getStudentNo() + " 失败: ";
                failureMsg.append(msg).append(e.getMessage());
            }
        }
        if (failureNum > 0)
        {
            failureMsg.insert(0, "导入完成，成功 " + successNum + " 条，失败 " + failureNum + " 条：");
            throw new ServiceException(failureMsg.toString());
        }
        if (successNum == 0)
        {
            throw new ServiceException("未导入有效学生数据，请填写学号、姓名，并保留班级名称");
        }
        successMsg.insert(0, "导入成功，共 " + successNum + " 条：");
        return successMsg.toString();
    }

    @Override
    public List<SpasStudent> buildImportTemplateRows(Long deptId)
    {
        List<SysDept> classes = resolveTemplateClasses(deptId);
        List<SpasStudent> rows = new ArrayList<SpasStudent>();
        for (SysDept dept : classes)
        {
            SpasStudent row = new SpasStudent();
            row.setDeptName(buildDeptPath(dept));
            row.setGender("0");
            row.setStatus("0");
            rows.add(row);
        }
        if (rows.isEmpty())
        {
            SpasStudent row = new SpasStudent();
            row.setDeptName("请填写班级名称，重名时用 上级/班级");
            row.setGender("0");
            row.setStatus("0");
            rows.add(row);
        }
        return rows;
    }

    @Override
    @Transactional
    public int resetStudentPwd(Long studentId)
    {
        SpasStudent student = studentMapper.selectSpasStudentById(studentId);
        if (student == null || student.getUserId() == null)
        {
            throw new ServiceException("学生或绑定用户不存在");
        }
        SysUser user = new SysUser();
        user.setUserId(student.getUserId());
        user.setPassword(SecurityUtils.encryptPassword(initPassword));
        return userService.resetPwd(user);
    }

    private void resolveDeptIdFromName(SpasStudent student)
    {
        if (student.getDeptId() != null)
        {
            return;
        }
        String raw = StringUtils.trim(student.getDeptName());
        if (StringUtils.isEmpty(raw))
        {
            return;
        }
        if (raw.matches("^\\d+$"))
        {
            student.setDeptId(Long.valueOf(raw));
            return;
        }
        String normalized = raw.replace('\\', '/').replace('／', '/');
        if (normalized.contains("/"))
        {
            student.setDeptId(resolveDeptIdByPath(normalized));
            return;
        }
        List<SysDept> all = deptService.selectDeptList(new SysDept());
        List<SysDept> matched = all.stream()
            .filter(d -> raw.equals(d.getDeptName()))
            .collect(Collectors.toList());
        if (matched.isEmpty())
        {
            throw new ServiceException("未找到班级「" + raw + "」");
        }
        if (matched.size() > 1)
        {
            String hint = matched.stream().limit(5).map(this::buildDeptPath).collect(Collectors.joining("；"));
            throw new ServiceException("班级「" + raw + "」存在多个，请填写完整路径，例如：" + hint);
        }
        student.setDeptId(matched.get(0).getDeptId());
    }

    private Long resolveDeptIdByPath(String path)
    {
        String[] parts = path.split("/");
        List<String> names = new ArrayList<String>();
        for (String p : parts)
        {
            String n = StringUtils.trim(p);
            if (StringUtils.isNotEmpty(n))
            {
                names.add(n);
            }
        }
        if (names.isEmpty())
        {
            throw new ServiceException("班级路径无效");
        }
        List<SysDept> all = deptService.selectDeptList(new SysDept());
        List<SysDept> current = all.stream()
            .filter(d -> names.get(0).equals(d.getDeptName()))
            .collect(Collectors.toList());
        if (current.isEmpty())
        {
            throw new ServiceException("未找到路径「" + path + "」中的「" + names.get(0) + "」");
        }
        for (int i = 1; i < names.size(); i++)
        {
            String name = names.get(i);
            List<SysDept> next = new ArrayList<SysDept>();
            for (SysDept parent : current)
            {
                for (SysDept d : all)
                {
                    if (parent.getDeptId().equals(d.getParentId()) && name.equals(d.getDeptName()))
                    {
                        next.add(d);
                    }
                }
            }
            if (next.isEmpty())
            {
                throw new ServiceException("未找到路径「" + path + "」中的「" + name + "」");
            }
            current = next;
        }
        if (current.size() > 1)
        {
            throw new ServiceException("路径「" + path + "」匹配到多个班级，请补充更完整上级名称");
        }
        return current.get(0).getDeptId();
    }

    private List<SysDept> resolveTemplateClasses(Long deptId)
    {
        List<SysDept> all = deptService.selectDeptList(new SysDept());
        if (deptId == null)
        {
            return all.stream()
                .filter(d -> "0".equals(StringUtils.nvl(d.getStatus(), "0")))
                .filter(d -> !hasChild(all, d.getDeptId()))
                .sorted(Comparator.comparing(SysDept::getAncestors, Comparator.nullsLast(String::compareTo))
                    .thenComparing(SysDept::getOrderNum, Comparator.nullsLast(Integer::compareTo)))
                .collect(Collectors.toList());
        }
        SysDept selected = deptService.selectDeptById(deptId);
        if (selected == null)
        {
            return Collections.emptyList();
        }
        List<SysDept> under = all.stream()
            .filter(d -> deptId.equals(d.getDeptId())
                || (StringUtils.isNotEmpty(d.getAncestors())
                    && ("," + d.getAncestors() + ",").contains("," + deptId + ",")))
            .filter(d -> "0".equals(StringUtils.nvl(d.getStatus(), "0")))
            .collect(Collectors.toList());
        List<SysDept> leaves = under.stream()
            .filter(d -> !hasChild(under, d.getDeptId()))
            .sorted(Comparator.comparing(SysDept::getOrderNum, Comparator.nullsLast(Integer::compareTo)))
            .collect(Collectors.toList());
        if (!leaves.isEmpty())
        {
            return leaves;
        }
        return Collections.singletonList(selected);
    }

    private boolean hasChild(List<SysDept> list, Long deptId)
    {
        for (SysDept d : list)
        {
            if (deptId.equals(d.getParentId()))
            {
                return true;
            }
        }
        return false;
    }

    private String buildDeptPath(SysDept dept)
    {
        if (dept == null)
        {
            return "";
        }
        List<String> names = new ArrayList<String>();
        names.add(dept.getDeptName());
        String ancestors = dept.getAncestors();
        if (StringUtils.isNotEmpty(ancestors))
        {
            String[] ids = ancestors.split(",");
            for (int i = ids.length - 1; i >= 0; i--)
            {
                String id = ids[i];
                if (StringUtils.isEmpty(id) || "0".equals(id))
                {
                    continue;
                }
                try
                {
                    SysDept parent = deptService.selectDeptById(Long.valueOf(id));
                    if (parent != null && StringUtils.isNotEmpty(parent.getDeptName()))
                    {
                        names.add(0, parent.getDeptName());
                    }
                }
                catch (NumberFormatException ignored)
                {
                }
            }
        }
        if (names.size() >= 2)
        {
            return names.get(names.size() - 2) + "/" + names.get(names.size() - 1);
        }
        return names.get(0);
    }

    private Long createStudentUser(SpasStudent student, Long[] roleIds)
    {
        SysUser user = new SysUser();
        user.setUserName(student.getStudentNo());
        user.setNickName(student.getStudentName());
        user.setDeptId(student.getDeptId());
        user.setPassword(SecurityUtils.encryptPassword(initPassword));
        user.setStatus(StringUtils.isEmpty(student.getStatus()) ? "0" : student.getStatus());
        user.setCreateBy(student.getCreateBy());
        user.setSex(student.getGender());
        user.setRoleIds(roleIds != null ? roleIds : resolveStudentRoleIds());
        userService.insertUser(user);
        return user.getUserId();
    }

    private Long[] resolveStudentRoleIds()
    {
        List<SysRole> roles = roleService.selectRoleAll();
        if (roles != null)
        {
            for (SysRole role : roles)
            {
                if ("spas_student".equals(role.getRoleKey()))
                {
                    return new Long[] { role.getRoleId() };
                }
            }
        }
        throw new ServiceException("未找到角色 spas_student，请先初始化角色数据");
    }
}
