package com.ruoyi.spas.service.impl;

import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.spas.domain.SpasWarningRecord;
import com.ruoyi.spas.mapper.SpasWarningRecordMapper;
import com.ruoyi.spas.service.ISpasWarningRecordService;
import com.ruoyi.spas.support.SpasAccessService;
import com.ruoyi.spas.support.SpasTeacherScopeService;

@Service
public class SpasWarningRecordServiceImpl implements ISpasWarningRecordService
{
    @Autowired
    private SpasWarningRecordMapper recordMapper;

    @Autowired
    private SpasTeacherScopeService teacherScopeService;

    @Autowired
    private SpasAccessService accessService;

    @Override
    public List<SpasWarningRecord> selectSpasWarningRecordList(SpasWarningRecord record)
    {
        if (teacherScopeService.useTeacherDeptFilter())
        {
            teacherScopeService.applyTeacherDeptFilter(record);
            return recordMapper.selectSpasWarningRecordList(record);
        }
        return SpringUtils.getAopProxy(this).selectSpasWarningRecordListScoped(record);
    }

    @DataScope(deptAlias = "s")
    public List<SpasWarningRecord> selectSpasWarningRecordListScoped(SpasWarningRecord record)
    {
        return recordMapper.selectSpasWarningRecordList(record);
    }

    @Override
    public SpasWarningRecord selectSpasWarningRecordById(Long warningId)
    {
        SpasWarningRecord record = recordMapper.selectSpasWarningRecordById(warningId);
        if (record != null)
        {
            accessService.checkStudentAccess(record.getStudentId());
        }
        return record;
    }

    @Override
    public int handleRecord(SpasWarningRecord record)
    {
        if (record.getWarningId() == null || StringUtils.isEmpty(record.getStatus()))
        {
            throw new ServiceException("预警ID与状态不能为空");
        }
        if (!"1".equals(record.getStatus()) && !"2".equals(record.getStatus()))
        {
            throw new ServiceException("状态只能是 1(已处理) 或 2(已忽略)");
        }
        SpasWarningRecord db = recordMapper.selectSpasWarningRecordById(record.getWarningId());
        if (db == null)
        {
            throw new ServiceException("预警记录不存在");
        }
        accessService.checkStudentAccess(db.getStudentId());
        record.setHandleBy(SecurityUtils.getUsername());
        record.setHandleTime(new Date());
        return recordMapper.updateSpasWarningRecord(record);
    }
}
