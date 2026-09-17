package com.ruoyi.spas.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.spas.analysis.KnowledgeStatCalculator;
import com.ruoyi.spas.domain.SpasPaper;
import com.ruoyi.spas.mapper.SpasAnalysisMapper;
import com.ruoyi.spas.mapper.SpasPaperMapper;
import com.ruoyi.spas.service.ISpasAnalysisService;
import com.ruoyi.spas.service.ISpasInterveneService;
import com.ruoyi.spas.support.SpasAccessService;
import com.ruoyi.spas.support.SpasAnalysisWindowHelper;
import com.ruoyi.spas.domain.SpasKnowledge;
import com.ruoyi.spas.mapper.SpasKnowledgeMapper;
import java.util.Date;
import com.ruoyi.spas.support.SpasTeacherScopeService;
import com.ruoyi.spas.warning.WarningEngine;
import com.ruoyi.system.service.ISysDeptService;

/**
 * Analysis service wrapping calculator and query mapper
 */
@Service
public class SpasAnalysisServiceImpl implements ISpasAnalysisService
{
    @Autowired
    private SpasAnalysisMapper analysisMapper;

    @Autowired
    private KnowledgeStatCalculator knowledgeStatCalculator;

    @Autowired
    private SpasTeacherScopeService teacherScopeService;

    @Autowired
    private ISysDeptService deptService;

    @Autowired
    private SpasPaperMapper paperMapper;

    @Autowired
    private SpasAccessService accessService;

    @Autowired
    private WarningEngine warningEngine;

    @Autowired
    private ISpasInterveneService interveneService;

    @Autowired
    private SpasAnalysisWindowHelper windowHelper;

    @Autowired
    private SpasKnowledgeMapper knowledgeMapper;

    @Value("${spas.analysis.weak-thresholds.watch:0.75}")
    private double watchThreshold;

    @Value("${spas.intervene.auto-evaluate-after-recalc:true}")
    private boolean autoEvaluateIntervene;

    @Value("${spas.intervene.async-evaluate:true}")
    private boolean asyncEvaluateIntervene;

    @Override
    public List<Map<String, Object>> studentRadar(Long studentId, Long subjectId)
    {
        return studentRadar(studentId, subjectId, null);
    }

    @Override
    public List<Map<String, Object>> studentRadar(Long studentId, Long subjectId, String window)
    {
        Date from = windowHelper.resolveExamDateFrom(window);
        List<Map<String, Object>> list;
        if (from == null)
        {
            list = analysisMapper.selectStudentRadar(studentId, subjectId);
        }
        else
        {
            list = analysisMapper.selectStudentRadarLive(studentId, subjectId, from);
        }
        enrichConfidence(list);
        return list;
    }

    @Override
    public List<Map<String, Object>> studentTrend(Long studentId, Long subjectId)
    {
        return studentTrend(studentId, subjectId, null);
    }

    @Override
    public List<Map<String, Object>> studentTrend(Long studentId, Long subjectId, String window)
    {
        Date from = windowHelper.resolveExamDateFrom(window);
        return analysisMapper.selectStudentTrend(studentId, subjectId, from);
    }

    @Override
    public List<Map<String, Object>> studentWeakTop(Long studentId, Long subjectId, Integer limit)
    {
        return studentWeakTop(studentId, subjectId, limit, null);
    }

    @Override
    public List<Map<String, Object>> studentWeakTop(Long studentId, Long subjectId, Integer limit, String window)
    {
        int top = limit == null || limit <= 0 ? 10 : limit;
        Date from = windowHelper.resolveExamDateFrom(window);
        List<Map<String, Object>> list;
        if (from == null)
        {
            list = analysisMapper.selectStudentWeakTop(studentId, subjectId, top);
        }
        else
        {
            list = analysisMapper.selectStudentRadarLive(studentId, subjectId, from);
            list.sort((a, b) -> {
                double ra = toDouble(a.get("rate"));
                double rb = toDouble(b.get("rate"));
                return Double.compare(ra, rb);
            });
            if (list.size() > top)
            {
                list = new ArrayList<>(list.subList(0, top));
            }
        }
        enrichConfidence(list);
        return list;
    }

    @Override
    public Map<String, Object> studentSummary(Long studentId, Long subjectId)
    {
        return studentSummary(studentId, subjectId, null);
    }

