package com.ruoyi.spas.service;

import java.util.List;
import com.ruoyi.spas.domain.SpasSubject;

/**
 * Subject service
 */
public interface ISpasSubjectService
{
    public List<SpasSubject> selectSpasSubjectList(SpasSubject subject);

    public SpasSubject selectSpasSubjectById(Long subjectId);

    public List<SpasSubject> selectSpasSubjectAll();

    public boolean checkSubjectCodeUnique(SpasSubject subject);

    public int insertSpasSubject(SpasSubject subject);

    public int updateSpasSubject(SpasSubject subject);

    public int deleteSpasSubjectByIds(Long[] subjectIds);
}
