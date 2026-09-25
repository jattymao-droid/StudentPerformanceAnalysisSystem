package com.ruoyi.spas.qb.domain;

/**
 * Normalized box on a page (ratios 0..1 relative to page image)
 */
public class SpasQbAnnotateRegion
{
    /** stem | options | answer | analysis | diagram */
    private String role;
    private Integer pageNo;
    private Double x;
    private Double y;
    private Double w;
    private Double h;

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
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
}
