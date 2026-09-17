package com.ruoyi.spas.open.filter;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import com.alibaba.fastjson2.JSON;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.open.SpasOpenContext;
import com.ruoyi.spas.open.SpasOpenToken;
import com.ruoyi.spas.open.config.SpasOpenProperties;
import com.ruoyi.spas.service.impl.SpasOpenServiceImpl;

/**
 * Auth gate for /open/v1/** (except oauth/token).
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE + 20)
public class SpasOpenAuthFilter extends OncePerRequestFilter
{
    @Autowired
    private SpasOpenProperties openProperties;

    @Autowired
    private SpasOpenServiceImpl openService;

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request)
    {
        String path = request.getRequestURI();
        String context = request.getContextPath();
        if (StringUtils.isNotEmpty(context) && path.startsWith(context))
        {
            path = path.substring(context.length());
        }
        if (!path.startsWith("/open/v1/"))
        {
            return true;
        }
        return "/open/v1/oauth/token".equals(path);
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
        throws ServletException, IOException
    {
        try
        {
            if (!openProperties.isEnabled())
            {
                writeJson(response, HttpServletResponse.SC_SERVICE_UNAVAILABLE,
                    AjaxResult.error(503, "开放接口未启用"));
                return;
            }
            String auth = request.getHeader("Authorization");
            String token = null;
            if (StringUtils.isNotEmpty(auth) && auth.regionMatches(true, 0, "Bearer ", 0, 7))
            {
                token = auth.substring(7).trim();
            }
            if (StringUtils.isEmpty(token))
            {
                writeJson(response, HttpServletResponse.SC_UNAUTHORIZED,
                    AjaxResult.error(401, "缺少 Bearer Token"));
                return;
            }
            SpasOpenToken payload = openService.resolveToken(token);
            if (payload == null || payload.getParentId() == null)
            {
                writeJson(response, HttpServletResponse.SC_UNAUTHORIZED,
                    AjaxResult.error(401, "Token 无效或已过期"));
                return;
            }
            SpasOpenContext.set(payload);
            filterChain.doFilter(request, response);
        }
        finally
        {
            SpasOpenContext.clear();
        }
    }

    private void writeJson(HttpServletResponse response, int status, AjaxResult body) throws IOException
    {
        response.setStatus(status);
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.getWriter().write(JSON.toJSONString(body));
    }
}
