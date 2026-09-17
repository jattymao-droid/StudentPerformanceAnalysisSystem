package com.ruoyi.spas.service;

import java.util.List;
import com.ruoyi.spas.domain.SpasSubjectQuestionType;

/**
 * Subject question type service
 */
public interface ISpasSubjectQuestionTypeService
{
    public List<SpasSubjectQuestionType> selectList(SpasSubjectQuestionType query);

    public SpasSubjectQuestionType selectById(Long typeId);

    public List<SpasSubjectQuestionType> selectEnabledBySubjectId(Long subjectId);

    public boolean checkTypeCodeUnique(SpasSubjectQuestionType entity);

    public int insert(SpasSubjectQuestionType entity);

    public int update(SpasSubjectQuestionType entity);

    public int deleteByIds(Long[] typeIds);
}
