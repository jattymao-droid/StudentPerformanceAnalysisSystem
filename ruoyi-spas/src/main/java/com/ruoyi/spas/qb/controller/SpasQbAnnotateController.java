package com.ruoyi.spas.qb.controller;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.spas.qb.domain.SpasQbAnnotateCommitRequest;
import com.ruoyi.spas.qb.domain.SpasQbAnnotateRecognizeRequest;
import com.ruoyi.spas.qb.service.ISpasQbAnnotateService;
import com.ruoyi.spas.support.SpasAccessService;

/**
 * Visual paper annotate (page render + box crop commit)
 */
@RestController
@RequestMapping("/spas/qb/annotate")
public class SpasQbAnnotateController extends BaseController
{
    @Autowired
    private ISpasQbAnnotateService annotateService;

    @Autowired
    private SpasAccessService accessService;

    @PreAuthorize("@ss.hasPermi('spas:qb:question:add')")
    @Log(title = "QB Annotate Upload", businessType = BusinessType.OTHER)
    @PostMapping("/upload")
    public AjaxResult upload(@RequestParam("file") MultipartFile file, @RequestParam("subjectId") Long subjectId)
    {
        accessService.assertCanWrite();
        return success(annotateService.uploadAndRender(file, subjectId, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:question:add')")
    @Log(title = "QB Annotate Recognize", businessType = BusinessType.OTHER)
    @PostMapping("/recognize")
    public AjaxResult recognize(@RequestBody SpasQbAnnotateRecognizeRequest request)
    {
        accessService.assertCanWrite();
        return success(annotateService.recognizeRegion(request));
    }

    @PreAuthorize("@ss.hasPermi('spas:qb:question:add')")
    @Log(title = "QB Annotate Commit", businessType = BusinessType.INSERT)
    @PostMapping("/commit")
    public AjaxResult commit(@RequestBody SpasQbAnnotateCommitRequest request)
    {
        accessService.assertCanWrite();
        Map<String, Object> result = annotateService.commit(request, getUsername());
        return success(result);
    }
}
