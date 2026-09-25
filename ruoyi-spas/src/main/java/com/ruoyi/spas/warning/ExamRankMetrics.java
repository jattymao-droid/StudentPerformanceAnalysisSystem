package com.ruoyi.spas.warning;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasExamRankPoint;

/**
 * Rank-drop and subject-vs-total imbalance from imported exam ranks.
 * A larger school rank number is worse.
 */
public final class ExamRankMetrics
{
    public static final String TYPE_TOTAL = "2";

    private ExamRankMetrics()
    {
    }

    public static final class Hit
    {
        private final Long studentId;
        private final String studentName;
        private final BigDecimal metricValue;
        private final String detail;
        private String subjectName;

        public Hit(Long studentId, String studentName, BigDecimal metricValue, String detail)
        {
            this.studentId = studentId;
            this.studentName = studentName;
            this.metricValue = metricValue;
            this.detail = detail;
        }

        public Long getStudentId()
        {
            return studentId;
        }

        public String getStudentName()
        {
            return studentName;
        }

        public BigDecimal getMetricValue()
        {
            return metricValue;
        }

        public String getDetail()
        {
            return detail;
        }

        public String getSubjectName()
        {
            return subjectName;
        }

        public void setSubjectName(String subjectName)
        {
            this.subjectName = subjectName;
        }
    }

    /**
     * Last {@code minExams} total ranks must each be strictly worse than the previous.
     * Metric = last rank - first rank in that window.
     */
    public static List<Hit> rankDrop(List<SpasExamRankPoint> points, Long deptId, int minExams)
    {
        int window = minExams < 2 ? 2 : minExams;
        List<Hit> hits = new ArrayList<Hit>();
        for (List<SpasExamRankPoint> series : groupTotals(points, deptId).values())
        {
            if (series.size() < window)
            {
                continue;
            }
            List<SpasExamRankPoint> tail = series.subList(series.size() - window, series.size());
            boolean consecutive = true;
            for (int i = 1; i < tail.size(); i++)
            {
                Integer prev = tail.get(i - 1).getSchoolRank();
                Integer cur = tail.get(i).getSchoolRank();
                if (prev == null || cur == null || cur.intValue() <= prev.intValue())
                {
                    consecutive = false;
                    break;
                }
            }
            if (!consecutive)
            {
                continue;
            }
            int first = tail.get(0).getSchoolRank().intValue();
            int last = tail.get(tail.size() - 1).getSchoolRank().intValue();
            SpasExamRankPoint sample = tail.get(tail.size() - 1);
            hits.add(new Hit(sample.getStudentId(), sample.getStudentName(), BigDecimal.valueOf(last - first),
                "最近" + window + "场总分校次 " + first + "→" + last));
        }
        return hits;
    }

