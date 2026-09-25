package com.ruoyi.spas.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
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
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.spas.domain.SpasKnowledgeEdge;
import com.ruoyi.spas.service.ISpasKnowledgeEdgeService;
import com.ruoyi.spas.support.SpasAccessService;

/**
 * Knowledge prerequisite edge controller
 */
@RestController
@RequestMapping("/spas/knowledgeEdge")
public class SpasKnowledgeEdgeController extends BaseController
{
    @Autowired
    private ISpasKnowledgeEdgeService knowledgeEdgeService;

    @Autowired
    private SpasAccessService accessService;

    @PreAuthorize("@ss.hasPermi('spas:knowledge:list')")
    @GetMapping("/list")
    public AjaxResult list(@RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) Long toKnowledgeId,
        @RequestParam(required = false) Long fromKnowledgeId)
    {
        List<SpasKnowledgeEdge> list;
        if (toKnowledgeId != null)
        {
            list = knowledgeEdgeService.selectByToKnowledgeId(toKnowledgeId);
        }
        else if (fromKnowledgeId != null)
        {
            list = knowledgeEdgeService.selectByFromKnowledgeId(fromKnowledgeId);
        }
        else if (subjectId != null)
        {
            list = knowledgeEdgeService.selectBySubjectId(subjectId);
        }
        else
        {
            return error("请指定 subjectId、toKnowledgeId 或 fromKnowledgeId");
        }
        return success(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:knowledge:edit')")
    @Log(title = "Knowledge Edge", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SpasKnowledgeEdge edge)
    {
        accessService.assertCanWrite();
        edge.setCreateBy(getUsername());
        return toAjax(knowledgeEdgeService.insertSpasKnowledgeEdge(edge));
    }

    @PreAuthorize("@ss.hasPermi('spas:knowledge:edit')")
    @Log(title = "Knowledge Edge", businessType = BusinessType.DELETE)
    @DeleteMapping("/{edgeId}")
    public AjaxResult remove(@PathVariable Long edgeId)
    {
        accessService.assertCanWrite();
        return toAjax(knowledgeEdgeService.deleteById(edgeId));
    }
}