    @Override
    public Map<String, Object> studentSummary(Long studentId, Long subjectId, String window)
    {
        Date from = windowHelper.resolveExamDateFrom(window);
        Map<String, Object> summary;
        if (from == null)
        {
            summary = analysisMapper.selectStudentSummary(studentId, subjectId);
        }
        else
        {
            summary = analysisMapper.selectStudentSummaryLive(studentId, subjectId, from);
        }
        if (summary == null)
        {
            summary = new HashMap<String, Object>();
        }
        Object attempts = summary.get("totalAttempts");
        int att = 0;
        if (attempts != null)
        {
            try
            {
                att = Integer.parseInt(attempts.toString());
            }
            catch (Exception ignored)
            {
            }
        }
        summary.put("confidence", knowledgeStatCalculator.confidence(att));
        summary.put("window", windowHelper.isAll(window) ? "all" : window);
        summary.put("headline", buildStudentHeadline(summary));
        return summary;
    }

    @Override
    public List<Map<String, Object>> studentChapterRadar(Long studentId, Long subjectId)
    {
        List<Map<String, Object>> list = analysisMapper.selectStudentChapterRadar(studentId, subjectId);
        enrichConfidence(list);
        return list;
    }

    @Override
    public Map<String, Object> classChapterOverview(Long deptId, Long subjectId)
    {
        accessService.checkDeptAccess(deptId);
        List<Map<String, Object>> chapters = analysisMapper.selectClassChapterOverview(deptId, subjectId);
        Map<String, Object> data = new HashMap<>();
        data.put("chapters", chapters);
        data.put("headline", chapters == null || chapters.isEmpty()
            ? "\u6682\u65e0\u7ae0\u8282\u6c47\u603b\u6570\u636e"
            : ("\u7ae0\u8282\u6570 " + chapters.size()));
        return data;
    }

    @Override
    public List<Map<String, Object>> classTrend(Long deptId, Long subjectId, String window)
    {
        accessService.checkDeptAccess(deptId);
        Date from = windowHelper.resolveExamDateFrom(window);
        return analysisMapper.selectClassTrend(deptId, subjectId, from);
    }

    private double toDouble(Object v)
    {
        if (v == null)
        {
            return 1.0;
        }
        try
        {
            return Double.parseDouble(String.valueOf(v));
        }
        catch (Exception e)
        {
            return 1.0;
        }
    }

    private String buildStudentHeadline(Map<String, Object> summary)
    {
        int severe = toInt(summary.get("severeCount"));
        int weak = toInt(summary.get("weakCount"));
        int watch = toInt(summary.get("watchCount"));
        Object rate = summary.get("overallRate");
        Object gap = summary.get("gap");
        StringBuilder sb = new StringBuilder();
        if (rate != null)
        {
            sb.append("综合得分率 ").append(formatPct(rate));
        }
        if (gap != null)
        {
            BigDecimal g = new BigDecimal(gap.toString());
            if (g.compareTo(BigDecimal.ZERO) < 0)
            {
                sb.append("，低于班级 ").append(formatPct(g.abs()));
            }
            else if (g.compareTo(BigDecimal.ZERO) > 0)
            {
                sb.append("，高于班级 ").append(formatPct(g));
            }
            else
            {
                sb.append("，与班级持平");
            }
        }
        sb.append("；严重 ").append(severe).append(" / 薄弱 ").append(weak).append(" / 关注 ").append(watch);
        return sb.toString();
    }

    private String formatPct(Object v)
    {
        if (v == null)
        {
            return "-";
        }
        BigDecimal n = new BigDecimal(v.toString()).multiply(BigDecimal.valueOf(100)).setScale(1, RoundingMode.HALF_UP);
        return n.toPlainString() + "%";
    }

    private void enrichConfidence(List<Map<String, Object>> list)
    {
        if (list == null)
        {
            return;
        }
        for (Map<String, Object> row : list)
        {
            row.put("confidence", knowledgeStatCalculator.confidence(toInt(row.get("attemptCount"))));
        }
    }

    @Override
    public List<Map<String, Object>> classWeakTop(Long deptId, Long subjectId, Integer limit)
    {
        int top = limit == null || limit <= 0 ? 10 : limit;
        return analysisMapper.selectClassWeakTop(deptId, subjectId, top);
    }

