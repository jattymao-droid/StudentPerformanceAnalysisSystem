package com.ruoyi.spas.qb.domain;

/**
 * Recognize / preview a boxed region on annotate session page
 */
public class SpasQbAnnotateRecognizeRequest
{
    private String sessionId;
    private Integer pageNo;
    private Double x;
    private Double y;
    private Double w;
    private Double h;
    private String role;

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }
    public Integer getPageNo() { return pageNo; }
    public void setPageNo(Integer pageNo) { this.pageNo = pageNo; }
    public Double getX() { return x; }
    public void setX(Double x) { this.x = x; }
    public Double getY() { return y; }
    public void setY(Double y) { this.y = y; }
    public Double getW() { return w; }
    public void setW(Double w) { this.w = w; }
    public Double getH() { return h; }
    public void setH(Double h) { this.h = h; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
}
