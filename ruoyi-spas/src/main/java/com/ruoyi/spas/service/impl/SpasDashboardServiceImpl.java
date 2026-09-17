package com.ruoyi.spas.service.impl;

import java.util.HashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.mapper.SpasDashboardMapper;
import com.ruoyi.spas.service.ISpasDashboardService;
import com.ruoyi.spas.support.SpasTeacherScopeService;

@Service
public class SpasDashboardServiceImpl implements ISpasDashboardService
{
    @Autowired
    private SpasDashboardMapper dashboardMapper;

    @Autowired
    private SpasTeacherScopeService teacherScopeService;

    @Override
    public Map<String, Object> getOverview()
    {
        SpasStudent scope = new SpasStudent();
        if (teacherScopeService.useTeacherDeptFilter())
        {
            teacherScopeService.applyTeacherDeptFilter(scope);
            return loadOverview(scope);
        }
        return SpringUtils.getAopProxy(this).getOverviewScoped(scope);
    }

    @DataScope(deptAlias = "d")
    public Map<String, Object> getOverviewScoped(SpasStudent scope)
    {
        return loadOverview(scope);
    }

    private Map<String, Object> loadOverview(SpasStudent scope)
    {
        Map<String, Object> data = new HashMap<>();
        data.put("studentCount", dashboardMapper.countActiveStudents(scope));
        data.put("openWarningCount", dashboardMapper.countOpenWarnings(scope));
        data.put("publishedPaperCount", dashboardMapper.countPublishedPapers(scope));
        data.put("recentBatches", dashboardMapper.selectRecentBatches(scope, 5));
        data.put("weakKnowledgeTop", dashboardMapper.selectWeakKnowledgeTop(scope, 3));
        data.put("openInterveneCount", dashboardMapper.countOpenIntervenes(scope));
        data.put("qualityAlertCount", dashboardMapper.countQualityAlerts(scope));
        return data;
    }
}
