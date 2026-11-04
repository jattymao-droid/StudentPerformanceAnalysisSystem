package com.ruoyi.web.core.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import com.ruoyi.spas.analysis.AnalysisQueryRequestCache;

/**
 * Clears analysis request-scope ThreadLocal caches after each /spas/analysis call.
 */
@Configuration
public class SpasAnalysisCacheConfig implements WebMvcConfigurer
{
    @Override
    public void addInterceptors(InterceptorRegistry registry)
    {
        registry.addInterceptor(new HandlerInterceptor()
        {
            @Override
            public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler,
                Exception ex)
            {
                AnalysisQueryRequestCache.clear();
            }
        }).addPathPatterns("/spas/analysis/**");
    }
}
