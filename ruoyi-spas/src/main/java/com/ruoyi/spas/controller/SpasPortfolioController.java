package com.ruoyi.spas.controller;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.spas.domain.SpasCoachLog;
import com.ruoyi.spas.service.ISpasPortfolioService;

/**
 * Student portfolio controller
 */
@RestController
@RequestMapping("/spas/portfolio")
public class SpasPortfolioController extends BaseController
{
    @Autowired
    private ISpasPortfolioService portfolioService;

    @PreAuthorize("@ss.hasPermi('spas:portfolio:mine')")
    @GetMapping("/mine")
    public AjaxResult getMine(@RequestParam(required = false) Long subjectId)
    {
        Map<String, Object> data = portfolioService.getMyPortfolio(subjectId);
        return success(data);
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:portfolio:coach,spas:portfolio:list')")
    @GetMapping("/coach/list")
    public TableDataInfo coachList(SpasCoachLog log)
    {
        startPage();
        List<SpasCoachLog> list = portfolioService.selectCoachLogList(log);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:portfolio:coach,spas:portfolio:list')")
    @Log(title = "Coach Log", businessType = BusinessType.INSERT)
    @PostMapping("/coach")
    public AjaxResult addCoach(@RequestBody SpasCoachLog log)
    {
        log.setCreateBy(getUsername());
        return toAjax(portfolioService.insertCoachLog(log));
    }

    @PreAuthorize("@ss.hasPermi('spas:portfolio:list')")
    @GetMapping("/{studentId}")
    public AjaxResult getPortfolio(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId)
    {
        Map<String, Object> data = portfolioService.getPortfolio(studentId, subjectId);
        return success(data);
    }
}
