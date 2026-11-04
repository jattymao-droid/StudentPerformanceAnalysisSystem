package com.ruoyi.spas.service;

import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpServletResponse;

public interface ISpasReportService
{
    Map<String, Object> previewStudent(Long studentId, Long subjectId);

    Map<String, Object> previewStudent(Long studentId, Long subjectId, String window, List<Long> paperIds);

    /** Same as analysis page: optional useRecency + weakTop limit (default 10). */
    Map<String, Object> previewStudent(Long studentId, Long subjectId, String window, List<Long> paperIds,
        Boolean useRecency, Integer limit);

    Map<String, Object> previewClass(Long deptId, Long subjectId);

    Map<String, Object> previewClass(Long deptId, Long subjectId, String window, List<Long> paperIds);

    void exportStudent(Long studentId, Long subjectId, String format, HttpServletResponse response);

    void exportStudent(Long studentId, Long subjectId, String window, List<Long> paperIds, String format,
        HttpServletResponse response);

    void exportStudent(Long studentId, Long subjectId, String window, List<Long> paperIds, Boolean useRecency,
        Integer limit, String format, HttpServletResponse response);

    void exportClass(Long deptId, Long subjectId, String format, HttpServletResponse response);

    void exportClass(Long deptId, Long subjectId, String window, List<Long> paperIds, String format,
        HttpServletResponse response);

    /**
     * Batch export class reports as ZIP. Pass parentDeptId to include all direct child depts,
     * and/or explicit deptIds. Empty children falls back to parent itself.
     */
    void exportClassBatch(Long parentDeptId, List<Long> deptIds, Long subjectId, String window,
        List<Long> paperIds, String format, HttpServletResponse response);

    /**
     * One-click: ZIP of per-student academic reports for everyone in the class (dept).
     * Students without score data are skipped.
     * Optional jobId enables Redis progress for UI polling.
     */
    void exportClassStudents(Long deptId, Long subjectId, String window, List<Long> paperIds,
        Boolean useRecency, Integer limit, String format, String jobId, HttpServletResponse response);

    /** Progress snapshot for batch student ZIP export (jobId from exportClassStudents). */
    Map<String, Object> getClassStudentsExportProgress(String jobId);
}
