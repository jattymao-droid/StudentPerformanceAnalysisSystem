package com.ruoyi.spas.qb.config;

/**
 * Effective QB AI settings after merging sys_config over yml defaults.
 */
public class SpasQbAiRuntimeConfig
{
    private boolean enabled;
    private String endpoint;
    private String apiKey;
    private String model;
    private int timeoutMs;
    private int topK;

    public boolean isEnabled()
    {
        return enabled;
    }

    public void setEnabled(boolean enabled)
    {
        this.enabled = enabled;
    }

    public String getEndpoint()
    {
        return endpoint;
    }

    public void setEndpoint(String endpoint)
    {
        this.endpoint = endpoint;
    }

    public String getApiKey()
    {
        return apiKey;
    }

    public void setApiKey(String apiKey)
    {
        this.apiKey = apiKey;
    }

    public String getModel()
    {
        return model;
    }

    public void setModel(String model)
    {
        this.model = model;
    }

    public int getTimeoutMs()
    {
        return timeoutMs;
    }

    public void setTimeoutMs(int timeoutMs)
    {
        this.timeoutMs = timeoutMs;
    }

    public int getTopK()
    {
        return topK;
    }

    public void setTopK(int topK)
    {
        this.topK = topK;
    }
}
