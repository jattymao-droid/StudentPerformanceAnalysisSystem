package com.ruoyi.spas.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.domain.AjaxResult;

/**
 * SPAS module health check endpoint.
 */
@RestController
@RequestMapping("/spas")
public class SpasPingController
{
    @GetMapping("/ping")
    public AjaxResult ping()
    {
        return AjaxResult.success("spas-ok");
    }
}
