package com.ruoyi.spas.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.spas.domain.SpasQualityTicket;

public interface ISpasQualityService
{
    Map<String, Object> overview(Long deptId, Long subjectId);

    List<Map<String, Object>> detail(String metric, Long deptId, Long subjectId);

    List<SpasQualityTicket> selectTicketList(SpasQualityTicket query);

    SpasQualityTicket selectTicketById(Long ticketId);

    int insertTicket(SpasQualityTicket ticket);

    int updateTicket(SpasQualityTicket ticket);

    int deleteTicketByIds(Long[] ticketIds);
}
