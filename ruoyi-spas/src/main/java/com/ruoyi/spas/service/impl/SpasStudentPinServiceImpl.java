package com.ruoyi.spas.service.impl;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.domain.SpasStudentPin;
import com.ruoyi.spas.mapper.SpasStudentMapper;
import com.ruoyi.spas.mapper.SpasStudentPinMapper;
import com.ruoyi.spas.service.ISpasStudentPinService;

@Service
public class SpasStudentPinServiceImpl implements ISpasStudentPinService
{
    private static final String REDIS_FAIL_KEY = "spas:practice:pin:fail:";
    private static final int MAX_FAIL = 5;
    private static final int LOCK_MINUTES = 15;

    @Autowired
    private SpasStudentPinMapper pinMapper;

    @Autowired
    private SpasStudentMapper studentMapper;

    @Autowired
    private RedisCache redisCache;

    @Override
    public Map<String, Object> pinStatus()
    {
        SpasStudent self = requireLoginStudent();
        SpasStudentPin pin = pinMapper.selectByStudentId(self.getStudentId());
        Map<String, Object> data = new HashMap<String, Object>();
        boolean set = pin != null && "0".equals(pin.getStatus()) && StringUtils.isNotEmpty(pin.getPinHash());
        data.put("pinSet", Boolean.valueOf(set));
        data.put("studentNo", self.getStudentNo());
        return data;
    }

    @Override
    public int setPin(String pin, String oldPin)
    {
        SpasStudent self = requireLoginStudent();
        validatePinFormat(pin);
        SpasStudentPin existing = pinMapper.selectByStudentId(self.getStudentId());
        if (existing != null && "0".equals(existing.getStatus()) && StringUtils.isNotEmpty(existing.getPinHash()))
        {
            if (StringUtils.isEmpty(oldPin) || !SecurityUtils.matchesPassword(oldPin, existing.getPinHash()))
            {
                throw new ServiceException("原 PIN 不正确");
            }
        }
        SpasStudentPin row = new SpasStudentPin();
        row.setStudentId(self.getStudentId());
        row.setPinHash(SecurityUtils.encryptPassword(pin));
        row.setStatus("0");
        redisCache.deleteObject(REDIS_FAIL_KEY + self.getStudentNo());
        return pinMapper.upsertPin(row);
    }

    @Override
    public SpasStudent verifyPinLogin(String studentNo, String pin)
    {
        if (StringUtils.isEmpty(studentNo) || StringUtils.isEmpty(pin))
        {
            throw new ServiceException("请输入学号和 PIN");
        }
        studentNo = studentNo.trim();
        String failKey = REDIS_FAIL_KEY + studentNo;
        Integer redisFail = redisCache.getCacheObject(failKey);
        if (redisFail != null && redisFail.intValue() >= MAX_FAIL)
        {
            throw new ServiceException("PIN 尝试过多，请 " + LOCK_MINUTES + " 分钟后再试");
        }
        SpasStudent student = studentMapper.selectSpasStudentByStudentNo(studentNo);
        if (student == null || !"0".equals(student.getStatus()))
        {
            bumpRedisFail(failKey);
            throw new ServiceException("学号或 PIN 不正确");
        }
        if (student.getUserId() == null)
        {
            throw new ServiceException("该学生未绑定登录账号");
        }
        SpasStudentPin row = pinMapper.selectByStudentId(student.getStudentId());
        if (row == null || !"0".equals(row.getStatus()) || StringUtils.isEmpty(row.getPinHash()))
        {
            bumpRedisFail(failKey);
            throw new ServiceException("尚未设置 PIN，请先用密码登录后在「每日自主练」中设置");
        }
        if (row.getLockUntil() != null && row.getLockUntil().after(new Date()))
        {
            throw new ServiceException("PIN 已锁定，请稍后再试");
        }
        if (!SecurityUtils.matchesPassword(pin, row.getPinHash()))
        {
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.MINUTE, LOCK_MINUTES);
            int fails = row.getFailCount() == null ? 0 : row.getFailCount().intValue();
            Date lockUntil = (fails + 1) >= MAX_FAIL ? cal.getTime() : null;
            pinMapper.bumpFail(student.getStudentId(), lockUntil);
            bumpRedisFail(failKey);
            throw new ServiceException("学号或 PIN 不正确");
        }
        pinMapper.clearFail(student.getStudentId());
        redisCache.deleteObject(failKey);
        return student;
    }

    private void bumpRedisFail(String failKey)
    {
        Integer n = redisCache.getCacheObject(failKey);
        int next = (n == null ? 0 : n.intValue()) + 1;
        redisCache.setCacheObject(failKey, Integer.valueOf(next), Integer.valueOf(LOCK_MINUTES), TimeUnit.MINUTES);
    }

    private void validatePinFormat(String pin)
    {
        if (pin == null || !pin.matches("^\\d{4,6}$"))
        {
            throw new ServiceException("PIN 须为 4～6 位数字");
        }
    }

    private SpasStudent requireLoginStudent()
    {
        Long userId = SecurityUtils.getUserId();
        SpasStudent self = studentMapper.selectSpasStudentByUserId(userId);
        if (self == null)
        {
            throw new ServiceException("请使用学生账号登录");
        }
        return self;
    }
}
