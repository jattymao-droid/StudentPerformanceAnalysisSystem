package com.ruoyi.spas.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
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
import com.ruoyi.spas.domain.SpasClassTeacherBind;
import com.ruoyi.spas.domain.SpasTeacher;
import com.ruoyi.spas.mapper.SpasTeacherDeptMapper;
import com.ruoyi.spas.mapper.SpasTeacherMapper;
import com.ruoyi.spas.service.ISpasTeacherService;
import com.ruoyi.spas.support.SpasPageGuard;
import com.ruoyi.spas.support.SpasAccessService;
import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.system.mapper.SysDeptMapper;
import com.ruoyi.system.mapper.SysRoleMapper;
import com.ruoyi.system.service.ISysUserService;

@Service
public class SpasTeacherServiceImpl implements ISpasTeacherService
{
    @Autowired
    private SpasTeacherMapper teacherMapper;

    @Autowired
    private ISysUserService userService;

    @Autowired
    private SysRoleMapper roleMapper;

    @Autowired
    private SpasTeacherDeptMapper teacherDeptMapper;

    @Autowired
    private SysDeptMapper deptMapper;

    @Autowired
    private SpasAccessService accessService;

    @Value("${spas.student.init-password:123456}")
    private String initPassword;

    @Override
    @DataScope(deptAlias = "d")
    public List<SpasTeacher> selectSpasTeacherList(SpasTeacher teacher)
    {
        List<SpasTeacher> list = teacherMapper.selectSpasTeacherList(teacher);
        for (SpasTeacher row : list)
        {
            row.setRoleKey(resolveDisplayRoleKey(row));
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
            teacher.setRoleKey(resolveDisplayRoleKey(teacher));
            fillExtraDepts(teacher);
        }
        return teacher;
    }

    @Override
    public boolean checkTeacherNoUnique(SpasTeacher teacher)
    {
        Long teacherId = StringUtils.isNull(teacher.getTeacherId()) ? -1L : teacher.getTeacherId();
        SpasTeacher info = SpasPageGuard.withoutPage(
            () -> teacherMapper.checkTeacherNoUnique(teacher.getTeacherNo()));
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
        if (SpasTeacher.TYPE_HOMEROOM.equals(teacher.getTeacherType()) && teacher.getHomeroomDeptId() == null)
        {
            teacherMapper.updateHomeroomDeptId(teacher.getTeacherId(), teacher.getDeptId());
            teacher.setHomeroomDeptId(teacher.getDeptId());
        }
        else if (teacher.getHomeroomDeptId() != null)
        {
            teacherMapper.updateHomeroomDeptId(teacher.getTeacherId(), teacher.getHomeroomDeptId());
        }
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
            if (SpasTeacher.TYPE_HOMEROOM.equals(newType) && teacher.getDeptId() != null)
            {
                teacherMapper.updateHomeroomDeptId(teacher.getTeacherId(), teacher.getDeptId());
            }
            else if (SpasTeacher.TYPE_SUBJECT.equals(newType) && teacher.getHomeroomDeptId() == null
                && db.getHomeroomDeptId() != null && !teacher.getDeptId().equals(db.getHomeroomDeptId()))
            {
                // keep existing homeroom flag unless type becomes grade/school
            }
            if (SpasTeacher.TYPE_GRADE.equals(newType) || SpasTeacher.TYPE_SCHOOL.equals(newType))
            {
                teacherMapper.updateHomeroomDeptId(teacher.getTeacherId(), null);
            }
            SpasTeacher refreshed = teacherMapper.selectSpasTeacherById(teacher.getTeacherId());
            syncUserRoles(refreshed != null ? refreshed : db);
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
        return SpasPageGuard.withoutPage(() -> {
            List<Map<String, Object>> result = new ArrayList<>();
            // Admins see full org tree on the frontend; do not pretend they are class-bound.
            if (accessService.isFullDataAccess())
            {
                return result;
            }
            Long userId = SecurityUtils.getUserId();
            SpasTeacher teacher = teacherMapper.selectSpasTeacherByUserId(userId);
            if (teacher != null)
            {
                String baseType = teacher.getTeacherType();
                Long homeroomDeptId = teacher.getHomeroomDeptId();
                if (homeroomDeptId == null && SpasTeacher.TYPE_HOMEROOM.equals(baseType))
                {
                    homeroomDeptId = teacher.getDeptId();
                }
                List<Long> extras = teacherDeptMapper.selectDeptIdsByTeacherId(teacher.getTeacherId());
                Set<Long> teaching = new LinkedHashSet<>();
                if (teacher.getDeptId() != null)
                {
                    teaching.add(teacher.getDeptId());
                }
                if (homeroomDeptId != null)
                {
                    teaching.add(homeroomDeptId);
                }
                if (extras != null)
                {
                    teaching.addAll(extras);
                }
                boolean first = true;
                for (Long deptId : teaching)
                {
                    boolean isHomeroom = deptId.equals(homeroomDeptId);
                    boolean isSubject = teachesDept(teacher, deptId, extras);
                    String roleType = roleTypeForClass(isHomeroom, isSubject, baseType);
                    addDeptOption(result, deptId, first, roleType);
                    first = false;
                }
                return result;
            }
            // Non-teacher accounts: empty list (use system dept tree / DataScope), do not bind personal dept
            return result;
        });
    }

