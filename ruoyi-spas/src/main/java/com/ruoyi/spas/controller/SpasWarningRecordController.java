package com.ruoyi.spas.controller;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
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
import com.ruoyi.spas.domain.SpasWarningRecord;
import com.ruoyi.spas.service.ISpasWarningRecordService;
import com.ruoyi.spas.support.SpasAccessService;

@RestController
@RequestMapping("/spas/warning/record")
public class SpasWarningRecordController extends BaseController
{
    @Autowired
    private ISpasWarningRecordService recordService;

    @Autowired
    private SpasAccessService accessService;

    @PreAuthorize("@ss.hasPermi('spas:warning:record')")
    @GetMapping("/list")
    public TableDataInfo list(SpasWarningRecord record)
    {
        startPage();
        List<SpasWarningRecord> list = recordService.selectSpasWarningRecordList(record);
        return getDataTable(list);
    }

    @Log(title = "Warning Record", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('spas:warning:record')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, SpasWarningRecord record)
    {
        List<SpasWarningRecord> list = recordService.selectSpasWarningRecordList(record);
        ExcelUtil<SpasWarningRecord> util = new ExcelUtil<SpasWarningRecord>(SpasWarningRecord.class);
        util.exportExcel(response, list, "warning_record");
    }

    @PreAuthorize("@ss.hasPermi('spas:warning:record')")
    @GetMapping(value = "/{warningId}")
    public AjaxResult getInfo(@PathVariable Long warningId)
    {
        return success(recordService.selectSpasWarningRecordById(warningId));
    }

    @PreAuthorize("@ss.hasPermi('spas:warning:record:handle')")
    @Log(title = "Warning Handle", businessType = BusinessType.UPDATE)
    @PutMapping("/handle")
    public AjaxResult handle(@RequestBody SpasWarningRecord record)
    {
        accessService.assertCanWrite();
        return toAjax(recordService.handleRecord(record));
    }
}
