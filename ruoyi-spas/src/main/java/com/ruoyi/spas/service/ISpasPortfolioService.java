package com.ruoyi.spas.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.spas.domain.SpasCoachLog;

public interface ISpasPortfolioService
{
    Map<String, Object> getPortfolio(Long studentId, Long subjectId);

    Map<String, Object> getMyPortfolio(Long subjectId);

    List<SpasCoachLog> selectCoachLogList(SpasCoachLog log);

    int insertCoachLog(SpasCoachLog log);
}