    @Override
    public Map<String, Object> getClassBinding(Long deptId)
    {
        SysDept dept = requireClassDept(deptId);
        Map<String, Object> data = new HashMap<>();
        data.put("deptId", dept.getDeptId());
        data.put("deptName", dept.getDeptName());
        data.put("classNode", Boolean.TRUE);
        SpasTeacher homeroom = findHomeroomByDept(deptId);
        data.put("homeroom", homeroom == null ? null : briefTeacher(homeroom, Boolean.TRUE));
        List<Map<String, Object>> subjects = new ArrayList<>();
        List<Long> subjectIds = new ArrayList<>();
        for (SpasTeacher teacher : teacherMapper.selectSubjectBoundToDept(deptId))
        {
            boolean primary = deptId.equals(teacher.getDeptId());
            subjects.add(briefTeacher(teacher, primary));
            subjectIds.add(teacher.getTeacherId());
        }
        data.put("subjects", subjects);
        data.put("subjectTeacherIds", subjectIds);
        List<Map<String, Object>> options = new ArrayList<>();
        Set<Long> listed = new LinkedHashSet<>();
        for (SpasTeacher teacher : teacherMapper.selectClassroomTeachers())
        {
            options.add(briefTeacher(teacher, deptId.equals(teacher.getDeptId())));
            listed.add(teacher.getTeacherId());
        }
        if (homeroom != null && !listed.contains(homeroom.getTeacherId()))
        {
            options.add(0, briefTeacher(homeroom, Boolean.TRUE));
            listed.add(homeroom.getTeacherId());
        }
        for (SpasTeacher teacher : teacherMapper.selectSubjectBoundToDept(deptId))
        {
            if (!listed.contains(teacher.getTeacherId()))
            {
                options.add(briefTeacher(teacher, deptId.equals(teacher.getDeptId())));
            }
        }
        data.put("homeroomOptions", options);
        data.put("subjectOptions", options);
        return data;
    }

