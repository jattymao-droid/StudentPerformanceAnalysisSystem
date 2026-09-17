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
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.spas.domain.SpasOpenClient;
import com.ruoyi.spas.domain.SpasParent;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.service.ISpasOpenAdminService;

/**
 * Open API client and parent binding admin
 */
@RestController
@RequestMapping("/spas/open")
public class SpasOpenAdminController extends BaseController
{
    @Autowired
    private ISpasOpenAdminService openAdminService;

    @PreAuthorize("@ss.hasPermi('spas:open:client:list')")
    @GetMapping("/client/list")
    public TableDataInfo clientList(SpasOpenClient query)
    {
        startPage();
        List<SpasOpenClient> list = openAdminService.selectClientList(query);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:open:client:query')")
    @GetMapping("/client/{clientId}")
    public AjaxResult getClient(@PathVariable Long clientId)
    {
        return success(openAdminService.selectClientById(clientId));
    }

    @PreAuthorize("@ss.hasPermi('spas:open:client:add')")
    @Log(title = "Open Client", businessType = BusinessType.INSERT)
    @PostMapping("/client")
    public AjaxResult addClient(@RequestBody SpasOpenClient client)
    {
        return toAjax(openAdminService.insertClient(client));
    }

    @PreAuthorize("@ss.hasPermi('spas:open:client:edit')")
    @Log(title = "Open Client", businessType = BusinessType.UPDATE)
    @PutMapping("/client")
    public AjaxResult editClient(@RequestBody SpasOpenClient client)
    {
        return toAjax(openAdminService.updateClient(client));
    }

    @PreAuthorize("@ss.hasPermi('spas:open:client:remove')")
    @Log(title = "Open Client", businessType = BusinessType.DELETE)
    @DeleteMapping("/client/{clientIds}")
    public AjaxResult removeClient(@PathVariable Long[] clientIds)
    {
        return toAjax(openAdminService.deleteClientByIds(clientIds));
    }

    @PreAuthorize("@ss.hasPermi('spas:open:parent:list')")
    @GetMapping("/parent/list")
    public TableDataInfo parentList(SpasParent query)
    {
        startPage();
        List<SpasParent> list = openAdminService.selectParentList(query);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:open:parent:query')")
    @GetMapping("/parent/{parentId}")
    public AjaxResult getParent(@PathVariable Long parentId)
    {
        return success(openAdminService.selectParentById(parentId));
    }

    @PreAuthorize("@ss.hasPermi('spas:open:parent:add')")
    @Log(title = "Parent", businessType = BusinessType.INSERT)
    @PostMapping("/parent")
    public AjaxResult addParent(@RequestBody SpasParent parent)
    {
        return toAjax(openAdminService.insertParent(parent));
    }

    @PreAuthorize("@ss.hasPermi('spas:open:parent:edit')")
    @Log(title = "Parent", businessType = BusinessType.UPDATE)
    @PutMapping("/parent")
    public AjaxResult editParent(@RequestBody SpasParent parent)
    {
        return toAjax(openAdminService.updateParent(parent));
    }

    @PreAuthorize("@ss.hasPermi('spas:open:parent:remove')")
    @Log(title = "Parent", businessType = BusinessType.DELETE)
    @DeleteMapping("/parent/{parentIds}")
    public AjaxResult removeParent(@PathVariable Long[] parentIds)
    {
        return toAjax(openAdminService.deleteParentByIds(parentIds));
    }

    @PreAuthorize("@ss.hasPermi('spas:open:parent:list')")
    @GetMapping("/parent/{parentId}/students")
    public AjaxResult parentStudents(@PathVariable Long parentId)
    {
        List<SpasStudent> list = openAdminService.selectParentBindStudents(parentId);
        return success(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:open:parent:edit')")
    @Log(title = "Parent Bind", businessType = BusinessType.UPDATE)
    @PostMapping("/parent/{parentId}/bind/{studentId}")
    public AjaxResult bindStudent(@PathVariable Long parentId, @PathVariable Long studentId)
    {
        return toAjax(openAdminService.bindParentStudent(parentId, studentId));
    }

    @PreAuthorize("@ss.hasPermi('spas:open:parent:edit')")
    @Log(title = "Parent Unbind", businessType = BusinessType.UPDATE)
    @DeleteMapping("/parent/{parentId}/bind/{studentId}")
    public AjaxResult unbindStudent(@PathVariable Long parentId, @PathVariable Long studentId)
    {
        return toAjax(openAdminService.unbindParentStudent(parentId, studentId));
    }
}
