package com.ruoyi.spas.warning;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.Test;
import com.ruoyi.spas.domain.SpasExamRankPoint;

class ExamRankMetricsTest
{
    @Test
    void rankDropRequiresStrictlyWorseTail()
    {
        List<SpasExamRankPoint> points = new ArrayList<SpasExamRankPoint>();
        points.add(total(1L, "A", 11L, day(1), 20));
        points.add(total(1L, "A", 12L, day(2), 30));
        points.add(total(1L, "A", 13L, day(3), 45));
        points.add(total(2L, "B", 21L, day(1), 10));
        points.add(total(2L, "B", 22L, day(2), 8));
        points.add(total(2L, "B", 23L, day(3), 20));
        List<ExamRankMetrics.Hit> hits = ExamRankMetrics.rankDrop(points, null, 3);
        assertEquals(1, hits.size());
        assertEquals(Long.valueOf(1L), hits.get(0).getStudentId());
        assertEquals(0, hits.get(0).getMetricValue().compareTo(new java.math.BigDecimal("25")));
    }

    @Test
    void subjectImbalanceUsesLatestExam()
    {
        List<SpasExamRankPoint> points = new ArrayList<SpasExamRankPoint>();
        points.add(total(1L, "A", 11L, day(1), 10));
        points.add(subject(1L, "A", 11L, day(1), "Math", 40));
        points.add(total(1L, "A", 12L, day(2), 10));
        points.add(subject(1L, "A", 12L, day(2), "Math", 35));
        points.add(subject(1L, "A", 12L, day(2), "Chinese", 12));
        List<ExamRankMetrics.Hit> hits = ExamRankMetrics.subjectImbalance(points, null, null);
        assertEquals(1, hits.size());
        assertEquals(0, hits.get(0).getMetricValue().compareTo(new java.math.BigDecimal("25")));
        assertTrue(hits.get(0).getDetail().contains("Math"));
    }

    @Test
    void subjectFilterIgnoresOtherSubjects()
    {
        List<SpasExamRankPoint> points = new ArrayList<SpasExamRankPoint>();
        points.add(total(1L, "A", 12L, day(2), 10));
        points.add(subject(1L, "A", 12L, day(2), "Math", 35));
        points.add(subject(1L, "A", 12L, day(2), "Chinese", 12));
        List<ExamRankMetrics.Hit> hits = ExamRankMetrics.subjectImbalance(points, null, "Chinese");
        assertEquals(1, hits.size());
        assertEquals(0, hits.get(0).getMetricValue().compareTo(new java.math.BigDecimal("2")));
    }

    private static SpasExamRankPoint total(Long studentId, String name, Long examId, Date date, int rank)
    {
        return point(studentId, name, examId, date, "2", null, rank);
    }

    private static SpasExamRankPoint subject(Long studentId, String name, Long examId, Date date, String subject, int rank)
    {
        return point(studentId, name, examId, date, "1", subject, rank);
    }

    private static SpasExamRankPoint point(Long studentId, String name, Long examId, Date date, String type, String subject, int rank)
    {
        SpasExamRankPoint point = new SpasExamRankPoint();
        point.setStudentId(studentId);
        point.setStudentName(name);
        point.setDeptId(9L);
        point.setExamId(examId);
        point.setExamDate(date);
        point.setScoreType(type);
        point.setSubjectName(subject);
        point.setSchoolRank(Integer.valueOf(rank));
        return point;
    }

    private static Date day(int offset)
    {
        return new Date(1_700_000_000_000L + offset * 86_400_000L);
    }
}
