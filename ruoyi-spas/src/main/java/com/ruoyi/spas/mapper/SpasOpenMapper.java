package com.ruoyi.spas.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.domain.SpasOpenClient;
import com.ruoyi.spas.domain.SpasParent;
import com.ruoyi.spas.domain.SpasStudent;

public interface SpasOpenMapper
{
    SpasOpenClient selectClientByAppId(@Param("appId") String appId);

    SpasParent selectParentByMobile(@Param("mobile") String mobile);

    SpasParent selectParentById(@Param("parentId") Long parentId);

    List<SpasStudent> selectBoundStudents(@Param("parentId") Long parentId);

    int countBind(@Param("parentId") Long parentId, @Param("studentId") Long studentId);

    List<SpasOpenClient> selectClientList(SpasOpenClient query);

    SpasOpenClient selectClientById(@Param("clientId") Long clientId);

    int insertClient(SpasOpenClient client);

    int updateClient(SpasOpenClient client);

    int deleteClientByIds(@Param("clientIds") Long[] clientIds);

    List<SpasParent> selectParentList(SpasParent query);

    int insertParent(SpasParent parent);

    int updateParent(SpasParent parent);

    int deleteParentByIds(@Param("parentIds") Long[] parentIds);

    int insertParentStudent(@Param("parentId") Long parentId, @Param("studentId") Long studentId);

    int deleteParentStudent(@Param("parentId") Long parentId, @Param("studentId") Long studentId);

    List<SpasStudent> selectParentBindStudents(@Param("parentId") Long parentId);
}
