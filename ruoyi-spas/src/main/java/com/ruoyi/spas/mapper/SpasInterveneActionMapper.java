package com.ruoyi.spas.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasInterveneAction;

public interface SpasInterveneActionMapper
{
    List<SpasInterveneAction> selectByInterveneId(Long interveneId);

    List<SpasInterveneAction> selectByInterveneIds(@Param("interveneIds") List<Long> interveneIds);

    int countByInterveneId(Long interveneId);

    int insertSpasInterveneAction(SpasInterveneAction action);

    int updateSpasInterveneAction(SpasInterveneAction action);

    int deleteByInterveneId(Long interveneId);

    int markPendingDoneByType(@Param("interveneId") Long interveneId,
        @Param("actionType") String actionType,
        @Param("refId") Long refId,
        @Param("remark") String remark,
        @Param("updateBy") String updateBy);
}
