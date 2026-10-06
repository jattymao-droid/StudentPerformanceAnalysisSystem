package com.ruoyi.spas.mapper;

import java.util.Date;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasStudentPin;

public interface SpasStudentPinMapper
{
    SpasStudentPin selectByStudentId(Long studentId);

    int upsertPin(SpasStudentPin pin);

    int clearFail(@Param("studentId") Long studentId);

    int bumpFail(@Param("studentId") Long studentId, @Param("lockUntil") Date lockUntil);

    int disablePin(Long studentId);
}
