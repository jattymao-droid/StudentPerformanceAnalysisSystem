package com.ruoyi.spas.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

/**
 * Student point account spas_student_point_account
 */
public class SpasStudentPointAccount
{
    private Long studentId;
    private Integer totalPoints;
    private Integer levelNo;
    private Integer dayStreak;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date lastPracticeDate;
    private Integer weekPoints;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date weekStart;
    private Date updateTime;

    /** transient display */
    private String studentName;
    private String studentNo;
    private Integer rankNo;
    private Integer todayPoints;
    private Integer levelMinPoints;
    private Integer levelMaxPoints;
    private Integer pointsToNext;
    private Integer lastAwardPoints;
    /** transient: 成长农场阶段 seed/seedling/sapling/tree（与 Lv 独立） */
    private String farmStage;
    private String farmStageLabel;
    private Integer farmStageMinPoints;
    private Integer farmStageMaxPoints;
    private Integer pointsToNextFarmStage;

    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }
    public Integer getTotalPoints() { return totalPoints; }
    public void setTotalPoints(Integer totalPoints) { this.totalPoints = totalPoints; }
    public Integer getLevelNo() { return levelNo; }
    public void setLevelNo(Integer levelNo) { this.levelNo = levelNo; }
    public Integer getDayStreak() { return dayStreak; }
    public void setDayStreak(Integer dayStreak) { this.dayStreak = dayStreak; }
    public Date getLastPracticeDate() { return lastPracticeDate; }
    public void setLastPracticeDate(Date lastPracticeDate) { this.lastPracticeDate = lastPracticeDate; }
    public Integer getWeekPoints() { return weekPoints; }
    public void setWeekPoints(Integer weekPoints) { this.weekPoints = weekPoints; }
    public Date getWeekStart() { return weekStart; }
    public void setWeekStart(Date weekStart) { this.weekStart = weekStart; }
    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public String getStudentNo() { return studentNo; }
    public void setStudentNo(String studentNo) { this.studentNo = studentNo; }
    public Integer getRankNo() { return rankNo; }
    public void setRankNo(Integer rankNo) { this.rankNo = rankNo; }
    public Integer getTodayPoints() { return todayPoints; }
    public void setTodayPoints(Integer todayPoints) { this.todayPoints = todayPoints; }
    public Integer getLevelMinPoints() { return levelMinPoints; }
    public void setLevelMinPoints(Integer levelMinPoints) { this.levelMinPoints = levelMinPoints; }
    public Integer getLevelMaxPoints() { return levelMaxPoints; }
    public void setLevelMaxPoints(Integer levelMaxPoints) { this.levelMaxPoints = levelMaxPoints; }
    public Integer getPointsToNext() { return pointsToNext; }
    public void setPointsToNext(Integer pointsToNext) { this.pointsToNext = pointsToNext; }
    public Integer getLastAwardPoints() { return lastAwardPoints; }
    public void setLastAwardPoints(Integer lastAwardPoints) { this.lastAwardPoints = lastAwardPoints; }
    public String getFarmStage() { return farmStage; }
    public void setFarmStage(String farmStage) { this.farmStage = farmStage; }
    public String getFarmStageLabel() { return farmStageLabel; }
    public void setFarmStageLabel(String farmStageLabel) { this.farmStageLabel = farmStageLabel; }
    public Integer getFarmStageMinPoints() { return farmStageMinPoints; }
    public void setFarmStageMinPoints(Integer farmStageMinPoints) { this.farmStageMinPoints = farmStageMinPoints; }
    public Integer getFarmStageMaxPoints() { return farmStageMaxPoints; }
    public void setFarmStageMaxPoints(Integer farmStageMaxPoints) { this.farmStageMaxPoints = farmStageMaxPoints; }
    public Integer getPointsToNextFarmStage() { return pointsToNextFarmStage; }
    public void setPointsToNextFarmStage(Integer pointsToNextFarmStage) { this.pointsToNextFarmStage = pointsToNextFarmStage; }
}
