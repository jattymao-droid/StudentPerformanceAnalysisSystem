package com.ruoyi.spas.controller;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
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
}
