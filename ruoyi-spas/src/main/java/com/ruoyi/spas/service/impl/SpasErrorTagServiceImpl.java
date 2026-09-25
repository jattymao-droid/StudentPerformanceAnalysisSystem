package com.ruoyi.spas.service.impl;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasErrorTag;
import com.ruoyi.spas.domain.SpasPaperQuestion;
import com.ruoyi.spas.mapper.SpasErrorTagMapper;
import com.ruoyi.spas.mapper.SpasPaperMapper;
import com.ruoyi.spas.service.ISpasErrorTagService;
import com.ruoyi.spas.support.SpasAccessService;
import com.ruoyi.spas.support.SpasErrorCauseCodes;

@Service
public class SpasErrorTagServiceImpl implements ISpasErrorTagService
{

    @Autowired
    private SpasErrorTagMapper errorTagMapper;

    @Autowired
    private SpasPaperMapper paperMapper;

    @Autowired
    private SpasAccessService accessService;

    @Override
    public SpasErrorTag selectByStudentAndQuestion(Long studentId, Long questionId)
    {
        accessService.checkStudentAccess(studentId);
        return errorTagMapper.selectByStudentAndQuestion(studentId, questionId);
    }

    @Override
    public List<SpasErrorTag> selectByStudentId(Long studentId)
    {
        accessService.checkStudentAccess(studentId);
        return errorTagMapper.selectByStudentId(studentId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int saveTag(SpasErrorTag tag)
    {
        accessService.assertCanWrite();
        if (tag == null || tag.getStudentId() == null || tag.getQuestionId() == null)
        {
            throw new ServiceException("\u5b66\u751f\u4e0e\u9898\u76ee\u4e0d\u80fd\u4e3a\u7a7a");
        }
        accessService.checkStudentAccess(tag.getStudentId());
        if (StringUtils.isEmpty(tag.getErrorCode()))
        {
            return errorTagMapper.deleteByStudentAndQuestion(tag.getStudentId(), tag.getQuestionId());
        }
        if (!SpasErrorCauseCodes.isAllowed(tag.getErrorCode().trim()))
        {
            throw new ServiceException("\u4e0d\u652f\u6301\u7684\u9519\u56e0\u4ee3\u7801");
        }
        tag.setErrorCode(tag.getErrorCode().trim());
        tag.setErrorCategory(SpasErrorCauseCodes.categoryOf(tag.getErrorCode()));
        tag.setErrorCategoryLabel(SpasErrorCauseCodes.categoryLabel(tag.getErrorCategory()));
        SpasPaperQuestion question = paperMapper.selectQuestionById(tag.getQuestionId());
        if (question == null)
        {
            throw new ServiceException("\u9898\u76ee\u4e0d\u5b58\u5728");
        }
        if (tag.getPaperId() == null)
        {
            tag.setPaperId(question.getPaperId());
        }
        String oper = SecurityUtils.getUsername();
        SpasErrorTag existing = errorTagMapper.selectByStudentAndQuestion(tag.getStudentId(), tag.getQuestionId());
        if (existing == null)
        {
            tag.setCreateBy(oper);
            return errorTagMapper.insertSpasErrorTag(tag);
        }
        existing.setPaperId(tag.getPaperId());
        existing.setErrorCode(tag.getErrorCode());
        existing.setRemark(tag.getRemark());
        existing.setUpdateBy(oper);
        return errorTagMapper.updateSpasErrorTag(existing);
    }

    @Override
    public List<Map<String, Object>> selectCauseSummary(Long studentId)
    {
        accessService.checkStudentAccess(studentId);
        List<Map<String, Object>> rows = errorTagMapper.selectCauseSummary(studentId);
        if (rows == null || rows.isEmpty())
        {
            return java.util.Collections.emptyList();
        }
        // Aggregate by category for report charts; keep subcode detail in each rollup's children.
        Map<String, Map<String, Object>> byCat = new LinkedHashMap<String, Map<String, Object>>();
        for (Map<String, Object> row : rows)
        {
            String code = row.get("errorCode") == null ? null : String.valueOf(row.get("errorCode"));
            String cat = SpasErrorCauseCodes.categoryOf(code);
            if (cat == null)
            {
                cat = "other";
            }
            Map<String, Object> agg = byCat.get(cat);
            if (agg == null)
            {
                agg = new LinkedHashMap<String, Object>();
                agg.put("errorCode", cat);
                agg.put("errorCategory", cat);
                agg.put("errorLabel", SpasErrorCauseCodes.categoryLabel(cat));
                agg.put("errorCategoryLabel", SpasErrorCauseCodes.categoryLabel(cat));
                agg.put("tagCount", Integer.valueOf(0));
                agg.put("details", new ArrayList<Map<String, Object>>());
                byCat.put(cat, agg);
            }
            int add = 0;
            Object tc = row.get("tagCount");
            if (tc instanceof Number)
            {
                add = ((Number) tc).intValue();
            }
            agg.put("tagCount", Integer.valueOf(((Number) agg.get("tagCount")).intValue() + add));
            Map<String, Object> detail = new LinkedHashMap<String, Object>(row);
            detail.put("errorCategory", cat);
            detail.put("errorCategoryLabel", SpasErrorCauseCodes.categoryLabel(cat));
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> details = (List<Map<String, Object>>) agg.get("details");
            details.add(detail);
        }
        return new ArrayList<Map<String, Object>>(byCat.values());
    }

    @Override
    public List<Map<String, Object>> selectDeptCauseSummary(Long deptId, Long subjectId)
    {
        if (deptId == null)
        {
            return java.util.Collections.emptyList();
        }
        accessService.checkDeptAccess(deptId);
        List<Map<String, Object>> rows = errorTagMapper.selectDeptCauseSummary(deptId, subjectId);
        if (rows == null || rows.isEmpty())
        {
            return java.util.Collections.emptyList();
        }
        for (Map<String, Object> row : rows)
        {
            String code = row.get("errorCode") == null ? null : String.valueOf(row.get("errorCode"));
            String cat = SpasErrorCauseCodes.categoryOf(code);
            row.put("errorCategory", cat);
            row.put("errorCategoryLabel", SpasErrorCauseCodes.categoryLabel(cat));
        }
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteByStudentAndQuestion(Long studentId, Long questionId)
    {
        accessService.assertCanWrite();
        accessService.checkStudentAccess(studentId);
        return errorTagMapper.deleteByStudentAndQuestion(studentId, questionId);
    }
}
