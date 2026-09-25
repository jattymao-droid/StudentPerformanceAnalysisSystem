package com.ruoyi.spas.open.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * Parent OpenAPI settings (spas.open.*)
 */
@Component
@ConfigurationProperties(prefix = "spas.open")
public class SpasOpenProperties
{
    /** Master switch */
    private boolean enabled = false;

    /** Access token TTL in minutes */
    private int tokenTtlMinutes = 120;

    /** Log authenticated OpenAPI access as SPAS_OPEN_AUDIT */
    private boolean auditLog = true;

    public boolean isEnabled()
    {
        return enabled;
    }

    public void setEnabled(boolean enabled)
    {
        this.enabled = enabled;
    }

    public int getTokenTtlMinutes()
    {
        return tokenTtlMinutes;
    }

    public void setTokenTtlMinutes(int tokenTtlMinutes)
    {
        this.tokenTtlMinutes = tokenTtlMinutes;
    }

    public boolean isAuditLog()
    {
        return auditLog;
    }

    public void setAuditLog(boolean auditLog)
    {
        this.auditLog = auditLog;
    }
}
