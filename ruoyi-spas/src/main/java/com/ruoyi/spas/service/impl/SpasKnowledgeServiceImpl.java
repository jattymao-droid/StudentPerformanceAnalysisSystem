package com.ruoyi.spas.service.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasKnowledge;
import com.ruoyi.spas.mapper.SpasKnowledgeMapper;
import com.ruoyi.spas.service.ISpasKnowledgeService;

/**
 * Knowledge service implementation
 */
@Service
public class SpasKnowledgeServiceImpl implements ISpasKnowledgeService
{
    @Autowired
    private SpasKnowledgeMapper knowledgeMapper;

    @Override
    public List<SpasKnowledge> selectSpasKnowledgeList(SpasKnowledge knowledge)
    {
        return knowledgeMapper.selectSpasKnowledgeList(knowledge);
    }

    @Override
    public SpasKnowledge selectSpasKnowledgeById(Long knowledgeId)
    {
        return knowledgeMapper.selectSpasKnowledgeById(knowledgeId);
    }

    @Override
    public List<SpasKnowledge> selectKnowledgeTree(Long subjectId)
    {
        List<SpasKnowledge> list = knowledgeMapper.selectSpasKnowledgeBySubjectId(subjectId);
        return buildKnowledgeTree(list);
    }

    @Override
    public int insertSpasKnowledge(SpasKnowledge knowledge)
    {
        if (StringUtils.isEmpty(knowledge.getNodeType()))
        {
            knowledge.setNodeType("2");
        }
        if (knowledge.getParentId() == null || knowledge.getParentId() == 0L)
        {
            if ("1".equals(knowledge.getNodeType()) || "2".equals(knowledge.getNodeType()))
            {
                throw new ServiceException("请选择所属版本/章节后再新增");
            }
            knowledge.setParentId(0L);
            knowledge.setAncestors("0");
        }
        else
        {
            SpasKnowledge parent = knowledgeMapper.selectSpasKnowledgeById(knowledge.getParentId());
            if (parent == null)
            {
                throw new ServiceException("上级节点不存在");
            }
            if (knowledge.getSubjectId() != null && parent.getSubjectId() != null
                && !knowledge.getSubjectId().equals(parent.getSubjectId()))
            {
                throw new ServiceException("上级节点必须属于同一学科");
            }
            // Knowledge points are leaf nodes; cannot nest under another knowledge point
            if ("2".equals(parent.getNodeType()))
            {
                throw new ServiceException("知识点为末级节点，请选择章节作为上级");
            }
            // Version nodes only accept chapters; knowledge must hang under a chapter
            if ("2".equals(knowledge.getNodeType()) && "0".equals(parent.getNodeType()))
            {
                throw new ServiceException("请选择章节作为知识点上级，不能直接挂在版本下");
            }
            if ("0".equals(knowledge.getNodeType()))
            {
                throw new ServiceException("版本须挂在学科根下");
            }
            knowledge.setAncestors(parent.getAncestors() + "," + knowledge.getParentId());
        }
        return knowledgeMapper.insertSpasKnowledge(knowledge);
    }

