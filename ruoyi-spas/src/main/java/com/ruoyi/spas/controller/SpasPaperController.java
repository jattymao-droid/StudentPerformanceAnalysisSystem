package com.ruoyi.spas.controller;

import java.util.List;
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
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.spas.domain.SpasPaper;
import com.ruoyi.spas.service.ISpasPaperService;
import com.ruoyi.spas.support.SpasAccessService;

/**
 * Paper controller
 */
@RestController
@RequestMapping("/spas/paper")
public class SpasPaperController extends BaseController
{
    @Autowired
    private ISpasPaperService paperService;

    @Autowired
    private SpasAccessService accessService;

    @PreAuthorize("@ss.hasPermi('spas:paper:list')")
    @GetMapping("/list")
    public TableDataInfo list(SpasPaper paper)
    {
        startPage();
        List<SpasPaper> list = paperService.selectSpasPaperList(paper);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:paper:query')")
    @GetMapping(value = "/{paperId}")
    public AjaxResult getInfo(@PathVariable Long paperId)
    {
        return success(paperService.selectSpasPaperById(paperId));
    }

    @PreAuthorize("@ss.hasPermi('spas:paper:add')")
    @Log(title = "Paper", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SpasPaper paper)
    {
        accessService.assertCanWrite();
        paper.setCreateBy(getUsername());
        return toAjax(paperService.insertSpasPaper(paper));
    }

    @PreAuthorize("@ss.hasPermi('spas:paper:edit')")
    @Log(title = "Paper", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody SpasPaper paper)
    {
        accessService.assertCanWrite();
        paper.setUpdateBy(getUsername());
        return toAjax(paperService.updateSpasPaper(paper));
    }

    @PreAuthorize("@ss.hasPermi('spas:paper:remove')")
    @Log(title = "Paper", businessType = BusinessType.DELETE)
    @DeleteMapping("/{paperIds}")
    public AjaxResult remove(@PathVariable Long[] paperIds)
    {
        accessService.assertCanWrite();
        return toAjax(paperService.deleteSpasPaperByIds(paperIds));
    }

    @PreAuthorize("@ss.hasPermi('spas:paper:edit')")
    @Log(title = "Paper Publish", businessType = BusinessType.UPDATE)
    @PutMapping("/publish/{paperId}")
    public AjaxResult publish(@PathVariable Long paperId)
    {
        accessService.assertCanWrite();
        return toAjax(paperService.publishPaper(paperId));
    }

    @PreAuthorize("@ss.hasPermi('spas:paper:edit')")
    @Log(title = "Paper Archive", businessType = BusinessType.UPDATE)
    @PutMapping("/archive/{paperId}")
    public AjaxResult archive(@PathVariable Long paperId)
    {
        accessService.assertCanWrite();
        return toAjax(paperService.archivePaper(paperId));
    }

    /**
     * Save questions batch for a paper.
     * Body example: { "paperId": 1, "questions": [ ... ] }
     */
    @PreAuthorize("@ss.hasPermi('spas:paper:edit')")
    @Log(title = "Paper Questions", businessType = BusinessType.UPDATE)
    @PostMapping("/questions")
    public AjaxResult saveQuestions(@RequestBody SpasPaper paper)
    {
        accessService.assertCanWrite();
        return toAjax(paperService.savePaperQuestions(paper.getPaperId(), paper.getQuestions()));
    }

    @PreAuthorize("@ss.hasPermi('spas:paper:add')")
    @Log(title = "Paper Copy", businessType = BusinessType.INSERT)
    @PostMapping("/copy/{paperId}")
    public AjaxResult copy(@PathVariable Long paperId)
    {
        accessService.assertCanWrite();
        return toAjax(paperService.copyPaper(paperId, getUsername()));
    }
}