    @Override
    public Map<String, Object> classHeatmap(Long deptId, Long subjectId)
    {
        List<Map<String, Object>> students = analysisMapper.selectClassHeatmapStudents(deptId);
        List<Map<String, Object>> knowledges = analysisMapper.selectClassHeatmapKnowledges(deptId, subjectId);
        List<Map<String, Object>> rates = analysisMapper.selectClassHeatmapRates(deptId, subjectId);

        Map<String, Object> rateIndex = new HashMap<String, Object>();
        if (rates != null)
        {
            for (Map<String, Object> row : rates)
            {
                Object sid = row.get("studentId");
                Object kid = row.get("knowledgeId");
                if (sid == null || kid == null)
                {
                    continue;
                }
                rateIndex.put(sid.toString() + "_" + kid.toString(), row.get("rate"));
            }
        }

        List<List<Object>> matrix = new ArrayList<List<Object>>();
        if (students != null)
        {
            for (Map<String, Object> student : students)
            {
                Object sid = student.get("id");
                List<Object> row = new ArrayList<Object>();
                if (knowledges != null)
                {
                    for (Map<String, Object> knowledge : knowledges)
                    {
                        Object kid = knowledge.get("id");
                        Object rate = null;
                        if (sid != null && kid != null)
                        {
                            rate = rateIndex.get(sid.toString() + "_" + kid.toString());
                        }
                        row.add(rate);
                    }
                }
                matrix.add(row);
            }
        }

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("students", students == null ? new ArrayList<Map<String, Object>>() : students);
        result.put("knowledges", knowledges == null ? new ArrayList<Map<String, Object>>() : knowledges);
        result.put("matrix", matrix);
        return result;
    }

    @Override
    public Map<String, Object> classOverview(Long deptId, Long subjectId)
    {
        Map<String, Object> summary = analysisMapper.selectClassSummary(deptId, subjectId);
        List<Map<String, Object>> knowledges = analysisMapper.selectClassOverview(deptId, subjectId);
        if (knowledges == null)
        {
            knowledges = new ArrayList<Map<String, Object>>();
        }

        Map<String, Object> result = new HashMap<String, Object>();
        if (summary != null)
        {
            result.putAll(summary);
        }
        int weakKnowledgeCount = 0;
        for (Map<String, Object> row : knowledges)
        {
            int watch = toInt(row.get("watchCount"));
            int weak = toInt(row.get("weakCount"));
            int severe = toInt(row.get("severeCount"));
            Object avgObj = row.get("avgRate");
            boolean lowAvg = false;
            if (avgObj != null)
            {
                lowAvg = new BigDecimal(avgObj.toString()).compareTo(BigDecimal.valueOf(watchThreshold)) < 0;
            }
            if (watch + weak + severe > 0 || lowAvg)
            {
                weakKnowledgeCount++;
            }
        }
        result.put("knowledgeCount", weakKnowledgeCount);
        result.put("knowledges", knowledges);
        List<Map<String, Object>> ranking = analysisMapper.selectClassStudentRanking(deptId, subjectId);
        result.put("studentRanking", ranking == null ? new ArrayList<Map<String, Object>>() : ranking);
        result.put("headline", buildClassHeadline(result));
        if (!result.containsKey("avgRate"))
        {
            result.put("avgRate", null);
        }
        if (!result.containsKey("studentCount"))
        {
            result.put("studentCount", 0);
        }
        if (!result.containsKey("weakStudentCount"))
        {
            result.put("weakStudentCount", 0);
        }
        return result;
    }

    private String buildClassHeadline(Map<String, Object> result)
    {
        Object avg = result.get("avgRate");
        int students = toInt(result.get("studentCount"));
        int weakStu = toInt(result.get("weakStudentCount"));
        int severeStu = toInt(result.get("severeStudentCount"));
        int weakKp = toInt(result.get("knowledgeCount"));
        StringBuilder sb = new StringBuilder();
        sb.append(students).append(" 名学生");
        if (avg != null)
        {
            sb.append("，班均 ").append(formatPct(avg));
        }
        sb.append("；薄弱学生 ").append(weakStu);
        if (severeStu > 0)
        {
            sb.append("（含严重 ").append(severeStu).append("）");
        }
        sb.append("，薄弱知识点 ").append(weakKp);
        return sb.toString();
    }

