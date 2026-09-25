package com.ruoyi.spas.qb.config;

/**
 * sys_config keys for QB AI / LLM (DeepSeek OpenAI-compatible).
 */
public final class SpasQbAiConfigKeys
{
    public static final String ENABLED = "spas.qb.ai.enabled";
    public static final String ENDPOINT = "spas.qb.ai.endpoint";
    public static final String API_KEY = "spas.qb.ai.api-key";
    public static final String MODEL = "spas.qb.ai.model";
    public static final String TIMEOUT_MS = "spas.qb.ai.timeout-ms";
    public static final String TOP_K = "spas.qb.ai.top-k";

    private SpasQbAiConfigKeys()
    {
    }

    public static boolean isSensitiveKey(String configKey)
    {
        if (configKey == null)
        {
            return false;
        }
        String k = configKey.toLowerCase();
        return k.contains("api-key") || k.contains("apikey") || k.contains("secret")
                || k.contains("password") || k.endsWith(".token");
    }
}
