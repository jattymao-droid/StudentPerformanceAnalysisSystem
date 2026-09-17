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
import com.ruoyi.spas.domain.SpasKnowledge;
import com.ruoyi.spas.service.ISpasKnowledgeService;
import com.ruoyi.spas.support.SpasAccessService;

/**
 * Knowledge controller
 */
@RestController
@RequestMapping("/spas/knowledge")
public class SpasKnowledgeController extends BaseController
{
    @Autowired
    private ISpasKnowledgeService knowledgeService;

    @Autowired
    private SpasAccessService accessService;

    @PreAuthorize("@ss.hasPermi('spas:knowledge:list')")
    @GetMapping("/list")
    public TableDataInfo list(SpasKnowledge knowledge)
    {
        startPage();
        List<SpasKnowledge> list = knowledgeService.selectSpasKnowledgeList(knowledge);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:knowledge:list')")
    @GetMapping("/tree/{subjectId}")
    public AjaxResult tree(@PathVariable Long subjectId)
    {
        return success(knowledgeService.selectKnowledgeTree(subjectId));
    }

    @PreAuthorize("@ss.hasPermi('spas:knowledge:query')")
    @GetMapping(value = "/{knowledgeId}")
    public AjaxResult getInfo(@PathVariable Long knowledgeId)
    {
        return success(knowledgeService.selectSpasKnowledgeById(knowledgeId));
    }

    @PreAuthorize("@ss.hasPermi('spas:knowledge:add')")
    @Log(title = "Knowledge", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SpasKnowledge knowledge)
    {
        accessService.assertCanWrite();
        knowledge.setCreateBy(getUsername());
        return toAjax(knowledgeService.insertSpasKnowledge(knowledge));
    }

    @PreAuthorize("@ss.hasPermi('spas:knowledge:edit')")
    @Log(title = "Knowledge", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody SpasKnowledge knowledge)
    {
        accessService.assertCanWrite();
        knowledge.setUpdateBy(getUsername());
        return toAjax(knowledgeService.updateSpasKnowledge(knowledge));
    }

    @PreAuthorize("@ss.hasPermi('spas:knowledge:remove')")
    @Log(title = "Knowledge", businessType = BusinessType.DELETE)
    @DeleteMapping("/{knowledgeId}")
    public AjaxResult remove(@PathVariable Long knowledgeId)
    {
        accessService.assertCanWrite();
        return toAjax(knowledgeService.deleteSpasKnowledgeById(knowledgeId));
    }
}
