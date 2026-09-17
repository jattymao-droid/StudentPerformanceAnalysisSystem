package com.ruoyi.spas.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.ruoyi.spas.warning.WarningEngine;

/**
 * Quartz bean: invoke as spasWarningTask.run()
 */
@Component("spasWarningTask")
public class SpasWarningTask
{
    private static final Logger log = LoggerFactory.getLogger(SpasWarningTask.class);

    @Autowired
    private WarningEngine warningEngine;

    public void run()
    {
        int created = warningEngine.evaluateAllEnabled();
        log.info("spasWarningTask.run created={}", created);
    }
}
