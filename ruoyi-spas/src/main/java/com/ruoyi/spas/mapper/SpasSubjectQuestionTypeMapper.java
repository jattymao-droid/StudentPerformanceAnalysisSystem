package com.ruoyi.spas.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasSubjectQuestionType;

/**
 * Subject question type mapper
 */
public interface SpasSubjectQuestionTypeMapper
{
    public List<SpasSubjectQuestionType> selectList(SpasSubjectQuestionType query);

    public SpasSubjectQuestionType selectById(Long typeId);

    public List<SpasSubjectQuestionType> selectEnabledBySubjectId(Long subjectId);

    public SpasSubjectQuestionType checkUnique(@Param("subjectId") Long subjectId,
        @Param("typeCode") String typeCode, @Param("typeId") Long typeId);

    public int countPaperQuestionByTypeCode(@Param("subjectId") Long subjectId, @Param("typeCode") String typeCode);

    public int insert(SpasSubjectQuestionType entity);

    public int update(SpasSubjectQuestionType entity);

    public int deleteById(Long typeId);

    public int deleteByIds(Long[] typeIds);
}
