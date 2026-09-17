package com.ruoyi.spas.service;

import java.util.List;
import com.ruoyi.spas.domain.SpasOpenClient;
import com.ruoyi.spas.domain.SpasParent;
import com.ruoyi.spas.domain.SpasStudent;

public interface ISpasOpenAdminService
{
    List<SpasOpenClient> selectClientList(SpasOpenClient query);

    SpasOpenClient selectClientById(Long clientId);

    int insertClient(SpasOpenClient client);

    int updateClient(SpasOpenClient client);

    int deleteClientByIds(Long[] clientIds);

    List<SpasParent> selectParentList(SpasParent query);

    SpasParent selectParentById(Long parentId);

    int insertParent(SpasParent parent);

    int updateParent(SpasParent parent);

    int deleteParentByIds(Long[] parentIds);

    List<SpasStudent> selectParentBindStudents(Long parentId);

    int bindParentStudent(Long parentId, Long studentId);

    int unbindParentStudent(Long parentId, Long studentId);
}