    @Override
    @Transactional
    public String saveClassBinding(SpasClassTeacherBind bind, String operator)
    {
        if (bind == null || bind.getDeptId() == null)
        {
            throw new ServiceException("\u8bf7\u9009\u62e9\u73ed\u7ea7");
        }
        Long deptId = bind.getDeptId();
        SysDept dept = requireClassDept(deptId);
        Long parentId = dept.getParentId();
        List<String> notes = new ArrayList<>();
        Set<Long> subjectIds = new LinkedHashSet<>();
        if (bind.getSubjectTeacherIds() != null)
        {
            for (Long teacherId : bind.getSubjectTeacherIds())
            {
                if (teacherId != null)
                {
                    subjectIds.add(teacherId);
                }
            }
        }
        Long homeroomId = bind.getHomeroomTeacherId();
        if (homeroomId != null)
        {
            requireClassroomTeacher(homeroomId, "\u73ed\u4e3b\u4efb");
        }
        for (Long teacherId : subjectIds)
        {
            requireClassroomTeacher(teacherId, "\u79d1\u4efb\u6559\u5e08");
        }

        SpasTeacher currentHomeroom = findHomeroomByDept(deptId);
        if (homeroomId == null)
        {
            if (currentHomeroom != null)
            {
                clearHomeroomRole(currentHomeroom, deptId, parentId, subjectIds.contains(currentHomeroom.getTeacherId()), operator, notes);
            }
        }
        else
        {
            if (currentHomeroom != null && !currentHomeroom.getTeacherId().equals(homeroomId))
            {
                clearHomeroomRole(currentHomeroom, deptId, parentId, subjectIds.contains(currentHomeroom.getTeacherId()), operator, notes);
            }
            SpasTeacher next = teacherMapper.selectSpasTeacherById(homeroomId);
            assignHomeroom(next, deptId, subjectIds.contains(homeroomId), operator, notes);
        }

        List<SpasTeacher> bound = teacherMapper.selectSubjectBoundToDept(deptId);
        for (SpasTeacher teacher : bound)
        {
            if (subjectIds.contains(teacher.getTeacherId()))
            {
                continue;
            }
            boolean keepHomeroom = teacher.getTeacherId().equals(homeroomId)
                || deptId.equals(teacher.getHomeroomDeptId());
            if (keepHomeroom)
            {
                detachSubjectKeepHomeroom(teacher, deptId, operator, notes);
            }
            else if (deptId.equals(teacher.getDeptId()))
            {
                detachPrimaryClass(teacher, deptId, parentId, operator, notes);
            }
            else
            {
                teacherDeptMapper.deleteTeacherDept(teacher.getTeacherId(), deptId);
            }
        }
        for (Long teacherId : subjectIds)
        {
            SpasTeacher teacher = teacherMapper.selectSpasTeacherById(teacherId);
            ensureSubjectOnClass(teacher, deptId, teacherId.equals(homeroomId), operator, notes);
        }
        if (notes.isEmpty())
        {
            return "\u73ed\u7ea7\u6559\u5e08\u7ed1\u5b9a\u5df2\u4fdd\u5b58\uff08\u540c\u4e00\u4eba\u53ef\u517c\u4efb\u73ed\u4e3b\u4efb\u4e0e\u79d1\u4efb\uff09";
        }
        return "\u73ed\u7ea7\u6559\u5e08\u7ed1\u5b9a\u5df2\u4fdd\u5b58\u3002" + String.join("\uff1b", notes);
    }

    private SpasTeacher requireClassroomTeacher(Long teacherId, String label)
    {
        SpasTeacher teacher = teacherMapper.selectSpasTeacherById(teacherId);
        if (teacher == null || !(SpasTeacher.TYPE_SUBJECT.equals(teacher.getTeacherType())
            || SpasTeacher.TYPE_HOMEROOM.equals(teacher.getTeacherType())))
        {
            throw new ServiceException(label + "\u4e0d\u5b58\u5728\u6216\u4e0d\u662f\u73ed\u7ea7\u6559\u5e08");
        }
        if (!"0".equals(teacher.getStatus()))
        {
            throw new ServiceException("\u6559\u5e08\u300c" + teacher.getTeacherName() + "\u300d\u5df2\u505c\u7528");
        }
        return teacher;
    }

    private void assignHomeroom(SpasTeacher teacher, Long deptId, boolean alsoSubject, String operator, List<String> notes)
    {
        Long oldPrimary = teacher.getDeptId();
        if (!deptId.equals(oldPrimary))
        {
            moveTeacherDept(teacher, deptId, operator);
            if (oldPrimary != null && isClassDept(oldPrimary))
            {
                List<Long> extras = teacherDeptMapper.selectDeptIdsByTeacherId(teacher.getTeacherId());
                if (extras == null || !extras.contains(oldPrimary))
                {
                    teacherDeptMapper.insertTeacherDept(teacher.getTeacherId(), oldPrimary);
                }
            }
        }
        teacherMapper.updateHomeroomDeptId(teacher.getTeacherId(), deptId);
        teacher.setHomeroomDeptId(deptId);
        if (alsoSubject)
        {
            if (!SpasTeacher.TYPE_SUBJECT.equals(teacher.getTeacherType()))
            {
                patchTeacherType(teacher, SpasTeacher.TYPE_SUBJECT, operator);
            }
        }
        else
        {
            teacherDeptMapper.deleteTeacherDept(teacher.getTeacherId(), deptId);
            if (!SpasTeacher.TYPE_HOMEROOM.equals(teacher.getTeacherType()))
            {
                patchTeacherType(teacher, SpasTeacher.TYPE_HOMEROOM, operator);
            }
        }
        syncUserRoles(teacher);
    }

