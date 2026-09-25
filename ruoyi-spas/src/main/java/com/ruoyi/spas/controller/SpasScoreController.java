package com.ruoyi.spas.controller;

import java.util.List;
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
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.spas.domain.SpasScoreBatch;
import com.ruoyi.spas.domain.SpasScoreDetail;
import com.ruoyi.spas.service.ISpasScoreService;

/**
 * Score import controller
 */
@RestController
@RequestMapping("/spas/score")
public class SpasScoreController extends BaseController
{
    @Autowired
    private ISpasScoreService scoreService;

    @PreAuthorize("@ss.hasPermi('spas:score:list')")
    @GetMapping("/batch/list")
    public TableDataInfo batchList(SpasScoreBatch batch)
    {
        startPage();
        List<SpasScoreBatch> list = scoreService.selectSpasScoreBatchList(batch);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:score:list')")
    @GetMapping("/detail/list")
    public TableDataInfo detailList(SpasScoreDetail detail)
    {
        startPage();
        List<SpasScoreDetail> list = scoreService.selectSpasScoreDetailList(detail);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:score:list')")
    @GetMapping("/detail/{detailId}")
    public AjaxResult getDetail(@PathVariable Long detailId)
    {
        return success(scoreService.selectSpasScoreDetailById(detailId));
    }

    @PreAuthorize("@ss.hasPermi('spas:score:edit')")
    @Log(title = "Score Detail", businessType = BusinessType.INSERT)
    @PostMapping("/detail")
    public AjaxResult addDetail(@RequestBody SpasScoreDetail detail)
    {
        return toAjax(scoreService.insertSpasScoreDetail(detail));
    }

    @PreAuthorize("@ss.hasPermi('spas:score:edit')")
    @Log(title = "Score Detail", businessType = BusinessType.UPDATE)
    @PutMapping("/detail")
    public AjaxResult editDetail(@RequestBody SpasScoreDetail detail)
    {
        return toAjax(scoreService.updateSpasScoreDetail(detail));
    }

    @PreAuthorize("@ss.hasPermi('spas:score:remove')")
    @Log(title = "Score Detail", businessType = BusinessType.DELETE)
    @DeleteMapping("/detail/{detailIds}")
    public AjaxResult removeDetail(@PathVariable Long[] detailIds)
    {
        return toAjax(scoreService.deleteSpasScoreDetailByIds(detailIds));
    }

    @PreAuthorize("@ss.hasPermi('spas:score:import')")
    @PostMapping("/template/{paperId}")
    public void downloadTemplate(@PathVariable Long paperId, HttpServletResponse response)
    {
        scoreService.downloadTemplate(paperId, response);
    }

    @PreAuthorize("@ss.hasPermi('spas:score:import')")
    @Log(title = "Score Import", businessType = BusinessType.IMPORT)
    @PostMapping("/import/{paperId}")
    public AjaxResult importData(@PathVariable Long paperId, MultipartFile file) throws Exception
    {
        SpasScoreBatch batch = scoreService.importScores(paperId, file, getUsername());
        return success(batch);
    }

    @Log(title = "Score Export", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('spas:score:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, SpasScoreDetail detail)
    {
        scoreService.exportScoreDetail(detail, response);
    }

    @PreAuthorize("@ss.hasPermi('spas:score:import')")
    @Log(title = "Score Batch Revoke", businessType = BusinessType.DELETE)
    @DeleteMapping("/batch/{batchId}")
    public AjaxResult revokeBatch(@PathVariable Long batchId)
    {
        return toAjax(scoreService.revokeBatch(batchId));
    }
}
