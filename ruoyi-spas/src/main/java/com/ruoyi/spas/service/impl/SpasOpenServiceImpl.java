package com.ruoyi.spas.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasOpenClient;
import com.ruoyi.spas.domain.SpasParent;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.domain.SpasWarningRecord;
import com.ruoyi.spas.mapper.SpasOpenMapper;
import com.ruoyi.spas.mapper.SpasStudentMapper;
import com.ruoyi.spas.mapper.SpasWarningRecordMapper;
import com.ruoyi.spas.open.SpasOpenToken;
import com.ruoyi.spas.open.config.SpasOpenProperties;
import com.ruoyi.spas.service.ISpasAnalysisService;
import com.ruoyi.spas.service.ISpasOpenService;

@Service
public class SpasOpenServiceImpl implements ISpasOpenService
{
    public static final String TOKEN_KEY_PREFIX = "spas:open:token:";

    @Autowired
    private SpasOpenProperties openProperties;

    @Autowired
    private SpasOpenMapper openMapper;

    @Autowired
    private SpasStudentMapper studentMapper;

    @Autowired
    private SpasWarningRecordMapper warningRecordMapper;

    @Autowired
    private ISpasAnalysisService analysisService;

    @Autowired
    private RedisCache redisCache;

    @Override
    public Map<String, Object> issueToken(String appId, String appSecret, String mobile)
    {
        if (!openProperties.isEnabled())
        {
            throw new ServiceException("开放接口未启用");
        }
        if (StringUtils.isEmpty(appId) || StringUtils.isEmpty(appSecret) || StringUtils.isEmpty(mobile))
        {
            throw new ServiceException("appId、appSecret、mobile 不能为空");
        }
        SpasOpenClient client = openMapper.selectClientByAppId(appId.trim());
        if (client == null || !"0".equals(client.getStatus()))
        {
            throw new ServiceException("无效的 appId");
        }
        if (!appSecret.equals(client.getAppSecret()))
        {
            throw new ServiceException("无效的 appSecret");
        }
        SpasParent parent = openMapper.selectParentByMobile(mobile.trim());
        if (parent == null || !"0".equals(parent.getStatus()))
        {
            throw new ServiceException("家长账号不存在或已停用");
        }

        String token = UUID.randomUUID().toString().replace("-", "");
        SpasOpenToken payload = new SpasOpenToken();
        payload.setToken(token);
        payload.setParentId(parent.getParentId());
        payload.setMobile(parent.getMobile());
        payload.setAppId(client.getAppId());
        payload.setClientId(client.getClientId());

        int ttl = Math.max(openProperties.getTokenTtlMinutes(), 5);
        redisCache.setCacheObject(TOKEN_KEY_PREFIX + token, payload, ttl, TimeUnit.MINUTES);

        Map<String, Object> data = new HashMap<>();
        data.put("accessToken", token);
        data.put("tokenType", "Bearer");
        data.put("expiresIn", ttl * 60L);
        data.put("parentId", parent.getParentId());
        data.put("parentName", parent.getParentName());
        data.put("mobile", parent.getMobile());
        return data;
    }

    public SpasOpenToken resolveToken(String accessToken)
    {
        if (StringUtils.isEmpty(accessToken))
        {
            return null;
        }
        return redisCache.getCacheObject(TOKEN_KEY_PREFIX + accessToken);
    }

    @Override
    public List<SpasStudent> listBoundStudents(Long parentId)
    {
        return openMapper.selectBoundStudents(parentId);
    }

    @Override
    public void assertBound(Long parentId, Long studentId)
    {
        if (parentId == null || studentId == null || openMapper.countBind(parentId, studentId) <= 0)
        {
            throw new ServiceException("该学生未绑定到当前家长");
        }
    }

    @Override
    public Map<String, Object> getPortfolio(Long parentId, Long studentId, Long subjectId)
    {
        assertBound(parentId, studentId);
        SpasStudent student = studentMapper.selectSpasStudentById(studentId);
        if (student == null || "2".equals(student.getDelFlag()))
        {
            throw new ServiceException("学生不存在");
        }
        Map<String, Object> data = new HashMap<>();
        Map<String, Object> profile = new HashMap<>();
        profile.put("studentId", student.getStudentId());
        profile.put("studentNo", student.getStudentNo());
        profile.put("studentName", student.getStudentName());
        profile.put("deptId", student.getDeptId());
        profile.put("gender", student.getGender());
        data.put("student", profile);
        data.put("radar", analysisService.studentRadar(studentId, subjectId));
        data.put("trend", analysisService.studentTrend(studentId, subjectId));
        data.put("weakTop", analysisService.studentWeakTop(studentId, subjectId, 10));
        data.put("openWarnings", warningRecordMapper.selectOpenByStudent(studentId));
        data.put("openWarningCount", warningRecordMapper.countOpenByStudent(studentId));
        return data;
    }

    @Override
    public List<SpasWarningRecord> listWarnings(Long parentId, Long studentId)
    {
        assertBound(parentId, studentId);
        return warningRecordMapper.selectOpenByStudent(studentId);
    }

    @Override
    public List<Map<String, Object>> radar(Long parentId, Long studentId, Long subjectId)
    {
        assertBound(parentId, studentId);
        return analysisService.studentRadar(studentId, subjectId);
    }

    @Override
    public List<Map<String, Object>> trend(Long parentId, Long studentId, Long subjectId)
    {
        assertBound(parentId, studentId);
        return analysisService.studentTrend(studentId, subjectId);
    }

    @Override
    public List<Map<String, Object>> weakTop(Long parentId, Long studentId, Long subjectId, Integer limit)
    {
        assertBound(parentId, studentId);
        return analysisService.studentWeakTop(studentId, subjectId, limit == null ? 10 : limit);
    }
}
