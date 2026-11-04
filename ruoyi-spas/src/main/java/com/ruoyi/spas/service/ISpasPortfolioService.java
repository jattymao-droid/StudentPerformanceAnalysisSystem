package com.ruoyi.spas.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.spas.domain.SpasCoachLog;

public interface ISpasPortfolioService
{
    Map<String, Object> getPortfolio(Long studentId, Long subjectId);

    Map<String, Object> getMyPortfolio(Long subjectId);

    /**
     * 档案核心分析切片（雷达/趋势/薄弱/开放预警）。调用方自行鉴权；供 Open / Report 等复用，避免各端重复拼装。
     */
    Map<String, Object> getAnalysisSlices(Long studentId, Long subjectId);

    List<SpasCoachLog> selectCoachLogList(SpasCoachLog log);

    int insertCoachLog(SpasCoachLog log);
}