    private void clearHomeroomRole(SpasTeacher teacher, Long deptId, Long parentId, boolean remainSubject,
        String operator, List<String> notes)
    {
        teacherMapper.updateHomeroomDeptId(teacher.getTeacherId(), null);
        teacher.setHomeroomDeptId(null);
        if (remainSubject)
        {
            if (!SpasTeacher.TYPE_SUBJECT.equals(teacher.getTeacherType()))
            {
                patchTeacherType(teacher, SpasTeacher.TYPE_SUBJECT, operator);
            }
            notes.add("\u300c" + teacher.getTeacherName() + "\u300d\u5df2\u89e3\u9664\u73ed\u4e3b\u4efb\uff0c\u4ecd\u4fdd\u7559\u79d1\u4efb");
        }
        else
        {
            if (deptId.equals(teacher.getDeptId()))
            {
                parkTeacher(teacher, parentId, operator);
            }
            notes.add("\u539f\u73ed\u4e3b\u4efb\u300c" + teacher.getTeacherName() + "\u300d\u5df2\u89e3\u9664");
        }
        syncUserRoles(teacher);
    }

    private void ensureSubjectOnClass(SpasTeacher teacher, Long deptId, boolean alsoHomeroom, String operator, List<String> notes)
    {
        if (!SpasTeacher.TYPE_SUBJECT.equals(teacher.getTeacherType())
            && !SpasTeacher.TYPE_HOMEROOM.equals(teacher.getTeacherType()))
        {
            return;
        }
        if (!SpasTeacher.TYPE_SUBJECT.equals(teacher.getTeacherType()))
        {
            patchTeacherType(teacher, SpasTeacher.TYPE_SUBJECT, operator);
        }
        if (alsoHomeroom)
        {
            teacherMapper.updateHomeroomDeptId(teacher.getTeacherId(), deptId);
            teacher.setHomeroomDeptId(deptId);
        }
        if (deptId.equals(teacher.getDeptId()))
        {
            syncUserRoles(teacher);
            return;
        }
        List<Long> extras = teacherDeptMapper.selectDeptIdsByTeacherId(teacher.getTeacherId());
        if (extras != null && extras.contains(deptId))
        {
            syncUserRoles(teacher);
            return;
        }
        if (teacher.getDeptId() != null && isClassDept(teacher.getDeptId()))
        {
            teacherDeptMapper.insertTeacherDept(teacher.getTeacherId(), deptId);
        }
        else
        {
            moveTeacherDept(teacher, deptId, operator);
        }
        syncUserRoles(teacher);
    }

    private void detachSubjectKeepHomeroom(SpasTeacher teacher, Long deptId, String operator, List<String> notes)
    {
        teacherDeptMapper.deleteTeacherDept(teacher.getTeacherId(), deptId);
        if (!deptId.equals(teacher.getDeptId()))
        {
            syncUserRoles(teacher);
            return;
        }
        if (!SpasTeacher.TYPE_HOMEROOM.equals(teacher.getTeacherType()))
        {
            patchTeacherType(teacher, SpasTeacher.TYPE_HOMEROOM, operator);
        }
        teacherMapper.updateHomeroomDeptId(teacher.getTeacherId(), deptId);
        teacher.setHomeroomDeptId(deptId);
        notes.add("\u300c" + teacher.getTeacherName() + "\u300d\u5df2\u79fb\u9664\u79d1\u4efb\uff0c\u4ecd\u4e3a\u73ed\u4e3b\u4efb");
        syncUserRoles(teacher);
    }

