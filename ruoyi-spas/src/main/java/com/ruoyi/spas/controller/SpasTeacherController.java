package com.ruoyi.spas.controller;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.spas.domain.SpasTeacher;
import com.ruoyi.spas.service.ISpasTeacherService;

@RestController
@RequestMapping("/spas/teacher")
public class SpasTeacherController extends BaseController
{
    @Autowired
    private ISpasTeacherService teacherService;

    @PreAuthorize("@ss.hasPermi('spas:teacher:list')")
    @GetMapping("/list")
    public TableDataInfo list(SpasTeacher teacher)
    {
        startPage();
        List<SpasTeacher> list = teacherService.selectSpasTeacherList(teacher);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:teacher:list')")
    @GetMapping("/role-options")
    public AjaxResult roleOptions()
    {
        return success(teacherService.listRoleTypeOptions());
    }

    /** Teaching depts for current user (used by analysis quick switch) */
    @PreAuthorize("@ss.hasAnyPermi('spas:analysis:class,spas:analysis:student,spas:analysis:knowledge,spas:portfolio:list,spas:score:list')")
    @GetMapping("/my-depts")
    public AjaxResult myDepts()
    {
        return success(teacherService.listMyTeachingDepts());
    }

    @Log(title = "Teacher", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('spas:teacher:list')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, SpasTeacher teacher)
    {
        List<SpasTeacher> list = teacherService.selectSpasTeacherList(teacher);
        ExcelUtil<SpasTeacher> util = new ExcelUtil<SpasTeacher>(SpasTeacher.class);
        util.exportExcel(response, list, "teacher");
    }

    @PreAuthorize("@ss.hasPermi('spas:teacher:query')")
    @GetMapping("/{teacherId}")
    public AjaxResult getInfo(@PathVariable Long teacherId)
    {
        return success(teacherService.selectSpasTeacherById(teacherId));
    }

    @PreAuthorize("@ss.hasPermi('spas:teacher:add')")
    @Log(title = "Teacher", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SpasTeacher teacher)
    {
        if (!teacherService.checkTeacherNoUnique(teacher))
        {
            return error("\u5de5\u53f7\u5df2\u5b58\u5728");
        }
        teacher.setCreateBy(getUsername());
        return toAjax(teacherService.insertSpasTeacher(teacher));
    }

    @PreAuthorize("@ss.hasPermi('spas:teacher:edit')")
    @Log(title = "Teacher", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody SpasTeacher teacher)
    {
        if (!teacherService.checkTeacherNoUnique(teacher))
        {
            return error("\u5de5\u53f7\u5df2\u5b58\u5728");
        }
        teacher.setUpdateBy(getUsername());
        return toAjax(teacherService.updateSpasTeacher(teacher));
    }

    @PreAuthorize("@ss.hasPermi('spas:teacher:remove')")
    @Log(title = "Teacher", businessType = BusinessType.DELETE)
    @DeleteMapping("/{teacherIds}")
    public AjaxResult remove(@PathVariable Long[] teacherIds)
    {
        return toAjax(teacherService.deleteSpasTeacherByIds(teacherIds));
    }

    @PreAuthorize("@ss.hasPermi('spas:teacher:resetPwd')")
    @Log(title = "Teacher ResetPwd", businessType = BusinessType.UPDATE)
    @PutMapping("/resetPwd/{teacherId}")
    public AjaxResult resetPwd(@PathVariable Long teacherId)
    {
        return toAjax(teacherService.resetTeacherPwd(teacherId));
    }
}
