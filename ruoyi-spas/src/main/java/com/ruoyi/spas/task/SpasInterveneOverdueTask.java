package com.ruoyi.spas.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.ruoyi.spas.service.ISpasInterveneService;

/**
 * Quartz bean: invoke as spasInterveneTask.markOverdue()
 */
@Component("spasInterveneTask")
public class SpasInterveneOverdueTask
{
    private static final Logger log = LoggerFactory.getLogger(SpasInterveneOverdueTask.class);

    @Autowired
    private ISpasInterveneService interveneService;

    public void markOverdue()
    {
        int n = interveneService.markOverdue();
        log.info("spasInterveneTask.markOverdue updated={}", n);
    }
}