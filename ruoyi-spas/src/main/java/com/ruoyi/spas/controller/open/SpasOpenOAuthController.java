package com.ruoyi.spas.controller.open;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.spas.service.ISpasOpenService;

/**
 * Parent OpenAPI token endpoint
 */
@RestController
@RequestMapping("/open/v1/oauth")
public class SpasOpenOAuthController extends BaseController
{
    @Autowired
    private ISpasOpenService openService;

    @PostMapping("/token")
    public AjaxResult token(@RequestBody Map<String, String> body)
    {
        String appId = body == null ? null : body.get("appId");
        String appSecret = body == null ? null : body.get("appSecret");
        String mobile = body == null ? null : body.get("mobile");
        return success(openService.issueToken(appId, appSecret, mobile));
    }
}
