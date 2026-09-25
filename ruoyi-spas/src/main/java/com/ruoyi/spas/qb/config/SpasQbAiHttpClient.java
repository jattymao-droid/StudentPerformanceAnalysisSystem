package com.ruoyi.spas.qb.config;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import org.springframework.stereotype.Component;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;

/**
 * OpenAI-compatible chat/completions client for QB AI.
 */
@Component
public class SpasQbAiHttpClient
{
    public String postChatCompletions(SpasQbAiRuntimeConfig aiCfg, String jsonBody)
    {
        if (aiCfg == null || StringUtils.isEmpty(aiCfg.getEndpoint()))
        {
            throw new ServiceException("AI endpoint empty");
        }
        HttpURLConnection conn = null;
        try
        {
            URL url = new URL(aiCfg.getEndpoint());
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setConnectTimeout(Math.max(1000, aiCfg.getTimeoutMs()));
            conn.setReadTimeout(Math.max(1000, aiCfg.getTimeoutMs()));
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("Accept", "application/json");
            if (StringUtils.isNotEmpty(aiCfg.getApiKey()))
            {
                conn.setRequestProperty("Authorization", "Bearer " + aiCfg.getApiKey());
            }
            byte[] payload = jsonBody.getBytes(StandardCharsets.UTF_8);
            conn.setFixedLengthStreamingMode(payload.length);
            try (OutputStream os = conn.getOutputStream())
            {
                os.write(payload);
            }
            int code = conn.getResponseCode();
            InputStream stream = code >= 200 && code < 300 ? conn.getInputStream() : conn.getErrorStream();
            String resp = readStream(stream);
            if (code < 200 || code >= 300)
            {
                throw new ServiceException("AI HTTP " + code + ": " + truncate(resp, 300));
            }
            return resp;
        }
        catch (ServiceException e)
        {
            throw e;
        }
        catch (Exception e)
        {
            throw new ServiceException("AI call failed: " + e.getMessage());
        }
        finally
        {
            if (conn != null)
            {
                conn.disconnect();
            }
        }
    }

    /**
     * Lightweight connectivity probe using current or override settings.
     * @return map: ok, latencyMs, model, message
     */
    public Map<String, Object> testConnection(SpasQbAiRuntimeConfig aiCfg)
    {
        Map<String, Object> out = new HashMap<>();
        long t0 = System.currentTimeMillis();
        try
        {
            if (aiCfg == null || StringUtils.isEmpty(aiCfg.getEndpoint()))
            {
                throw new ServiceException("endpoint empty");
            }
            if (StringUtils.isEmpty(aiCfg.getApiKey()))
            {
                throw new ServiceException("api-key empty");
            }
            JSONObject body = new JSONObject();
            body.put("model", StringUtils.isEmpty(aiCfg.getModel()) ? "deepseek-chat" : aiCfg.getModel());
            body.put("temperature", 0);
            body.put("max_tokens", 8);
            JSONArray messages = new JSONArray();
            JSONObject msg = new JSONObject();
            msg.put("role", "user");
            msg.put("content", "Reply with exactly: ok");
            messages.add(msg);
            body.put("messages", messages);
            String resp = postChatCompletions(aiCfg, body.toJSONString());
            long ms = System.currentTimeMillis() - t0;
            out.put("ok", Boolean.TRUE);
            out.put("latencyMs", ms);
            out.put("model", aiCfg.getModel());
            out.put("message", summarizeTestResponse(resp));
        }
        catch (Exception e)
        {
            out.put("ok", Boolean.FALSE);
            out.put("latencyMs", System.currentTimeMillis() - t0);
            out.put("model", aiCfg == null ? "" : aiCfg.getModel());
            out.put("message", e.getMessage() == null ? "failed" : e.getMessage());
        }
        return out;
    }

    private String summarizeTestResponse(String resp)
    {
        try
        {
            JSONObject root = JSON.parseObject(resp);
            if (root != null && root.containsKey("choices"))
            {
                JSONArray choices = root.getJSONArray("choices");
                if (choices != null && !choices.isEmpty())
                {
                    JSONObject c0 = choices.getJSONObject(0);
                    if (c0.getJSONObject("message") != null)
                    {
                        String content = c0.getJSONObject("message").getString("content");
                        return truncate(content == null ? "ok" : content.trim(), 80);
                    }
                }
            }
        }
        catch (Exception ignored)
        {
        }
        return "ok";
    }

    private String readStream(InputStream stream) throws Exception
    {
        if (stream == null)
        {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(stream, StandardCharsets.UTF_8)))
        {
            char[] buf = new char[4096];
            int n;
            while ((n = reader.read(buf)) >= 0)
            {
                sb.append(buf, 0, n);
            }
        }
        return sb.toString();
    }

    private static String truncate(String text, int max)
    {
        if (text == null)
        {
            return "";
        }
        return text.length() <= max ? text : text.substring(0, max);
    }
}
