package com.ruoyi.spas.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasOpenClient;
import com.ruoyi.spas.domain.SpasParent;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.mapper.SpasOpenMapper;
import com.ruoyi.spas.open.config.SpasOpenProperties;
import com.ruoyi.spas.service.ISpasOpenAdminService;

@Service
public class SpasOpenAdminServiceImpl implements ISpasOpenAdminService
{
    @Autowired
    private SpasOpenMapper openMapper;

    @Autowired
    private SpasOpenProperties openProperties;

    @Override
    public Map<String, Object> openRuntimeStatus()
    {
        Map<String, Object> data = new HashMap<>();
        data.put("enabled", openProperties.isEnabled());
        data.put("tokenTtlMinutes", openProperties.getTokenTtlMinutes());
        data.put("basePath", "/open/v1");
        data.put("docsPath", "docs/spas-open-api.md");
        data.put("hint", openProperties.isEnabled()
            ? "OpenAPI is ON. Use /open/v1/** with client token; keep secrets out of logs."
            : "OpenAPI is OFF (spas.open.enabled=false). Enable only for parent integration/staging; restart after change.");
        return data;
    }

    @Override
    public List<SpasOpenClient> selectClientList(SpasOpenClient query)
    {
        return openMapper.selectClientList(query);
    }

    @Override
    public SpasOpenClient selectClientById(Long clientId)
    {
        return openMapper.selectClientById(clientId);
    }

    @Override
    public int insertClient(SpasOpenClient client)
    {
        if (StringUtils.isEmpty(client.getAppId()) || StringUtils.isEmpty(client.getAppSecret()))
        {
            throw new ServiceException("AppId and AppSecret are required");
        }
        return openMapper.insertClient(client);
    }

    @Override
    public int updateClient(SpasOpenClient client)
    {
        return openMapper.updateClient(client);
    }

    @Override
    public int deleteClientByIds(Long[] clientIds)
    {
        return openMapper.deleteClientByIds(clientIds);
    }

    @Override
    public List<SpasParent> selectParentList(SpasParent query)
    {
        return openMapper.selectParentList(query);
    }

    @Override
    public SpasParent selectParentById(Long parentId)
    {
        return openMapper.selectParentById(parentId);
    }

    @Override
    public int insertParent(SpasParent parent)
    {
        if (StringUtils.isEmpty(parent.getMobile()))
        {
            throw new ServiceException("Parent mobile is required");
        }
        return openMapper.insertParent(parent);
    }

    @Override
    public int updateParent(SpasParent parent)
    {
        return openMapper.updateParent(parent);
    }

    @Override
    public int deleteParentByIds(Long[] parentIds)
    {
        return openMapper.deleteParentByIds(parentIds);
    }

    @Override
    public List<SpasStudent> selectParentBindStudents(Long parentId)
    {
        return openMapper.selectParentBindStudents(parentId);
    }

    @Override
    public int bindParentStudent(Long parentId, Long studentId)
    {
        if (parentId == null || studentId == null)
        {
            throw new ServiceException("Parent and student are required");
        }
        return openMapper.insertParentStudent(parentId, studentId);
    }

    @Override
    public int unbindParentStudent(Long parentId, Long studentId)
    {
        return openMapper.deleteParentStudent(parentId, studentId);
    }
}
