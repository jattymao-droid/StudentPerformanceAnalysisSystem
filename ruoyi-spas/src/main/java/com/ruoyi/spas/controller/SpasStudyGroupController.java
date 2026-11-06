package com.ruoyi.spas.controller;

import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.spas.domain.SpasStudyGroup;
import com.ruoyi.spas.service.ISpasStudyGroupService;
import com.ruoyi.spas.support.SpasAccessService;

@RestController
@RequestMapping("/spas/group")
public class SpasStudyGroupController extends BaseController
{
    @Autowired
    private ISpasStudyGroupService groupService;

    @Autowired
    private SpasAccessService accessService;

    @PreAuthorize("@ss.hasPermi('spas:group:list')")
    @GetMapping("/list")
    public TableDataInfo list(SpasStudyGroup query)
    {
        startPage();
        List<SpasStudyGroup> list = groupService.selectSpasStudyGroupList(query);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:group:list')")
    @GetMapping("/unassigned")
    public AjaxResult unassigned(@RequestParam Long deptId,
        @RequestParam(required = false) Long subjectId)
    {
        return success(groupService.selectUnassignedStudents(deptId, subjectId));
    }

    /** Smart grouping: mode=unassigned|rebuild, groupSize=3..8 (default 5) */
    @PreAuthorize("@ss.hasPermi('spas:group:add')")
    @Log(title = "智能分组", businessType = BusinessType.INSERT)
    @PostMapping("/smart")
    public AjaxResult smart(@RequestBody Map<String, Object> body)
    {
        Long deptId = body.get("deptId") == null ? null : Long.valueOf(body.get("deptId").toString());
        Long subjectId = body.get("subjectId") == null || "".equals(String.valueOf(body.get("subjectId")))
            ? null : Long.valueOf(body.get("subjectId").toString());
        Integer groupSize = body.get("groupSize") == null ? null : Integer.valueOf(body.get("groupSize").toString());
        String mode = body.get("mode") == null ? "unassigned" : String.valueOf(body.get("mode"));
        Long examId = body.get("examId") == null || "".equals(String.valueOf(body.get("examId")))
            ? null : Long.valueOf(body.get("examId").toString());
        return success(groupService.smartAssign(deptId, subjectId, groupSize, mode, examId, getUsername()));
    }

    /** Export all active groups' weak knowledge for a class (pdf|xlsx). Frontend download() posts form. */
    @PreAuthorize("@ss.hasPermi('spas:group:query') or @ss.hasPermi('spas:group:list') or @ss.hasPermi('spas:group:export')")
    @Log(title = "小组薄弱导出", businessType = BusinessType.EXPORT)
    @PostMapping("/weak/export")
    public void exportDeptWeak(HttpServletResponse response,
        @RequestParam Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false, defaultValue = "xlsx") String format)
    {
        groupService.exportDeptGroupsWeak(deptId, subjectId, format, response);
    }

    /** Group scores + multi-exam trend (subject scoped). */
    @PreAuthorize("@ss.hasPermi('spas:group:query') or @ss.hasPermi('spas:group:list')")
    @GetMapping("/{groupId}/performance")
    public AjaxResult performance(@PathVariable Long groupId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) Long examId)
    {
        return success(groupService.selectGroupPerformance(groupId, subjectId, examId));
    }

    /** Export one group's weak knowledge (pdf|xlsx). Frontend download() posts form. */
    @PreAuthorize("@ss.hasPermi('spas:group:query') or @ss.hasPermi('spas:group:list') or @ss.hasPermi('spas:group:export')")
    @Log(title = "小组薄弱导出", businessType = BusinessType.EXPORT)
    @PostMapping("/{groupId}/weak/export")
    public void exportGroupWeak(HttpServletResponse response,
        @PathVariable Long groupId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false, defaultValue = "xlsx") String format)
    {
        groupService.exportGroupWeak(groupId, subjectId, format, response);
    }

    @PreAuthorize("@ss.hasPermi('spas:group:query')")
    @GetMapping("/{groupId}")
    public AjaxResult getInfo(@PathVariable Long groupId)
    {
        return success(groupService.selectSpasStudyGroupById(groupId));
    }

    @PreAuthorize("@ss.hasPermi('spas:group:add')")
    @Log(title = "班级分组", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SpasStudyGroup group)
    {
        group.setCreateBy(getUsername());
        groupService.insertSpasStudyGroup(group);
        return success(groupService.selectSpasStudyGroupById(group.getGroupId()));
    }

    @PreAuthorize("@ss.hasPermi('spas:group:edit')")
    @Log(title = "班级分组", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SpasStudyGroup group)
    {
        group.setUpdateBy(getUsername());
        groupService.updateSpasStudyGroup(group);
        return success(groupService.selectSpasStudyGroupById(group.getGroupId()));
    }

    @PreAuthorize("@ss.hasPermi('spas:group:remove')")
    @Log(title = "班级分组", businessType = BusinessType.DELETE)
    @DeleteMapping("/{groupIds}")
    public AjaxResult remove(@PathVariable Long[] groupIds)
    {
        return toAjax(groupService.deleteSpasStudyGroupByIds(groupIds));
    }

    @PreAuthorize("@ss.hasPermi('spas:group:edit')")
    @Log(title = "分组成员", businessType = BusinessType.UPDATE)
    @PutMapping("/{groupId}/members")
    public AjaxResult members(@PathVariable Long groupId, @RequestBody SpasStudyGroup body)
    {
        accessService.assertCanWrite();
        Long leader = body == null ? null : body.getLeaderStudentId();
        Long[] ids = body == null ? null : body.getStudentIds();
        groupService.replaceMembers(groupId, ids, leader);
        return success(groupService.selectSpasStudyGroupById(groupId));
    }
}
