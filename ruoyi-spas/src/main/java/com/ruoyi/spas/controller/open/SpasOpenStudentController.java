package com.ruoyi.spas.controller.open;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.domain.SpasWarningRecord;
import com.ruoyi.spas.open.SpasOpenContext;
import com.ruoyi.spas.service.ISpasOpenService;

/**
 * Parent OpenAPI student resources
 */
@RestController
@RequestMapping("/open/v1")
public class SpasOpenStudentController extends BaseController
{
    @Autowired
    private ISpasOpenService openService;

    private Long requireParentId()
    {
        Long parentId = SpasOpenContext.getParentId();
        if (parentId == null)
        {
            throw new ServiceException("开放接口未授权");
        }
        return parentId;
    }

    @GetMapping("/students")
    public AjaxResult students()
    {
        List<SpasStudent> list = openService.listBoundStudents(requireParentId());
        return success(list);
    }

    @GetMapping("/students/{studentId}/portfolio")
    public AjaxResult portfolio(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId)
    {
        Map<String, Object> data = openService.getPortfolio(requireParentId(), studentId, subjectId);
        return success(data);
    }

    @GetMapping("/students/{studentId}/warnings")
    public AjaxResult warnings(@PathVariable Long studentId)
    {
        List<SpasWarningRecord> list = openService.listWarnings(requireParentId(), studentId);
        return success(list);
    }

    @GetMapping("/students/{studentId}/radar")
    public AjaxResult radar(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId)
    {
        return success(openService.radar(requireParentId(), studentId, subjectId));
    }

    @GetMapping("/students/{studentId}/trend")
    public AjaxResult trend(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId)
    {
        return success(openService.trend(requireParentId(), studentId, subjectId));
    }

    @GetMapping("/students/{studentId}/weak-top")
    public AjaxResult weakTop(@PathVariable Long studentId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false, defaultValue = "10") Integer limit)
    {
        return success(openService.weakTop(requireParentId(), studentId, subjectId, limit));
    }
}
