package com.ruoyi.spas.controller;

import java.util.Date;
import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.spas.domain.SpasExam;
import com.ruoyi.spas.service.ISpasExamScoreService;
import com.ruoyi.spas.service.impl.SpasExamRankTrendService;

/**
 * Multi-subject exam score and school rank import
 */
@RestController
@RequestMapping("/spas/examScore")
public class SpasExamScoreController extends BaseController
{
    @Autowired
    private ISpasExamScoreService examScoreService;

    @Autowired
    private SpasExamRankTrendService rankTrendService;

    @PreAuthorize("@ss.hasPermi('spas:examScore:list')")
    @GetMapping("/list")
    public TableDataInfo list(SpasExam exam)
    {
        startPage();
        List<SpasExam> list = examScoreService.selectSpasExamList(exam);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('spas:examScore:list')")
    @GetMapping("/{examId}")
    public AjaxResult getInfo(@PathVariable Long examId)
    {
        return success(examScoreService.selectSpasExamById(examId));
    }

    @PreAuthorize("@ss.hasPermi('spas:examScore:list')")
    @GetMapping("/{examId}/matrix")
    public AjaxResult matrix(@PathVariable Long examId)
    {
        Map<String, Object> data = examScoreService.selectExamMatrix(examId);
        return success(data);
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student') or @ss.hasPermi('spas:examScore:list')")
    @GetMapping("/studentRankTrend")
    public AjaxResult rankTrend(@RequestParam Long studentId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds)
    {
        return success(rankTrendService.selectRankTrend(studentId, window, parsePaperIds(paperIds), subjectId));
    }

    @PreAuthorize("@ss.hasPermi('spas:analysis:student') or @ss.hasPermi('spas:examScore:list')")
    @Log(title = "Rank Trend PDF", businessType = BusinessType.EXPORT)
    @PostMapping("/studentRankTrend/export")
    public void exportRankTrend(@RequestParam Long studentId,
        @RequestParam(required = false) Long subjectId,
        @RequestParam(required = false) String window,
        @RequestParam(required = false) String paperIds,
        HttpServletResponse response)
    {
        rankTrendService.exportPdf(studentId, window, paperIds, subjectId, response);
    }

    @PreAuthorize("@ss.hasPermi('spas:examScore:import')")
    @PostMapping("/template")
    public void downloadTemplate(@RequestParam Long deptId, HttpServletResponse response)
    {
        examScoreService.downloadTemplate(deptId, response);
    }

    @PreAuthorize("@ss.hasPermi('spas:examScore:import')")
    @Log(title = "Exam Score Import", businessType = BusinessType.IMPORT)
    @PostMapping("/import")
    public AjaxResult importData(@RequestParam String examName,
        @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date examDate,
        @RequestParam Long deptId,
        @RequestParam(required = false) Long paperId,
        @RequestParam(defaultValue = "true") boolean overwrite,
        MultipartFile file) throws Exception
    {
        SpasExam exam = examScoreService.importScores(examName, examDate, deptId, paperId, file, overwrite, getUsername());
        return success(exam);
    }

    @PreAuthorize("@ss.hasPermi('spas:examScore:export')")
    @Log(title = "Exam Score Export", businessType = BusinessType.EXPORT)
    @PostMapping("/export/{examId}")
    public void export(@PathVariable Long examId, HttpServletResponse response)
    {
        examScoreService.exportExam(examId, response);
    }

    @PreAuthorize("@ss.hasPermi('spas:examScore:remove')")
    @Log(title = "Exam Score Remove", businessType = BusinessType.DELETE)
    @DeleteMapping("/{examIds}")
    public AjaxResult remove(@PathVariable Long[] examIds)
    {
        return toAjax(examScoreService.deleteSpasExamByIds(examIds));
    }

    private List<Long> parsePaperIds(String paperIds)
    {
        if (paperIds == null || paperIds.trim().isEmpty())
        {
            return null;
        }
        List<Long> ids = new java.util.ArrayList<Long>();
        for (String part : paperIds.split(","))
        {
            String s = part.trim();
            if (s.isEmpty())
            {
                continue;
            }
            ids.add(Long.valueOf(s));
        }
        return ids.isEmpty() ? null : ids;
    }
}
