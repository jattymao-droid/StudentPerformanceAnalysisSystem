package com.ruoyi.spas.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.domain.SpasWarningRecord;

public interface ISpasOpenService
{
    Map<String, Object> issueToken(String appId, String appSecret, String mobile);

    List<SpasStudent> listBoundStudents(Long parentId);

    void assertBound(Long parentId, Long studentId);

    Map<String, Object> getPortfolio(Long parentId, Long studentId, Long subjectId);

    List<SpasWarningRecord> listWarnings(Long parentId, Long studentId);

    List<Map<String, Object>> radar(Long parentId, Long studentId, Long subjectId);

    List<Map<String, Object>> trend(Long parentId, Long studentId, Long subjectId);

    List<Map<String, Object>> weakTop(Long parentId, Long studentId, Long subjectId, Integer limit);
}