    private int toInt(Object v)
    {
        if (v == null)
        {
            return 0;
        }
        try
        {
            return Integer.parseInt(v.toString());
        }
        catch (Exception e)
        {
            return 0;
        }
    }

    @Override
    public Map<String, Object> knowledgeOverview(Long knowledgeId, Long deptId)
    {
        SpasKnowledge kn = knowledgeMapper.selectSpasKnowledgeById(knowledgeId);
        boolean chapter = kn != null && "1".equals(String.valueOf(kn.getNodeType()));
        List<Long> deptIds = null;
        if (deptId == null)
        {
            if (teacherScopeService.useTeacherDeptFilter())
            {
                deptIds = teacherScopeService.getSubjectTeacherDeptIds();
            }
            else if (!SecurityUtils.isAdmin())
            {
                deptIds = resolveAccessibleDeptIds();
            }
        }
        List<Map<String, Object>> students = (chapter ? analysisMapper.selectKnowledgeOverviewChapter(knowledgeId, deptId, deptIds) : analysisMapper.selectKnowledgeOverview(knowledgeId, deptId, deptIds));
        List<Map<String, Object>> questions = analysisMapper.selectKnowledgeQuestions(knowledgeId, deptId, deptIds);
    // Expand grade/school node: include descendants for class comparison
        List<Long> comparisonDeptIds = null;
        if (deptId != null)
        {
            comparisonDeptIds = expandDeptWithChildren(deptId);
        }
        else
        {
            comparisonDeptIds = deptIds;
        }
        List<Map<String, Object>> classComparison = analysisMapper.selectKnowledgeClassComparison(knowledgeId, comparisonDeptIds);

        Map<String, Object> result = new HashMap<>();
        result.put("chapterMode", chapter);
        result.put("students", students == null ? new ArrayList<>() : students);
        result.put("questions", questions == null ? new ArrayList<>() : questions);
        result.put("classComparison", classComparison == null ? new ArrayList<>() : classComparison);

        int studentCount = students == null ? 0 : students.size();
        result.put("studentCount", studentCount);

        if (students != null && !students.isEmpty())
        {
            BigDecimal sum = BigDecimal.ZERO;
            int weakCount = 0;
            int attemptSum = 0;
            for (Map<String, Object> row : students)
            {
                Object rateObj = row.get("rate");
                if (rateObj != null)
                {
                    sum = sum.add(new BigDecimal(rateObj.toString()));
                }
                Object weak = row.get("weakLevel");
                if (weak != null && !"0".equals(weak.toString()))
                {
                    weakCount++;
                }
                Object att = row.get("attemptCount");
                if (att != null)
                {
                    attemptSum += Integer.parseInt(att.toString());
                }
            }
            result.put("avgRate", sum.divide(new BigDecimal(studentCount), 4, RoundingMode.HALF_UP));
            result.put("weakStudentCount", weakCount);
            result.put("avgAttemptCount", new BigDecimal(attemptSum).divide(new BigDecimal(studentCount), 2, RoundingMode.HALF_UP));
            enrichConfidence(students);
        }
        result.put("headline", buildKnowledgeHeadline(result));
        return result;
    }

    private String buildKnowledgeHeadline(Map<String, Object> result)
    {
        int students = toInt(result.get("studentCount"));
        int weak = toInt(result.get("weakStudentCount"));
        Object avg = result.get("avgRate");
        StringBuilder sb = new StringBuilder();
        sb.append("覆盖 ").append(students).append(" 名学生");
        if (avg != null)
        {
            sb.append("，平均得分率 ").append(formatPct(avg));
        }
        sb.append("；关注/薄弱/严重合计 ").append(weak).append(" 人");
        if (students > 0 && weak > 0)
        {
            BigDecimal ratio = BigDecimal.valueOf(weak).multiply(BigDecimal.valueOf(100))
                .divide(BigDecimal.valueOf(students), 1, RoundingMode.HALF_UP);
            sb.append("（占比 ").append(ratio.toPlainString()).append("%）");
        }
        return sb.toString();
    }

