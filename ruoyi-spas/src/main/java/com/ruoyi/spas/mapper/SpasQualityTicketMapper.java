package com.ruoyi.spas.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasQualityTicket;

public interface SpasQualityTicketMapper
{
    List<SpasQualityTicket> selectTicketList(SpasQualityTicket query);

    SpasQualityTicket selectTicketById(Long ticketId);

    int insertTicket(SpasQualityTicket ticket);

    int updateTicket(SpasQualityTicket ticket);

    int deleteTicketByIds(@Param("ticketIds") Long[] ticketIds);
}