    private void patchTeacherType(SpasTeacher teacher, String type, String operator)
    {
        SpasTeacher patch = new SpasTeacher();
        patch.setTeacherId(teacher.getTeacherId());
        patch.setTeacherType(type);
        patch.setUpdateBy(operator);
        teacherMapper.updateSpasTeacher(patch);
        teacher.setTeacherType(type);
    }

    private boolean teachesDept(SpasTeacher teacher, Long deptId, List<Long> extras)
    {
        if (deptId == null)
        {
            return false;
        }
        if (extras != null && extras.contains(deptId))
        {
            return true;
        }
        return SpasTeacher.TYPE_SUBJECT.equals(teacher.getTeacherType()) && deptId.equals(teacher.getDeptId());
    }

    private String roleTypeForClass(boolean isHomeroom, boolean isSubject, String baseType)
    {
        if (isHomeroom && isSubject)
        {
            return "12";
        }
        if (isHomeroom)
        {
            return SpasTeacher.TYPE_HOMEROOM;
        }
        if (isSubject)
        {
            return SpasTeacher.TYPE_SUBJECT;
        }
        return baseType;
    }

    private boolean isClassDept(Long deptId)
    {
        return deptId != null && deptMapper.selectNormalChildrenDeptById(deptId) == 0;
    }

    private void detachPrimaryClass(SpasTeacher teacher, Long deptId, Long parentId, String operator, List<String> notes)
    {
        List<Long> extras = teacherDeptMapper.selectDeptIdsByTeacherId(teacher.getTeacherId());
        Long promote = null;
        if (extras != null)
        {
            for (Long extraId : extras)
            {
                if (extraId != null && !extraId.equals(deptId))
                {
                    promote = extraId;
                    break;
                }
            }
        }
        if (promote != null)
        {
            moveTeacherDept(teacher, promote, operator);
            teacherDeptMapper.deleteTeacherDept(teacher.getTeacherId(), promote);
            notes.add("\u79d1\u4efb\u300c" + teacher.getTeacherName() + "\u300d\u7684\u4e3b\u5c5e\u73ed\u7ea7\u5df2\u6539\u6302");
            return;
        }
        parkTeacher(teacher, parentId, operator);
        notes.add("\u79d1\u4efb\u300c" + teacher.getTeacherName() + "\u300d\u5df2\u6539\u6302\u5230\u4e0a\u7ea7\u90e8\u95e8");
    }

    private void parkTeacher(SpasTeacher teacher, Long parentId, String operator)
    {
        if (parentId == null || parentId.longValue() == 0L)
        {
            throw new ServiceException("\u65e0\u6cd5\u89e3\u7ed1\uff1a\u73ed\u7ea7\u6ca1\u6709\u4e0a\u7ea7\u90e8\u95e8\uff0c\u8bf7\u5148\u4e3a\u8be5\u6559\u5e08\u6307\u5b9a\u5176\u4ed6\u73ed\u7ea7");
        }
        moveTeacherDept(teacher, parentId, operator);
    }

    private void moveTeacherDept(SpasTeacher teacher, Long deptId, String operator)
    {
        if (teacher == null || deptId == null || deptId.equals(teacher.getDeptId()))
        {
            return;
        }
        SpasTeacher patch = new SpasTeacher();
        patch.setTeacherId(teacher.getTeacherId());
        patch.setDeptId(deptId);
        patch.setUpdateBy(operator);
        teacherMapper.updateSpasTeacher(patch);
        teacher.setDeptId(deptId);
        if (teacher.getUserId() != null)
        {
            SysUser user = new SysUser();
            user.setUserId(teacher.getUserId());
            user.setDeptId(deptId);
            user.setUpdateBy(operator);
            userService.updateUserProfile(user);
        }
    }

    private SpasTeacher findHomeroomByDept(Long deptId)
    {
        return SpasPageGuard.withoutPage(() -> teacherMapper.selectHomeroomByDept(deptId));
    }

