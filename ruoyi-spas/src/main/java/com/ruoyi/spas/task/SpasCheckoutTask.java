package com.ruoyi.spas.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.ruoyi.spas.service.ISpasPracticeCheckoutService;

/**
 * Quartz bean: invoke as spasCheckoutTask.expirePendingAck()
 * Marks overnight unconfirmed checkout items as timeout (member_ack=3).
 */
@Component("spasCheckoutTask")
public class SpasCheckoutTask
{
    private static final Logger log = LoggerFactory.getLogger(SpasCheckoutTask.class);

    @Autowired
    private ISpasPracticeCheckoutService checkoutService;

    public void expirePendingAck()
    {
        int n = checkoutService.expirePendingAcks();
        log.info("spasCheckoutTask.expirePendingAck updated={}", n);
    }
}
