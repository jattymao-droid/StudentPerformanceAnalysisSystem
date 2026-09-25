package com.ruoyi.spas.config;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.Test;

class SpasWarningNotifyPropertiesTest
{
    @Test
    void webhookDisabledWhenUrlBlank()
    {
        SpasWarningNotifyProperties p = new SpasWarningNotifyProperties();
        p.setWebhookUrl("  ");
        assertFalse(p.isWebhookEnabled());
        p.setWebhookUrl("https://hooks.example.com/spas");
        assertTrue(p.isWebhookEnabled());
    }
}
