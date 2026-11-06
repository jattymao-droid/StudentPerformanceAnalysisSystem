package com.ruoyi.spas.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Intervention required action spas_intervene_action
 */
public class SpasInterveneAction extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    public static final String TYPE_PRACTICE = "practice";
    public static final String TYPE_SELECT = "select";
    public static final String TYPE_COACH = "coach";
    public static final String TYPE_CUSTOM = "custom";

    public static final String STATUS_PENDING = "0";
    public static final String STATUS_DONE = "1";
    public static final String STATUS_SKIPPED = "2";

    private Long actionId;
    private Long interveneId;
    /** practice | select | coach | custom */
    private String actionType;
    private Long refId;
    /** 0 pending 1 done 2 skipped */
    private String status;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date dueAt;
    private String title;
    private String progressJson;

    public Long getActionId() { return actionId; }
    public void setActionId(Long actionId) { this.actionId = actionId; }
    public Long getInterveneId() { return interveneId; }
    public void setInterveneId(Long interveneId) { this.interveneId = interveneId; }
    public String getActionType() { return actionType; }
    public void setActionType(String actionType) { this.actionType = actionType; }
    public Long getRefId() { return refId; }
    public void setRefId(Long refId) { this.refId = refId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Date getDueAt() { return dueAt; }
    public void setDueAt(Date dueAt) { this.dueAt = dueAt; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getProgressJson() { return progressJson; }
    public void setProgressJson(String progressJson) { this.progressJson = progressJson; }
}
