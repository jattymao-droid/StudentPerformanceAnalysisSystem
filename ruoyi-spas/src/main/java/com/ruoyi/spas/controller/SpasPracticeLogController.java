package com.ruoyi.spas.controller;

import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
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
import com.ruoyi.spas.domain.SpasPracticeAssignment;
import com.ruoyi.spas.domain.SpasPracticeCheckout;
import com.ruoyi.spas.domain.SpasPracticeLog;
import com.ruoyi.spas.service.ISpasPracticeCheckoutService;
import com.ruoyi.spas.service.ISpasPracticeLogService;
import com.ruoyi.spas.service.ISpasStudentPinService;
import com.ruoyi.spas.service.ISpasStudentPointService;

@RestController
@RequestMapping("/spas/practice")
public class SpasPracticeLogController extends BaseController
{
    @Autowired
    private ISpasPracticeLogService practiceService;

    @Autowired
    private ISpasStudentPinService pinService;

    @Autowired
    private ISpasStudentPointService pointService;

    @Autowired
    private ISpasPracticeCheckoutService checkoutService;

    @PreAuthorize("@ss.hasPermi('spas:practice:list')")
    @GetMapping("/list")
    public TableDataInfo list(SpasPracticeLog query)
    {
        startPage();
        List<SpasPracticeLog> list = practiceService.selectSpasPracticeLogList(query);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:query,spas:practice:mine')")
    @GetMapping("/{logId:\\d+}")
    public AjaxResult getInfo(@PathVariable Long logId)
    {
        return success(practiceService.selectSpasPracticeLogById(logId));
    }

    @PreAuthorize("@ss.hasPermi('spas:practice:add')")
    @Log(title = "自主练打卡", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SpasPracticeLog log)
    {
        int rows = practiceService.insertSelf(log);
        AjaxResult ajax = toAjax(rows);
        ajax.put("awardedPoints", Integer.valueOf(practiceService.consumeLastAwardedPoints()));
        return ajax;
    }

    @PreAuthorize("@ss.hasPermi('spas:practice:proxy')")
    @Log(title = "自主练打卡代提", businessType = BusinessType.INSERT)
    @PostMapping("/proxy")
    public AjaxResult proxy(@RequestBody SpasPracticeLog log)
    {
        int rows = practiceService.insertProxy(log);
        AjaxResult ajax = toAjax(rows);
        ajax.put("awardedPoints", Integer.valueOf(practiceService.consumeLastAwardedPoints()));
        return ajax;
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:edit,spas:practice:add')")
    @Log(title = "自主练打卡", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SpasPracticeLog log)
    {
        return toAjax(practiceService.updateSpasPracticeLog(log));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:remove,spas:practice:add')")
    @Log(title = "自主练打卡", businessType = BusinessType.DELETE)
    @DeleteMapping("/{logId}")
    public AjaxResult remove(@PathVariable Long logId)
    {
        return toAjax(practiceService.deleteSpasPracticeLogById(logId));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:mine,spas:practice:add')")
    @GetMapping("/mine/today")
    public AjaxResult mineToday(@RequestParam(required = false) Long subjectId)
    {
        return success(practiceService.mineToday(subjectId));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:mine,spas:practice:add')")
    @GetMapping("/mine/recent")
    public AjaxResult mineRecent(@RequestParam(required = false) Integer days)
    {
        return success(practiceService.mineRecent(days));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:mine,spas:practice:add')")
    @GetMapping("/suggest/weak")
    public AjaxResult suggestWeak(@RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) Integer limit)
    {
        return success(practiceService.suggestWeak(subjectId, limit));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:mine,spas:practice:add,spas:practice:list')")
    @GetMapping("/books/suggest")
    public AjaxResult books(@RequestParam(required = false) Long deptId,
        @RequestParam Long subjectId, @RequestParam(required = false) String q)
    {
        return success(practiceService.suggestBooks(deptId, subjectId, q));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:mine,spas:practice:add,spas:practice:list')")
    @GetMapping("/group/today")
    public AjaxResult groupToday(@RequestParam Long groupId,
        @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date practiceDate)
    {
        return success(practiceService.groupToday(groupId, practiceDate));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:stat,spas:practice:list')")
    @GetMapping("/stat/daily")
    public AjaxResult daily(@RequestParam Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date practiceDate)
    {
        return success(practiceService.dailyStat(deptId, subjectId, practiceDate));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:stat,spas:practice:list')")
    @GetMapping("/stat/alerts")
    public AjaxResult alerts(@RequestParam Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date practiceDate)
    {
        return success(practiceService.alerts(deptId, subjectId, practiceDate));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:stat,spas:practice:list')")
    @GetMapping("/stat/overlap")
    public AjaxResult overlap(@RequestParam Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date beginDate,
        @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate)
    {
        return success(practiceService.weekThemeOverlap(deptId, subjectId, beginDate, endDate));
    }

    @PreAuthorize("@ss.hasPermi('spas:practice:spot')")
    @GetMapping("/stat/spot-sample")
    public AjaxResult spotSample(@RequestParam Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date beginDate,
        @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate,
        @RequestParam(required = false) Integer limit)
    {
        return success(practiceService.spotSample(deptId, subjectId, beginDate, endDate, limit));
    }

    @PreAuthorize("@ss.hasPermi('spas:practice:spot')")
    @Log(title = "自主练抽查", businessType = BusinessType.UPDATE)
    @PutMapping("/{logId}/spot")
    public AjaxResult spot(@PathVariable Long logId, @RequestBody SpasPracticeLog body)
    {
        return toAjax(practiceService.updateSpot(logId, body.getSpotStatus(), body.getSpotRemark()));
    }

    @PreAuthorize("@ss.hasPermi('spas:intervene:add')")
    @Log(title = "自主练转干预", businessType = BusinessType.INSERT)
    @PostMapping("/alert/{logId}/to-intervene")
    public AjaxResult toIntervene(@PathVariable Long logId)
    {
        return success(practiceService.toIntervene(logId));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:mine,spas:practice:add')")
    @GetMapping("/session/profile")
    public AjaxResult profile()
    {
        return success(practiceService.sessionProfile());
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:mine,spas:practice:add,spas:practice:device')")
    @PostMapping("/device/heartbeat")
    public AjaxResult heartbeat(@RequestBody java.util.Map<String, Object> body)
    {
        String code = body == null ? null : String.valueOf(body.get("deviceCode"));
        String name = body == null || body.get("deviceName") == null ? null : String.valueOf(body.get("deviceName"));
        String ver = body == null || body.get("appVersion") == null ? null : String.valueOf(body.get("appVersion"));
        Long deptId = null;
        if (body != null && body.get("deptId") != null && !"".equals(String.valueOf(body.get("deptId"))))
        {
            deptId = Long.valueOf(String.valueOf(body.get("deptId")));
        }
        return toAjax(practiceService.heartbeatDevice(code, name, deptId, ver));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:device,spas:practice:list')")
    @GetMapping("/device/list")
    public AjaxResult devices(@RequestParam(required = false) Long deptId)
    {
        return success(practiceService.listDevices(deptId));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:stat,spas:practice:list')")
    @GetMapping("/stat/still-weak")
    public AjaxResult stillWeak(@RequestParam Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date beginDate,
        @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate)
    {
        return success(practiceService.practicedStillWeak(deptId, subjectId, beginDate, endDate));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:mine,spas:practice:add')")
    @GetMapping("/pin/status")
    public AjaxResult pinStatus()
    {
        return success(pinService.pinStatus());
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:mine,spas:practice:add')")
    @Log(title = "设置自主练PIN", businessType = BusinessType.UPDATE)
    @PutMapping("/pin")
    public AjaxResult setPin(@RequestBody java.util.Map<String, Object> body)
    {
        String pin = body == null || body.get("pin") == null ? null : String.valueOf(body.get("pin"));
        String oldPin = body == null || body.get("oldPin") == null ? null : String.valueOf(body.get("oldPin"));
        return toAjax(pinService.setPin(pin, oldPin));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:mine,spas:practice:add')")
    @GetMapping("/proxy/pending")
    public AjaxResult pendingProxy()
    {
        return success(practiceService.pendingProxyConfirm());
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:mine,spas:practice:add')")
    @Log(title = "确认代提打卡", businessType = BusinessType.UPDATE)
    @PutMapping("/proxy/{logId}/confirm")
    public AjaxResult confirmProxy(@PathVariable Long logId, @RequestBody(required = false) java.util.Map<String, Object> body)
    {
        boolean accept = true;
        if (body != null && body.get("accept") != null)
        {
            accept = Boolean.parseBoolean(String.valueOf(body.get("accept")));
        }
        int rows = practiceService.confirmProxy(logId, accept);
        AjaxResult ajax = toAjax(rows);
        ajax.put("awardedPoints", Integer.valueOf(practiceService.consumeLastAwardedPoints()));
        return ajax;
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:mine,spas:practice:add')")
    @GetMapping("/points/mine")
    public AjaxResult pointsMine()
    {
        return success(pointService.getMine());
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:mine,spas:practice:add')")
    @GetMapping("/points/ledger")
    public AjaxResult pointsLedger(@RequestParam(required = false) Integer limit)
    {
        return success(pointService.getMyLedger(limit));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:list,spas:practice:query,spas:practice:stat')")
    @GetMapping("/assignment/list")
    public AjaxResult assignmentList(SpasPracticeAssignment query)
    {
        return success(checkoutService.listAssignments(query));
    }

    @PreAuthorize("@ss.hasPermi('spas:practice:edit')")
    @Log(title = "自主练布置", businessType = BusinessType.INSERT)
    @PostMapping("/assignment")
    public AjaxResult saveAssignment(@RequestBody SpasPracticeAssignment body)
    {
        return toAjax(checkoutService.saveAssignment(body));
    }

    @PreAuthorize("@ss.hasPermi('spas:practice:edit')")
    @Log(title = "复制上次布置", businessType = BusinessType.INSERT)
    @PostMapping("/assignment/copy-last")
    public AjaxResult copyLast(@RequestBody SpasPracticeAssignment body)
    {
        return success(checkoutService.copyLast(body.getDeptId(), body.getSubjectId(), body.getAssignDate()));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:mine,spas:practice:add')")
    @GetMapping("/checkout/today")
    public AjaxResult checkoutToday(@RequestParam(required = false) Long subjectId)
    {
        return success(checkoutService.todayBundle(subjectId));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:mine,spas:practice:add')")
    @Log(title = "提交本组检查单", businessType = BusinessType.INSERT)
    @PostMapping("/checkout")
    public AjaxResult submitCheckout(@RequestBody SpasPracticeCheckout body)
    {
        int rows = checkoutService.submitCheckout(body);
        AjaxResult ajax = toAjax(rows);
        ajax.put("awardedPoints", Integer.valueOf(checkoutService.consumeLastAwardedPoints()));
        return ajax;
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:mine,spas:practice:add')")
    @Log(title = "确认检查结果", businessType = BusinessType.UPDATE)
    @PutMapping("/checkout/item/{itemId}/ack")
    public AjaxResult ackItem(@PathVariable Long itemId, @RequestBody(required = false) java.util.Map<String, Object> body)
    {
        boolean accept = true;
        if (body != null && body.get("accept") != null)
        {
            accept = Boolean.parseBoolean(String.valueOf(body.get("accept")));
        }
        int rows = checkoutService.ackItem(itemId, accept);
        AjaxResult ajax = toAjax(rows);
        ajax.put("awardedPoints", Integer.valueOf(checkoutService.consumeLastAwardedPoints()));
        return ajax;
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:edit,spas:practice:spot')")
    @Log(title = "困难已知晓", businessType = BusinessType.UPDATE)
    @PutMapping("/checkout/item/{itemId}/follow")
    public AjaxResult followItem(@PathVariable Long itemId)
    {
        return toAjax(checkoutService.followItem(itemId));
    }

    @PreAuthorize("@ss.hasPermi('spas:intervene:add')")
    @Log(title = "检查单转干预", businessType = BusinessType.INSERT)
    @PostMapping("/checkout/item/{itemId}/to-intervene")
    public AjaxResult checkoutToIntervene(@PathVariable Long itemId)
    {
        return success(checkoutService.toIntervene(itemId));
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:stat,spas:practice:list')")
    @GetMapping("/stat/checkout-alerts")
    public AjaxResult checkoutAlerts(@RequestParam Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date practiceDate)
    {
        return success(checkoutService.alerts(deptId, subjectId, practiceDate));
    }

    @PreAuthorize("@ss.hasPermi('spas:practice:spot')")
    @GetMapping("/stat/spot-queue")
    public AjaxResult spotQueue(@RequestParam Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date practiceDate)
    {
        return success(checkoutService.spotQueue(deptId, subjectId, practiceDate));
    }

    @PreAuthorize("@ss.hasPermi('spas:practice:spot')")
    @Log(title = "检查单抽检", businessType = BusinessType.UPDATE)
    @PutMapping("/spot/{itemId}")
    public AjaxResult checkoutSpot(@PathVariable Long itemId, @RequestBody java.util.Map<String, Object> body)
    {
        String result = body == null || body.get("spotResult") == null ? null : String.valueOf(body.get("spotResult"));
        String remark = body == null || body.get("spotRemark") == null ? null : String.valueOf(body.get("spotRemark"));
        int rows = checkoutService.recordSpot(itemId, result, remark);
        AjaxResult ajax = toAjax(rows);
        ajax.put("awardedPoints", Integer.valueOf(checkoutService.consumeLastAwardedPoints()));
        return ajax;
    }

    @PreAuthorize("@ss.hasAnyPermi('spas:practice:mine,spas:practice:add,spas:practice:list,spas:practice:stat')")
    @GetMapping("/points/leaderboard")
    public AjaxResult pointsLeaderboard(@RequestParam(required = false) Long deptId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String range,
        @RequestParam(required = false) Integer limit)
    {
        return success(pointService.getLeaderboard(deptId, subjectId, range, limit));
    }
}
