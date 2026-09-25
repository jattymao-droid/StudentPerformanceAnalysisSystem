package com.ruoyi.web.controller.system;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.qb.config.SpasQbAiConfigKeys;
import com.ruoyi.spas.qb.config.SpasQbAiConfigSupport;
import com.ruoyi.spas.qb.config.SpasQbAiHttpClient;
import com.ruoyi.spas.qb.config.SpasQbAiRuntimeConfig;
import com.ruoyi.system.domain.SysConfig;
import com.ruoyi.system.service.ISysConfigService;

/**
 * System Management - LLM (QB AI) settings stored in sys_config.
 */
@RestController
@RequestMapping("/system/llm")
public class SysLlmConfigController extends BaseController
{
    private static final String MASK = "********";

    @Autowired
    private ISysConfigService configService;

    @Autowired
    private SpasQbAiConfigSupport aiConfigSupport;

    @Autowired
    private SpasQbAiHttpClient aiHttpClient;

    @PreAuthorize("@ss.hasPermi('system:llm:query')")
    @GetMapping({ "", "/" })
    public AjaxResult get()
    {
        SpasQbAiRuntimeConfig cfg = aiConfigSupport.resolve();
        Map<String, Object> data = new HashMap<>();
        data.put("enabled", cfg.isEnabled());
        data.put("endpoint", cfg.getEndpoint());
        data.put("model", cfg.getModel());
        data.put("timeoutMs", cfg.getTimeoutMs());
        data.put("topK", cfg.getTopK());
        boolean set = StringUtils.isNotEmpty(cfg.getApiKey());
        data.put("apiKeySet", set);
        data.put("apiKeyMasked", set ? mask(cfg.getApiKey()) : "");
        data.put("apiKey", set ? MASK : "");
        return success(data);
    }

    @PreAuthorize("@ss.hasPermi('system:llm:edit')")
    @Log(title = "\u5927\u6a21\u578b\u914d\u7f6e", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult save(@RequestBody Map<String, Object> body)
    {
        if (body == null)
        {
            return error("\u53c2\u6570\u4e0d\u80fd\u4e3a\u7a7a");
        }
        upsert(SpasQbAiConfigKeys.ENABLED, boolStr(body.get("enabled")));
        upsert(SpasQbAiConfigKeys.ENDPOINT, str(body.get("endpoint")));
        upsert(SpasQbAiConfigKeys.MODEL, str(body.get("model")));
        upsert(SpasQbAiConfigKeys.TIMEOUT_MS, str(body.get("timeoutMs")));
        upsert(SpasQbAiConfigKeys.TOP_K, str(body.get("topK")));

        String apiKey = str(body.get("apiKey"));
        if (StringUtils.isNotEmpty(apiKey) && !MASK.equals(apiKey) && !apiKey.startsWith("****"))
        {
            upsert(SpasQbAiConfigKeys.API_KEY, apiKey);
        }
        return success();
    }


    @PreAuthorize("@ss.hasPermi('system:llm:edit')")
    @Log(title = "\u5927\u6a21\u578b\u8fde\u901a\u6d4b\u8bd5", businessType = BusinessType.OTHER)
    @PostMapping("/test")
    public AjaxResult test(@RequestBody(required = false) Map<String, Object> body)
    {
        SpasQbAiRuntimeConfig base = aiConfigSupport.resolve();
        SpasQbAiRuntimeConfig cfg = new SpasQbAiRuntimeConfig();
        cfg.setEnabled(true);
        cfg.setEndpoint(pick(body, "endpoint", base.getEndpoint()));
        cfg.setModel(pick(body, "model", base.getModel()));
        cfg.setTimeoutMs(base.getTimeoutMs());
        if (body != null && body.get("timeoutMs") != null)
        {
            Integer n = Convert.toInt(String.valueOf(body.get("timeoutMs")), base.getTimeoutMs());
            cfg.setTimeoutMs(n == null ? base.getTimeoutMs() : n);
        }
        cfg.setTopK(base.getTopK());
        String apiKey = body == null ? "" : str(body.get("apiKey"));
        if (StringUtils.isNotEmpty(apiKey) && !MASK.equals(apiKey) && !apiKey.startsWith("****"))
        {
            cfg.setApiKey(apiKey);
        }
        else
        {
            cfg.setApiKey(base.getApiKey());
        }
        Map<String, Object> result = aiHttpClient.testConnection(cfg);
        if (Boolean.TRUE.equals(result.get("ok")))
        {
            return success(result);
        }
        return AjaxResult.error(str(result.get("message")), result);
    }

    private static String pick(Map<String, Object> body, String key, String fallback)
    {
        if (body == null || body.get(key) == null)
        {
            return fallback == null ? "" : fallback;
        }
        String v = str(body.get(key));
        return StringUtils.isEmpty(v) ? (fallback == null ? "" : fallback) : v;
    }

    private void upsert(String key, String value)
    {
        if (value == null)
        {
            value = "";
        }
        SysConfig existing = findByKey(key);
        if (existing == null)
        {
            SysConfig row = new SysConfig();
            row.setConfigName(key);
            row.setConfigKey(key);
            row.setConfigValue(value);
            row.setConfigType("N");
            row.setCreateBy(getUsername());
            configService.insertConfig(row);
        }
        else
        {
            existing.setConfigValue(value);
            existing.setUpdateBy(getUsername());
            configService.updateConfig(existing);
        }
    }

    private SysConfig findByKey(String key)
    {
        SysConfig q = new SysConfig();
        q.setConfigKey(key);
        List<SysConfig> list = configService.selectConfigList(q);
        if (list == null)
        {
            return null;
        }
        for (SysConfig c : list)
        {
            if (key.equals(c.getConfigKey()))
            {
                return c;
            }
        }
        return null;
    }

    private static String str(Object v)
    {
        return v == null ? "" : String.valueOf(v).trim();
    }

    private static String boolStr(Object v)
    {
        if (v instanceof Boolean)
        {
            return ((Boolean) v) ? "true" : "false";
        }
        return Convert.toBool(str(v), false) ? "true" : "false";
    }

    private static String mask(String key)
    {
        if (key == null || key.length() < 8)
        {
            return MASK;
        }
        return key.substring(0, 3) + "****" + key.substring(key.length() - 4);
    }
}
