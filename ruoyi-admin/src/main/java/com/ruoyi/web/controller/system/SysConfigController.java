package com.ruoyi.web.controller.system;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.SysConfig;
import com.ruoyi.system.service.ISysConfigService;

/**
 * 参数配置 信息操作处理
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/system/config")
public class SysConfigController extends BaseController
{
    public static final String KEY_SITE_COPYRIGHT = "sys.site.copyright";
    public static final String KEY_SITE_ICP = "sys.site.icp";
    public static final String KEY_SITE_ICP_URL = "sys.site.icpUrl";

    @Autowired
    private ISysConfigService configService;

    @PreAuthorize("@ss.hasPermi('system:config:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysConfig config)
    {
        startPage();
        List<SysConfig> list = configService.selectConfigList(config);
        return getDataTable(list);
    }

    @Log(title = "参数管理", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('system:config:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysConfig config)
    {
        List<SysConfig> list = configService.selectConfigList(config);
        ExcelUtil<SysConfig> util = new ExcelUtil<SysConfig>(SysConfig.class);
        util.exportExcel(response, list, "参数数据");
    }

    @PreAuthorize("@ss.hasPermi('system:config:query')")
    @GetMapping(value = "/{configId:\\d+}")
    public AjaxResult getInfo(@PathVariable Long configId)
    {
        return success(configService.selectConfigById(configId));
    }

    /**
     * 登录页站点信息（版权 / ICP），匿名可读
     */
    @Anonymous
    @GetMapping("/siteInfo")
    public AjaxResult getSiteInfo()
    {
        Map<String, Object> data = new HashMap<>();
        data.put("copyright", configService.selectConfigByKey(KEY_SITE_COPYRIGHT));
        data.put("icp", configService.selectConfigByKey(KEY_SITE_ICP));
        String icpUrl = configService.selectConfigByKey(KEY_SITE_ICP_URL);
        if (StringUtils.isEmpty(icpUrl))
        {
            icpUrl = "https://beian.miit.gov.cn/";
        }
        data.put("icpUrl", icpUrl);
        return success(data);
    }

    /**
     * 保存站点信息（系统管理 · 站点信息）
     */
    @PreAuthorize("@ss.hasPermi('system:site:edit')")
    @Log(title = "站点信息", businessType = BusinessType.UPDATE)
    @PutMapping("/siteInfo")
    public AjaxResult saveSiteInfo(@RequestBody Map<String, Object> body)
    {
        String copyright = body == null ? "" : strVal(body.get("copyright"));
        String icp = body == null ? "" : strVal(body.get("icp"));
        String icpUrl = body == null ? "" : strVal(body.get("icpUrl"));
        if (StringUtils.isEmpty(icpUrl))
        {
            icpUrl = "https://beian.miit.gov.cn/";
        }
        upsertSiteKey(KEY_SITE_COPYRIGHT, copyright, "站点版权文案", "登录页与页脚版权文字");
        upsertSiteKey(KEY_SITE_ICP, icp, "ICP备案号", "空则登录页不显示备案行");
        upsertSiteKey(KEY_SITE_ICP_URL, icpUrl, "ICP备案链接", "备案号点击跳转");
        return success();
    }

    private static String strVal(Object v)
    {
        if (v == null)
        {
            return "";
        }
        String s = String.valueOf(v);
        return "null".equals(s) ? "" : s;
    }

    private void upsertSiteKey(String key, String value, String name, String remark)
    {
        SysConfig probe = new SysConfig();
        probe.setConfigKey(key);
        List<SysConfig> list = configService.selectConfigList(probe);
        SysConfig exist = null;
        if (list != null)
        {
            for (SysConfig c : list)
            {
                if (c != null && key.equals(c.getConfigKey()))
                {
                    exist = c;
                    break;
                }
            }
        }
        if (exist == null)
        {
            SysConfig row = new SysConfig();
            row.setConfigName(name);
            row.setConfigKey(key);
            row.setConfigValue(value == null ? "" : value);
            row.setConfigType("Y");
            row.setRemark(remark);
            row.setCreateBy(getUsername());
            configService.insertConfig(row);
        }
        else
        {
            exist.setConfigValue(value == null ? "" : value);
            exist.setUpdateBy(getUsername());
            configService.updateConfig(exist);
        }
    }

    @GetMapping(value = "/configKey/{configKey}")
    public AjaxResult getConfigKey(@PathVariable String configKey)
    {
        if (isSensitiveConfigKey(configKey))
        {
            return error("敏感参数不可通过该接口读取");
        }
        return success(configService.selectConfigByKey(configKey));
    }

    private static boolean isSensitiveConfigKey(String configKey)
    {
        if (configKey == null)
        {
            return false;
        }
        // 用户管理页需读取初始密码参数，不属于密钥类敏感项
        if ("sys.user.initPassword".equals(configKey))
        {
            return false;
        }
        String k = configKey.toLowerCase();
        return k.contains("api-key") || k.contains("apikey") || k.contains("secret")
                || k.contains("password") || k.endsWith(".token");
    }

    @PreAuthorize("@ss.hasPermi('system:config:add')")
    @Log(title = "参数管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SysConfig config)
    {
        if (!configService.checkConfigKeyUnique(config))
        {
            return error("新增参数'" + config.getConfigName() + "'失败，参数键名已存在");
        }
        config.setCreateBy(getUsername());
        return toAjax(configService.insertConfig(config));
    }

    @PreAuthorize("@ss.hasPermi('system:config:edit')")
    @Log(title = "参数管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody SysConfig config)
    {
        if (!configService.checkConfigKeyUnique(config))
        {
            return error("修改参数'" + config.getConfigName() + "'失败，参数键名已存在");
        }
        config.setUpdateBy(getUsername());
        return toAjax(configService.updateConfig(config));
    }

    @PreAuthorize("@ss.hasPermi('system:config:remove')")
    @Log(title = "参数管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{configIds}")
    public AjaxResult remove(@PathVariable Long[] configIds)
    {
        configService.deleteConfigByIds(configIds);
        return success();
    }

    @PreAuthorize("@ss.hasPermi('system:config:remove')")
    @Log(title = "参数管理", businessType = BusinessType.CLEAN)
    @DeleteMapping("/refreshCache")
    public AjaxResult refreshCache()
    {
        configService.resetConfigCache();
        return success();
    }
}
