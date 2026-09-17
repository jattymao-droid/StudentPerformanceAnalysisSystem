package com.ruoyi.spas.service;

import java.util.Map;
import jakarta.servlet.http.HttpServletResponse;

public interface ISpasReportService
{
    Map<String, Object> previewStudent(Long studentId, Long subjectId);

    Map<String, Object> previewClass(Long deptId, Long subjectId);

    void exportStudent(Long studentId, Long subjectId, String format, HttpServletResponse response);

    void exportClass(Long deptId, Long subjectId, String format, HttpServletResponse response);
}