    @Override
    public int updateSpasKnowledge(SpasKnowledge knowledge)
    {
        SpasKnowledge old = knowledgeMapper.selectSpasKnowledgeById(knowledge.getKnowledgeId());
        if (old == null)
        {
            throw new ServiceException("节点不存在");
        }
        if (StringUtils.isEmpty(knowledge.getNodeType()))
        {
            knowledge.setNodeType(StringUtils.isEmpty(old.getNodeType()) ? "2" : old.getNodeType());
        }
        // Downgrade chapter -> knowledge only when no children
        if ("2".equals(knowledge.getNodeType()) && !"2".equals(old.getNodeType())
            && knowledgeMapper.hasChildByKnowledgeId(knowledge.getKnowledgeId()) > 0)
        {
            throw new ServiceException("章节下仍有子节点，不能改为知识点");
        }

        SpasKnowledge newParent = null;
        if (knowledge.getParentId() != null && knowledge.getParentId() != 0L)
        {
            newParent = knowledgeMapper.selectSpasKnowledgeById(knowledge.getParentId());
            if (newParent == null)
            {
                throw new ServiceException("上级节点不存在");
            }
            if (newParent.getKnowledgeId().equals(knowledge.getKnowledgeId()))
            {
                throw new ServiceException("上级节点不能是自己");
            }
            if ("2".equals(newParent.getNodeType()))
            {
                throw new ServiceException("知识点为末级节点，请选择章节作为上级");
            }
            if (StringUtils.isNotEmpty(newParent.getAncestors())
                && ("," + newParent.getAncestors() + ",").contains("," + knowledge.getKnowledgeId() + ","))
            {
                throw new ServiceException("上级节点不能是自己的下级");
            }
        }
        if (newParent != null)
        {
            String newAncestors = newParent.getAncestors() + "," + newParent.getKnowledgeId();
            String oldAncestors = old.getAncestors();
            knowledge.setAncestors(newAncestors);
            updateChildren(knowledge.getKnowledgeId(), newAncestors, oldAncestors);
        }
        else if (knowledge.getParentId() != null && knowledge.getParentId() == 0L)
        {
            String newAncestors = "0";
            String oldAncestors = old.getAncestors();
            knowledge.setAncestors(newAncestors);
            updateChildren(knowledge.getKnowledgeId(), newAncestors, oldAncestors);
        }
        return knowledgeMapper.updateSpasKnowledge(knowledge);
    }

    private void updateChildren(Long knowledgeId, String newAncestors, String oldAncestors)
    {
        List<SpasKnowledge> children = knowledgeMapper.selectChildrenKnowledgeById(knowledgeId);
        for (SpasKnowledge child : children)
        {
            child.setAncestors(child.getAncestors().replaceFirst(oldAncestors, newAncestors));
        }
        if (children.size() > 0)
        {
            knowledgeMapper.updateKnowledgeChildren(children);
        }
    }

    @Override
    public int deleteSpasKnowledgeById(Long knowledgeId)
    {
        if (knowledgeMapper.hasChildByKnowledgeId(knowledgeId) > 0)
        {
            throw new ServiceException("存在下级节点，无法删除");
        }
        if (knowledgeMapper.countQuestionKnowledgeByKnowledgeId(knowledgeId) > 0)
        {
            throw new ServiceException("节点已被题目引用，无法删除");
        }
        return knowledgeMapper.deleteSpasKnowledgeById(knowledgeId);
    }

    private List<SpasKnowledge> buildKnowledgeTree(List<SpasKnowledge> knowledges)
    {
        List<SpasKnowledge> returnList = new ArrayList<SpasKnowledge>();
        List<Long> tempList = new ArrayList<Long>();
        for (SpasKnowledge k : knowledges)
        {
            tempList.add(k.getKnowledgeId());
        }
        for (SpasKnowledge k : knowledges)
        {
            if (!tempList.contains(k.getParentId()))
            {
                recursionFn(knowledges, k);
                returnList.add(k);
            }
        }
        if (returnList.isEmpty())
        {
            returnList = knowledges;
        }
        return returnList;
    }

    private void recursionFn(List<SpasKnowledge> list, SpasKnowledge t)
    {
        List<SpasKnowledge> childList = getChildList(list, t);
        t.setChildren(childList);
        for (SpasKnowledge tChild : childList)
        {
            if (hasChild(list, tChild))
            {
                recursionFn(list, tChild);
            }
        }
    }

    private List<SpasKnowledge> getChildList(List<SpasKnowledge> list, SpasKnowledge t)
    {
        List<SpasKnowledge> tlist = new ArrayList<SpasKnowledge>();
        Iterator<SpasKnowledge> it = list.iterator();
        while (it.hasNext())
        {
            SpasKnowledge n = it.next();
            if (StringUtils.isNotNull(n.getParentId()) && n.getParentId().longValue() == t.getKnowledgeId().longValue())
            {
                tlist.add(n);
            }
        }
        return tlist;
    }

    private boolean hasChild(List<SpasKnowledge> list, SpasKnowledge t)
    {
        return getChildList(list, t).size() > 0;
    }
}
