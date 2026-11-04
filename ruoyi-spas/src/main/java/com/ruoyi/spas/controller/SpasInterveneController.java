package com.ruoyi.spas.controller;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
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
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.spas.domain.SpasInterveneTask;
import com.ruoyi.spas.service.ISpasInterveneService;
import com.ruoyi.spas.service.ISpasPracticeCheckoutService;
import com.ruoyi.spas.service.ISpasPracticeLogService;
import com.ruoyi.spas.support.SpasAccessService;

@RestController
@RequestMapping("/spas/intervene")
public class SpasInterveneController extends BaseController
{
    @Autowired
    private ISpasInterveneService interveneService;

    @Autowired
    private ISpasPracticeLogService practiceLogService;

    @Autowired
    private ISpasPracticeCheckoutService checkoutService;

    @Autowired
    private SpasAccessService accessService;

    @PreAuthorize("@ss.hasPermi('spas:intervene:list')")
    @GetMapping("/list")
    public TableDataInfo list(SpasInterveneTask task)
    {
        startPage();
        List<SpasInterveneTask> list = interveneService.selectSpasInterveneTaskList(task);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:intervene:list')")
    @GetMapping("/{interveneId}")
    public AjaxResult getInfo(@PathVariable Long interveneId)
    {
        return success(interveneService.selectSpasInterveneTaskById(interveneId));
    }

    @PreAuthorize("@ss.hasPermi('spas:intervene:add')")
    @Log(title = "干预任务", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SpasInterveneTask task)
    {
        task.setCreateBy(getUsername());
        return toAjax(interveneService.insertSpasInterveneTask(task));
    }

    @PreAuthorize("@ss.hasPermi('spas:intervene:edit')")
    @Log(title = "干预任务", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SpasInterveneTask task)
    {
        return toAjax(interveneService.updateSpasInterveneTask(task));
    }

    /**
     * 统一转干预入口。sourceType: warning | practice_log | checkout_item
     * 旧路径仍可用，新 UI 请优先调用本接口。
     */
    @PreAuthorize("@ss.hasPermi('spas:intervene:add')")
    @Log(title = "来源转干预", businessType = BusinessType.INSERT)
    @PostMapping("/from-source")
    public AjaxResult fromSource(@RequestBody Map<String, Object> body)
    {
        if (body == null || body.get("sourceType") == null || body.get("sourceId") == null)
        {
            throw new ServiceException("sourceType 与 sourceId 不能为空");
        }
        String type = String.valueOf(body.get("sourceType")).trim().toLowerCase();
        Long sourceId = Long.valueOf(String.valueOf(body.get("sourceId")));
        if ("warning".equals(type) || "1".equals(type))
        {
            SpasInterveneTask form = new SpasInterveneTask();
            if (body.get("title") != null)
            {
                form.setTitle(String.valueOf(body.get("title")));
            }
            if (body.get("subjectId") != null && !"".equals(String.valueOf(body.get("subjectId"))))
            {
                form.setSubjectId(Long.valueOf(String.valueOf(body.get("subjectId"))));
            }
            if (body.get("targetRate") != null && !"".equals(String.valueOf(body.get("targetRate"))))
            {
                form.setTargetRate(new java.math.BigDecimal(String.valueOf(body.get("targetRate"))));
            }
            if (body.get("remark") != null)
            {
                form.setRemark(String.valueOf(body.get("remark")));
            }
            Object kids = body.get("knowledgeIdList");
            if (kids instanceof List)
            {
                java.util.ArrayList<Long> ids = new java.util.ArrayList<Long>();
                for (Object o : (List<?>) kids)
                {
                    if (o != null && !"".equals(String.valueOf(o)))
                    {
                        ids.add(Long.valueOf(String.valueOf(o)));
                    }
                }
                form.setKnowledgeIdList(ids);
            }
            return success(interveneService.createFromWarning(sourceId, form));
        }
        if ("practice_log".equals(type) || "log".equals(type) || "2".equals(type))
        {
            return success(practiceLogService.toIntervene(sourceId));
        }
        if ("checkout_item".equals(type) || "checkout".equals(type) || "4".equals(type))
        {
            return success(checkoutService.toIntervene(sourceId));
        }
        throw new ServiceException("不支持的 sourceType: " + type + "（可用 warning / practice_log / checkout_item）");
    }

    /** @deprecated 请用 POST /spas/intervene/from-source ，sourceType=warning */
    @Deprecated
    @PreAuthorize("@ss.hasPermi('spas:intervene:add')")
    @Log(title = "预警转干预", businessType = BusinessType.INSERT)
    @PostMapping("/from-warning/{warningId}")
    public AjaxResult fromWarning(@PathVariable Long warningId, @RequestBody(required = false) SpasInterveneTask form)
    {
        return success(interveneService.createFromWarning(warningId, form));
    }

    @PreAuthorize("@ss.hasPermi('spas:intervene:handle')")
    @Log(title = "干预效果评估", businessType = BusinessType.UPDATE)
    @PostMapping("/{interveneId}/evaluate")
    public AjaxResult evaluate(@PathVariable Long interveneId)
    {
        return success(interveneService.evaluate(interveneId));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:intervene:list,spas:portfolio:list,spas:portfolio:mine')")
    @GetMapping("/student/{studentId}/timeline")
    public AjaxResult timeline(@PathVariable Long studentId)
    {
        accessService.checkStudentAccess(studentId);
        List<Map<String, Object>> list = interveneService.studentTimeline(studentId);
        return success(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:intervene:list')")
    @GetMapping("/class/{deptId}/summary")
    public AjaxResult classSummary(@PathVariable Long deptId,
        @org.springframework.web.bind.annotation.RequestParam(required = false) Long subjectId)
    {
        return success(interveneService.classSummary(deptId, subjectId));
    }

    @PreAuthorize("@ss.hasPermi('spas:intervene:add')")
    @Log(title = "批量薄弱干预", businessType = BusinessType.INSERT)
    @PostMapping("/batch-weak")
    public AjaxResult batchWeak(@RequestBody Map<String, Object> body)
    {
        Long deptId = body.get("deptId") == null ? null : Long.valueOf(body.get("deptId").toString());
        Long subjectId = body.get("subjectId") == null ? null : Long.valueOf(body.get("subjectId").toString());
        Long knowledgeId = body.get("knowledgeId") == null ? null : Long.valueOf(body.get("knowledgeId").toString());
        String title = body.get("title") == null ? null : body.get("title").toString();
        java.math.BigDecimal target = null;
        if (body.get("targetRate") != null)
        {
            target = new java.math.BigDecimal(body.get("targetRate").toString());
        }
        return success(interveneService.batchCreateForWeak(deptId, subjectId, knowledgeId, title, target));
    }
}
