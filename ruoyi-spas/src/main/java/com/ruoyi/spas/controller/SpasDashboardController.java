package com.ruoyi.spas.controller;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.spas.service.ISpasDashboardService;

/**
 * SPAS home dashboard
 */
@RestController
@RequestMapping("/spas/dashboard")
public class SpasDashboardController extends BaseController
{
    @Autowired
    private ISpasDashboardService dashboardService;

    @PreAuthorize("@ss.hasAnyPermi('spas:student:list,spas:score:list,spas:warning:record')")
    @GetMapping("/overview")
    public AjaxResult overview()
    {
        Map<String, Object> data = dashboardService.getOverview();
        return success(data);
    }
}
