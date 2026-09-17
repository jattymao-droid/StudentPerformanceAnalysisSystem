package com.ruoyi.spas.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasSubjectQuestionType;
import com.ruoyi.spas.mapper.SpasSubjectQuestionTypeMapper;
import com.ruoyi.spas.service.ISpasSubjectQuestionTypeService;

/**
 * Subject question type service impl
 */
@Service
public class SpasSubjectQuestionTypeServiceImpl implements ISpasSubjectQuestionTypeService
{
    @Autowired
    private SpasSubjectQuestionTypeMapper mapper;

    @Override
    public List<SpasSubjectQuestionType> selectList(SpasSubjectQuestionType query)
    {
        return mapper.selectList(query);
    }

    @Override
    public SpasSubjectQuestionType selectById(Long typeId)
    {
        return mapper.selectById(typeId);
    }

    @Override
    public List<SpasSubjectQuestionType> selectEnabledBySubjectId(Long subjectId)
    {
        return mapper.selectEnabledBySubjectId(subjectId);
    }

    @Override
    public boolean checkTypeCodeUnique(SpasSubjectQuestionType entity)
    {
        Long typeId = entity.getTypeId() == null ? -1L : entity.getTypeId();
        SpasSubjectQuestionType info = mapper.checkUnique(entity.getSubjectId(), entity.getTypeCode(), typeId);
        return StringUtils.isNull(info);
    }

    @Override
    public int insert(SpasSubjectQuestionType entity)
    {
        if (StringUtils.isEmpty(entity.getStatus()))
        {
            entity.setStatus("0");
        }
        if (entity.getSort() == null)
        {
            entity.setSort(0);
        }
        return mapper.insert(entity);
    }

    @Override
    public int update(SpasSubjectQuestionType entity)
    {
        return mapper.update(entity);
    }

    @Override
    public int deleteByIds(Long[] typeIds)
    {
        if (typeIds == null || typeIds.length == 0)
        {
            return 0;
        }
        for (Long typeId : typeIds)
        {
            SpasSubjectQuestionType type = mapper.selectById(typeId);
            if (type == null)
            {
                continue;
            }
            int refs = mapper.countPaperQuestionByTypeCode(type.getSubjectId(), type.getTypeCode());
            if (refs > 0)
            {
                throw new ServiceException("题型已被试卷题目引用，无法删除");
            }
        }
        return mapper.deleteByIds(typeIds);
    }
}
