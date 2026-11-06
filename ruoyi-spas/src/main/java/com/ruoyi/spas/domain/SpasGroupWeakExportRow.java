package com.ruoyi.spas.domain;

import java.math.BigDecimal;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Export row for study-group weak knowledge points.
 */
public class SpasGroupWeakExportRow extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** \u5c0f\u7ec4 */
    @Excel(name = "\u5c0f\u7ec4", sort = 1)
    private String groupName;

    /** \u5b66\u79d1 */
    @Excel(name = "\u5b66\u79d1", sort = 2)
    private String subjectName;

    /** \u77e5\u8bc6\u70b9 */
    @Excel(name = "\u77e5\u8bc6\u70b9", sort = 3, width = 28)
    private String knowledgeName;

    /** \u7ec4\u5747\u5f97\u5206\u7387(%) */
    @Excel(name = "\u7ec4\u5747\u5f97\u5206\u7387(%)", sort = 4, scale = 1)
    private BigDecimal groupRatePct;

    /** \u73ed\u5747\u5f97\u5206\u7387(%) */
    @Excel(name = "\u73ed\u5747\u5f97\u5206\u7387(%)", sort = 5, scale = 1)
    private BigDecimal classRatePct;

    /** \u8584\u5f31\u4eba\u6570 */
    @Excel(name = "\u8584\u5f31\u4eba\u6570", sort = 6)
    private String weakCountLabel;

    /** \u8584\u5f31\u6210\u5458 */
    @Excel(name = "\u8584\u5f31\u6210\u5458", sort = 7, width = 28)
    private String weakStudentNames;

    /** \u6b63\u5f0f\u8584\u5f31\u4eba\u6570 */
    @Excel(name = "\u6b63\u5f0f\u8584\u5f31\u4eba\u6570", sort = 8)
    private Integer formalWeakStudentCount;

    /** \u5224\u5b9a */
    @Excel(name = "\u5224\u5b9a", sort = 9)
    private String judgeLabel;

    /** \u5e73\u5747\u4f5c\u7b54 */
    @Excel(name = "\u5e73\u5747\u4f5c\u7b54", sort = 10)
    private Integer attemptCount;

    public String getGroupName()
    {
        return groupName;
    }

    public void setGroupName(String groupName)
    {
        this.groupName = groupName;
    }

    public String getSubjectName()
    {
        return subjectName;
    }

    public void setSubjectName(String subjectName)
    {
        this.subjectName = subjectName;
    }

    public String getKnowledgeName()
    {
        return knowledgeName;
    }

    public void setKnowledgeName(String knowledgeName)
    {
        this.knowledgeName = knowledgeName;
    }

    public BigDecimal getGroupRatePct()
    {
        return groupRatePct;
    }

    public void setGroupRatePct(BigDecimal groupRatePct)
    {
        this.groupRatePct = groupRatePct;
    }

    public BigDecimal getClassRatePct()
    {
        return classRatePct;
    }

    public void setClassRatePct(BigDecimal classRatePct)
    {
        this.classRatePct = classRatePct;
    }

    public String getWeakCountLabel()
    {
        return weakCountLabel;
    }

    public void setWeakCountLabel(String weakCountLabel)
    {
        this.weakCountLabel = weakCountLabel;
    }

    public String getWeakStudentNames()
    {
        return weakStudentNames;
    }

    public void setWeakStudentNames(String weakStudentNames)
    {
        this.weakStudentNames = weakStudentNames;
    }

    public Integer getFormalWeakStudentCount()
    {
        return formalWeakStudentCount;
    }

    public void setFormalWeakStudentCount(Integer formalWeakStudentCount)
    {
        this.formalWeakStudentCount = formalWeakStudentCount;
    }

    public String getJudgeLabel()
    {
        return judgeLabel;
    }

    public void setJudgeLabel(String judgeLabel)
    {
        this.judgeLabel = judgeLabel;
    }

    public Integer getAttemptCount()
    {
        return attemptCount;
    }

    public void setAttemptCount(Integer attemptCount)
    {
        this.attemptCount = attemptCount;
    }
}
