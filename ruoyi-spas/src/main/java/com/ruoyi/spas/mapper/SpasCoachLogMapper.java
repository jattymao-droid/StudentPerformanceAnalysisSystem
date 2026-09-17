package com.ruoyi.spas.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasCoachLog;

public interface SpasCoachLogMapper
{
    List<SpasCoachLog> selectSpasCoachLogList(SpasCoachLog log);

    int insertSpasCoachLog(SpasCoachLog log);

    int deleteSpasCoachLogByIds(Long[] logIds);
}
