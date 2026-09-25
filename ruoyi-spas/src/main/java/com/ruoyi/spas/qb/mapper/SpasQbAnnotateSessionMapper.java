package com.ruoyi.spas.qb.mapper;

import com.ruoyi.spas.qb.domain.SpasQbAnnotateSession;

/**
 * Annotate session mapper
 */
public interface SpasQbAnnotateSessionMapper
{
    int insertSession(SpasQbAnnotateSession session);

    SpasQbAnnotateSession selectById(String sessionId);

    int updateStatus(SpasQbAnnotateSession session);
}
