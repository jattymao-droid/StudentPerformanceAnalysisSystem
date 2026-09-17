package com.ruoyi.spas.service;

import java.util.List;
import com.ruoyi.spas.domain.SpasWarningRecord;

public interface ISpasWarningRecordService
{
    List<SpasWarningRecord> selectSpasWarningRecordList(SpasWarningRecord record);

    SpasWarningRecord selectSpasWarningRecordById(Long warningId);

    int handleRecord(SpasWarningRecord record);
}