    /**
     * Latest exam that has a total rank. Metric = max(subject rank - total rank) when positive.
     */
    public static List<Hit> subjectImbalance(List<SpasExamRankPoint> points, Long deptId, String subjectName)
    {
        String only = StringUtils.isEmpty(subjectName) ? null : subjectName.trim();
        List<Hit> hits = new ArrayList<Hit>();
        Map<Long, List<SpasExamRankPoint>> byStudent = new LinkedHashMap<Long, List<SpasExamRankPoint>>();
        if (points != null)
        {
            for (SpasExamRankPoint point : points)
            {
                if (!accept(point, deptId) || point.getSchoolRank() == null)
                {
                    continue;
                }
                List<SpasExamRankPoint> bucket = byStudent.get(point.getStudentId());
                if (bucket == null)
                {
                    bucket = new ArrayList<SpasExamRankPoint>();
                    byStudent.put(point.getStudentId(), bucket);
                }
                bucket.add(point);
            }
        }
        for (List<SpasExamRankPoint> rows : byStudent.values())
        {
            rows.sort(POINT_ORDER);
            Long latestExamId = null;
            for (int i = rows.size() - 1; i >= 0; i--)
            {
                if (TYPE_TOTAL.equals(rows.get(i).getScoreType()))
                {
                    latestExamId = rows.get(i).getExamId();
                    break;
                }
            }
            if (latestExamId == null)
            {
                continue;
            }
            Integer totalRank = null;
            int maxGap = 0;
            String worst = null;
            SpasExamRankPoint sample = null;
            for (SpasExamRankPoint row : rows)
            {
                if (!latestExamId.equals(row.getExamId()) || row.getSchoolRank() == null)
                {
                    continue;
                }
                if (TYPE_TOTAL.equals(row.getScoreType()))
                {
                    totalRank = row.getSchoolRank();
                    sample = row;
                    continue;
                }
                if (only != null && !com.ruoyi.spas.support.SubjectAlias.same(only, row.getSubjectName()))
                {
                    continue;
                }
            }
            if (totalRank == null)
            {
                continue;
            }
            for (SpasExamRankPoint row : rows)
            {
                if (!latestExamId.equals(row.getExamId()) || TYPE_TOTAL.equals(row.getScoreType()) || row.getSchoolRank() == null)
                {
                    continue;
                }
                if (only != null && !com.ruoyi.spas.support.SubjectAlias.same(only, row.getSubjectName()))
                {
                    continue;
                }
                int gap = row.getSchoolRank().intValue() - totalRank.intValue();
                if (gap > maxGap)
                {
                    maxGap = gap;
                    worst = row.getSubjectName();
                }
            }
            if (maxGap <= 0 || sample == null)
            {
                continue;
            }
            Hit hit = new Hit(sample.getStudentId(), sample.getStudentName(), BigDecimal.valueOf(maxGap),
                (worst == null ? "\u5355\u79d1" : worst) + "\u6821\u6b21\u843d\u540e\u603b\u5206 " + maxGap + " \u540d");
            hit.setSubjectName(worst);
            hits.add(hit);
        }
        return hits;
    }

    private static Map<Long, List<SpasExamRankPoint>> groupTotals(List<SpasExamRankPoint> points, Long deptId)
    {
        Map<Long, List<SpasExamRankPoint>> grouped = new LinkedHashMap<Long, List<SpasExamRankPoint>>();
        if (points == null)
        {
            return grouped;
        }
        for (SpasExamRankPoint point : points)
        {
            if (!accept(point, deptId) || !TYPE_TOTAL.equals(point.getScoreType()) || point.getSchoolRank() == null)
            {
                continue;
            }
            List<SpasExamRankPoint> bucket = grouped.get(point.getStudentId());
            if (bucket == null)
            {
                bucket = new ArrayList<SpasExamRankPoint>();
                grouped.put(point.getStudentId(), bucket);
            }
            bucket.add(point);
        }
        for (List<SpasExamRankPoint> series : grouped.values())
        {
            series.sort(POINT_ORDER);
        }
        return grouped;
    }

    private static boolean accept(SpasExamRankPoint point, Long deptId)
    {
        if (point == null || point.getStudentId() == null || point.getExamId() == null)
        {
            return false;
        }
        return deptId == null || deptId.equals(point.getDeptId());
    }

    private static final Comparator<SpasExamRankPoint> POINT_ORDER = new Comparator<SpasExamRankPoint>()
    {
        @Override
        public int compare(SpasExamRankPoint a, SpasExamRankPoint b)
        {
            Date da = a.getExamDate();
            Date db = b.getExamDate();
            if (da == null && db != null)
            {
                return 1;
            }
            if (da != null && db == null)
            {
                return -1;
            }
            if (da != null && db != null)
            {
                int c = da.compareTo(db);
                if (c != 0)
                {
                    return c;
                }
            }
            long ia = a.getExamId() == null ? 0L : a.getExamId().longValue();
            long ib = b.getExamId() == null ? 0L : b.getExamId().longValue();
            return Long.compare(ia, ib);
        }
    };
}
