package com.ruoyi.spas.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Teacher error-cause tag spas_error_tag
 */
public class SpasErrorTag extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long tagId;
    private Long studentId;
    private Long paperId;
    private Long questionId;
    /** reading | calc | concept | skip  (legacy) / v2 subcodes */
    private String errorCode;

    /** display */
    private String errorLabel;
    /** D2 category code */
    private String errorCategory;
    private String errorCategoryLabel;
    private String studentName;
    private String questionNo;
    private String paperName;

    public Long getTagId()
    {
        return tagId;
    }

    public void setTagId(Long tagId)
    {
        this.tagId = tagId;
    }

    public Long getStudentId()
    {
        return studentId;
    }

    public void setStudentId(Long studentId)
    {
        this.studentId = studentId;
    }

    public Long getPaperId()
    {
        return paperId;
    }

    public void setPaperId(Long paperId)
    {
        this.paperId = paperId;
    }

    public Long getQuestionId()
    {
        return questionId;
    }

    public void setQuestionId(Long questionId)
    {
        this.questionId = questionId;
    }

    public String getErrorCode()
    {
        return errorCode;
    }

    public void setErrorCode(String errorCode)
    {
        this.errorCode = errorCode;
    }

    public String getErrorLabel()
    {
        return errorLabel;
    }

    public void setErrorLabel(String errorLabel)
    {
        this.errorLabel = errorLabel;
    }

    public String getErrorCategory()
    {
        return errorCategory;
    }

    public void setErrorCategory(String errorCategory)
    {
        this.errorCategory = errorCategory;
    }

    public String getErrorCategoryLabel()
    {
        return errorCategoryLabel;
    }

    public void setErrorCategoryLabel(String errorCategoryLabel)
    {
        this.errorCategoryLabel = errorCategoryLabel;
    }

    public String getStudentName()
    {
        return studentName;
    }

    public void setStudentName(String studentName)
    {
        this.studentName = studentName;
    }

    public String getQuestionNo()
    {
        return questionNo;
    }

    public void setQuestionNo(String questionNo)
    {
        this.questionNo = questionNo;
    }

    public String getPaperName()
    {
        return paperName;
    }

    public void setPaperName(String paperName)
    {
        this.paperName = paperName;
    }
}
