package com.ruoyi.spas.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

/**
 * Student kiosk PIN hash spas_student_pin
 */
public class SpasStudentPin
{
    private Long studentId;
    private String pinHash;
    private String status;
    private Integer failCount;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date lockUntil;
    private Date createTime;
    private Date updateTime;

    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }
    public String getPinHash() { return pinHash; }
    public void setPinHash(String pinHash) { this.pinHash = pinHash; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getFailCount() { return failCount; }
    public void setFailCount(Integer failCount) { this.failCount = failCount; }
    public Date getLockUntil() { return lockUntil; }
    public void setLockUntil(Date lockUntil) { this.lockUntil = lockUntil; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }
}
