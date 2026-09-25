package com.ruoyi.spas.qb.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.service.ISysConfigService;

/**
 * Resolve QB AI settings: sys_config (runtime, admin UI) overrides application.yml.
 */
@Component
public class SpasQbAiConfigSupport
{
    @Autowired
    private SpasQbAiProperties ymlProperties;

    @Autowired
    private ISysConfigService configService;

    public SpasQbAiRuntimeConfig resolve()
    {
        SpasQbAiRuntimeConfig cfg = new SpasQbAiRuntimeConfig();
        cfg.setEnabled(readBool(SpasQbAiConfigKeys.ENABLED, ymlProperties.isEnabled()));
        cfg.setEndpoint(readStr(SpasQbAiConfigKeys.ENDPOINT, ymlProperties.getEndpoint()));
        cfg.setApiKey(readStr(SpasQbAiConfigKeys.API_KEY, ymlProperties.getApiKey()));
        cfg.setModel(readStr(SpasQbAiConfigKeys.MODEL, ymlProperties.getModel()));
        cfg.setTimeoutMs(readInt(SpasQbAiConfigKeys.TIMEOUT_MS, ymlProperties.getTimeoutMs(), 1000, 300000));
        cfg.setTopK(readInt(SpasQbAiConfigKeys.TOP_K, ymlProperties.getTopK(), 1, 20));
        return cfg;
    }

    private String readStr(String key, String fallback)
    {
        String v = configService.selectConfigByKey(key);
        if (StringUtils.isNotEmpty(v))
        {
            return v.trim();
        }
        return fallback == null ? "" : fallback;
    }

    private boolean readBool(String key, boolean fallback)
    {
        String v = configService.selectConfigByKey(key);
        if (StringUtils.isEmpty(v))
        {
            return fallback;
        }
        return Convert.toBool(v, fallback);
    }

    private int readInt(String key, int fallback, int min, int max)
    {
        String v = configService.selectConfigByKey(key);
        if (StringUtils.isEmpty(v))
        {
            return clamp(fallback, min, max);
        }
        Integer n = Convert.toInt(v, fallback);
        return clamp(n == null ? fallback : n, min, max);
    }

    private static int clamp(int v, int min, int max)
    {
        if (v < min)
        {
            return min;
        }
        if (v > max)
        {
            return max;
        }
        return v;
    }
}
