package com.ruoyi.spas.controller;

import java.util.List;
import java.util.Map;
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
import com.ruoyi.spas.domain.SpasQualityTicket;
import com.ruoyi.spas.service.ISpasQualityService;

@RestController
@RequestMapping("/spas/quality")
public class SpasQualityController extends BaseController
{
    @Autowired
    private ISpasQualityService qualityService;

    @PreAuthorize("@ss.hasPermi('spas:quality:list')")
    @GetMapping("/overview")
    public AjaxResult overview(@RequestParam(required = false) Long deptId,
        @RequestParam(required = false) Long subjectId)
    {
        return success(qualityService.overview(deptId, subjectId));
    }

    @PreAuthorize("@ss.hasPermi('spas:quality:list')")
    @GetMapping("/detail")
    public AjaxResult detail(@RequestParam String metric,
        @RequestParam(required = false) Long deptId,
        @RequestParam(required = false) Long subjectId)
    {
        List<Map<String, Object>> list = qualityService.detail(metric, deptId, subjectId);
        return success(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:quality:ticket:list')")
    @GetMapping("/ticket/list")
    public TableDataInfo ticketList(SpasQualityTicket query)
    {
        startPage();
        List<SpasQualityTicket> list = qualityService.selectTicketList(query);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:quality:ticket:list')")
    @GetMapping("/ticket/{ticketId}")
    public AjaxResult getTicket(@PathVariable Long ticketId)
    {
        return success(qualityService.selectTicketById(ticketId));
    }

    @PreAuthorize("@ss.hasPermi('spas:quality:ticket:add')")
    @Log(title = "Quality Ticket", businessType = BusinessType.INSERT)
    @PostMapping("/ticket")
    public AjaxResult addTicket(@RequestBody SpasQualityTicket ticket)
    {
        return toAjax(qualityService.insertTicket(ticket));
    }

    @PreAuthorize("@ss.hasPermi('spas:quality:ticket:edit')")
    @Log(title = "Quality Ticket", businessType = BusinessType.UPDATE)
    @PutMapping("/ticket")
    public AjaxResult editTicket(@RequestBody SpasQualityTicket ticket)
    {
        return toAjax(qualityService.updateTicket(ticket));
    }

    @PreAuthorize("@ss.hasPermi('spas:quality:ticket:remove')")
    @Log(title = "Quality Ticket", businessType = BusinessType.DELETE)
    @DeleteMapping("/ticket/{ticketIds}")
    public AjaxResult removeTicket(@PathVariable Long[] ticketIds)
    {
        return toAjax(qualityService.deleteTicketByIds(ticketIds));
    }
}
