package com.ruoyi.spas.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.analysis.KnowledgeStatCalculator;
import com.ruoyi.spas.analysis.KnowledgeStatQueryService;
import com.ruoyi.spas.domain.SpasPaper;
import com.ruoyi.spas.mapper.SpasAnalysisMapper;
import com.ruoyi.spas.mapper.SpasPaperMapper;
import com.ruoyi.spas.mapper.SpasSubjectQuestionTypeMapper;
import com.ruoyi.spas.service.ISpasAnalysisService;
import com.ruoyi.spas.service.ISpasInterveneService;
import com.ruoyi.spas.service.ISpasKnowledgeEdgeService;
import com.ruoyi.spas.domain.SpasSubjectQuestionType;
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
    private KnowledgeStatQueryService knowledgeStatQueryService;

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

    @Autowired
    private SpasSubjectQuestionTypeMapper subjectQuestionTypeMapper;

    @Autowired
    private ISpasKnowledgeEdgeService knowledgeEdgeService;

    @Autowired(required = false)
    private com.ruoyi.spas.config.SpasAnalysisTuningProperties tuningProperties;

    @Value("${spas.analysis.weak-thresholds.watch:0.75}")
    private double watchThreshold;

    @Value("${spas.analysis.weak-thresholds.weak:0.60}")
    private double weakThreshold;

    /** Bloom insight: foundation considered solid above this rate (default between weak and watch). */
    @Value("${spas.analysis.bloom-insight.foundation-solid:0.70}")
    private double bloomFoundationSolid;

    @Value("${spas.analysis.bloom-insight.gap:0.15}")
    private double bloomInsightGap;

    @Value("${spas.intervene.auto-evaluate-after-recalc:true}")
    private boolean autoEvaluateIntervene;

    @Value("${spas.intervene.async-evaluate:true}")
    private boolean asyncEvaluateIntervene;

    @Value("${spas.analysis.priority.question-min:2}")
    private int priorityQuestionMin;

    @Value("${spas.analysis.priority.weak-rate:0.60}")
    private double priorityWeakRate;

    @Value("${spas.analysis.priority.solid-rate:0.75}")
    private double prioritySolidRate;

    @Value("${spas.analysis.priority.attempt-mid:3}")
    private int attemptMid;

    @Value("${spas.analysis.priority.attempt-high:6}")
    private int attemptHigh;

    @Value("${spas.analysis.annotation-coverage.unbound-ratio-threshold:0.20}")
    private double annotationUnboundThreshold;

    @Value("${spas.analysis.annotation-coverage.force-insufficient:true}")
    private boolean annotationForceInsufficient;

    @Value("${spas.analysis.annotation-coverage.confidence-multiplier:0.5}")
    private double annotationConfidenceMultiplier;

    @Value("${spas.analysis.annotation-coverage.apply-on-window:true}")
    private boolean annotationApplyOnWindow;

    @Value("${spas.paper.require-question-type:false}")
    private boolean requireQuestionType;

    @Value("${spas.paper.require-bloom-level:false}")
    private boolean requireBloomLevel;

    @Override
    public List<Map<String, Object>> studentRadar(Long studentId, Long subjectId)
    {
        return studentRadar(studentId, subjectId, null);
    }

    @Override
    public List<Map<String, Object>> studentRadar(Long studentId, Long subjectId, String window)
    {
        return studentRadar(studentId, subjectId, window, null);
    }

    @Override
    public List<Map<String, Object>> studentRadar(Long studentId, Long subjectId, String window, List<Long> paperIds)
    {
        List<Long> pids = normalizePaperIds(paperIds);
        List<Map<String, Object>> list;
        if (pids != null)
        {
            list = knowledgeStatQueryService.studentRadar(studentId, subjectId, null, pids);
        }
        else
        {
            Date from = windowHelper.resolveExamDateFrom(window);
            if (from == null)
            {
                list = analysisMapper.selectStudentRadar(studentId, subjectId);
            }
            else
            {
                list = knowledgeStatQueryService.studentRadar(studentId, subjectId, from, null);
            }
        }
        enrichConfidence(list, pids);
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
        return studentTrend(studentId, subjectId, window, null);
    }

    @Override
    public List<Map<String, Object>> studentTrend(Long studentId, Long subjectId, String window, List<Long> paperIds)
    {
        List<Long> pids = normalizePaperIds(paperIds);
        Date from = pids != null ? null : windowHelper.resolveExamDateFrom(window);
        return analysisMapper.selectStudentTrend(studentId, subjectId, from, pids);
    }

    @Override
    public List<Map<String, Object>> studentWeakTop(Long studentId, Long subjectId, Integer limit)
    {
        return studentWeakTop(studentId, subjectId, limit, null);
    }

    @Override
    public List<Map<String, Object>> studentWeakTop(Long studentId, Long subjectId, Integer limit, String window)
    {
        return studentWeakTop(studentId, subjectId, limit, window, null);
    }

    @Override
    public List<Map<String, Object>> studentWeakTop(Long studentId, Long subjectId, Integer limit, String window,
        List<Long> paperIds)
    {
        int top = limit == null || limit <= 0 ? 10 : limit;
        List<Long> pids = normalizePaperIds(paperIds);
        List<Map<String, Object>> list;
        if (pids != null)
        {
            list = knowledgeStatQueryService.studentWeakTop(studentId, subjectId, top, null, pids);
        }
        else
        {
            Date from = windowHelper.resolveExamDateFrom(window);
            if (from == null)
            {
                list = analysisMapper.selectStudentWeakTop(studentId, subjectId, top);
            }
            else
            {
                list = knowledgeStatQueryService.studentWeakTop(studentId, subjectId, top, from, null);
            }
        }
        enrichConfidence(list, pids);
        if (list != null)
        {
            for (Map<String, Object> row : list)
            {
                Object gapObj = row.get("gap");
                if (gapObj != null)
                {
                    try
                    {
                        knowledgeStatQueryService.annotateRelativeWeak(row, new BigDecimal(gapObj.toString()));
                    }
                    catch (Exception ignored)
                    {
                    }
                }
            }
        }
        if (list != null && !list.isEmpty())
        {
            knowledgeEdgeService.buildDependencyHints(studentId, subjectId, list);
        }
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
        return studentSummary(studentId, subjectId, window, null);
    }

    @Override
    public Map<String, Object> studentSummary(Long studentId, Long subjectId, String window, List<Long> paperIds)
    {
        List<Long> pids = normalizePaperIds(paperIds);
        Map<String, Object> summary;
        Date from = null;
        String dataMode;
        if (pids != null)
        {
            summary = knowledgeStatQueryService.studentSummary(studentId, subjectId, null, pids);
            dataMode = "papers";
        }
        else
        {
            from = windowHelper.resolveExamDateFrom(window);
            if (from == null)
            {
                summary = analysisMapper.selectStudentSummary(studentId, subjectId,
                    Double.valueOf(knowledgeStatCalculator.resolveWeakThreshold()),
                    Double.valueOf(knowledgeStatCalculator.resolveSevereThreshold()),
                    Integer.valueOf(knowledgeStatCalculator.resolveMinAttempts()));
                dataMode = "snapshot";
            }
            else
            {
                summary = knowledgeStatQueryService.studentSummary(studentId, subjectId, from, null);
                dataMode = "live";
            }
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
        summary.put("confidenceLabel", confidenceLabel(att));
        List<Long> coveragePids = resolveCoveragePaperIds(subjectId, window, pids);
        applyAnnotationCoveragePenalty(summary, coveragePids, att);
        summary.put("window", pids != null ? "papers" : (windowHelper.isAll(window) ? "all" : windowHelper.normalize(window)));
        summary.put("dataMode", dataMode);
        summary.put("paperCount", pids == null ? 0 : pids.size());
        if (coveragePids != null && !coveragePids.isEmpty() && (pids == null || pids.isEmpty()))
        {
            summary.put("coveragePaperCount", Integer.valueOf(coveragePids.size()));
        }
        if (summary.get("calcTime") == null && !"snapshot".equals(dataMode))
        {
            summary.put("calcTime", new Date());
            summary.put("calcTimeLive", Boolean.TRUE);
        }
        summary.put("lastCalcTime", summary.get("calcTime"));
        attachSubjectsWithData(summary, studentId, subjectId, from, pids);
        if (subjectId == null)
        {
            attachSubjectBreakdown(summary, studentId, from, pids);
            summary.put("allSubjects", Boolean.TRUE);
        }
        else
        {
            summary.put("allSubjects", Boolean.FALSE);
        }
        summary.put("headline", buildStudentHeadline(summary));
        return summary;
    }

    /**
     * Per-subject KPIs when analyzing all subjects (subjectId == null).
     */
    @SuppressWarnings("unchecked")
    private void attachSubjectBreakdown(Map<String, Object> summary, Long studentId, Date examDateFrom,
        List<Long> paperIds)
    {
        List<Map<String, Object>> subjects = (List<Map<String, Object>>) summary.get("subjectsWithData");
        if (subjects == null || subjects.isEmpty())
        {
            summary.put("subjectBreakdown", new ArrayList<Map<String, Object>>());
            return;
        }
        List<Map<String, Object>> breakdown = new ArrayList<Map<String, Object>>();
        for (Map<String, Object> s : subjects)
        {
            Long sid = toLong(s.get("subjectId"));
            if (sid == null)
            {
                continue;
            }
            Map<String, Object> part;
            if (paperIds != null && !paperIds.isEmpty())
            {
                part = knowledgeStatQueryService.studentSummary(studentId, sid, null, paperIds);
            }
            else if (examDateFrom != null)
            {
                part = knowledgeStatQueryService.studentSummary(studentId, sid, examDateFrom, null);
            }
            else
            {
                part = analysisMapper.selectStudentSummary(studentId, sid,
                    Double.valueOf(knowledgeStatCalculator.resolveWeakThreshold()),
                    Double.valueOf(knowledgeStatCalculator.resolveSevereThreshold()),
                    Integer.valueOf(knowledgeStatCalculator.resolveMinAttempts()));
            }
            if (part == null)
            {
                part = new HashMap<String, Object>();
            }
            Map<String, Object> row = new HashMap<String, Object>();
            row.put("subjectId", sid);
            row.put("subjectName", s.get("subjectName"));
            row.put("overallRate", part.get("overallRate") != null ? part.get("overallRate") : part.get("avgRate"));
            row.put("classAvgRate", part.get("classAvgRate"));
            row.put("gap", part.get("gap"));
            row.put("weakCount", part.get("weakCount"));
            row.put("severeCount", part.get("severeCount"));
            row.put("watchCount", part.get("watchCount"));
            row.put("lowRateCount", part.get("lowRateCount"));
            row.put("totalAttempts", part.get("totalAttempts"));
            row.put("knowledgeCount", part.get("knowledgeCount"));
            breakdown.add(row);
        }
        breakdown.sort((a, b) -> {
            Double ra = toDoubleObj(a.get("overallRate"));
            Double rb = toDoubleObj(b.get("overallRate"));
            double da = ra == null ? 2.0 : ra.doubleValue();
            double db = rb == null ? 2.0 : rb.doubleValue();
            return Double.compare(da, db);
        });
        summary.put("subjectBreakdown", breakdown);
    }

    /**
     * Attach subjectsWithData / emptyKnowledge / suggestedSubject* so UI can auto-switch
     * when the default sorted subject (e.g. 语文) has no score_detail for this student.
     */
    private void attachSubjectsWithData(Map<String, Object> summary, Long studentId, Long subjectId,
        Date examDateFrom, List<Long> paperIds)
    {
        List<Map<String, Object>> subjects = analysisMapper.selectStudentSubjectsWithData(studentId, examDateFrom,
            paperIds);
        if (subjects == null)
        {
            subjects = new ArrayList<Map<String, Object>>();
        }
        summary.put("subjectsWithData", subjects);
        int attempts = toInt(summary.get("totalAttempts"));
        int knowledgeCount = toInt(summary.get("knowledgeCount"));
        boolean empty = summary.get("overallRate") == null && attempts <= 0 && knowledgeCount <= 0;
        summary.put("emptyKnowledge", Boolean.valueOf(empty));
        if (!empty || subjects.isEmpty())
        {
            return;
        }
        Map<String, Object> pick = null;
        for (Map<String, Object> row : subjects)
        {
            Long sid = toLong(row.get("subjectId"));
            if (sid == null)
            {
                continue;
            }
            if (subjectId == null || !sid.equals(subjectId))
            {
                pick = row;
                break;
            }
        }
        if (pick == null)
        {
            pick = subjects.get(0);
        }
        if (pick != null)
        {
            summary.put("suggestedSubjectId", pick.get("subjectId"));
            summary.put("suggestedSubjectName", pick.get("subjectName"));
        }
    }

    private Long toLong(Object v)
    {
        if (v == null)
        {
            return null;
        }
        if (v instanceof Number)
        {
            return ((Number) v).longValue();
        }
        try
        {
            return Long.valueOf(v.toString());
        }
        catch (Exception ignored)
        {
            return null;
        }
    }

    @Override
    public List<Map<String, Object>> studentChapterRadar(Long studentId, Long subjectId)
    {
        return studentChapterRadar(studentId, subjectId, null, null);
    }

    @Override
    public List<Map<String, Object>> studentChapterRadar(Long studentId, Long subjectId, String window,
        List<Long> paperIds)
    {
        List<Long> pids = normalizePaperIds(paperIds);
        List<Map<String, Object>> list;
        if (pids != null)
        {
            list = knowledgeStatQueryService.studentChapterRadar(studentId, subjectId, null, pids);
        }
        else
        {
            Date from = windowHelper.resolveExamDateFrom(window);
            if (from == null)
            {
                list = analysisMapper.selectStudentChapterRadar(studentId, subjectId);
            }
            else
            {
                list = knowledgeStatQueryService.studentChapterRadar(studentId, subjectId, from, null);
            }
        }
        enrichConfidence(list, pids);
        return list;
    }

    @Override
    public Map<String, Object> classChapterOverview(Long deptId, Long subjectId)
    {
        return classChapterOverview(deptId, subjectId, null, null);
    }

    @Override
    public Map<String, Object> classChapterOverview(Long deptId, Long subjectId, String window, List<Long> paperIds)
    {
        accessService.checkClassAnalysisDept(deptId);
        List<Long> pids = normalizePaperIds(paperIds);
        Map<String, Object> data;
        if (pids != null)
        {
            data = knowledgeStatQueryService.classChapterOverview(deptId, subjectId, null, pids);
        }
        else
        {
            Date from = windowHelper.resolveExamDateFrom(window);
            if (from == null)
            {
                List<Map<String, Object>> chapters = analysisMapper.selectClassChapterOverview(deptId, subjectId,
                    Double.valueOf(knowledgeStatCalculator.resolveWeakThreshold()));
                data = new HashMap<>();
                data.put("chapters", chapters == null ? new ArrayList<>() : chapters);
                data.put("dataMode", "snapshot");
                data.put("headline", chapters == null || chapters.isEmpty()
                    ? "\u6682\u65e0\u7ae0\u8282\u6c47\u603b\u6570\u636e"
                    : ("\u7ae0\u8282\u6570 " + chapters.size()));
            }
            else
            {
                data = knowledgeStatQueryService.classChapterOverview(deptId, subjectId, from, null);
            }
        }
        return data;
    }

    @Override
    public Map<String, Object> paperAnnotationCoverage(List<Long> paperIds)
    {
        List<Long> pids = normalizePaperIds(paperIds);
        if (pids == null)
        {
            throw new ServiceException("请至少选择一份试卷");
        }
        for (Long paperId : pids)
        {
            SpasPaper paper = paperMapper.selectSpasPaperById(paperId);
            if (paper == null)
            {
                throw new ServiceException("试卷不存在：" + paperId);
            }
            accessService.checkDeptAccess(paper.getDeptId());
        }
        return knowledgeStatQueryService.paperAnnotationCoverage(pids);
    }

    @Override
    public List<Map<String, Object>> classTrend(Long deptId, Long subjectId, String window)
    {
        return classTrend(deptId, subjectId, window, null);
    }

    @Override
    public List<Map<String, Object>> classTrend(Long deptId, Long subjectId, String window, List<Long> paperIds)
    {
        accessService.checkClassAnalysisDept(deptId);
        List<Long> pids = normalizePaperIds(paperIds);
        Date from = pids != null ? null : windowHelper.resolveExamDateFrom(window);
        return analysisMapper.selectClassTrend(deptId, subjectId, from, pids,
            Double.valueOf(knowledgeStatCalculator.resolveWeakThreshold()));
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
        if (Boolean.TRUE.equals(summary.get("emptyKnowledge")))
        {
            StringBuilder empty = new StringBuilder();
            if (Boolean.TRUE.equals(summary.get("allSubjects")))
            {
                empty.append("当前口径下各科均暂无小题掌握度数据（上方卡片来自小题成绩，不是实考校次）");
            }
            else
            {
                empty.append("当前学科暂无小题掌握度数据（上方卡片来自小题成绩，不是实考校次）");
            }
            Object suggested = summary.get("suggestedSubjectName");
            if (suggested != null && StringUtils.isNotEmpty(suggested.toString()))
            {
                empty.append("。该生有数据的学科：").append(suggested);
            }
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> withData = (List<Map<String, Object>>) summary.get("subjectsWithData");
            if ((suggested == null || StringUtils.isEmpty(String.valueOf(suggested)))
                && (withData == null || withData.isEmpty()))
            {
                empty.append("。请先导入带知识点标注的小题成绩");
            }
            return empty.toString();
        }
        int severe = toInt(summary.get("severeCount"));
        int weak = toInt(summary.get("weakCount"));
        int watch = toInt(summary.get("watchCount"));
        Object rate = summary.get("overallRate");
        Object gap = summary.get("gap");
        StringBuilder sb = new StringBuilder();
        if (Boolean.TRUE.equals(summary.get("allSubjects")))
        {
            sb.append("【全科】");
        }
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
        sb.append("；正式严重 ").append(severe).append(" / 正式薄弱 ").append(weak).append(" / 关注 ").append(watch);
        int lowRate = toInt(summary.get("lowRateCount"));
        int thin = toInt(summary.get("thinSampleCount"));
        sb.append("；综合低分 ").append(lowRate);
        if (thin > 0)
        {
            sb.append("（其中样本不足 ").append(thin).append("）");
        }
        if (Boolean.TRUE.equals(summary.get("formalWeakBlocked")))
        {
            sb.append("；标注覆盖不足，薄弱结论仅供参考");
        }
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
        enrichConfidence(list, null);
    }

    private void enrichConfidence(List<Map<String, Object>> list, List<Long> paperIds)
    {
        if (list == null)
        {
            return;
        }
        CoveragePenalty penalty = resolveCoveragePenalty(paperIds);
        for (Map<String, Object> row : list)
        {
            int attempts = toInt(row.get("attemptCount"));
            if (attempts <= 0)
            {
                attempts = toInt(row.get("attemptAvg"));
            }
            BigDecimal conf = knowledgeStatCalculator.confidence(attempts);
            String label = confidenceLabel(attempts);
            if (penalty != null && penalty.apply)
            {
                if (penalty.forceInsufficient)
                {
                    label = "\u6837\u672c\u4e0d\u8db3";
                }
                conf = conf.multiply(BigDecimal.valueOf(penalty.multiplier)).setScale(4, RoundingMode.HALF_UP);
                row.put("coverageAdjusted", Boolean.TRUE);
                row.put("unboundRatio", penalty.unboundRatio);
            }
            row.put("confidence", conf);
            row.put("confidenceLabel", label);
            // 正式薄弱 vs 证据不足：与快照 weak_level / min-attempts 对齐
            knowledgeStatQueryService.annotateEvidence(row);
            if (penalty != null && penalty.apply && penalty.forceInsufficient)
            {
                row.put("evidenceOk", Boolean.FALSE);
                row.put("formalWeakBlocked", Boolean.TRUE);
            }
        }
    }

    private void applyAnnotationCoveragePenalty(Map<String, Object> summary, List<Long> paperIds, int attempts)
    {
        CoveragePenalty penalty = resolveCoveragePenalty(paperIds);
        if (penalty == null || !penalty.apply || summary == null)
        {
            return;
        }
        Object confObj = summary.get("confidence");
        BigDecimal conf = confObj instanceof BigDecimal ? (BigDecimal) confObj
            : knowledgeStatCalculator.confidence(attempts);
        if (penalty.forceInsufficient)
        {
            summary.put("confidenceLabel", "\u6837\u672c\u4e0d\u8db3");
            // 选卷标注覆盖不足：禁止当作正式薄弱结论
            summary.put("formalWeakBlocked", Boolean.TRUE);
            summary.put("formalWeakBlockReason",
                "\u5f53\u524d\u53e3\u5f84\u5185\u8bd5\u5377\u672a\u6807\u6ce8\u77e5\u8bc6\u70b9\u5360\u6bd4\u8fc7\u9ad8\uff0c\u8584\u5f31\u7ed3\u8bba\u4ec5\u4f5c\u53c2\u8003\uff0c\u4e0d\u5f97\u4f5c\u4e3a\u6b63\u5f0f\u5b9a\u7ea7");
        }
        summary.put("confidence",
            conf.multiply(BigDecimal.valueOf(penalty.multiplier)).setScale(4, RoundingMode.HALF_UP));
        summary.put("coverageAdjusted", Boolean.TRUE);
        summary.put("unboundRatio", penalty.unboundRatio);
        summary.put("annotationCoverage", penalty.coverage);
    }

    private CoveragePenalty resolveCoveragePenalty(List<Long> paperIds)
    {
        if (paperIds == null || paperIds.isEmpty())
        {
            return null;
        }
        try
        {
            Map<String, Object> coverage = knowledgeStatQueryService.paperAnnotationCoverage(paperIds);
            if (coverage == null)
            {
                return null;
            }
            Object ratioObj = coverage.get("unboundRatio");
            if (ratioObj == null)
            {
                return null;
            }
            double unbound = Double.parseDouble(ratioObj.toString());
            CoveragePenalty p = new CoveragePenalty();
            p.coverage = coverage;
            p.unboundRatio = unbound;
            p.apply = unbound > annotationUnboundThreshold;
            p.forceInsufficient = annotationForceInsufficient;
            p.multiplier = annotationConfidenceMultiplier <= 0 ? 0.5 : annotationConfidenceMultiplier;
            return p;
        }
        catch (Exception e)
        {
            return null;
        }
    }

    private static class CoveragePenalty
    {
        boolean apply;
        boolean forceInsufficient;
        double multiplier;
        double unboundRatio;
        Map<String, Object> coverage;
    }

    @Override
    public List<Map<String, Object>> classWeakTop(Long deptId, Long subjectId, Integer limit)
    {
        return classWeakTop(deptId, subjectId, limit, null, null);
    }

    @Override
    public List<Map<String, Object>> classWeakTop(Long deptId, Long subjectId, Integer limit, String window,
        List<Long> paperIds)
    {
        int top = limit == null || limit <= 0 ? 10 : limit;
        List<Long> pids = normalizePaperIds(paperIds);
        List<Map<String, Object>> list;
        if (pids != null)
        {
            list = knowledgeStatQueryService.classWeakTop(deptId, subjectId, top, null, pids);
        }
        else
        {
            Date from = windowHelper.resolveExamDateFrom(window);
            if (from == null)
            {
                list = analysisMapper.selectClassWeakTop(deptId, subjectId, top);
            }
            else
            {
                list = knowledgeStatQueryService.classWeakTop(deptId, subjectId, top, from, null);
            }
        }
        enrichConfidence(list, pids);
        if (list != null && !list.isEmpty() && subjectId != null)
        {
            Map<Long, java.math.BigDecimal> classRates = resolveClassKnowledgeRates(deptId, subjectId, window, paperIds);
            knowledgeEdgeService.buildDependencyHints(null, subjectId, list, classRates);
        }
        return list;
    }

    /** Class avg rates for D5 prerequisite hints (live or snapshot). */
    private Map<Long, java.math.BigDecimal> resolveClassKnowledgeRates(Long deptId, Long subjectId, String window,
        List<Long> paperIds)
    {
        Map<Long, java.math.BigDecimal> map = new HashMap<Long, java.math.BigDecimal>();
        List<Long> pids = normalizePaperIds(paperIds);
        Date from = pids != null ? null : windowHelper.resolveExamDateFrom(window);
        if (pids != null || from != null)
        {
            return knowledgeStatQueryService.classKnowledgeAvgRates(deptId, subjectId, from, pids);
        }
        List<Map<String, Object>> overview = analysisMapper.selectClassOverview(deptId, subjectId);
        if (overview == null)
        {
            return map;
        }
        for (Map<String, Object> row : overview)
        {
            Object kidObj = row.get("knowledgeId");
            if (kidObj == null)
            {
                continue;
            }
            Long kid;
            try
            {
                kid = Long.valueOf(kidObj.toString());
            }
            catch (Exception ignored)
            {
                continue;
            }
            Object rate = row.get("avgRate");
            if (rate == null)
            {
                rate = row.get("rate");
            }
            if (rate instanceof java.math.BigDecimal)
            {
                map.put(kid, (java.math.BigDecimal) rate);
            }
            else if (rate instanceof Number)
            {
                map.put(kid, java.math.BigDecimal.valueOf(((Number) rate).doubleValue()));
            }
        }
        return map;
    }

    @Override
    public List<Map<String, Object>> knowledgeExamTrend(Long studentId, Long knowledgeId, Long subjectId,
        List<Long> paperIds, String window)
    {
        List<Long> pids = normalizePaperIds(paperIds);
        Date from = pids != null ? null : windowHelper.resolveExamDateFrom(window);
        return knowledgeStatQueryService.knowledgeExamTrend(studentId, knowledgeId, subjectId, pids, from);
    }

    @Override
    public List<Map<String, Object>> classKnowledgeExamTrend(Long deptId, Long knowledgeId, Long subjectId,
        String window, List<Long> paperIds)
    {
        accessService.checkClassAnalysisDept(deptId);
        if (knowledgeId == null)
        {
            throw new ServiceException("\u8bf7\u9009\u62e9\u77e5\u8bc6\u70b9");
        }
        List<Long> pids = normalizePaperIds(paperIds);
        Date from = pids != null ? null : windowHelper.resolveExamDateFrom(window);
        return knowledgeStatQueryService.classKnowledgeExamTrend(deptId, knowledgeId, subjectId, pids, from);
    }

    @Override
    public List<Map<String, Object>> persistentWeak(Long studentId, Long subjectId, List<Long> paperIds, String window,
        Integer minPapers, Double rateThreshold, Double ratio)
    {
        List<Long> pids = normalizePaperIds(paperIds);
        Date from = pids != null ? null : windowHelper.resolveExamDateFrom(window);
        List<Map<String, Object>> list = knowledgeStatQueryService.persistentWeak(studentId, subjectId, pids, from,
            minPapers, rateThreshold, ratio);
        enrichConfidence(list, pids);
        return list;
    }

    @Override
    public Map<String, Object> studentScopeCompare(Long studentId, Long subjectId, List<Long> paperIds,
        String baselineWindow)
    {
        List<Long> pids = normalizePaperIds(paperIds);
        if (pids == null)
        {
            throw new ServiceException("\u8bf7\u81f3\u5c11\u9009\u62e9\u4e00\u4efd\u8bd5\u5377");
        }
        Map<String, Object> papersSummary = knowledgeStatQueryService.studentSummary(studentId, subjectId, null, pids);
        Map<String, Object> baselineSummary = studentSummary(studentId, subjectId, baselineWindow, null);
        List<Map<String, Object>> papersPersist = knowledgeStatQueryService.persistentWeak(studentId, subjectId, pids,
            null, null, null, null);
        Date baseFrom = windowHelper.resolveExamDateFrom(baselineWindow);
        List<Map<String, Object>> baselinePersist;
        if (baseFrom == null && (baselineWindow == null || windowHelper.isAll(baselineWindow)))
        {
            baselinePersist = knowledgeStatQueryService.persistentWeak(studentId, subjectId, null, null, null, null,
                null);
        }
        else
        {
            baselinePersist = knowledgeStatQueryService.persistentWeak(studentId, subjectId, null, baseFrom, null, null,
                null);
        }
        Set<Long> basePersistIds = new HashSet<Long>();
        if (baselinePersist != null)
        {
            for (Map<String, Object> row : baselinePersist)
            {
                if ("\u53cd\u590d\u8584\u5f31".equals(String.valueOf(row.get("persistTag"))))
                {
                    Long kid = toLongObj(row.get("knowledgeId"));
                    if (kid != null)
                    {
                        basePersistIds.add(kid);
                    }
                }
            }
        }
        List<Map<String, Object>> newPersist = new ArrayList<Map<String, Object>>();
        int papersPersistCount = 0;
        if (papersPersist != null)
        {
            for (Map<String, Object> row : papersPersist)
            {
                if (!"\u53cd\u590d\u8584\u5f31".equals(String.valueOf(row.get("persistTag"))))
                {
                    continue;
                }
                papersPersistCount++;
                Long kid = toLongObj(row.get("knowledgeId"));
                if (kid != null && !basePersistIds.contains(kid))
                {
                    Map<String, Object> item = new HashMap<String, Object>();
                    item.put("knowledgeId", kid);
                    item.put("knowledgeName", row.get("knowledgeName") != null ? row.get("knowledgeName") : row.get("name"));
                    item.put("rate", row.get("rate"));
                    item.put("persistTag", row.get("persistTag"));
                    newPersist.add(item);
                }
            }
        }
        BigDecimal papersRate = toBigDecimal(papersSummary == null ? null : papersSummary.get("overallRate"));
        BigDecimal baseRate = toBigDecimal(baselineSummary == null ? null : baselineSummary.get("overallRate"));
        BigDecimal delta = null;
        if (papersRate != null && baseRate != null)
        {
            delta = papersRate.subtract(baseRate);
        }
        Map<String, Object> result = new LinkedHashMap<String, Object>();
        Map<String, Object> papersScope = new LinkedHashMap<String, Object>();
        papersScope.put("overallRate", papersRate);
        papersScope.put("paperCount", Integer.valueOf(pids.size()));
        papersScope.put("persistentWeakCount", Integer.valueOf(papersPersistCount));
        Map<String, Object> baselineScope = new LinkedHashMap<String, Object>();
        baselineScope.put("overallRate", baseRate);
        baselineScope.put("window", baselineWindow == null || windowHelper.isAll(baselineWindow) ? "all"
            : windowHelper.normalize(baselineWindow));
        baselineScope.put("dataMode", baselineSummary == null ? null : baselineSummary.get("dataMode"));
        result.put("papersScope", papersScope);
        result.put("baselineScope", baselineScope);
        result.put("deltaOverallRate", delta);
        result.put("newPersistentWeaks", newPersist);
        result.put("newPersistentCount", Integer.valueOf(newPersist.size()));
        return result;
    }

    private BigDecimal toBigDecimal(Object v)
    {
        if (v == null)
        {
            return null;
        }
        if (v instanceof BigDecimal)
        {
            return (BigDecimal) v;
        }
        try
        {
            return new BigDecimal(v.toString());
        }
        catch (Exception e)
        {
            return null;
        }
    }

    @Override
    public Map<String, Object> classHeatmap(Long deptId, Long subjectId)
    {
        return classHeatmap(deptId, subjectId, null, null);
    }

    @Override
    public Map<String, Object> classHeatmap(Long deptId, Long subjectId, String window, List<Long> paperIds)
    {
        List<Long> pids = normalizePaperIds(paperIds);
        if (pids != null)
        {
            return knowledgeStatQueryService.classHeatmap(deptId, subjectId, null, pids);
        }
        Date from = windowHelper.resolveExamDateFrom(window);
        if (from == null)
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
            result.put("dataMode", "snapshot");
            return result;
        }
        return knowledgeStatQueryService.classHeatmap(deptId, subjectId, from, null);
    }

    @Override
    public Map<String, Object> classOverview(Long deptId, Long subjectId)
    {
        return classOverview(deptId, subjectId, null, null);
    }

    @Override
    public Map<String, Object> classOverview(Long deptId, Long subjectId, String window, List<Long> paperIds)
    {
        List<Long> pids = normalizePaperIds(paperIds);
        Map<String, Object> result;
        Date from = null;
        if (pids != null)
        {
            result = knowledgeStatQueryService.classOverview(deptId, subjectId, null, pids);
        }
        else
        {
            from = windowHelper.resolveExamDateFrom(window);
            if (from == null)
            {
                Map<String, Object> summary = analysisMapper.selectClassSummary(deptId, subjectId);
                List<Map<String, Object>> knowledges = analysisMapper.selectClassOverview(deptId, subjectId);
                if (knowledges == null)
                {
                    knowledges = new ArrayList<Map<String, Object>>();
                }

                result = new HashMap<String, Object>();
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
                List<Map<String, Object>> ranking = analysisMapper.selectClassStudentRanking(deptId, subjectId,
                    Double.valueOf(knowledgeStatCalculator.resolveWeakThreshold()),
                    Double.valueOf(knowledgeStatCalculator.resolveSevereThreshold()),
                    Integer.valueOf(knowledgeStatCalculator.resolveMinAttempts()));
                result.put("studentRanking", ranking == null ? new ArrayList<Map<String, Object>>() : ranking);
                result.put("dataMode", "snapshot");
            }
            else
            {
                result = knowledgeStatQueryService.classOverview(deptId, subjectId, from, null);
            }
        }
        if (result == null)
        {
            result = new HashMap<String, Object>();
        }
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
        enrichClassOverviewMetrics(result);
        attachDeptSubjectsWithData(result, deptId, subjectId, from, pids);
        List<Long> coveragePids = resolveCoveragePaperIds(subjectId, window, pids);
        if (coveragePids != null && !coveragePids.isEmpty())
        {
            applyAnnotationCoveragePenalty(result, coveragePids, 0);
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> ranking = result.get("studentRanking") instanceof List
                ? (List<Map<String, Object>>) result.get("studentRanking") : null;
            enrichConfidence(ranking, coveragePids);
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> knowledges = result.get("knowledges") instanceof List
                ? (List<Map<String, Object>>) result.get("knowledges") : null;
            enrichConfidence(knowledges, coveragePids);
            if (pids == null || pids.isEmpty())
            {
                result.put("coveragePaperCount", Integer.valueOf(coveragePids.size()));
            }
        }
        result.put("headline", buildClassHeadline(result));
        result.put("window", pids != null ? "papers" : (windowHelper.isAll(window) ? "all" : windowHelper.normalize(window)));
        return result;
    }

    /**
     * Derive lowRate / thinSample student counts from ranking when live path did not set them.
     */
    @SuppressWarnings("unchecked")
    private void enrichClassOverviewMetrics(Map<String, Object> result)
    {
        List<Map<String, Object>> ranking = null;
        Object raw = result.get("studentRanking");
        if (raw instanceof List)
        {
            ranking = (List<Map<String, Object>>) raw;
        }
        if (ranking == null)
        {
            ranking = new ArrayList<Map<String, Object>>();
        }
        if (!result.containsKey("lowRateStudentCount") || !result.containsKey("thinSampleStudentCount"))
        {
            int lowRate = 0;
            int thinOnly = 0;
            for (Map<String, Object> row : ranking)
            {
                Object rateObj = row.get("overallRate");
                if (rateObj != null)
                {
                    try
                    {
                        if (new BigDecimal(rateObj.toString()).compareTo(BigDecimal.valueOf(knowledgeStatCalculator.resolveWeakThreshold())) < 0)
                        {
                            lowRate++;
                        }
                    }
                    catch (Exception ignored)
                    {
                    }
                }
                int thin = toInt(row.get("thinSampleCount"));
                int formal = toInt(row.get("weakKnowledgeCount"));
                if (thin > 0 && formal <= 0)
                {
                    thinOnly++;
                }
            }
            if (!result.containsKey("lowRateStudentCount"))
            {
                result.put("lowRateStudentCount", Integer.valueOf(lowRate));
            }
            if (!result.containsKey("thinSampleStudentCount"))
            {
                result.put("thinSampleStudentCount", Integer.valueOf(thinOnly));
            }
        }
    }

    private void attachDeptSubjectsWithData(Map<String, Object> result, Long deptId, Long subjectId,
        Date examDateFrom, List<Long> paperIds)
    {
        List<Map<String, Object>> subjects = analysisMapper.selectDeptSubjectsWithData(deptId, examDateFrom, paperIds);
        if (subjects == null)
        {
            subjects = new ArrayList<Map<String, Object>>();
        }
        result.put("subjectsWithData", subjects);
        int students = toInt(result.get("studentCount"));
        boolean empty = result.get("avgRate") == null && students <= 0
            && (result.get("knowledges") instanceof List ? ((List<?>) result.get("knowledges")).isEmpty() : true);
        result.put("emptyKnowledge", Boolean.valueOf(empty));
        if (!empty || subjects.isEmpty())
        {
            return;
        }
        Map<String, Object> pick = null;
        for (Map<String, Object> row : subjects)
        {
            Long sid = toLong(row.get("subjectId"));
            if (sid == null)
            {
                continue;
            }
            if (subjectId == null || !sid.equals(subjectId))
            {
                pick = row;
                break;
            }
        }
        if (pick == null)
        {
            pick = subjects.get(0);
        }
        if (pick != null)
        {
            result.put("suggestedSubjectId", pick.get("subjectId"));
            result.put("suggestedSubjectName", pick.get("subjectName"));
        }
    }

    private String buildClassHeadline(Map<String, Object> result)
    {
        if (Boolean.TRUE.equals(result.get("emptyKnowledge")))
        {
            StringBuilder empty = new StringBuilder();
            empty.append("当前学科暂无小题掌握度数据");
            Object suggested = result.get("suggestedSubjectName");
            if (suggested != null && StringUtils.isNotEmpty(suggested.toString()))
            {
                empty.append("。本班有数据的学科：").append(suggested);
            }
            else
            {
                empty.append("。请先导入带知识点标注的小题成绩");
            }
            return empty.toString();
        }
        Object avg = result.get("avgRate");
        int students = toInt(result.get("studentCount"));
        int weakStu = toInt(result.get("weakStudentCount"));
        int severeStu = toInt(result.get("severeStudentCount"));
        int lowRateStu = toInt(result.get("lowRateStudentCount"));
        int thinStu = toInt(result.get("thinSampleStudentCount"));
        int weakKp = toInt(result.get("knowledgeCount"));
        StringBuilder sb = new StringBuilder();
        sb.append(students).append(" 名学生");
        if (avg != null)
        {
            sb.append("，班均 ").append(formatPct(avg));
        }
        sb.append("；正式薄弱 ").append(weakStu);
        if (severeStu > 0)
        {
            sb.append("（含严重 ").append(severeStu).append("）");
        }
        sb.append("，综合低分 ").append(lowRateStu);
        if (thinStu > 0)
        {
            if (weakStu <= 0)
            {
                sb.append("（").append(thinStu).append(" 人因作答不足未定正式薄弱）");
            }
            else
            {
                sb.append("，样本不足 ").append(thinStu);
            }
        }
        if (Boolean.TRUE.equals(result.get("formalWeakBlocked")))
        {
            sb.append("；标注覆盖不足，薄弱结论仅供参考");
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
        return knowledgeOverview(knowledgeId, null, deptId, null, null);
    }

    @Override
    public Map<String, Object> knowledgeOverview(Long knowledgeId, Long deptId, String window, List<Long> paperIds)
    {
        return knowledgeOverview(knowledgeId, null, deptId, window, paperIds);
    }

    @Override
    public Map<String, Object> knowledgeOverview(Long knowledgeId, Long subjectId, Long deptId, String window,
        List<Long> paperIds)
    {
        List<Long> pids = normalizePaperIds(paperIds);
        boolean papers = pids != null;
        boolean scoped = papers || (window != null && !windowHelper.isAll(window));

        SpasKnowledge kn = knowledgeId == null ? null : knowledgeMapper.selectSpasKnowledgeById(knowledgeId);
        if (knowledgeId != null && kn == null)
        {
            throw new ServiceException("\u77e5\u8bc6\u70b9\u4e0d\u5b58\u5728");
        }
        Long resolvedSubjectId = subjectId;
        if (resolvedSubjectId == null && kn != null)
        {
            resolvedSubjectId = kn.getSubjectId();
        }
        if (knowledgeId == null && resolvedSubjectId == null)
        {
            throw new ServiceException("\u8bf7\u9009\u62e9\u5b66\u79d1\u6216\u77e5\u8bc6\u70b9");
        }

        String nodeType = kn == null ? null : String.valueOf(kn.getNodeType());
        boolean subjectAll = knowledgeId == null;
        boolean versionMode = "0".equals(nodeType);
        boolean chapterMode = "1".equals(nodeType);
        boolean rollup = subjectAll || versionMode || chapterMode;

        // Rollup under time-window / papers: live leaf roll-up (same weighted engine)
        if (rollup && scoped)
        {
            Date from = papers ? null : windowHelper.resolveExamDateFrom(window);
            Map<String, Object> liveRollup = knowledgeStatQueryService.knowledgeRollupOverview(knowledgeId,
                resolvedSubjectId, deptId, subjectAll, versionMode, chapterMode, from, pids);
            if (liveRollup == null)
            {
                liveRollup = new HashMap<String, Object>();
            }
            List<Long> allow = knowledgeDeptAllow(deptId);
            filterStudentsByDept(liveRollup, allow);
            refreshKnowledgeAggregates(liveRollup);
            liveRollup.put("questions", new ArrayList<Map<String, Object>>());
            liveRollup.put("classComparison", new ArrayList<Map<String, Object>>());
            liveRollup.put("headline", buildKnowledgeHeadline(liveRollup));
            liveRollup.put("chapterMode", Boolean.TRUE);
            liveRollup.put("rollupMode", subjectAll ? "all" : (versionMode ? "version" : "chapter"));
            String scope = papers ? "papers" : windowHelper.normalize(window);
            liveRollup.put("scope", scope);
            liveRollup.put("window", scope);
            liveRollup.put("dataMode", papers ? "papers" : "live");
            liveRollup.put("scopeNote",
                "\u7248\u672c/\u7ae0\u8282/\u5168\u90e8\u5df2\u6309\u5f53\u524d\u65f6\u95f4\u7a97\u6216\u9009\u5377\uff0c\u5bf9\u53f6\u5b50\u77e5\u8bc6\u70b9\u505a\u52a0\u6743\u5373\u65f6\u6c47\u603b\uff1b\u4e0e\u300c\u5168\u90e8\u5feb\u7167\u300d\u53e3\u5f84\u4e0d\u540c\u3002");
            return liveRollup;
        }

        // Unscoped rollup or snapshot leaf: use snapshot tables
        if (rollup || !scoped)
        {
            Map<String, Object> snap = buildKnowledgeSnapshot(knowledgeId, resolvedSubjectId, deptId, rollup,
                subjectAll, versionMode, chapterMode);
            snap.put("scope", window == null || windowHelper.isAll(window) ? "all" : windowHelper.normalize(window));
            return snap;
        }

        Date from = papers ? null : windowHelper.resolveExamDateFrom(window);
        Map<String, Object> live = knowledgeStatQueryService.knowledgeOverview(knowledgeId, resolvedSubjectId, deptId,
            from, pids);
        if (live == null)
        {
            live = new HashMap<String, Object>();
        }
        List<Long> allow = knowledgeDeptAllow(deptId);
        filterStudentsByDept(live, allow);
        refreshKnowledgeAggregates(live);
        List<Long> deptIds = deptId == null ? allow : null;
        List<Map<String, Object>> questions = analysisMapper.selectKnowledgeQuestions(knowledgeId, deptId, deptIds);
        live.put("questions", filterKnowledgeQuestions(questions, from, pids));
        live.put("headline", buildKnowledgeHeadline(live));
        live.put("rollupMode", "leaf");
        live.put("chapterMode", Boolean.FALSE);
        String scope = papers ? "papers" : windowHelper.normalize(window);
        live.put("scope", scope);
        live.put("window", scope);
        return live;
    }

    private Map<String, Object> buildKnowledgeSnapshot(Long knowledgeId, Long subjectId, Long deptId, boolean rollup,
        boolean subjectAll, boolean versionMode, boolean chapterMode)
    {
        List<Long> deptIds = null;
        if (deptId == null)
        {
            if (teacherScopeService.useTeacherDeptFilter())
            {
                deptIds = teacherScopeService.getSubjectTeacherDeptIds();
            }
            else if (!accessService.isFullDataAccess())
            {
                deptIds = resolveAccessibleDeptIds();
            }
        }

        List<Map<String, Object>> students;
        if (subjectAll)
        {
            students = analysisMapper.selectKnowledgeOverviewSubject(subjectId, deptId, deptIds);
        }
        else if (rollup)
        {
            students = analysisMapper.selectKnowledgeOverviewChapter(knowledgeId, deptId, deptIds);
        }
        else
        {
            students = analysisMapper.selectKnowledgeOverview(knowledgeId, deptId, deptIds);
        }
        if (students == null)
        {
            students = new ArrayList<>();
        }
        fillWeakLevelFromRate(students);

        List<Map<String, Object>> questions = new ArrayList<>();
        if (!rollup && knowledgeId != null)
        {
            questions = analysisMapper.selectKnowledgeQuestions(knowledgeId, deptId, deptIds);
            if (questions == null)
            {
                questions = new ArrayList<>();
            }
        }

        List<Long> comparisonDeptIds = null;
        if (deptId != null)
        {
            comparisonDeptIds = expandDeptWithChildren(deptId);
        }
        else
        {
            comparisonDeptIds = deptIds;
        }
        List<Map<String, Object>> classComparison = new ArrayList<>();
        if (!rollup && knowledgeId != null)
        {
            classComparison = analysisMapper.selectKnowledgeClassComparison(knowledgeId, comparisonDeptIds);
            if (classComparison == null)
            {
                classComparison = new ArrayList<>();
            }
        }
        else if (rollup)
        {
            classComparison = analysisMapper.selectKnowledgeClassComparisonRollup(subjectId, knowledgeId,
                comparisonDeptIds);
            if (classComparison == null)
            {
                classComparison = new ArrayList<>();
            }
        }

        List<Map<String, Object>> children = new ArrayList<>();
        String childType = null;
        String childrenLabel = null;
        if (subjectAll)
        {
            childType = "0";
            childrenLabel = "\u7248\u672c";
        }
        else if (versionMode)
        {
            childType = "1";
            childrenLabel = "\u7ae0\u8282";
        }
        else if (chapterMode)
        {
            childType = "2";
            childrenLabel = "\u77e5\u8bc6\u70b9";
        }
        Double weakRate = Double.valueOf(knowledgeStatCalculator.resolveWeakThreshold());
        if (childType != null && subjectId != null)
        {
            children = analysisMapper.selectKnowledgeChildBreakdown(subjectId, knowledgeId, childType, deptId, deptIds,
                weakRate);
            if (children == null)
            {
                children = new ArrayList<>();
            }
            // Flat trees: no version nodes → fall back to chapters; no chapters → leaves
            if (children.isEmpty() && subjectAll)
            {
                children = analysisMapper.selectKnowledgeChildBreakdown(subjectId, null, "1", deptId, deptIds, weakRate);
                if (children != null && !children.isEmpty())
                {
                    childrenLabel = "\u7ae0\u8282";
                    childType = "1";
                }
                else
                {
                    children = analysisMapper.selectKnowledgeChildBreakdown(subjectId, null, "2", deptId, deptIds,
                        weakRate);
                    childrenLabel = "\u77e5\u8bc6\u70b9";
                }
            }
            else if (children.isEmpty() && versionMode)
            {
                children = analysisMapper.selectKnowledgeChildBreakdown(subjectId, knowledgeId, "2", deptId, deptIds,
                    weakRate);
                childrenLabel = "\u77e5\u8bc6\u70b9";
            }
            if (children == null)
            {
                children = new ArrayList<>();
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("chapterMode", Boolean.valueOf(chapterMode || versionMode || subjectAll));
        result.put("rollupMode", subjectAll ? "all" : (versionMode ? "version" : (chapterMode ? "chapter" : "leaf")));
        result.put("students", students);
        result.put("questions", questions);
        result.put("classComparison", classComparison);
        result.put("children", children);
        result.put("childrenLabel", childrenLabel);

        int studentCount = students.size();
        result.put("studentCount", studentCount);

        if (!students.isEmpty())
        {
            BigDecimal sum = BigDecimal.ZERO;
            int weakCount = 0;
            int attemptSum = 0;
            int rateN = 0;
            for (Map<String, Object> row : students)
            {
                Object rateObj = row.get("rate");
                if (rateObj != null)
                {
                    sum = sum.add(new BigDecimal(rateObj.toString()));
                    rateN++;
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
            if (rateN > 0)
            {
                result.put("avgRate", sum.divide(new BigDecimal(rateN), 4, RoundingMode.HALF_UP));
            }
            result.put("weakStudentCount", weakCount);
            result.put("avgAttemptCount",
                new BigDecimal(attemptSum).divide(new BigDecimal(studentCount), 2, RoundingMode.HALF_UP));
            enrichConfidence(students);
        }
        else
        {
            result.put("weakStudentCount", 0);
        }
        result.put("headline", buildKnowledgeHeadline(result));
        return result;
    }

    private void fillWeakLevelFromRate(List<Map<String, Object>> students)
    {
        if (students == null)
        {
            return;
        }
        for (Map<String, Object> row : students)
        {
            if (row.get("weakLevel") != null)
            {
                continue;
            }
            Object rateObj = row.get("rate");
            if (rateObj == null)
            {
                continue;
            }
            BigDecimal rate = new BigDecimal(rateObj.toString());
            int attempts = 0;
            Object att = row.get("attemptCount");
            if (att != null)
            {
                try
                {
                    attempts = Integer.parseInt(att.toString());
                }
                catch (Exception ignored)
                {
                    attempts = 0;
                }
            }
            row.put("weakLevel", knowledgeStatCalculator.resolveWeakLevel(rate, attempts));
        }
    }

    private List<Long> knowledgeDeptAllow(Long deptId)
    {
        if (deptId != null)
        {
            return null;
        }
        if (teacherScopeService.useTeacherDeptFilter())
        {
            return teacherScopeService.getSubjectTeacherDeptIds();
        }
        if (!accessService.isFullDataAccess())
        {
            return resolveAccessibleDeptIds();
        }
        return null;
    }

    @SuppressWarnings("unchecked")
    private void filterStudentsByDept(Map<String, Object> live, List<Long> allow)
    {
        if (allow == null)
        {
            return;
        }
        Object raw = live.get("students");
        if (!(raw instanceof List))
        {
            return;
        }
        List<Map<String, Object>> kept = new ArrayList<Map<String, Object>>();
        for (Object item : (List<?>) raw)
        {
            if (!(item instanceof Map))
            {
                continue;
            }
            Map<String, Object> row = (Map<String, Object>) item;
            Long did = toLongObj(row.get("deptId"));
            if (did != null && allow.contains(did))
            {
                kept.add(row);
            }
        }
        live.put("students", kept);
    }

    @SuppressWarnings("unchecked")
    private void refreshKnowledgeAggregates(Map<String, Object> live)
    {
        Object raw = live.get("students");
        List<Map<String, Object>> students = new ArrayList<Map<String, Object>>();
        if (raw instanceof List)
        {
            for (Object item : (List<?>) raw)
            {
                if (item instanceof Map)
                {
                    students.add((Map<String, Object>) item);
                }
            }
        }
        BigDecimal sum = BigDecimal.ZERO;
        int weak = 0;
        int attemptSum = 0;
        int rateN = 0;
        Map<String, BigDecimal> deptSum = new HashMap<String, BigDecimal>();
        Map<String, Integer> deptN = new HashMap<String, Integer>();
        for (Map<String, Object> row : students)
        {
            Object rateObj = row.get("rate");
            if (rateObj != null)
            {
                BigDecimal rate = new BigDecimal(rateObj.toString());
                sum = sum.add(rate);
                rateN++;
                String deptName = row.get("deptName") == null ? "-" : String.valueOf(row.get("deptName"));
                BigDecimal prev = deptSum.get(deptName);
                deptSum.put(deptName, prev == null ? rate : prev.add(rate));
                Integer n = deptN.get(deptName);
                deptN.put(deptName, n == null ? Integer.valueOf(1) : Integer.valueOf(n.intValue() + 1));
            }
            Object weakLevel = row.get("weakLevel");
            if (weakLevel != null && !"0".equals(weakLevel.toString()))
            {
                weak++;
            }
            Object att = row.get("attemptCount");
            if (att != null)
            {
                attemptSum += Integer.parseInt(att.toString());
            }
        }
        live.put("studentCount", Integer.valueOf(students.size()));
        live.put("weakStudentCount", Integer.valueOf(weak));
        live.put("avgRate", rateN > 0 ? sum.divide(new BigDecimal(rateN), 4, RoundingMode.HALF_UP) : null);
        live.put("avgAttemptCount", students.isEmpty() ? null
            : new BigDecimal(attemptSum).divide(new BigDecimal(students.size()), 2, RoundingMode.HALF_UP));
        List<Map<String, Object>> comparison = new ArrayList<Map<String, Object>>();
        for (Map.Entry<String, Integer> e : deptN.entrySet())
        {
            Map<String, Object> row = new HashMap<String, Object>();
            row.put("deptName", e.getKey());
            row.put("studentCount", e.getValue());
            BigDecimal deptRate = deptSum.get(e.getKey());
            if (deptRate != null && e.getValue().intValue() > 0)
            {
                row.put("avgRate", deptRate.divide(new BigDecimal(e.getValue().intValue()), 4, RoundingMode.HALF_UP));
            }
            comparison.add(row);
        }
        live.put("classComparison", comparison);
        enrichConfidence(students);
    }

    private List<Map<String, Object>> filterKnowledgeQuestions(List<Map<String, Object>> questions, Date from,
        List<Long> paperIds)
    {
        List<Map<String, Object>> out = new ArrayList<Map<String, Object>>();
        if (questions == null)
        {
            return out;
        }
        for (Map<String, Object> row : questions)
        {
            if (paperIds != null)
            {
                Long pid = toLongObj(row.get("paperId"));
                if (pid == null || !paperIds.contains(pid))
                {
                    continue;
                }
            }
            else if (from != null)
            {
                Date exam = toDate(row.get("examDate"));
                if (exam != null && exam.before(from))
                {
                    continue;
                }
            }
            out.add(row);
        }
        return out;
    }

    private Date toDate(Object v)
    {
        if (v == null)
        {
            return null;
        }
        if (v instanceof Date)
        {
            return (Date) v;
        }
        String s = v.toString();
        if (s.length() < 10)
        {
            return null;
        }
        try
        {
            return new java.text.SimpleDateFormat("yyyy-MM-dd").parse(s.substring(0, 10));
        }
        catch (Exception e)
        {
            return null;
        }
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
        return studentKnowledgeQuestions(studentId, knowledgeId, subjectId, null, null);
    }

    @Override
    public List<Map<String, Object>> studentKnowledgeQuestions(Long studentId, Long knowledgeId, Long subjectId,
        String window, List<Long> paperIds)
    {
        List<Long> pids = normalizePaperIds(paperIds);
        Date from = pids != null ? null : windowHelper.resolveExamDateFrom(window);
        return analysisMapper.selectStudentKnowledgeQuestions(studentId, knowledgeId, subjectId, from, pids);
    }

    @Override
    public int recalculateByPaper(Long paperId)
    {
        return recalculateByPaper(paperId, null);
    }

    @Override
    public int recalculateByPaper(Long paperId, Boolean useRecency)
    {
        SpasPaper paper = paperMapper.selectSpasPaperById(paperId);
        if (paper == null)
        {
            throw new ServiceException("试卷不存在");
        }
        accessService.checkDeptAccess(paper.getDeptId());
        applyRecencyOverride(useRecency);
        try
        {
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
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @Override
    public int recalculateByStudent(Long studentId)
    {
        return recalculateByStudent(studentId, null);
    }

    @Override
    public int recalculateByStudent(Long studentId, Boolean useRecency)
    {
        applyRecencyOverride(useRecency);
        try
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
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @Override
    public int recalculateByStudents(Collection<Long> studentIds, Long paperId)
    {
        return knowledgeStatCalculator.recalculateByStudents(studentIds, paperId);
    }

    @Override
    public Map<String, Object> recalculateByDept(Long deptId, Long subjectId)
    {
        return recalculateByDept(deptId, subjectId, null);
    }

    @Override
    public Map<String, Object> recalculateByDept(Long deptId, Long subjectId, Boolean useRecency)
    {
        if (deptId == null)
        {
            throw new ServiceException("请选择班级/部门");
        }
        accessService.checkClassAnalysisDept(deptId);
        applyRecencyOverride(useRecency);
        try
        {
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
            result.put("useRecency", useRecency == null ? Boolean.TRUE : useRecency);
            result.put("recencyHalfLifeDays", knowledgeStatCalculator.effectiveRecencyHalfLifeDays());
            return result;
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @Override
    public Map<String, Object> recalculateAll(Boolean useRecency)
    {
        applyRecencyOverride(useRecency);
        try
        {
            List<Long> studentIds = analysisMapper.selectStudentIdsForRecalc(null, null);
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
            result.put("studentCount", Integer.valueOf(studentCount));
            result.put("statRows", Integer.valueOf(upserted));
            result.put("warningCreated", Integer.valueOf(warnings));
            result.put("interveneEvaluated", Integer.valueOf(interveneEval));
            result.put("interveneAsync", Boolean.valueOf(interveneAsync));
            result.put("scope", "all");
            result.put("useRecency", useRecency == null ? Boolean.TRUE : useRecency);
            result.put("recencyHalfLifeDays",
                Integer.valueOf(knowledgeStatCalculator.effectiveRecencyHalfLifeDays()));
            return result;
        }
        finally
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    private void applyRecencyOverride(Boolean useRecency)
    {
        if (useRecency == null)
        {
            return;
        }
        if (Boolean.FALSE.equals(useRecency))
        {
            KnowledgeStatCalculator.setRecencyOverride(Integer.valueOf(0));
        }
        else
        {
            KnowledgeStatCalculator.clearRecencyOverride();
        }
    }

    @Override
    public Map<String, Object> analysisConfig()
    {
        Map<String, Object> cfg = new HashMap<String, Object>();
        cfg.put("defaultWindow", windowHelper.getDefaultWindow());
        cfg.put("recencyHalfLifeDays", knowledgeStatCalculator.effectiveRecencyHalfLifeDays());
        cfg.put("recencyAnchor", knowledgeStatCalculator.getRecencyAnchor());
        cfg.put("minAttempts", Integer.valueOf(knowledgeStatCalculator.resolveMinAttempts()));
        cfg.put("windowModes", java.util.Arrays.asList("all", "last30d", "last90d", "semester", "prev_semester"));
        cfg.put("windowNote", "all=snapshot; other windows=live weighted; prev_semester=closed range; paperIds=paper-set live weighted; default primary window=semester");
        cfg.put("scopeMaxPapers", Integer.valueOf(knowledgeStatQueryService.getScopeMaxPapers()));
        cfg.put("priority", priorityThresholds());
        Map<String, Object> weak = new HashMap<String, Object>();
        weak.put("watch", Double.valueOf(watchThreshold));
        weak.put("weak", Double.valueOf(knowledgeStatCalculator.resolveWeakThreshold()));
        weak.put("severe", Double.valueOf(knowledgeStatCalculator.resolveSevereThreshold()));
        weak.put("minAttempts", Integer.valueOf(knowledgeStatCalculator.resolveMinAttempts()));
        cfg.put("weakThresholds", weak);
        Map<String, Object> bloom = new HashMap<String, Object>();
        bloom.put("weak", Double.valueOf(weakThreshold > 0 ? weakThreshold : knowledgeStatCalculator.resolveWeakThreshold()));
        bloom.put("foundationSolid", Double.valueOf(bloomFoundationSolid));
        bloom.put("gap", Double.valueOf(bloomInsightGap));
        cfg.put("bloomInsight", bloom);
        Map<String, Object> persist = new HashMap<String, Object>();
        persist.put("minPapers", Integer.valueOf(knowledgeStatQueryService.getPersistMinPapers()));
        persist.put("rateThreshold", Double.valueOf(knowledgeStatQueryService.getPersistRateThreshold()));
        persist.put("persistRatio", Double.valueOf(knowledgeStatQueryService.getPersistRatio()));
        cfg.put("persistentWeak", persist);
        Map<String, Object> annot = new HashMap<String, Object>();
        annot.put("unboundRatioThreshold", Double.valueOf(annotationUnboundThreshold));
        annot.put("forceInsufficient", Boolean.valueOf(annotationForceInsufficient));
        annot.put("confidenceMultiplier", Double.valueOf(annotationConfidenceMultiplier));
        annot.put("applyOnWindow", Boolean.valueOf(annotationApplyOnWindow));
        annot.put("requireQuestionType", Boolean.valueOf(requireQuestionType));
        annot.put("requireBloomLevel", Boolean.valueOf(requireBloomLevel));
        cfg.put("annotationCoverage", annot);
        cfg.put("allocationMode", knowledgeStatCalculator.resolveAllocationMode());
        Map<String, Object> relative = new HashMap<String, Object>();
        if (tuningProperties != null && tuningProperties.getRelativeWeak() != null)
        {
            relative.put("enabled", Boolean.valueOf(tuningProperties.getRelativeWeak().isEnabled()));
            relative.put("delta", Double.valueOf(tuningProperties.getRelativeWeak().getDelta()));
        }
        else
        {
            relative.put("enabled", Boolean.TRUE);
            relative.put("delta", Double.valueOf(0.10));
        }
        cfg.put("relativeWeak", relative);
        cfg.put("subjectOverrides", tuningProperties == null ? java.util.Collections.emptyMap()
            : tuningProperties.getSubjectOverrides());
        cfg.put("prevSemester", windowHelper.describePrevSemester());
        cfg.put("semesterStart", windowHelper.getSemesterStartConfig());
        return cfg;
    }

    @Override
    public Map<String, Object> studentQuestionType(Long studentId, Long subjectId, String window, List<Long> paperIds)
    {
        List<Long> pids = resolveScopePaperIds(subjectId, window, paperIds);
        if (pids != null && pids.isEmpty())
        {
            return buildDimensionBreakdown(new ArrayList<Map<String, Object>>(), "typeCode", "typeName", subjectId, true);
        }
        Date from = pids != null ? null : windowHelper.resolveExamDateFrom(window);
        List<Map<String, Object>> rows = analysisMapper.selectStudentQuestionType(studentId, subjectId, from, pids);
        return buildDimensionBreakdown(rows, "typeCode", "typeName", subjectId, true);
    }

    @Override
    public Map<String, Object> classQuestionType(Long deptId, Long subjectId, String window, List<Long> paperIds)
    {
        List<Long> pids = resolveScopePaperIds(subjectId, window, paperIds);
        if (pids != null && pids.isEmpty())
        {
            return buildDimensionBreakdown(new ArrayList<Map<String, Object>>(), "typeCode", "typeName", subjectId, true);
        }
        Date from = pids != null ? null : windowHelper.resolveExamDateFrom(window);
        List<Map<String, Object>> rows = analysisMapper.selectClassQuestionType(deptId, subjectId, from, pids);
        return buildDimensionBreakdown(rows, "typeCode", "typeName", subjectId, true);
    }

    @Override
    public Map<String, Object> studentBloom(Long studentId, Long subjectId, String window, List<Long> paperIds)
    {
        List<Long> pids = resolveScopePaperIds(subjectId, window, paperIds);
        if (pids != null && pids.isEmpty())
        {
            return buildDimensionBreakdown(new ArrayList<Map<String, Object>>(), "bloomLevel", "bloomLabel", subjectId, false);
        }
        Date from = pids != null ? null : windowHelper.resolveExamDateFrom(window);
        List<Map<String, Object>> rows = analysisMapper.selectStudentBloom(studentId, subjectId, from, pids);
        return buildDimensionBreakdown(rows, "bloomLevel", "bloomLabel", subjectId, false);
    }

    @Override
    public Map<String, Object> classBloom(Long deptId, Long subjectId, String window, List<Long> paperIds)
    {
        List<Long> pids = resolveScopePaperIds(subjectId, window, paperIds);
        if (pids != null && pids.isEmpty())
        {
            return buildDimensionBreakdown(new ArrayList<Map<String, Object>>(), "bloomLevel", "bloomLabel", subjectId, false);
        }
        Date from = pids != null ? null : windowHelper.resolveExamDateFrom(window);
        List<Map<String, Object>> rows = analysisMapper.selectClassBloom(deptId, subjectId, from, pids);
        return buildDimensionBreakdown(rows, "bloomLevel", "bloomLabel", subjectId, false);
    }

    @Override
    public Map<String, Object> studentChapterDelta(Long studentId, Long subjectId, String window, List<Long> paperIds,
        String baselineWindow)
    {
        List<Map<String, Object>> recent = studentChapterRadar(studentId, subjectId, window, paperIds);
        String baseWin = StringUtils.isEmpty(baselineWindow) ? "prev_semester" : baselineWindow;
        List<Long> baselinePids = resolveScopePaperIds(subjectId, baseWin, null);
        List<Map<String, Object>> baseline;
        if (baselinePids != null && baselinePids.isEmpty())
        {
            baseline = new ArrayList<Map<String, Object>>();
        }
        else if (baselinePids != null)
        {
            baseline = studentChapterRadar(studentId, subjectId, null, baselinePids);
        }
        else
        {
            baseline = studentChapterRadar(studentId, subjectId, baseWin, null);
        }
        Map<String, Object> result = buildChapterDelta(recent, baseline, baseWin);
        enrichBaselineMeta(result, subjectId, baseWin, baselinePids);
        return result;
    }

    @Override
    public Map<String, Object> classChapterDelta(Long deptId, Long subjectId, String window, List<Long> paperIds,
        String baselineWindow)
    {
        Map<String, Object> recentOv = classChapterOverview(deptId, subjectId, window, paperIds);
        List<Map<String, Object>> recent = castChapterList(recentOv);
        String baseWin = StringUtils.isEmpty(baselineWindow) ? "prev_semester" : baselineWindow;
        List<Long> baselinePids = resolveScopePaperIds(subjectId, baseWin, null);
        Map<String, Object> baseOv;
        if (baselinePids != null && baselinePids.isEmpty())
        {
            baseOv = new LinkedHashMap<String, Object>();
            baseOv.put("chapters", new ArrayList<Map<String, Object>>());
        }
        else if (baselinePids != null)
        {
            baseOv = classChapterOverview(deptId, subjectId, null, baselinePids);
        }
        else
        {
            baseOv = classChapterOverview(deptId, subjectId, baseWin, null);
        }
        Map<String, Object> result = buildChapterDelta(recent, castChapterList(baseOv), baseWin);
        enrichBaselineMeta(result, subjectId, baseWin, baselinePids);
        return result;
    }

    private void enrichBaselineMeta(Map<String, Object> result, Long subjectId, String baselineWindow,
        List<Long> baselinePids)
    {
        if (result == null)
        {
            return;
        }
        Map<String, Object> prev = windowHelper.describePrevSemester();
        result.put("baselineRange", prev);
        int paperCount = baselinePids == null ? -1 : baselinePids.size();
        result.put("baselinePaperCount", Integer.valueOf(paperCount < 0 ? 0 : paperCount));
        boolean empty = baselinePids != null && baselinePids.isEmpty();
        result.put("baselineEmpty", Boolean.valueOf(empty));
        if (empty)
        {
            Object label = prev.get("label");
            result.put("baselineHint", "\u4e0a\u5b66\u671f\u7a97\u53e3 "
                + (label == null ? "" : label)
                + " \u5185\u65e0\u5df2\u53d1\u5e03\u8bd5\u5377\uff0c\u65e0\u6cd5\u5bf9\u6bd4\u3002\u8bf7\u68c0\u67e5\u8bd5\u5377\u8003\u8bd5\u65e5\u671f\uff0c\u6216\u5728 application.yml \u914d\u7f6e spas.analysis.prev-semester-start/end");
            if (result.get("headline") == null || String.valueOf(result.get("headline")).contains("\u6682\u65e0"))
            {
                result.put("headline", result.get("baselineHint"));
            }
        }
        else if (paperCount > 0)
        {
            result.put("baselineHint", "\u57fa\u7ebf\u7a97 "
                + (prev.get("label") == null ? baselineWindow : prev.get("label"))
                + "\uff0c\u5171 " + paperCount + " \u4efd\u8bd5\u5377");
        }
    }

    /** When window is prev_semester (closed range), resolve to concrete paperIds. */
    private List<Long> resolveScopePaperIds(Long subjectId, String window, List<Long> paperIds)
    {
        List<Long> pids = normalizePaperIds(paperIds);
        if (pids != null)
        {
            return pids;
        }
        if (windowHelper.isClosedRangeWindow(window))
        {
            Date from = windowHelper.resolveExamDateFrom(window);
            Date to = windowHelper.resolveExamDateToExclusive(window);
            List<Long> ranged = analysisMapper.selectPaperIdsByExamDateRange(subjectId, from, to);
            if (ranged == null || ranged.isEmpty())
            {
                return java.util.Collections.emptyList();
            }
            return normalizePaperIds(ranged);
        }
        return null;
    }

    /**
     * Resolve papers for annotation-coverage gate: explicit paperIds, or live window papers when enabled.
     */
    private List<Long> resolveCoveragePaperIds(Long subjectId, String window, List<Long> paperIds)
    {
        List<Long> pids = normalizePaperIds(paperIds);
        if (pids != null)
        {
            return pids;
        }
        if (!annotationApplyOnWindow)
        {
            return null;
        }
        if (windowHelper.isClosedRangeWindow(window))
        {
            Date from = windowHelper.resolveExamDateFrom(window);
            Date to = windowHelper.resolveExamDateToExclusive(window);
            List<Long> ranged = analysisMapper.selectPaperIdsByExamDateRange(subjectId, from, to);
            return (ranged == null || ranged.isEmpty()) ? null : normalizePaperIds(ranged);
        }
        Date from = windowHelper.resolveExamDateFrom(window);
        if (from == null)
        {
            // window=all / snapshot: skip coverage gate (no concrete paper set)
            return null;
        }
        List<Long> ranged = analysisMapper.selectPaperIdsByExamDateRange(subjectId, from, null);
        return (ranged == null || ranged.isEmpty()) ? null : normalizePaperIds(ranged);
    }

    private Map<String, Object> buildDimensionBreakdown(List<Map<String, Object>> rows, String codeKey,
        String nameKey, Long subjectId, boolean questionType)
    {
        Map<String, String> nameMap = questionType ? loadQuestionTypeNames(subjectId) : bloomLabels();
        int minAttempts = knowledgeStatCalculator.resolveMinAttempts();
        int labeledAttempts = 0;
        int unlabeledAttempts = 0;
        int totalAttempts = 0;
        List<Map<String, Object>> items = new ArrayList<Map<String, Object>>();
        if (rows != null)
        {
            for (Map<String, Object> row : rows)
            {
                Map<String, Object> item = new LinkedHashMap<String, Object>(row);
                String code = row.get(codeKey) == null ? "_unlabeled" : String.valueOf(row.get(codeKey));
                item.put(codeKey, code);
                if ("_unlabeled".equals(code))
                {
                    item.put(nameKey, "\u672a\u6807\u6ce8");
                }
                else
                {
                    String nm = nameMap.get(code);
                    item.put(nameKey, nm != null ? nm : code);
                }
                int attempts = toInt(row.get("attemptCount"), 0);
                totalAttempts += attempts;
                if ("_unlabeled".equals(code))
                {
                    unlabeledAttempts += attempts;
                }
                else
                {
                    labeledAttempts += attempts;
                }
                String confidence = attempts < minAttempts ? "low" : (attempts < minAttempts * 2 ? "mid" : "high");
                item.put("confidence", confidence);
                items.add(item);
            }
        }
        Map<String, Object> summary = new LinkedHashMap<String, Object>();
        summary.put("totalAttempts", Integer.valueOf(totalAttempts));
        summary.put("unlabeledCount", Integer.valueOf(unlabeledAttempts));
        summary.put("coverageRate", totalAttempts <= 0 ? null
            : Double.valueOf((double) labeledAttempts / (double) totalAttempts));
        Map<String, Object> result = new LinkedHashMap<String, Object>();
        result.put("items", items);
        result.put("summary", summary);
        if (!questionType)
        {
            String insight = bloomInsight(items, minAttempts);
            if (insight != null)
            {
                result.put("insight", insight);
            }
        }
        return result;
    }

    /** Light rules: foundation weak vs higher-order weak (needs labeled coverage). */
    private String bloomInsight(List<Map<String, Object>> items, int minAttempts)
    {
        if (items == null || items.isEmpty())
        {
            return null;
        }
        Double foundation = null;
        Double higher = null;
        int foundationAtt = 0;
        int higherAtt = 0;
        for (Map<String, Object> item : items)
        {
            String code = item.get("bloomLevel") == null ? "" : String.valueOf(item.get("bloomLevel"));
            if ("_unlabeled".equals(code))
            {
                continue;
            }
            Double rate = toDoubleObj(item.get("avgRate"));
            int att = toInt(item.get("attemptCount"), 0);
            if (rate == null || att < minAttempts)
            {
                continue;
            }
            if ("remember".equals(code) || "understand".equals(code))
            {
                foundation = foundation == null ? rate
                    : Double.valueOf((foundation.doubleValue() * foundationAtt + rate.doubleValue() * att)
                        / (foundationAtt + att));
                foundationAtt += att;
            }
            else if ("apply".equals(code) || "analyze".equals(code))
            {
                higher = higher == null ? rate
                    : Double.valueOf((higher.doubleValue() * higherAtt + rate.doubleValue() * att)
                        / (higherAtt + att));
                higherAtt += att;
            }
        }
        if (foundation == null || higher == null)
        {
            return null;
        }
        double weak = weakThreshold > 0 ? weakThreshold : knowledgeStatCalculator.resolveWeakThreshold();
        double solid = bloomFoundationSolid > 0 ? bloomFoundationSolid : 0.70;
        double gapCut = bloomInsightGap > 0 ? bloomInsightGap : 0.15;
        double gap = foundation.doubleValue() - higher.doubleValue();
        if (foundation.doubleValue() < weak && higher.doubleValue() >= weak)
        {
            return "\u57fa\u7840\u5c42\uff08\u8bb0\u5fc6/\u7406\u89e3\uff09\u504f\u5f31\uff0c\u5efa\u8bae\u5148\u8865\u6982\u5ff5\u4e0e\u516c\u5f0f";
        }
        if (foundation.doubleValue() >= solid && higher.doubleValue() < weak)
        {
            return "\u57fa\u7840\u5c1a\u53ef\uff0c\u9ad8\u9636\uff08\u5e94\u7528/\u5206\u6790\uff09\u504f\u5f31\uff0c\u5efa\u8bae\u52a0\u5f3a\u7efc\u5408\u9898";
        }
        if (gap >= gapCut)
        {
            return "\u57fa\u7840\u76f8\u5bf9\u7a33\u56fa\uff0c\u9ad8\u9636\u80fd\u529b\u6709\u5dee\u8ddd";
        }
        if (gap <= -gapCut)
        {
            return "\u9ad8\u9636\u8868\u73b0\u4f18\u4e8e\u57fa\u7840\u5c42\uff0c\u5efa\u8bae\u590d\u76d8\u57fa\u7840\u6982\u5ff5";
        }
        return null;
    }

    private Map<String, String> loadQuestionTypeNames(Long subjectId)
    {
        Map<String, String> map = new LinkedHashMap<String, String>();
        map.put("single", "\u5355\u9009\u9898");
        map.put("multi", "\u591a\u9009\u9898");
        map.put("judge", "\u5224\u65ad\u9898");
        map.put("fill", "\u586b\u7a7a\u9898");
        map.put("short", "\u7b80\u7b54\u9898");
        map.put("calc", "\u8ba1\u7b97\u9898");
        map.put("experiment", "\u5b9e\u9a8c\u9898");
        if (subjectId != null)
        {
            List<SpasSubjectQuestionType> list = subjectQuestionTypeMapper.selectEnabledBySubjectId(subjectId);
            if (list != null)
            {
                for (SpasSubjectQuestionType t : list)
                {
                    if (t != null && StringUtils.isNotEmpty(t.getTypeCode()))
                    {
                        map.put(t.getTypeCode(), t.getTypeName());
                    }
                }
            }
        }
        return map;
    }

    private static Map<String, String> bloomLabels()
    {
        Map<String, String> map = new LinkedHashMap<String, String>();
        map.put("remember", "\u8bb0\u5fc6/\u8bc6\u8bb0");
        map.put("understand", "\u7406\u89e3");
        map.put("apply", "\u5e94\u7528");
        map.put("analyze", "\u5206\u6790/\u7efc\u5408");
        return map;
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> castChapterList(Map<String, Object> overview)
    {
        if (overview == null)
        {
            return new ArrayList<Map<String, Object>>();
        }
        Object chapters = overview.get("chapters");
        if (chapters instanceof List)
        {
            return (List<Map<String, Object>>) chapters;
        }
        Object items = overview.get("items");
        if (items instanceof List)
        {
            return (List<Map<String, Object>>) items;
        }
        return new ArrayList<Map<String, Object>>();
    }

    private Map<String, Object> buildChapterDelta(List<Map<String, Object>> recent,
        List<Map<String, Object>> baseline, String baselineWindow)
    {
        int minAttempts = knowledgeStatCalculator.resolveMinAttempts();
        Map<String, Map<String, Object>> baseMap = new HashMap<String, Map<String, Object>>();
        if (baseline != null)
        {
            for (Map<String, Object> row : baseline)
            {
                Long id = toLongObj(row.get("knowledgeId"));
                if (id == null)
                {
                    id = toLongObj(row.get("chapterId"));
                }
                if (id != null)
                {
                    baseMap.put(String.valueOf(id), row);
                }
            }
        }
        List<Map<String, Object>> deltas = new ArrayList<Map<String, Object>>();
        if (recent != null)
        {
            for (Map<String, Object> row : recent)
            {
                Long id = toLongObj(row.get("knowledgeId"));
                if (id == null)
                {
                    id = toLongObj(row.get("chapterId"));
                }
                if (id == null)
                {
                    continue;
                }
                Map<String, Object> item = new LinkedHashMap<String, Object>();
                item.put("knowledgeId", id);
                item.put("chapterId", id);
                Object name = row.get("knowledgeName");
                if (name == null)
                {
                    name = row.get("name");
                }
                if (name == null)
                {
                    name = row.get("chapterName");
                }
                item.put("chapterName", name);
                Double recentRate = toDoubleObj(row.get("rate"));
                if (recentRate == null)
                {
                    recentRate = toDoubleObj(row.get("avgRate"));
                }
                if (recentRate == null)
                {
                    recentRate = toDoubleObj(row.get("weightedRate"));
                }
                int recentAttempts = toInt(row.get("attemptCount"), 0);
                Map<String, Object> base = baseMap.get(String.valueOf(id));
                Double baseRate = null;
                int baseAttempts = 0;
                if (base != null)
                {
                    baseRate = toDoubleObj(base.get("rate"));
                    if (baseRate == null)
                    {
                        baseRate = toDoubleObj(base.get("avgRate"));
                    }
                    if (baseRate == null)
                    {
                        baseRate = toDoubleObj(base.get("weightedRate"));
                    }
                    baseAttempts = toInt(base.get("attemptCount"), 0);
                }
                item.put("recentRate", recentRate);
                item.put("baselineRate", baseRate);
                item.put("recentAttempts", Integer.valueOf(recentAttempts));
                item.put("baselineAttempts", Integer.valueOf(baseAttempts));
                boolean insufficient = recentAttempts < minAttempts || baseAttempts < minAttempts
                    || recentRate == null || baseRate == null;
                item.put("insufficient", Boolean.valueOf(insufficient));
                if (!insufficient)
                {
                    double delta = recentRate.doubleValue() - baseRate.doubleValue();
                    item.put("deltaRate", Double.valueOf(delta));
                }
                else
                {
                    item.put("deltaRate", null);
                }
                deltas.add(item);
            }
        }
        List<Map<String, Object>> ranked = new ArrayList<Map<String, Object>>();
        for (Map<String, Object> d : deltas)
        {
            if (!Boolean.TRUE.equals(d.get("insufficient")) && d.get("deltaRate") != null)
            {
                ranked.add(d);
            }
        }
        ranked.sort((a, b) -> {
            Double da = toDoubleObj(a.get("deltaRate"));
            Double db = toDoubleObj(b.get("deltaRate"));
            return Double.compare(db == null ? 0 : db.doubleValue(), da == null ? 0 : da.doubleValue());
        });
        List<Map<String, Object>> improved = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> declined = new ArrayList<Map<String, Object>>();
        for (Map<String, Object> d : ranked)
        {
            Double deltaObj = toDoubleObj(d.get("deltaRate"));
            double delta = deltaObj == null ? 0 : deltaObj.doubleValue();
            if (delta > 0.0001 && improved.size() < 5)
            {
                improved.add(d);
            }
        }
        for (int i = ranked.size() - 1; i >= 0 && declined.size() < 5; i--)
        {
            Map<String, Object> d = ranked.get(i);
            Double deltaObj = toDoubleObj(d.get("deltaRate"));
            double delta = deltaObj == null ? 0 : deltaObj.doubleValue();
            if (delta < -0.0001)
            {
                declined.add(d);
            }
        }
        String headline = "\u6682\u65e0\u8db3\u591f\u6837\u672c\u505a\u7ae0\u8282\u8fdb\u9000\u5bf9\u6bd4";
        if (!improved.isEmpty() || !declined.isEmpty())
        {
            StringBuilder sb = new StringBuilder();
            if (!improved.isEmpty())
            {
                sb.append("\u8fdb\u6b65\u6700\u5feb\uff1a").append(improved.get(0).get("chapterName"));
            }
            if (!declined.isEmpty())
            {
                if (sb.length() > 0)
                {
                    sb.append("\uff1b");
                }
                sb.append("\u9000\u6b65\u6700\u660e\u663e\uff1a").append(declined.get(0).get("chapterName"));
            }
            headline = sb.toString();
        }
        Map<String, Object> result = new LinkedHashMap<String, Object>();
        result.put("items", deltas);
        result.put("improved", improved);
        result.put("declined", declined);
        result.put("headline", headline);
        result.put("baselineWindow", StringUtils.isEmpty(baselineWindow) ? "prev_semester" : baselineWindow);
        return result;
    }

    private static int toInt(Object v, int def)
    {
        if (v instanceof Number)
        {
            return ((Number) v).intValue();
        }
        if (v == null)
        {
            return def;
        }
        try
        {
            return Integer.parseInt(String.valueOf(v));
        }
        catch (Exception e)
        {
            return def;
        }
    }

    @Override
    public Map<String, Object> knowledgeFrequency(List<Long> paperIds, Long subjectId)
    {
        if (paperIds == null || paperIds.isEmpty())
        {
            throw new ServiceException("请至少选择一份试卷");
        }
        if (paperIds.size() > knowledgeStatQueryService.getScopeMaxPapers())
        {
            throw new ServiceException("一次最多选择 " + knowledgeStatQueryService.getScopeMaxPapers() + " 份试卷");
        }
        List<Map<String, Object>> papers = new ArrayList<Map<String, Object>>();
        for (Long paperId : paperIds)
        {
            if (paperId == null)
            {
                continue;
            }
            SpasPaper paper = paperMapper.selectSpasPaperById(paperId);
            if (paper == null)
            {
                throw new ServiceException("试卷不存在：" + paperId);
            }
            accessService.checkDeptAccess(paper.getDeptId());
            Map<String, Object> p = new HashMap<String, Object>();
            p.put("paperId", paper.getPaperId());
            p.put("paperName", paper.getPaperName());
            p.put("examDate", paper.getExamDate());
            p.put("subjectId", paper.getSubjectId());
            papers.add(p);
        }
        if (papers.isEmpty())
        {
            throw new ServiceException("请至少选择一份试卷");
        }
        List<Long> ids = new ArrayList<Long>();
        for (Map<String, Object> p : papers)
        {
            ids.add((Long) p.get("paperId"));
        }
        List<Map<String, Object>> items = analysisMapper.selectKnowledgeFrequency(ids, subjectId);
        List<Map<String, Object>> byPaper = analysisMapper.selectKnowledgeFrequencyByPaper(ids, subjectId);
        if (items == null)
        {
            items = new ArrayList<Map<String, Object>>();
        }
        if (byPaper == null)
        {
            byPaper = new ArrayList<Map<String, Object>>();
        }
        int questionLinkCount = 0;
        BigDecimal weightSumAll = BigDecimal.ZERO;
        for (Map<String, Object> row : items)
        {
            Object qc = row.get("questionCount");
            if (qc != null)
            {
                questionLinkCount += Integer.parseInt(qc.toString());
            }
            Object ws = row.get("weightSum");
            if (ws != null)
            {
                weightSumAll = weightSumAll.add(new BigDecimal(ws.toString()));
            }
        }
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("papers", papers);
        result.put("items", items);
        result.put("byPaper", byPaper);
        result.put("knowledgeCount", items.size());
        result.put("paperCount", papers.size());
        result.put("questionLinkCount", questionLinkCount);
        result.put("weightSum", weightSumAll);
        return result;
    }

    @Override
    public Map<String, Object> knowledgePriority(List<Long> paperIds, Long subjectId, Long deptId)
    {
        return knowledgePriority(paperIds, subjectId, deptId, "papers");
    }

    @Override
    public Map<String, Object> knowledgePriority(List<Long> paperIds, Long subjectId, Long deptId, String masteryScope)
    {
        if (paperIds == null || paperIds.isEmpty())
        {
            throw new ServiceException("请至少选择一份试卷");
        }
        if (paperIds.size() > knowledgeStatQueryService.getScopeMaxPapers())
        {
            throw new ServiceException("一次最多选择 " + knowledgeStatQueryService.getScopeMaxPapers() + " 份试卷");
        }
        List<Long> ids = new ArrayList<Long>();
        for (Long paperId : paperIds)
        {
            if (paperId == null)
            {
                continue;
            }
            SpasPaper paper = paperMapper.selectSpasPaperById(paperId);
            if (paper == null)
            {
                throw new ServiceException("试卷不存在：" + paperId);
            }
            accessService.checkDeptAccess(paper.getDeptId());
            ids.add(paperId);
        }
        if (ids.isEmpty())
        {
            throw new ServiceException("请至少选择一份试卷");
        }
        if (deptId != null)
        {
            accessService.checkClassAnalysisDept(deptId);
        }
        boolean usePapersMastery = masteryScope == null || "papers".equalsIgnoreCase(masteryScope.trim());
        List<Map<String, Object>> rows;
        String masteryMode;
        if (usePapersMastery)
        {
            masteryMode = "papers";
            rows = analysisMapper.selectKnowledgeFrequency(ids, subjectId);
            if (rows == null)
            {
                rows = new ArrayList<Map<String, Object>>();
            }
            Map<Long, Double> mastery = knowledgeStatQueryService.masteryAvgByPapers(ids, subjectId, deptId);
            Map<Long, Double> attempts = knowledgeStatQueryService.attemptAvgByPapers(ids, subjectId, deptId);
            for (Map<String, Object> row : rows)
            {
                Long kid = toLongObj(row.get("knowledgeId"));
                if (kid == null)
                {
                    continue;
                }
                Double avgRate = mastery.get(kid);
                Double attemptAvg = attempts.get(kid);
                row.put("avgRate", avgRate);
                row.put("attemptAvg", attemptAvg == null ? 0 : attemptAvg);
                row.put("masteryScope", "papers");
            }
        }
        else
        {
            masteryMode = "snapshot";
            rows = analysisMapper.selectKnowledgePriority(ids, subjectId, deptId);
            if (rows == null)
            {
                rows = new ArrayList<Map<String, Object>>();
            }
            for (Map<String, Object> row : rows)
            {
                row.put("masteryScope", "snapshot");
            }
        }
        int priorityCount = 0;
        int solidCount = 0;
        int lowEvidence = 0;
        for (Map<String, Object> row : rows)
        {
            int qCount = toInt(row.get("questionCount"));
            int attemptAvg = (int) Math.round(toDouble(row.get("attemptAvg")));
            Double avgRate = toDoubleObj(row.get("avgRate"));
            String quadrant = classifyPriorityQuadrant(qCount, avgRate, attemptAvg);
            row.put("quadrant", quadrant);
            row.put("attemptAvg", attemptAvg);
            row.put("confidence", knowledgeStatCalculator.confidence(attemptAvg));
            row.put("confidenceLabel", confidenceLabel(attemptAvg));
            if ("priority".equals(quadrant))
            {
                priorityCount++;
            }
            else if ("solid".equals(quadrant))
            {
                solidCount++;
            }
            else if ("low_evidence".equals(quadrant))
            {
                lowEvidence++;
            }
        }
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("items", rows);
        result.put("paperCount", ids.size());
        result.put("knowledgeCount", rows.size());
        result.put("priorityCount", priorityCount);
        result.put("solidCount", solidCount);
        result.put("lowEvidenceCount", lowEvidence);
        result.put("thresholds", priorityThresholds());
        result.put("masteryScope", masteryMode);
        return result;
    }

    private List<Long> normalizePaperIds(List<Long> paperIds)
    {
        if (paperIds == null || paperIds.isEmpty())
        {
            return null;
        }
        List<Long> ids = new ArrayList<Long>();
        for (Long id : paperIds)
        {
            if (id != null)
            {
                ids.add(id);
            }
        }
        if (ids.isEmpty())
        {
            return null;
        }
        if (ids.size() > knowledgeStatQueryService.getScopeMaxPapers())
        {
            throw new ServiceException("一次最多选择 " + knowledgeStatQueryService.getScopeMaxPapers() + " 份试卷");
        }
        return ids;
    }

    private Long toLongObj(Object v)
    {
        if (v == null)
        {
            return null;
        }
        try
        {
            return Long.valueOf(v.toString());
        }
        catch (Exception e)
        {
            return null;
        }
    }

    private Map<String, Object> priorityThresholds()
    {
        Map<String, Object> t = new HashMap<String, Object>();
        t.put("questionMin", priorityQuestionMin);
        t.put("weakRate", priorityWeakRate);
        t.put("solidRate", prioritySolidRate);
        t.put("attemptMid", attemptMid);
        t.put("attemptHigh", attemptHigh);
        return t;
    }

    private String classifyPriorityQuadrant(int questionCount, Double avgRate, int attemptAvg)
    {
        if (attemptAvg < attemptMid || avgRate == null)
        {
            return "low_evidence";
        }
        if (questionCount >= priorityQuestionMin && avgRate < priorityWeakRate)
        {
            return "priority";
        }
        if (questionCount >= priorityQuestionMin && avgRate >= prioritySolidRate)
        {
            return "solid";
        }
        return "watch";
    }

    private String confidenceLabel(int attempts)
    {
        if (attempts < attemptMid)
        {
            return "样本不足";
        }
        if (attempts < attemptHigh)
        {
            return "中";
        }
        return "高";
    }

    private Double toDoubleObj(Object v)
    {
        if (v == null)
        {
            return null;
        }
        try
        {
            return Double.parseDouble(v.toString());
        }
        catch (Exception e)
        {
            return null;
        }
    }
}
