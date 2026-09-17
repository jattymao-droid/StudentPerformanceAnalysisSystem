package com.ruoyi.spas.mapper;

import java.util.List;
import com.ruoyi.spas.domain.SpasSubject;

/**
 * Subject mapper
 */
public interface SpasSubjectMapper
{
    public List<SpasSubject> selectSpasSubjectList(SpasSubject subject);

    public SpasSubject selectSpasSubjectById(Long subjectId);

    public List<SpasSubject> selectSpasSubjectAll();

    public SpasSubject checkSubjectCodeUnique(String subjectCode);

    public int insertSpasSubject(SpasSubject subject);

    public int updateSpasSubject(SpasSubject subject);

    public int deleteSpasSubjectById(Long subjectId);

    public int deleteSpasSubjectByIds(Long[] subjectIds);
}
