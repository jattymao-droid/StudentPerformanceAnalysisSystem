package com.ruoyi.spas.controller;

import java.util.List;
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
        return toAjax(groupService.insertSpasStudyGroup(group));
    }

    @PreAuthorize("@ss.hasPermi('spas:group:edit')")
    @Log(title = "班级分组", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SpasStudyGroup group)
    {
        group.setUpdateBy(getUsername());
        return toAjax(groupService.updateSpasStudyGroup(group));
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
        return toAjax(groupService.replaceMembers(groupId, ids, leader));
    }

    @PreAuthorize("@ss.hasPermi('spas:group:list')")
    @GetMapping("/unassigned")
    public AjaxResult unassigned(@RequestParam Long deptId,
        @RequestParam(required = false) Long subjectId)
    {
        return success(groupService.selectUnassignedStudents(deptId, subjectId));
    }
}