    /** Resolve self + child dept ids for grade/school nodes. */
    private List<Long> expandDeptWithChildren(Long deptId)
    {
        List<Long> ids = new ArrayList<>();
        ids.add(deptId);
        SysDept query = new SysDept();
        List<SysDept> depts = deptService.selectDeptList(query);
        if (depts != null)
        {
            String needle = String.valueOf(deptId);
            for (SysDept d : depts)
            {
                if (d.getDeptId() == null || d.getDeptId().equals(deptId))
                {
                    continue;
                }
                String ancestors = d.getAncestors();
                if (ancestors == null || ancestors.isEmpty())
                {
                    continue;
                }
                for (String part : ancestors.split(","))
                {
                    if (needle.equals(part.trim()))
                    {
                        ids.add(d.getDeptId());
                        break;
                    }
                }
            }
        }
        return ids;
    }

    /** Resolve dept ids visible to current user via role data scope (for knowledge drill-down without deptId). */
    private List<Long> resolveAccessibleDeptIds()
    {
        SysDept query = new SysDept();
        List<SysDept> depts = deptService.selectDeptList(query);
        List<Long> ids = new ArrayList<>();
        if (depts != null)
        {
            for (SysDept d : depts)
            {
                if (d.getDeptId() != null)
                {
                    ids.add(d.getDeptId());
                }
            }
        }
        if (ids.isEmpty())
        {
            ids.add(-1L);
        }
        return ids;
    }

    @Override
    public List<Map<String, Object>> studentKnowledgeQuestions(Long studentId, Long knowledgeId, Long subjectId)
    {
        return analysisMapper.selectStudentKnowledgeQuestions(studentId, knowledgeId, subjectId);
    }

    @Override
    public int recalculateByPaper(Long paperId)
    {
        SpasPaper paper = paperMapper.selectSpasPaperById(paperId);
        if (paper == null)
        {
            throw new ServiceException("试卷不存在");
        }
        accessService.checkDeptAccess(paper.getDeptId());
        int rows = knowledgeStatCalculator.recalculateByPaper(paperId);
        if (autoEvaluateIntervene)
        {
            List<Long> sids = analysisMapper.selectStudentIdsByPaperId(paperId);
            if (asyncEvaluateIntervene)
            {
                interveneService.evaluateOpenForStudentsAsync(sids);
            }
            else
            {
                interveneService.evaluateOpenForStudents(sids);
            }
        }
        return rows;
    }

    @Override
    public int recalculateByStudent(Long studentId)
    {
        int rows = knowledgeStatCalculator.recalculateByStudent(studentId);
        if (autoEvaluateIntervene)
        {
            List<Long> one = java.util.Collections.singletonList(studentId);
            if (asyncEvaluateIntervene)
            {
                interveneService.evaluateOpenForStudentsAsync(one);
            }
            else
            {
                interveneService.evaluateOpenForStudents(one);
            }
        }
        return rows;
    }

    @Override
    public int recalculateByStudents(Collection<Long> studentIds, Long paperId)
    {
        return knowledgeStatCalculator.recalculateByStudents(studentIds, paperId);
    }

    @Override
    public Map<String, Object> recalculateByDept(Long deptId, Long subjectId)
    {
        if (deptId == null)
        {
            throw new ServiceException("请选择班级/部门");
        }
        accessService.checkDeptAccess(deptId);
        List<Long> studentIds = analysisMapper.selectStudentIdsForRecalc(deptId, subjectId);
        int studentCount = studentIds == null ? 0 : studentIds.size();
        int upserted = 0;
        if (studentCount > 0)
        {
            upserted = knowledgeStatCalculator.recalculateByStudents(studentIds, null);
        }
        int warnings = warningEngine.evaluateAllEnabled();
        int interveneEval = 0;
        boolean interveneAsync = false;
        if (autoEvaluateIntervene && studentCount > 0)
        {
            if (asyncEvaluateIntervene)
            {
                interveneService.evaluateOpenForStudentsAsync(studentIds);
                interveneAsync = true;
            }
            else
            {
                interveneEval = interveneService.evaluateOpenForStudents(studentIds);
            }
        }
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("studentCount", studentCount);
        result.put("statRows", upserted);
        result.put("warningCreated", warnings);
        result.put("interveneEvaluated", interveneEval);
        result.put("interveneAsync", interveneAsync);
        return result;
    }
}
