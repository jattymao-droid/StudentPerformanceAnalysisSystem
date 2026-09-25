package com.ruoyi.spas.task;

import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.ruoyi.spas.service.ISpasAnalysisService;

/**
 * Quartz bean: invoke as spasRecalcTask.run()
 * Nightly full-school mastery snapshot refresh.
 */
@Component("spasRecalcTask")
public class SpasRecalcTask
{
    private static final Logger log = LoggerFactory.getLogger(SpasRecalcTask.class);

    @Autowired
    private ISpasAnalysisService analysisService;

    public void run()
    {
        Map<String, Object> result = analysisService.recalculateAll(Boolean.TRUE);
        log.info("spasRecalcTask.run studentCount={} statRows={} warningCreated={} interveneAsync={}",
            result.get("studentCount"), result.get("statRows"), result.get("warningCreated"),
            result.get("interveneAsync"));
    }
}