    private SysDept requireClassDept(Long deptId)
    {
        if (deptId == null)
        {
            throw new ServiceException("\u8bf7\u9009\u62e9\u73ed\u7ea7");
        }
        SysDept dept = deptMapper.selectDeptById(deptId);
        if (dept == null || !"0".equals(dept.getDelFlag()))
        {
            throw new ServiceException("\u73ed\u7ea7\u4e0d\u5b58\u5728");
        }
        if (deptMapper.selectNormalChildrenDeptById(deptId) > 0)
        {
            throw new ServiceException("\u8bf7\u9009\u62e9\u5177\u4f53\u73ed\u7ea7\uff0c\u4e0d\u80fd\u7ed1\u5b9a\u5230\u5e74\u7ea7\u6216\u5b66\u6821");
        }
        return dept;
    }

    private Map<String, Object> briefTeacher(SpasTeacher teacher, Boolean primary)
    {
        Map<String, Object> row = new HashMap<>();
        row.put("teacherId", teacher.getTeacherId());
        row.put("teacherNo", teacher.getTeacherNo());
        row.put("teacherName", teacher.getTeacherName());
        row.put("deptId", teacher.getDeptId());
        row.put("deptName", teacher.getDeptName());
        row.put("status", teacher.getStatus());
        if (primary != null)
        {
            row.put("primary", primary);
        }
        return row;
    }

