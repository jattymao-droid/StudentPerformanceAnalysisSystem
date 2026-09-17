package com.ruoyi.spas.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasSubject;
import com.ruoyi.spas.mapper.SpasSubjectMapper;
import com.ruoyi.spas.service.ISpasSubjectService;

/**
 * Subject service implementation
 */
@Service
public class SpasSubjectServiceImpl implements ISpasSubjectService
{
    @Autowired
    private SpasSubjectMapper subjectMapper;

    @Override
    public List<SpasSubject> selectSpasSubjectList(SpasSubject subject)
    {
        return subjectMapper.selectSpasSubjectList(subject);
    }

    @Override
    public SpasSubject selectSpasSubjectById(Long subjectId)
    {
        return subjectMapper.selectSpasSubjectById(subjectId);
    }

    @Override
    public List<SpasSubject> selectSpasSubjectAll()
    {
        return subjectMapper.selectSpasSubjectAll();
    }

    @Override
    public boolean checkSubjectCodeUnique(SpasSubject subject)
    {
        Long subjectId = StringUtils.isNull(subject.getSubjectId()) ? -1L : subject.getSubjectId();
        SpasSubject info = subjectMapper.checkSubjectCodeUnique(subject.getSubjectCode());
        if (StringUtils.isNotNull(info) && info.getSubjectId().longValue() != subjectId.longValue())
        {
            return UserConstants.NOT_UNIQUE;
        }
        return UserConstants.UNIQUE;
    }

    @Override
    public int insertSpasSubject(SpasSubject subject)
    {
        return subjectMapper.insertSpasSubject(subject);
    }

    @Override
    public int updateSpasSubject(SpasSubject subject)
    {
        return subjectMapper.updateSpasSubject(subject);
    }

    @Override
    public int deleteSpasSubjectByIds(Long[] subjectIds)
    {
        return subjectMapper.deleteSpasSubjectByIds(subjectIds);
    }
}
