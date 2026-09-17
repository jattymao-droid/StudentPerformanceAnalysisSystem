package com.ruoyi.spas.service;

import java.util.List;
import java.util.Map;

public interface ISpasQualityService
{
    Map<String, Object> overview(Long deptId, Long subjectId);

    List<Map<String, Object>> detail(String metric, Long deptId, Long subjectId);
}
