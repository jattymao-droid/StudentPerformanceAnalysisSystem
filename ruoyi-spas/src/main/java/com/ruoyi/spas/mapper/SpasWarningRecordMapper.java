package com.ruoyi.spas.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasWarningRecord;

public interface SpasWarningRecordMapper
{
    List<SpasWarningRecord> selectSpasWarningRecordList(SpasWarningRecord record);

    SpasWarningRecord selectSpasWarningRecordById(Long warningId);

    SpasWarningRecord selectOpenRecord(@Param("studentId") Long studentId, @Param("ruleId") Long ruleId);

    List<Long> selectOpenStudentIdsByRule(@Param("ruleId") Long ruleId);

    int insertSpasWarningRecord(SpasWarningRecord record);

    int updateSpasWarningRecord(SpasWarningRecord record);

    int countOpenByStudent(Long studentId);

    List<SpasWarningRecord> selectOpenByStudent(@Param("studentId") Long studentId);
}