    private void addDeptOption(List<Map<String, Object>> result, Long deptId, boolean primary, String teacherType)
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
        if (StringUtils.isNotEmpty(teacherType))
        {
            m.put("teacherType", teacherType);
        }
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
        if (SpasTeacher.TYPE_SUBJECT.equals(teacher.getTeacherType()) || SpasTeacher.TYPE_HOMEROOM.equals(teacher.getTeacherType()))
        {
            assertClassDept(teacher.getDeptId());
        }
        if (SpasTeacher.TYPE_HOMEROOM.equals(teacher.getTeacherType()) || teacher.getHomeroomDeptId() != null)
        {
            Long homeDept = teacher.getHomeroomDeptId() != null ? teacher.getHomeroomDeptId() : teacher.getDeptId();
            SpasTeacher other = findHomeroomByDept(homeDept);
            if (other != null && (teacher.getTeacherId() == null || !other.getTeacherId().equals(teacher.getTeacherId())))
            {
                throw new ServiceException("\u8be5\u73ed\u5df2\u6709\u73ed\u4e3b\u4efb\u300c" + other.getTeacherName()
                    + "\u300d\uff0c\u8bf7\u5148\u5728\u5de6\u4fa7\u9009\u4e2d\u8be5\u73ed\u540e\u66f4\u6362\u7ed1\u5b9a");
            }
        }
        if (SpasTeacher.TYPE_HOMEROOM.equals(teacher.getTeacherType()) && teacher.getHomeroomDeptId() == null)
        {
            teacher.setHomeroomDeptId(teacher.getDeptId());
        }
    }

    private void assertClassDept(Long deptId)
    {
        if (deptMapper.selectNormalChildrenDeptById(deptId) > 0)
        {
            throw new ServiceException("\u4efb\u8bfe\u6559\u5e08\u548c\u73ed\u4e3b\u4efb\u53ea\u80fd\u7ed1\u5b9a\u5230\u73ed\u7ea7");
        }
    }

    private void saveExtraDepts(SpasTeacher teacher)
    {
        if (teacher.getTeacherId() == null)
        {
            return;
        }
        teacherDeptMapper.deleteByTeacherId(teacher.getTeacherId());
        List<Long> extraDeptIds = teacher.getExtraDeptIds();
        if (extraDeptIds == null || extraDeptIds.isEmpty())
        {
            return;
        }
        if (!(SpasTeacher.TYPE_SUBJECT.equals(teacher.getTeacherType())
            || SpasTeacher.TYPE_HOMEROOM.equals(teacher.getTeacherType())))
        {
            return;
        }
        for (Long deptId : extraDeptIds)
        {
            if (deptId == null || deptId.equals(teacher.getDeptId()))
            {
                continue;
            }
            if (deptMapper.selectNormalChildrenDeptById(deptId) > 0)
            {
                throw new ServiceException("\u9644\u52a0\u73ed\u7ea7\u53ea\u80fd\u9009\u62e9\u5177\u4f53\u73ed\u7ea7");
            }
            teacherDeptMapper.insertTeacherDept(teacher.getTeacherId(), deptId);
        }
    }

    private void fillExtraDepts(SpasTeacher teacher)
    {
        if (teacher == null)
        {
            return;
        }
        Long homeId = teacher.getHomeroomDeptId();
        if (homeId == null && SpasTeacher.TYPE_HOMEROOM.equals(teacher.getTeacherType()))
        {
            homeId = teacher.getDeptId();
        }
        if (homeId != null)
        {
            if (homeId.equals(teacher.getDeptId()) && StringUtils.isNotEmpty(teacher.getDeptName()))
            {
                teacher.setHomeroomDeptName(teacher.getDeptName());
            }
            else
            {
                SysDept homeDept = deptMapper.selectDeptById(homeId);
                if (homeDept != null)
                {
                    teacher.setHomeroomDeptName(homeDept.getDeptName());
                }
            }
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
        user.setRoleIds(resolveRoleIds(teacher));
        userService.insertUser(user);
        return user.getUserId();
    }

    private void syncUserRoles(SpasTeacher teacher)
    {
        if (teacher == null || teacher.getUserId() == null)
        {
            return;
        }
        SysUser user = userService.selectUserById(teacher.getUserId());
        if (user == null)
        {
            return;
        }
        user.setRoleIds(resolveRoleIds(teacher));
        userService.updateUser(user);
    }

    private Long[] resolveRoleIds(SpasTeacher teacher)
    {
        String type = teacher.getTeacherType();
        if (SpasTeacher.TYPE_GRADE.equals(type) || SpasTeacher.TYPE_SCHOOL.equals(type))
        {
            return new Long[] { resolveRoleId(type) };
        }
        Long homeroomDeptId = teacher.getHomeroomDeptId();
        if (homeroomDeptId == null && SpasTeacher.TYPE_HOMEROOM.equals(type))
        {
            homeroomDeptId = teacher.getDeptId();
        }
        List<Long> extras = teacherDeptMapper.selectDeptIdsByTeacherId(teacher.getTeacherId());
        boolean subject = SpasTeacher.TYPE_SUBJECT.equals(type)
            || (extras != null && !extras.isEmpty());
        boolean homeroom = homeroomDeptId != null || SpasTeacher.TYPE_HOMEROOM.equals(type);
        List<Long> roleIds = new ArrayList<>();
        if (subject)
        {
            roleIds.add(resolveRoleId(SpasTeacher.TYPE_SUBJECT));
        }
        if (homeroom)
        {
            Long bzr = resolveRoleId(SpasTeacher.TYPE_HOMEROOM);
            if (!roleIds.contains(bzr))
            {
                roleIds.add(bzr);
            }
        }
        if (roleIds.isEmpty())
        {
            roleIds.add(resolveRoleId(type));
        }
        return roleIds.toArray(new Long[0]);
    }

    private String resolveDisplayRoleKey(SpasTeacher teacher)
    {
        String type = teacher.getTeacherType();
        if (SpasTeacher.TYPE_GRADE.equals(type) || SpasTeacher.TYPE_SCHOOL.equals(type))
        {
            return resolveRoleKey(type);
        }
        Long home = teacher.getHomeroomDeptId();
        if (home == null && SpasTeacher.TYPE_HOMEROOM.equals(type))
        {
            home = teacher.getDeptId();
        }
        List<Long> extras = teacher.getExtraDeptIds();
        if (extras == null)
        {
            extras = teacherDeptMapper.selectDeptIdsByTeacherId(teacher.getTeacherId());
        }
        boolean subject = SpasTeacher.TYPE_SUBJECT.equals(type) || (extras != null && !extras.isEmpty());
        boolean homeroom = home != null;
        if (subject && (homeroom))
        {
            return "spas_teacher+spas_bzr";
        }
        if (homeroom)
        {
            return "spas_bzr";
        }
        return "spas_teacher";
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
        SysRole role = SpasPageGuard.withoutPage(() -> roleMapper.checkRoleKeyUnique(roleKey));
        if (role != null && role.getRoleId() != null && roleKey.equals(role.getRoleKey()))
        {
            return role.getRoleId();
        }
        throw new ServiceException("Role not found: " + roleKey);
    }
}
