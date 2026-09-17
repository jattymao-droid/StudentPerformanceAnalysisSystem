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
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.service.ISpasStudentService;
import com.ruoyi.spas.support.SpasAccessService;

/**
 * Student controller
 */
@RestController
@RequestMapping("/spas/student")
public class SpasStudentController extends BaseController
{
    @Autowired
    private ISpasStudentService studentService;

    @Autowired
    private SpasAccessService accessService;

    @PreAuthorize("@ss.hasPermi('spas:student:list')")
    @GetMapping("/list")
    public TableDataInfo list(SpasStudent student)
    {
        startPage();
        List<SpasStudent> list = studentService.selectSpasStudentList(student);
        return getDataTable(list);
    }

    @Log(title = "Student", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('spas:student:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, SpasStudent student)
    {
        List<SpasStudent> list = studentService.selectSpasStudentList(student);
        ExcelUtil<SpasStudent> util = new ExcelUtil<SpasStudent>(SpasStudent.class);
        util.exportExcel(response, list, "student");
    }

    @PreAuthorize("@ss.hasPermi('spas:student:query')")
    @GetMapping(value = "/{studentId}")
    public AjaxResult getInfo(@PathVariable Long studentId)
    {
        accessService.checkStudentAccess(studentId);
        return success(studentService.selectSpasStudentById(studentId));
    }

    @PreAuthorize("@ss.hasPermi('spas:student:add')")
    @Log(title = "Student", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SpasStudent student)
    {
        accessService.assertCanWrite();
        if (!studentService.checkStudentNoUnique(student))
        {
            return error("学号已存在");
        }
        student.setCreateBy(getUsername());
        return toAjax(studentService.insertSpasStudent(student));
    }

    @PreAuthorize("@ss.hasPermi('spas:student:edit')")
    @Log(title = "Student", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody SpasStudent student)
    {
        accessService.assertCanWrite();
        if (!studentService.checkStudentNoUnique(student))
        {
            return error("学号已存在");
        }
        student.setUpdateBy(getUsername());
        return toAjax(studentService.updateSpasStudent(student));
    }

    @PreAuthorize("@ss.hasPermi('spas:student:remove')")
    @Log(title = "Student", businessType = BusinessType.DELETE)
    @DeleteMapping("/{studentIds}")
    public AjaxResult remove(@PathVariable Long[] studentIds)
    {
        accessService.assertCanWrite();
        return toAjax(studentService.deleteSpasStudentByIds(studentIds));
    }

    @Log(title = "Student", businessType = BusinessType.IMPORT)
    @PreAuthorize("@ss.hasPermi('spas:student:import')")
    @PostMapping("/importData")
    public AjaxResult importData(MultipartFile file, boolean updateSupport) throws Exception
    {
        accessService.assertCanWrite();
        ExcelUtil<SpasStudent> util = new ExcelUtil<SpasStudent>(SpasStudent.class);
        List<SpasStudent> studentList = util.importExcel(file.getInputStream());
        String message = studentService.importStudent(studentList, updateSupport, getUsername());
        return success(message);
    }

    @PreAuthorize("@ss.hasPermi('spas:student:import')")
    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response, Long deptId)
    {
        List<SpasStudent> list = studentService.buildImportTemplateRows(deptId);
        ExcelUtil<SpasStudent> util = new ExcelUtil<SpasStudent>(SpasStudent.class);
        util.init(list, "student", StringUtils.EMPTY, com.ruoyi.common.annotation.Excel.Type.IMPORT);
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("utf-8");
        util.exportExcel(response);
    }

    @PreAuthorize("@ss.hasPermi('spas:student:resetPwd')")
    @Log(title = "Student ResetPwd", businessType = BusinessType.UPDATE)
    @PutMapping("/resetPwd/{studentId}")
    public AjaxResult resetPwd(@PathVariable Long studentId)
    {
        accessService.assertCanWrite();
        return toAjax(studentService.resetStudentPwd(studentId));
    }
}
