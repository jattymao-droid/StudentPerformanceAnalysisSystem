package com.ruoyi.spas.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasErrorTag;

public interface SpasErrorTagMapper
{
    public SpasErrorTag selectByStudentAndQuestion(@Param("studentId") Long studentId,
        @Param("questionId") Long questionId);

    public List<SpasErrorTag> selectByStudentId(@Param("studentId") Long studentId);

    public int insertSpasErrorTag(SpasErrorTag tag);

    public int updateSpasErrorTag(SpasErrorTag tag);

    public int deleteByStudentAndQuestion(@Param("studentId") Long studentId,
        @Param("questionId") Long questionId);

    public List<java.util.Map<String, Object>> selectCauseSummary(@Param("studentId") Long studentId);
}
