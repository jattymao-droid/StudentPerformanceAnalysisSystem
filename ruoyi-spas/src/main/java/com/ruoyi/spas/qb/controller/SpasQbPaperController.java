package com.ruoyi.spas.qb.controller;

import java.util.HashMap;
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
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasPaper;
import com.ruoyi.spas.domain.SpasPaperQuestion;
import com.ruoyi.spas.mapper.SpasPaperMapper;
import com.ruoyi.spas.qb.domain.SpasQbPaper;
import com.ruoyi.spas.qb.domain.SpasQbPublishRequest;
import com.ruoyi.spas.qb.service.ISpasQbPaperService;
import com.ruoyi.spas.support.SpasAccessService;

/**
 * Bank paper compose / publish APIs
 */
@RestController
@RequestMapping("/spas/qb/paper")
public class SpasQbPaperController extends BaseController
{
    @Autowired
    private ISpasQbPaperService paperService;

    @Autowired
    private SpasPaperMapper analysisPaperMapper;

    @Autowired
    private SpasAccessService accessService;

    @PreAuthorize("@ss.hasPermi('spas:qb:paper:list')")
    @GetMapping("/list")
    public TableDataInfo list(SpasQbPaper query)
    {
        startPage();
        List<SpasQbPaper> list = paperService.selectSpasQbPaperList(query);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:paper:query')")
    @GetMapping("/{paperId}")
    public AjaxResult getInfo(@PathVariable Long paperId)
    {
        return success(paperService.selectSpasQbPaperById(paperId));
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:paper:add')")
    @Log(title = "题库组卷", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SpasQbPaper paper)
    {
        accessService.assertCanWrite();
        paper.setCreateBy(getUsername());
        return toAjax(paperService.insertSpasQbPaper(paper));
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:paper:edit')")
    @Log(title = "题库组卷", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SpasQbPaper paper)
    {
        accessService.assertCanWrite();
        paper.setUpdateBy(getUsername());
        return toAjax(paperService.updateSpasQbPaper(paper));
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:paper:remove')")
    @Log(title = "题库组卷", businessType = BusinessType.DELETE)
    @DeleteMapping("/{paperIds}")
    public AjaxResult remove(@PathVariable Long[] paperIds)
    {
        accessService.assertCanWrite();
        return toAjax(paperService.deleteSpasQbPaperByIds(paperIds));
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:paper:edit')")
    @Log(title = "题库组卷选题", businessType = BusinessType.UPDATE)
    @PutMapping("/{paperId}/items")
    public AjaxResult saveItems(@PathVariable Long paperId, @RequestBody SpasQbPaper paper)
    {
        accessService.assertCanWrite();
        paper.setPaperId(paperId);
        paper.setUpdateBy(getUsername());
        return toAjax(paperService.saveItems(paper));
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:paper:publish')")
    @Log(title = "题库发布分析卷", businessType = BusinessType.UPDATE)
    @PostMapping("/{paperId}/publish")
    public AjaxResult publish(@PathVariable Long paperId, @RequestBody SpasQbPublishRequest request)
    {
        request.setBankPaperId(paperId);
        SpasPaper analysis = paperService.publishToAnalysis(request, getUsername());
        Map<String, Object> data = new HashMap<>();
        data.put("paper", analysis);
        data.put("paperId", analysis != null ? analysis.getPaperId() : null);
        int noBloom = 0;
        int noType = 0;
        int questionCount = 0;
        if (analysis != null && analysis.getPaperId() != null)
        {
            List<SpasPaperQuestion> qs = analysisPaperMapper.selectQuestionsByPaperId(analysis.getPaperId());
            if (qs != null)
            {
                questionCount = qs.size();
                for (SpasPaperQuestion q : qs)
                {
                    if (q == null)
                    {
                        continue;
                    }
                    if (StringUtils.isEmpty(q.getBloomLevel()))
                    {
                        noBloom++;
                    }
                    if (StringUtils.isEmpty(q.getQuestionType()))
                    {
                        noType++;
                    }
                }
            }
        }
        data.put("questionCount", questionCount);
        data.put("noBloomCount", noBloom);
        data.put("noQuestionTypeCount", noType);
        data.put("needBloomBeforeScore", noBloom > 0);
        if (noBloom > 0)
        {
            data.put("nextStep", "分析卷有 " + noBloom + " 题未标认知层级。请先到「试卷管理」补全 Bloom，再导入成绩（当前为硬门禁）。");
        }
        else if (noType > 0)
        {
            data.put("nextStep", "分析卷有 " + noType + " 题未选题型，请补全后再导分。");
        }
        else
        {
            data.put("nextStep", "标注齐全，可前往导入成绩。");
        }
        return success(data);
    }

    /** Pre-publish: unbound KP / weight sum != 1 */
    @PreAuthorize("@ss.hasPermi('spas:qb:paper:query')")
    @GetMapping("/{paperId}/annotation-check")
    public AjaxResult annotationCheck(@PathVariable Long paperId)
    {
        return success(paperService.annotationCheck(paperId));
    }

    /** Weak knowledge coverage vs class weak-top (before publish) */
    @PreAuthorize("@ss.hasPermi('spas:qb:paper:query')")
    @GetMapping("/{paperId}/weak-cover")
    public AjaxResult weakCover(@PathVariable Long paperId,
            @RequestParam Long deptId,
            @RequestParam(required = false) Long subjectId,
            @RequestParam(required = false) Integer limit)
    {
        Map<String, Object> data = paperService.weakCover(paperId, deptId, subjectId, limit);
        return success(data);
    }
}
