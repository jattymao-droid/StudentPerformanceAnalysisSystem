package com.ruoyi.spas.support;

import java.util.List;
import java.util.Map;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasStudent;

/**
 * Match an exam-score Excel row to a student in the selected class.
 * Student number wins. Name is used only when the number cell is empty.
 */
public final class ExamStudentResolver
{
    private ExamStudentResolver()
    {
    }

    public static SpasStudent resolve(String studentNo, String studentName, Map<String, List<SpasStudent>> byNo,
        Map<String, List<SpasStudent>> byName)
    {
        String no = studentNo == null ? "" : studentNo.trim();
        String name = studentName == null ? "" : studentName.trim();
        if (StringUtils.isNotEmpty(no))
        {
            List<SpasStudent> matched = byNo == null ? null : byNo.get(no);
            if (matched == null || matched.isEmpty())
            {
                throw new ServiceException("班级内未找到学号「" + no + "」");
            }
            if (matched.size() > 1)
            {
                throw new ServiceException("班级内学号重复「" + no + "」，请先在学生档案中区分");
            }
            return matched.get(0);
        }
        if (StringUtils.isEmpty(name))
        {
            throw new ServiceException("姓名为空");
        }
        List<SpasStudent> matched = byName == null ? null : byName.get(name);
        if (matched == null || matched.isEmpty())
        {
            throw new ServiceException("班级内未找到学生「" + name + "」，可填写学号");
        }
        if (matched.size() > 1)
        {
            throw new ServiceException("班级内姓名重复「" + name + "」，请填写学号");
        }
        return matched.get(0);
    }
}
