package com.ruoyi.spas.support;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.fail;
import org.junit.jupiter.api.Test;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.spas.domain.SpasStudent;

class ExamStudentResolverTest
{
    @Test
    void studentNoWinsOverDifferentName()
    {
        SpasStudent a = student(1L, "S001", "A");
        Map<String, List<SpasStudent>> byNo = map("S001", a);
        Map<String, List<SpasStudent>> byName = map("B", student(2L, "S002", "B"));
        SpasStudent hit = ExamStudentResolver.resolve("S001", "B", byNo, byName);
        assertEquals(Long.valueOf(1L), hit.getStudentId());
    }

    @Test
    void missingStudentNoDoesNotFallBackToName()
    {
        Map<String, List<SpasStudent>> byName = map("A", student(1L, "S001", "A"));
        try
        {
            ExamStudentResolver.resolve("NOPE", "A", Collections.emptyMap(), byName);
            fail("expected missing student number");
        }
        catch (ServiceException ex)
        {
            assertTrue(ex.getMessage().contains("\u5b66\u53f7"));
        }
    }

    @Test
    void duplicateNameRequiresStudentNo()
    {
        Map<String, List<SpasStudent>> byName = new HashMap<String, List<SpasStudent>>();
        byName.put("A", Arrays.asList(student(1L, "S001", "A"), student(2L, "S002", "A")));
        try
        {
            ExamStudentResolver.resolve("", "A", Collections.emptyMap(), byName);
            fail("expected duplicate name");
        }
        catch (ServiceException ex)
        {
            assertTrue(ex.getMessage().contains("\u8bf7\u586b\u5199\u5b66\u53f7"));
        }
    }

    @Test
    void uniqueNameMatchesWhenNumberBlank()
    {
        SpasStudent a = student(1L, "S001", "A");
        SpasStudent hit = ExamStudentResolver.resolve("  ", "A", Collections.emptyMap(), map("A", a));
        assertEquals(Long.valueOf(1L), hit.getStudentId());
    }

    private static SpasStudent student(Long id, String no, String name)
    {
        SpasStudent student = new SpasStudent();
        student.setStudentId(id);
        student.setStudentNo(no);
        student.setStudentName(name);
        return student;
    }

    private static Map<String, List<SpasStudent>> map(String key, SpasStudent student)
    {
        Map<String, List<SpasStudent>> index = new HashMap<String, List<SpasStudent>>();
        index.put(key, Collections.singletonList(student));
        return index;
    }
}
