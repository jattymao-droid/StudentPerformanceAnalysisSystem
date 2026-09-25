package com.ruoyi.spas.qb.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * Question-bank AI suggest settings (DeepSeek / OpenAI-compatible).
 */
@Component
@ConfigurationProperties(prefix = "spas.qb.ai")
public class SpasQbAiProperties
{
    private boolean enabled = false;
    private String endpoint = "https://api.deepseek.com/v1/chat/completions";
    private String apiKey = "";
    private String model = "deepseek-chat";
    private int timeoutMs = 30000;
    private int topK = 5;

    public boolean isEnabled() { return enabled; }
    public void setEnabled(boolean enabled) { this.enabled = enabled; }
    public String getEndpoint() { return endpoint; }
    public void setEndpoint(String endpoint) { this.endpoint = endpoint; }
    public String getApiKey() { return apiKey; }
    public void setApiKey(String apiKey) { this.apiKey = apiKey; }
    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }
    public int getTimeoutMs() { return timeoutMs; }
    public void setTimeoutMs(int timeoutMs) { this.timeoutMs = timeoutMs; }
    public int getTopK() { return topK; }
    public void setTopK(int topK) { this.topK = topK; }
}
