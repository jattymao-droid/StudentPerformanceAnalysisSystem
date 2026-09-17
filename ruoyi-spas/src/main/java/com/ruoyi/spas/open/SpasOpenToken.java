package com.ruoyi.spas.open;

import java.io.Serializable;

/**
 * Cached open access token payload
 */
public class SpasOpenToken implements Serializable
{
    private static final long serialVersionUID = 1L;

    private String token;
    private Long parentId;
    private String mobile;
    private String appId;
    private Long clientId;

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }
    public Long getParentId() { return parentId; }
    public void setParentId(Long parentId) { this.parentId = parentId; }
    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }
    public String getAppId() { return appId; }
    public void setAppId(String appId) { this.appId = appId; }
    public Long getClientId() { return clientId; }
    public void setClientId(Long clientId) { this.clientId = clientId; }
}
