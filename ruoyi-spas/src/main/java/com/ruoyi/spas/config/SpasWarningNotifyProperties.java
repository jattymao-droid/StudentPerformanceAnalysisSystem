package com.ruoyi.spas.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * Warning notify channel hooks (spas.warning.*).
 */
@Component
@ConfigurationProperties(prefix = "spas.warning")
public class SpasWarningNotifyProperties
{
    /** Optional HTTP webhook URL; empty = disabled */
    private String webhookUrl = "";

    private int webhookTimeoutMs = 5000;

    public String getWebhookUrl()
    {
        return webhookUrl;
    }

    public void setWebhookUrl(String webhookUrl)
    {
        this.webhookUrl = webhookUrl == null ? "" : webhookUrl.trim();
    }

    public boolean isWebhookEnabled()
    {
        return webhookUrl != null && !webhookUrl.isEmpty();
    }

    public int getWebhookTimeoutMs()
    {
        return webhookTimeoutMs;
    }

    public void setWebhookTimeoutMs(int webhookTimeoutMs)
    {
        this.webhookTimeoutMs = webhookTimeoutMs > 0 ? webhookTimeoutMs : 5000;
    }
}
