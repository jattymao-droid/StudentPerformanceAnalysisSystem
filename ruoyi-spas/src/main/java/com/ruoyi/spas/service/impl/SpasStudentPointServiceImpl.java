package com.ruoyi.spas.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasExam;
import com.ruoyi.spas.domain.SpasExamScore;
import com.ruoyi.spas.domain.SpasPracticeLog;
import com.ruoyi.spas.domain.SpasPracticeLogKnowledge;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.domain.SpasStudentPointAccount;
import com.ruoyi.spas.domain.SpasStudentPointLedger;
import com.ruoyi.spas.domain.SpasStudentKnowledgeStat;
import com.ruoyi.spas.mapper.SpasAnalysisMapper;
import com.ruoyi.spas.mapper.SpasExamScoreMapper;
import com.ruoyi.spas.mapper.SpasPracticeLogMapper;
import com.ruoyi.spas.mapper.SpasStudentMapper;
import com.ruoyi.spas.mapper.SpasStudentPointMapper;
import com.ruoyi.spas.service.ISpasStudentPointService;
import com.ruoyi.spas.support.SpasAccessService;

@Service
public class SpasStudentPointServiceImpl implements ISpasStudentPointService
{
    public static final int POINTS_DAY = 10;
    public static final int POINTS_EXTRA = 3;
    public static final int EXTRA_CAP = 2;
    public static final int POINTS_WEAK = 5;
    public static final int STREAK_UNIT = 2;
    public static final int STREAK_CAP_DAYS = 7;
    public static final int POINTS_MASTERY = 15;
    public static final double MASTERY_DELTA = 0.05d;
    public static final int MASTERY_WINDOW_DAYS = 14;
    public static final int DAILY_CAP = 40;
    public static final int LEVEL_STEP = 50;
    /** 成长农场阶段阈值（累计积分；与三角等级 Lv 独立，50/150 恰与 Lv2/Lv3 起点重合） */
    public static final int FARM_SEEDLING = 15;
    public static final int FARM_SAPLING = 50;
    public static final int FARM_TREE = 150;
    /** 教师批量奖励：每人单次上限 */
    public static final int TEACHER_AWARD_MAX = 20;
    /** 教师批量奖励：单次最多人数 */
    public static final int TEACHER_AWARD_MAX_STUDENTS = 80;

    @Autowired
    private SpasStudentPointMapper pointMapper;

    @Autowired
    private SpasPracticeLogMapper practiceMapper;

    @Autowired
    private SpasStudentMapper studentMapper;

    @Autowired
    private SpasAnalysisMapper analysisMapper;

    @Autowired
    private SpasAccessService accessService;

    @Autowired
    private SpasExamScoreMapper examScoreMapper;

    @Override
    @Transactional
    public int awardForPracticeLog(SpasPracticeLog log, boolean proxyConfirmed)
    {
        if (log == null || log.getLogId() == null || log.getStudentId() == null)
        {
            return 0;
        }
        boolean proxy = "1".equals(log.getProxyFlag());
        if (proxy && !proxyConfirmed)
        {
            return 0;
        }
        double factor = proxy ? 0.5d : 1.0d;
        Date day = normalizeDay(log.getPracticeDate());
        String dayStr = DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD, day);
        Long studentId = log.getStudentId();
        Long subjectId = log.getSubjectId();
        Long deptId = log.getDeptId();

        int awarded = 0;
        int logsOnDay = pointMapper.countLogsOnDay(studentId, subjectId, day);
        // count includes current log after insert
        boolean firstOfDay = logsOnDay <= 1;

        if (firstOfDay)
        {
            SpasStudentPointAccount acc = ensureAccount(studentId);
            int streak = nextStreak(acc, day);
            int streakBonus = streak >= 2 ? STREAK_UNIT * Math.min(streak, STREAK_CAP_DAYS) : 0;
            int base = scale(POINTS_DAY + streakBonus, factor);
            String biz = "PRACTICE_DAY:" + studentId + ":" + subjectId + ":" + dayStr;
            awarded += credit(studentId, deptId, subjectId, base, "PRACTICE_DAY", "practice",
                String.valueOf(log.getLogId()), biz,
                streakBonus > 0 ? ("首条打卡+" + streakBonus + "连击") : "当日首条打卡", day, streak);
        }
        else
        {
            int extras = pointMapper.countReasonToday(studentId, "PRACTICE_EXTRA", day, subjectId);
            if (extras < EXTRA_CAP)
            {
                int pts = scale(POINTS_EXTRA, factor);
                String biz = "PRACTICE_EXTRA:" + log.getLogId();
                awarded += credit(studentId, deptId, subjectId, pts, "PRACTICE_EXTRA", "practice",
                    String.valueOf(log.getLogId()), biz, "同日额外打卡", day, null);
            }
        }

        return awarded;
    }

    @Override
    @Transactional
    public int awardCheckoutAck(Long studentId, Long deptId, Long subjectId, Long itemId, String finishStatus)
    {
        if (studentId == null || itemId == null)
        {
            return 0;
        }
        if (!"1".equals(finishStatus) && !"2".equals(finishStatus) && !"3".equals(finishStatus))
        {
            return 0;
        }
        int pts = "3".equals(finishStatus) ? 8 : 10;
        Date day = normalizeDay(new Date());
        String remark = "3".equals(finishStatus) ? "检查确认·有困难（如实上报）" : "检查确认属实";
        return credit(studentId, deptId, subjectId, pts, "CHECKOUT_ACK", "checkout",
            String.valueOf(itemId), "CHECKOUT_ACK:" + itemId, remark, day, null);
    }

    @Override
    @Transactional
    public int awardCheckoutSubmit(Long leaderStudentId, Long deptId, Long subjectId, Long checkoutId)
    {
        if (leaderStudentId == null || checkoutId == null)
        {
            return 0;
        }
        Date day = normalizeDay(new Date());
        return credit(leaderStudentId, deptId, subjectId, 5, "CHECKOUT_SUBMIT", "checkout",
            String.valueOf(checkoutId), "CHECKOUT_SUBMIT:" + checkoutId, "按时提交本组检查单", day, null);
    }

    @Override
    @Transactional
    public int awardCheckoutSpotMatch(Long studentId, Long deptId, Long subjectId, Long itemId)
    {
        if (studentId == null || itemId == null)
        {
            return 0;
        }
        Date day = normalizeDay(new Date());
        return credit(studentId, deptId, subjectId, 5, "CHECKOUT_SPOT", "checkout",
            String.valueOf(itemId), "CHECKOUT_SPOT:" + itemId, "抽检一致", day, null);
    }

    @Override
    @Transactional
    public int clawbackCheckoutAck(Long studentId, Long deptId, Long subjectId, Long itemId)
    {
        if (studentId == null || itemId == null)
        {
            return 0;
        }
        String ackKey = "CHECKOUT_ACK:" + itemId;
        SpasStudentPointLedger awarded = pointMapper.selectLedgerByBizKey(ackKey);
        if (awarded == null || awarded.getPoints() == null || awarded.getPoints().intValue() <= 0)
        {
            return 0;
        }
        String voidKey = "CHECKOUT_ACK_VOID:" + itemId;
        if (pointMapper.selectLedgerByBizKey(voidKey) != null)
        {
            return 0;
        }
        int pts = awarded.getPoints().intValue();
        Date day = normalizeDay(new Date());
        return debit(studentId, deptId != null ? deptId : awarded.getDeptId(),
            subjectId != null ? subjectId : awarded.getSubjectId(), pts, "CHECKOUT_ACK_VOID", "checkout",
            String.valueOf(itemId), voidKey, "抽检偏松·扣回确认积分", day);
    }

    @Override
    public Map<String, Double> snapshotRates(Collection<Long> studentIds)
    {
        Map<String, Double> map = new HashMap<String, Double>();
        List<Long> ids = distinctIds(studentIds);
        if (ids.isEmpty())
        {
            return map;
        }
        List<Map<String, Object>> rows = pointMapper.selectRatesByStudents(ids);
        if (rows == null)
        {
            return map;
        }
        for (Map<String, Object> row : rows)
        {
            Long sid = toLong(row.get("studentId"));
            Long kid = toLong(row.get("knowledgeId"));
            Double rate = toDouble(row.get("avgRate"));
            if (sid != null && kid != null && rate != null)
            {
                map.put(sid + ":" + kid, rate);
            }
        }
        return map;
    }

    @Override
    @Transactional
    public int awardMasteryGains(Collection<Long> studentIds, Map<String, Double> beforeRates)
    {
        List<Long> ids = distinctIds(studentIds);
        if (ids.isEmpty() || beforeRates == null || beforeRates.isEmpty())
        {
            return 0;
        }
        Map<String, Double> after = snapshotRates(ids);
        Date today = normalizeDay(new Date());
        Calendar cal = Calendar.getInstance();
        cal.setTime(today);
        cal.add(Calendar.DATE, -(MASTERY_WINDOW_DAYS - 1));
        Date begin = normalizeDay(cal.getTime());
        // 14-day window key: floor day-of-epoch / 14
        long window = today.getTime() / (86400000L * MASTERY_WINDOW_DAYS);

        int awarded = 0;
        for (Long studentId : ids)
        {
            List<Long> practiced = pointMapper.selectPracticedKnowledgeIds(studentId, begin, today);
            if (practiced == null || practiced.isEmpty())
            {
                continue;
            }
            SpasStudent student = studentMapper.selectSpasStudentById(studentId);
            Long deptId = student == null ? null : student.getDeptId();
            Set<Long> set = new HashSet<Long>(practiced);
            for (Long kid : set)
            {
                String key = studentId + ":" + kid;
                Double prev = beforeRates.get(key);
                Double now = after.get(key);
                if (prev == null || now == null)
                {
                    continue;
                }
                if (now - prev + 1e-9 < MASTERY_DELTA)
                {
                    continue;
                }
                String biz = "MASTERY_UP:" + studentId + ":" + kid + ":" + window;
                int pts = credit(studentId, deptId, null, POINTS_MASTERY, "MASTERY_UP", "knowledge",
                    String.valueOf(kid), biz,
                    "掌握度+" + String.format("%.0f", (now - prev) * 100) + "%", today, null);
                awarded += pts;
            }
        }
        return awarded;
    }

    /**
     * 实考班级名次赋分：按本场导入学生人数 N，班级第 r 名得 (N-r+1) 分。
     * 同分并列（竞赛名次），均不计入日封顶。覆盖重导时先冲销再发。
     */
    @Override
    @Transactional
    public int syncExamClassRankPoints(Long examId)
    {
        if (examId == null)
        {
            return 0;
        }
        SpasExam exam = examScoreMapper.selectSpasExamById(examId);
        if (exam == null || exam.getDeptId() == null)
        {
            return 0;
        }
        Long deptId = exam.getDeptId();
        revokeExamClassRankPoints(examId, deptId);

        return awardExamClassRankPoints(exam, deptId);
    }

    @Override
    @Transactional
    public int clearExamClassRankPoints(Long examId)
    {
        if (examId == null)
        {
            return 0;
        }
        SpasExam exam = examScoreMapper.selectSpasExamById(examId);
        Long deptId = exam != null ? exam.getDeptId() : null;
        return revokeExamClassRankPoints(examId, deptId);
    }

    private int awardExamClassRankPoints(SpasExam exam, Long deptId)
    {
        Long examId = exam.getExamId();
        List<SpasExamScore> scores = examScoreMapper.selectScoresByExamId(examId);
        if (scores == null || scores.isEmpty())
        {
            return 0;
        }
        Map<Long, ExamRankMetric> metrics = buildExamRankMetrics(scores);
        if (metrics.isEmpty())
        {
            return 0;
        }
        List<ExamRankMetric> ordered = new ArrayList<ExamRankMetric>(metrics.values());
        Collections.sort(ordered, new Comparator<ExamRankMetric>()
        {
            @Override
            public int compare(ExamRankMetric a, ExamRankMetric b)
            {
                int c = Double.compare(b.sortScore, a.sortScore);
                if (c != 0)
                {
                    return c;
                }
                // 同分时学号/ID 稳定排序，便于并列名次计算
                if (a.studentNo != null && b.studentNo != null)
                {
                    int n = a.studentNo.compareTo(b.studentNo);
                    if (n != 0)
                    {
                        return n;
                    }
                }
                return Long.compare(a.studentId, b.studentId);
            }
        });

        // 批次后缀保证覆盖重导时可再次发放（旧正向流水 biz_key 仍保留作审计）
        String batch = String.valueOf(System.currentTimeMillis());
        int n = ordered.size();
        int awarded = 0;
        int i = 0;
        while (i < n)
        {
            int j = i + 1;
            while (j < n && nearlySameScore(ordered.get(i).sortScore, ordered.get(j).sortScore))
            {
                j++;
            }
            // 竞赛名次：并列段起点为当前名次
            int classRank = i + 1;
            int pts = Math.max(1, n - classRank + 1);
            for (int k = i; k < j; k++)
            {
                ExamRankMetric m = ordered.get(k);
                String biz = "EXAM_CLASS_RANK:" + examId + ":" + m.studentId + ":" + batch;
                String remark = "考试「" + safeExamName(exam) + "」班级第" + classRank + "名/"
                    + n + "人，+" + pts;
                awarded += credit(m.studentId, deptId, null, pts, "EXAM_CLASS_RANK", "exam",
                    String.valueOf(examId), biz, remark, null, null, false);
            }
            i = j;
        }
        return awarded;
    }

    private int revokeExamClassRankPoints(Long examId, Long deptId)
    {
        List<SpasStudentPointLedger> old = pointMapper.selectExamClassRankLedgers(examId);
        if (old == null || old.isEmpty())
        {
            return 0;
        }
        int cleared = 0;
        for (SpasStudentPointLedger row : old)
        {
            if (row.getPoints() == null || row.getPoints().intValue() <= 0)
            {
                continue;
            }
            String voidBiz = "EXAM_CLASS_RANK_VOID:" + examId + ":" + row.getStudentId() + ":" + row.getLedgerId();
            cleared += debit(row.getStudentId(), deptId != null ? deptId : row.getDeptId(), row.getSubjectId(),
                row.getPoints().intValue(), "EXAM_CLASS_RANK_VOID", "exam", String.valueOf(examId),
                voidBiz, "考试名次积分冲销", null);
        }
        return cleared;
    }

    /**
     * 整场考试只用一种可比指标，禁止「分数」与「1e6-校次」混排。
     * 优先：全员总分 → 总分校次 → 科目分合计 → 最佳单科校次。
     */
    private Map<Long, ExamRankMetric> buildExamRankMetrics(List<SpasExamScore> scores)
    {
        Map<Long, ExamRankMetric> map = new HashMap<Long, ExamRankMetric>();
        for (SpasExamScore s : scores)
        {
            if (s == null || s.getStudentId() == null)
            {
                continue;
            }
            ExamRankMetric m = map.get(s.getStudentId());
            if (m == null)
            {
                m = new ExamRankMetric();
                m.studentId = s.getStudentId();
                m.studentNo = s.getStudentNo();
                map.put(s.getStudentId(), m);
            }
            if (SpasExamScore.TYPE_TOTAL.equals(s.getScoreType()))
            {
                if (s.getScore() != null)
                {
                    m.totalScore = s.getScore();
                }
                if (s.getSchoolRank() != null)
                {
                    m.totalSchoolRank = s.getSchoolRank();
                }
            }
            else if (SpasExamScore.TYPE_SUBJECT.equals(s.getScoreType()))
            {
                if (s.getScore() != null)
                {
                    m.subjectScoreSum = m.subjectScoreSum.add(s.getScore());
                    m.subjectScoreCount++;
                }
                if (s.getSchoolRank() != null)
                {
                    if (m.bestSubjectRank == null || s.getSchoolRank().intValue() < m.bestSubjectRank.intValue())
                    {
                        m.bestSubjectRank = s.getSchoolRank();
                    }
                }
            }
        }
        int mode = pickExamRankMode(map.values());
        Map<Long, ExamRankMetric> usable = new HashMap<Long, ExamRankMetric>();
        for (ExamRankMetric m : map.values())
        {
            if (m.applyMode(mode))
            {
                usable.put(m.studentId, m);
            }
        }
        return usable;
    }

    /** 0总分 1总分校次 2科目合计 3最佳单科校次；整场统一 */
    private static int pickExamRankMode(Collection<ExamRankMetric> all)
    {
        int totalScore = 0;
        int totalRank = 0;
        int subjectSum = 0;
        int subjectRank = 0;
        for (ExamRankMetric m : all)
        {
            if (m.totalScore != null)
            {
                totalScore++;
            }
            if (m.totalSchoolRank != null && m.totalSchoolRank.intValue() > 0)
            {
                totalRank++;
            }
            if (m.subjectScoreCount > 0)
            {
                subjectSum++;
            }
            if (m.bestSubjectRank != null && m.bestSubjectRank.intValue() > 0)
            {
                subjectRank++;
            }
        }
        if (totalScore > 0)
        {
            return 0;
        }
        if (totalRank > 0)
        {
            return 1;
        }
        if (subjectSum > 0)
        {
            return 2;
        }
        if (subjectRank > 0)
        {
            return 3;
        }
        return -1;
    }

    private static boolean nearlySameScore(double a, double b)
    {
        return Math.abs(a - b) < 1e-6;
    }

    private static String safeExamName(SpasExam exam)
    {
        if (exam == null || StringUtils.isEmpty(exam.getExamName()))
        {
            return "考试";
        }
        String name = exam.getExamName().trim();
        return name.length() > 24 ? name.substring(0, 24) + "…" : name;
    }

    /** 班级名次排序指标：整场统一模式，越大越好 */
    private static final class ExamRankMetric
    {
        Long studentId;
        String studentNo;
        BigDecimal totalScore;
        Integer totalSchoolRank;
        BigDecimal subjectScoreSum = BigDecimal.ZERO;
        int subjectScoreCount;
        Integer bestSubjectRank;
        double sortScore;

        boolean applyMode(int mode)
        {
            if (mode == 0 && totalScore != null)
            {
                sortScore = totalScore.doubleValue();
                return true;
            }
            if (mode == 1 && totalSchoolRank != null && totalSchoolRank.intValue() > 0)
            {
                // 校次越小越好 → 统一映射为降序分（仅在本模式内互比）
                sortScore = 1_000_000d - totalSchoolRank.doubleValue();
                return true;
            }
            if (mode == 2 && subjectScoreCount > 0)
            {
                sortScore = subjectScoreSum.doubleValue();
                return true;
            }
            if (mode == 3 && bestSubjectRank != null && bestSubjectRank.intValue() > 0)
            {
                sortScore = 1_000_000d - bestSubjectRank.doubleValue();
                return true;
            }
            return false;
        }
    }

    @Override
    public Map<String, Object> getMine()
    {
        SpasStudent self = requireLoginStudent();
        SpasStudentPointAccount acc = enrich(ensureAccount(self.getStudentId()));
        acc.setTodayPoints(Integer.valueOf(pointMapper.sumPointsToday(self.getStudentId(), normalizeDay(new Date()))));
        Date weekStart = mondayOf(normalizeDay(new Date()));
        Integer weekRank = pointMapper.selectRankWeek(self.getDeptId(), weekStart, self.getStudentId());
        Integer allRank = pointMapper.selectRankAll(self.getDeptId(), self.getStudentId());
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("account", acc);
        data.put("weekRank", weekRank);
        data.put("allRank", allRank);
        data.put("deptId", self.getDeptId());
        data.put("studentId", self.getStudentId());
        data.put("studentName", self.getStudentName());
        data.put("farmThresholds", farmThresholdsMap());
        return data;
    }

    @Override
    public List<SpasStudentPointLedger> getMyLedger(Integer limit)
    {
        SpasStudent self = requireLoginStudent();
        int lim = limit == null || limit.intValue() <= 0 ? 30 : Math.min(limit.intValue(), 100);
        List<SpasStudentPointLedger> list = pointMapper.selectLedgerByStudent(self.getStudentId(), Integer.valueOf(lim));
        if (list != null)
        {
            for (SpasStudentPointLedger row : list)
            {
                row.setReasonLabel(labelOf(row.getReasonCode()));
            }
        }
        return list == null ? new ArrayList<SpasStudentPointLedger>() : list;
    }

    @Override
    public Map<String, Object> getLeaderboard(Long deptId, Long subjectId, String range, Integer limit)
    {
        SpasStudent self = currentStudentOrNull();
        if (self != null)
        {
            deptId = self.getDeptId();
        }
        else
        {
            if (deptId == null)
            {
                throw new ServiceException("请指定班级");
            }
            accessService.checkDeptAccess(deptId);
        }
        int lim = limit == null || limit.intValue() <= 0 ? 20 : Math.min(limit.intValue(), 50);
        boolean week = range == null || "week".equalsIgnoreCase(range);
        Date weekStart = mondayOf(normalizeDay(new Date()));
        List<SpasStudentPointAccount> rows = week
            ? pointMapper.selectLeaderboardWeek(deptId, weekStart, Integer.valueOf(lim))
            : pointMapper.selectLeaderboardAll(deptId, Integer.valueOf(lim));
        if (rows != null)
        {
            for (SpasStudentPointAccount a : rows)
            {
                enrich(a);
            }
        }
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("range", week ? "week" : "all");
        data.put("weekStart", DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD, weekStart));
        data.put("deptId", deptId);
        data.put("list", rows == null ? new ArrayList<SpasStudentPointAccount>() : rows);
        if (self != null)
        {
            Integer myRank = week
                ? pointMapper.selectRankWeek(deptId, weekStart, self.getStudentId())
                : pointMapper.selectRankAll(deptId, self.getStudentId());
            data.put("myRank", myRank);
            data.put("myStudentId", self.getStudentId());
        }
        return data;
    }

    @Override
    public Map<String, Object> getClassFarm(Long deptId)
    {
        SpasStudent self = currentStudentOrNull();
        if (self != null)
        {
            deptId = self.getDeptId();
        }
        else
        {
            if (deptId == null)
            {
                throw new ServiceException("请指定班级");
            }
            accessService.checkDeptAccess(deptId);
        }
        List<SpasStudentPointAccount> rows = pointMapper.selectClassFarm(deptId);
        if (rows != null)
        {
            for (SpasStudentPointAccount a : rows)
            {
                enrich(a);
            }
        }
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("deptId", deptId);
        data.put("list", rows == null ? new ArrayList<SpasStudentPointAccount>() : rows);
        data.put("farmThresholds", farmThresholdsMap());
        if (self != null)
        {
            data.put("myStudentId", self.getStudentId());
            data.put("deptName", self.getDeptName());
        }
        return data;
    }

    /** 演示积分阶梯：覆盖萌芽→浮叶→花蕾→盛放 */
    private static final int[] FARM_DEMO_POINTS = new int[] {
        0, 8, 15, 28, 49, 50, 80, 120, 149, 150, 200, 280
    };

    @Override
    @Transactional
    public Map<String, Object> seedFarmGrowthDemo(Long deptId)
    {
        SpasStudent self = currentStudentOrNull();
        if (self != null)
        {
            deptId = self.getDeptId();
        }
        else
        {
            if (deptId == null)
            {
                throw new ServiceException("请指定班级");
            }
            accessService.checkDeptAccess(deptId);
        }
        List<SpasStudentPointAccount> roster = pointMapper.selectClassFarm(deptId);
        if (roster == null || roster.isEmpty())
        {
            throw new ServiceException("该班暂无学生，无法写入农场演示数据");
        }
        Date weekStart = mondayOf(normalizeDay(new Date()));
        int updated = 0;
        Map<String, Integer> stageCount = new HashMap<String, Integer>();
        stageCount.put("seed", Integer.valueOf(0));
        stageCount.put("seedling", Integer.valueOf(0));
        stageCount.put("sapling", Integer.valueOf(0));
        stageCount.put("tree", Integer.valueOf(0));
        for (int i = 0; i < roster.size(); i++)
        {
            SpasStudentPointAccount row = roster.get(i);
            Long studentId = row.getStudentId();
            if (studentId == null)
            {
                continue;
            }
            int pts = FARM_DEMO_POINTS[i % FARM_DEMO_POINTS.length];
            int lv = levelOf(pts);
            SpasStudentPointAccount acc = new SpasStudentPointAccount();
            acc.setStudentId(studentId);
            acc.setTotalPoints(Integer.valueOf(pts));
            acc.setLevelNo(Integer.valueOf(lv));
            acc.setDayStreak(Integer.valueOf(pts >= FARM_SEEDLING ? 3 : 0));
            if (pts > 0)
            {
                Calendar cal = Calendar.getInstance();
                cal.setTime(normalizeDay(new Date()));
                cal.add(Calendar.DATE, -(i % 3));
                acc.setLastPracticeDate(cal.getTime());
            }
            acc.setWeekPoints(Integer.valueOf(Math.min(pts, DAILY_CAP)));
            acc.setWeekStart(weekStart);
            pointMapper.upsertAccount(acc);

            String biz = "FARM_DEMO:" + studentId;
            if (pointMapper.selectLedgerByBizKey(biz) == null && pts > 0)
            {
                SpasStudentPointLedger led = new SpasStudentPointLedger();
                led.setStudentId(studentId);
                led.setDeptId(deptId);
                led.setPoints(Integer.valueOf(pts));
                led.setReasonCode("FARM_DEMO");
                led.setRefType("demo");
                led.setRefId("farm_growth");
                led.setBizKey(biz);
                String stage = farmStageOf(pts);
                led.setRemark("农场生长演示 · " + farmStageLabelOf(stage));
                pointMapper.insertLedger(led);
            }
            else if (pts == 0)
            {
                // keep zero accounts without ledger
            }
            String stage = farmStageOf(pts);
            stageCount.put(stage, Integer.valueOf(stageCount.get(stage).intValue() + 1));
            updated++;
        }
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("deptId", deptId);
        data.put("updated", Integer.valueOf(updated));
        data.put("stageCount", stageCount);
        data.put("thresholds", farmThresholdsMap());
        data.put("hint", "刷新一体机「农场」可见萌芽/浮叶/花蕾/盛放混排");
        return data;
    }

    @Override
    @Transactional
    public Map<String, Object> awardTeacherBatch(Long deptId, Long subjectId, List<Long> studentIds,
        int points, String remark, String batchId)
    {
        if (deptId == null)
        {
            throw new ServiceException("请指定班级");
        }
        accessService.checkDeptAccess(deptId);
        if (points < 1 || points > TEACHER_AWARD_MAX)
        {
            throw new ServiceException("每人可发 1～" + TEACHER_AWARD_MAX + " 分");
        }
        List<Long> ids = distinctIds(studentIds);
        if (ids.isEmpty())
        {
            throw new ServiceException("请选择学生");
        }
        if (ids.size() > TEACHER_AWARD_MAX_STUDENTS)
        {
            throw new ServiceException("单次最多选择 " + TEACHER_AWARD_MAX_STUDENTS + " 人");
        }
        // biz_key = TEACHER_AWARD:{batch}:{studentId} ≤ 120；batch 限 40 安全字符
        String batch = StringUtils.isNotEmpty(batchId) ? batchId.trim() : java.util.UUID.randomUUID().toString().replace("-", "");
        batch = batch.replaceAll("[^A-Za-z0-9_-]", "");
        if (StringUtils.isEmpty(batch))
        {
            batch = java.util.UUID.randomUUID().toString().replace("-", "");
        }
        if (batch.length() > 40)
        {
            batch = batch.substring(0, 40);
        }
        String finalRemark = StringUtils.isEmpty(remark) ? "教师奖励" : remark.trim();
        if (finalRemark.length() > 180)
        {
            finalRemark = finalRemark.substring(0, 180);
        }
        Long operatorId = SecurityUtils.getUserId();
        String refId = operatorId == null ? "0" : String.valueOf(operatorId);

        List<Map<String, Object>> results = new ArrayList<Map<String, Object>>();
        int awardedTotal = 0;
        int successCount = 0;
        int cappedCount = 0;
        int skippedCount = 0;

        for (Long sid : ids)
        {
            Map<String, Object> row = new HashMap<String, Object>();
            row.put("studentId", sid);
            SpasStudent st = studentMapper.selectSpasStudentById(sid);
            if (st == null || st.getDeptId() == null || !deptId.equals(st.getDeptId()))
            {
                row.put("awardedPoints", Integer.valueOf(0));
                row.put("status", "skipped");
                row.put("message", "非本班学生或不存在");
                results.add(row);
                skippedCount++;
                continue;
            }
            row.put("studentName", st.getStudentName());
            ensureAccount(sid);
            String bizKey = "TEACHER_AWARD:" + batch + ":" + sid;
            int got = credit(sid, deptId, subjectId, points, "TEACHER_AWARD", "teacher",
                refId, bizKey, finalRemark, null, null, true);
            row.put("awardedPoints", Integer.valueOf(got));
            if (got > 0)
            {
                row.put("status", "ok");
                awardedTotal += got;
                successCount++;
                if (got < points)
                {
                    row.put("status", "capped");
                    row.put("message", "触及日封顶，实发 " + got);
                    cappedCount++;
                }
            }
            else if (pointMapper.selectLedgerByBizKey(bizKey) != null)
            {
                // 已有流水：可能是幂等重放，或日封顶记 0
                SpasStudentPointLedger existed = pointMapper.selectLedgerByBizKey(bizKey);
                int existedPts = existed != null && existed.getPoints() != null ? existed.getPoints().intValue() : 0;
                if (existedPts > 0)
                {
                    row.put("status", "duplicate");
                    row.put("message", "本批次已发过");
                    row.put("awardedPoints", Integer.valueOf(0));
                    skippedCount++;
                }
                else
                {
                    row.put("status", "capped");
                    row.put("message", "日封顶，记 0 分");
                    cappedCount++;
                }
            }
            else
            {
                row.put("status", "skipped");
                row.put("message", "未发放");
                skippedCount++;
            }
            results.add(row);
        }

        Map<String, Object> data = new HashMap<String, Object>();
        data.put("batchId", batch);
        data.put("pointsPerStudent", Integer.valueOf(points));
        data.put("awardedTotal", Integer.valueOf(awardedTotal));
        data.put("successCount", Integer.valueOf(successCount));
        data.put("cappedCount", Integer.valueOf(cappedCount));
        data.put("skippedCount", Integer.valueOf(skippedCount));
        data.put("results", results);
        return data;
    }

    @Override
    public SpasStudentPointAccount ensureAccount(Long studentId)
    {
        SpasStudentPointAccount acc = pointMapper.selectAccount(studentId);
        if (acc != null)
        {
            Date weekStart = mondayOf(normalizeDay(new Date()));
            if (acc.getWeekStart() == null || !sameDay(acc.getWeekStart(), weekStart))
            {
                acc.setWeekStart(weekStart);
                acc.setWeekPoints(Integer.valueOf(0));
                pointMapper.upsertAccount(acc);
            }
            return acc;
        }
        acc = new SpasStudentPointAccount();
        acc.setStudentId(studentId);
        acc.setTotalPoints(Integer.valueOf(0));
        acc.setLevelNo(Integer.valueOf(1));
        acc.setDayStreak(Integer.valueOf(0));
        acc.setWeekPoints(Integer.valueOf(0));
        acc.setWeekStart(mondayOf(normalizeDay(new Date())));
        pointMapper.upsertAccount(acc);
        return acc;
    }

    private int credit(Long studentId, Long deptId, Long subjectId, int rawPoints, String reason,
        String refType, String refId, String bizKey, String remark, Date practiceDay, Integer streakOverride)
    {
        return credit(studentId, deptId, subjectId, rawPoints, reason, refType, refId, bizKey, remark,
            practiceDay, streakOverride, true);
    }

    private int credit(Long studentId, Long deptId, Long subjectId, int rawPoints, String reason,
        String refType, String refId, String bizKey, String remark, Date practiceDay, Integer streakOverride,
        boolean applyDailyCap)
    {
        if (rawPoints <= 0 || StringUtils.isEmpty(bizKey))
        {
            return 0;
        }
        if (pointMapper.selectLedgerByBizKey(bizKey) != null)
        {
            return 0;
        }
        Date today = normalizeDay(new Date());
        int points = rawPoints;
        String finalRemark = remark;
        boolean cappedToZero = false;
        if (applyDailyCap)
        {
            // 考试名次分不计入封顶预算，避免挤占日常激励
            int earnedToday = pointMapper.sumCapPointsToday(studentId, today);
            int remain = Math.max(0, DAILY_CAP - earnedToday);
            points = Math.min(rawPoints, remain);
            if (points < rawPoints)
            {
                finalRemark = (remark == null ? "" : remark + "；") + "日封顶" + DAILY_CAP + "，原+" + rawPoints;
            }
            if (points <= 0 && rawPoints > 0)
            {
                cappedToZero = true;
                points = 0;
                finalRemark = (remark == null ? "" : remark + "；") + "日封顶" + DAILY_CAP + "，记0分";
            }
        }
        if (points <= 0 && !cappedToZero)
        {
            return 0;
        }
        SpasStudentPointLedger ledger = new SpasStudentPointLedger();
        ledger.setStudentId(studentId);
        ledger.setDeptId(deptId);
        ledger.setSubjectId(subjectId);
        ledger.setPoints(Integer.valueOf(points));
        ledger.setReasonCode(reason);
        ledger.setRefType(refType);
        ledger.setRefId(refId);
        ledger.setBizKey(bizKey);
        ledger.setRemark(finalRemark);
        try
        {
            pointMapper.insertLedger(ledger);
        }
        catch (DuplicateKeyException ex)
        {
            return 0;
        }
        if (points == 0)
        {
            return 0;
        }

        Date weekStart = mondayOf(today);
        Date lastPractice = null;
        Integer streak = null;
        if ("PRACTICE_DAY".equals(reason) && practiceDay != null)
        {
            lastPractice = practiceDay;
            streak = streakOverride;
        }
        pointMapper.applyAccountDelta(studentId, points, weekStart, lastPractice, streak);
        return points;
    }

    /** Insert negative ledger and reduce account balances (idempotent via bizKey). */
    private int debit(Long studentId, Long deptId, Long subjectId, int rawPoints, String reason,
        String refType, String refId, String bizKey, String remark, Date practiceDay)
    {
        if (rawPoints <= 0 || StringUtils.isEmpty(bizKey))
        {
            return 0;
        }
        if (pointMapper.selectLedgerByBizKey(bizKey) != null)
        {
            return 0;
        }
        int points = -rawPoints;
        SpasStudentPointLedger ledger = new SpasStudentPointLedger();
        ledger.setStudentId(studentId);
        ledger.setDeptId(deptId);
        ledger.setSubjectId(subjectId);
        ledger.setPoints(Integer.valueOf(points));
        ledger.setReasonCode(reason);
        ledger.setRefType(refType);
        ledger.setRefId(refId);
        ledger.setBizKey(bizKey);
        ledger.setRemark(remark);
        try
        {
            pointMapper.insertLedger(ledger);
        }
        catch (DuplicateKeyException ex)
        {
            return 0;
        }

        Date weekStart = mondayOf(normalizeDay(new Date()));
        pointMapper.applyAccountDelta(studentId, points, weekStart, null, null);
        return rawPoints;
    }

    private boolean hitsWeakTop(SpasPracticeLog log)
    {
        List<SpasPracticeLogKnowledge> links = log.getKnowledgeIds() == null
            ? practiceMapper.selectKnowledgeByLogId(log.getLogId()) : null;
        Set<Long> kids = new HashSet<Long>();
        if (log.getKnowledgeIds() != null)
        {
            kids.addAll(log.getKnowledgeIds());
        }
        else if (links != null)
        {
            for (SpasPracticeLogKnowledge k : links)
            {
                if (k.getKnowledgeId() != null)
                {
                    kids.add(k.getKnowledgeId());
                }
            }
        }
        if (kids.isEmpty())
        {
            links = practiceMapper.selectKnowledgeByLogId(log.getLogId());
            if (links != null)
            {
                for (SpasPracticeLogKnowledge k : links)
                {
                    if (k.getKnowledgeId() != null)
                    {
                        kids.add(k.getKnowledgeId());
                    }
                }
            }
        }
        if (kids.isEmpty())
        {
            return false;
        }
        try
        {
            // 避免依赖 AnalysisService 造成与 KnowledgeStatCalculator 的循环注入
            List<SpasStudentKnowledgeStat> raw =
                analysisMapper.selectStudentKnowledgeStats(log.getStudentId(), log.getSubjectId());
            if (raw == null || raw.isEmpty())
            {
                return false;
            }
            List<SpasStudentKnowledgeStat> stats = new ArrayList<SpasStudentKnowledgeStat>(raw);
            int hit = 0;
            // 按掌握度升序取前 8 个薄弱/低分主题
            stats.sort((a, b) -> {
                double ra = a.getWeightedRate() != null ? a.getWeightedRate().doubleValue()
                    : (a.getAvgRate() != null ? a.getAvgRate().doubleValue() : 1d);
                double rb = b.getWeightedRate() != null ? b.getWeightedRate().doubleValue()
                    : (b.getAvgRate() != null ? b.getAvgRate().doubleValue() : 1d);
                return Double.compare(ra, rb);
            });
            for (SpasStudentKnowledgeStat st : stats)
            {
                if (hit >= 8)
                {
                    break;
                }
                hit++;
                int weakLv = 0;
                try
                {
                    weakLv = st.getWeakLevel() == null ? 0 : Integer.parseInt(String.valueOf(st.getWeakLevel()));
                }
                catch (Exception ignore)
                {
                    weakLv = 0;
                }
                double rate = st.getWeightedRate() != null ? st.getWeightedRate().doubleValue()
                    : (st.getAvgRate() != null ? st.getAvgRate().doubleValue() : 1d);
                if ((weakLv >= 1 || rate < 0.75d) && st.getKnowledgeId() != null && kids.contains(st.getKnowledgeId()))
                {
                    return true;
                }
            }
        }
        catch (Exception ignored)
        {
            return false;
        }
        return false;
    }

    private int nextStreak(SpasStudentPointAccount acc, Date practiceDay)
    {
        if (acc.getLastPracticeDate() == null)
        {
            return 1;
        }
        Date last = normalizeDay(acc.getLastPracticeDate());
        if (sameDay(last, practiceDay))
        {
            return acc.getDayStreak() == null || acc.getDayStreak().intValue() <= 0 ? 1 : acc.getDayStreak().intValue();
        }
        Calendar cal = Calendar.getInstance();
        cal.setTime(practiceDay);
        cal.add(Calendar.DATE, -1);
        Date yest = normalizeDay(cal.getTime());
        if (sameDay(last, yest))
        {
            int prev = acc.getDayStreak() == null ? 0 : acc.getDayStreak().intValue();
            return prev + 1;
        }
        return 1;
    }

    private SpasStudentPointAccount enrich(SpasStudentPointAccount acc)
    {
        int total = acc.getTotalPoints() == null ? 0 : acc.getTotalPoints().intValue();
        int level = levelOf(total);
        acc.setLevelNo(Integer.valueOf(level));
        int min = pointsForLevel(level);
        int max = pointsForLevel(level + 1);
        acc.setLevelMinPoints(Integer.valueOf(min));
        acc.setLevelMaxPoints(Integer.valueOf(max));
        acc.setPointsToNext(Integer.valueOf(Math.max(0, max - total)));
        String stage = farmStageOf(total);
        acc.setFarmStage(stage);
        acc.setFarmStageLabel(farmStageLabelOf(stage));
        int stageMin = farmStageMinPoints(stage);
        int stageMax = farmStageMaxPoints(stage);
        acc.setFarmStageMinPoints(Integer.valueOf(stageMin));
        acc.setFarmStageMaxPoints(Integer.valueOf(stageMax));
        acc.setPointsToNextFarmStage(Integer.valueOf(
            "tree".equals(stage) ? 0 : Math.max(0, stageMax - total)));
        return acc;
    }

    private static Map<String, Object> farmThresholdsMap()
    {
        Map<String, Object> th = new HashMap<String, Object>();
        th.put("seedling", Integer.valueOf(FARM_SEEDLING));
        th.put("sapling", Integer.valueOf(FARM_SAPLING));
        th.put("tree", Integer.valueOf(FARM_TREE));
        return th;
    }

    /** 成长农场阶段：萌芽 → 浮叶 → 花蕾 → 盛放 */
    public static String farmStageOf(int totalPoints)
    {
        int p = Math.max(0, totalPoints);
        if (p >= FARM_TREE)
        {
            return "tree";
        }
        if (p >= FARM_SAPLING)
        {
            return "sapling";
        }
        if (p >= FARM_SEEDLING)
        {
            return "seedling";
        }
        return "seed";
    }

    public static String farmStageLabelOf(String stage)
    {
        if ("seedling".equals(stage))
        {
            return "浮叶";
        }
        if ("sapling".equals(stage))
        {
            return "花蕾";
        }
        if ("tree".equals(stage))
        {
            return "盛放";
        }
        return "萌芽";
    }

    public static int farmStageMinPoints(String stage)
    {
        if ("seedling".equals(stage))
        {
            return FARM_SEEDLING;
        }
        if ("sapling".equals(stage))
        {
            return FARM_SAPLING;
        }
        if ("tree".equals(stage))
        {
            return FARM_TREE;
        }
        return 0;
    }

    /** 当前阶段上界（下一阶段门槛；盛放阶段等于自身） */
    public static int farmStageMaxPoints(String stage)
    {
        if ("seed".equals(stage))
        {
            return FARM_SEEDLING;
        }
        if ("seedling".equals(stage))
        {
            return FARM_SAPLING;
        }
        if ("sapling".equals(stage))
        {
            return FARM_TREE;
        }
        return FARM_TREE;
    }

    /** triangular levels: need LEVEL_STEP * n(n-1)/2 cumulative */
    public static int levelOf(int totalPoints)
    {
        int p = Math.max(0, totalPoints);
        double n = (Math.sqrt(1.0 + 8.0 * p / LEVEL_STEP) - 1.0) / 2.0;
        return 1 + (int) Math.floor(n);
    }

    public static int pointsForLevel(int level)
    {
        int lv = Math.max(1, level);
        int n = lv - 1;
        return LEVEL_STEP * n * (n + 1) / 2;
    }

    private int scale(int points, double factor)
    {
        return (int) Math.floor(points * factor + 1e-9);
    }

    private static String labelOf(String code)
    {
        if ("PRACTICE_DAY".equals(code)) return "当日打卡";
        if ("PRACTICE_EXTRA".equals(code)) return "加练";
        if ("PRACTICE_WEAK".equals(code)) return "薄弱主题";
        if ("MASTERY_UP".equals(code)) return "掌握进步";
        if ("CHECKOUT_ACK".equals(code)) return "检查确认";
        if ("CHECKOUT_ACK_VOID".equals(code)) return "偏松扣回确认分";
        if ("CHECKOUT_SUBMIT".equals(code)) return "提交检查单";
        if ("CHECKOUT_SPOT".equals(code)) return "抽检一致";
        if ("EXAM_CLASS_RANK".equals(code)) return "考试班级名次";
        if ("EXAM_CLASS_RANK_VOID".equals(code)) return "考试名次冲销";
        if ("TEACHER_AWARD".equals(code)) return "教师奖励";
        return code == null ? "-" : code;
    }

    private Date normalizeDay(Date d)
    {
        if (d == null)
        {
            return DateUtils.parseDate(DateUtils.getDate());
        }
        return DateUtils.parseDate(DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD, d));
    }

    private Date mondayOf(Date day)
    {
        Calendar cal = Calendar.getInstance();
        cal.setTime(day);
        int dow = cal.get(Calendar.DAY_OF_WEEK);
        int delta = (dow == Calendar.SUNDAY) ? -6 : (Calendar.MONDAY - dow);
        cal.add(Calendar.DATE, delta);
        return normalizeDay(cal.getTime());
    }

    private boolean sameDay(Date a, Date b)
    {
        if (a == null || b == null) return false;
        return DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD, a)
            .equals(DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD, b));
    }

    private List<Long> distinctIds(Collection<Long> studentIds)
    {
        List<Long> ids = new ArrayList<Long>();
        if (studentIds == null)
        {
            return ids;
        }
        Set<Long> seen = new HashSet<Long>();
        for (Long id : studentIds)
        {
            if (id != null && seen.add(id))
            {
                ids.add(id);
            }
        }
        return ids;
    }

    private Long toLong(Object v)
    {
        if (v == null) return null;
        if (v instanceof Number) return Long.valueOf(((Number) v).longValue());
        try { return Long.valueOf(String.valueOf(v)); } catch (Exception e) { return null; }
    }

    private Double toDouble(Object v)
    {
        if (v == null) return null;
        if (v instanceof BigDecimal) return Double.valueOf(((BigDecimal) v).doubleValue());
        if (v instanceof Number) return Double.valueOf(((Number) v).doubleValue());
        try { return Double.valueOf(String.valueOf(v)); } catch (Exception e) { return null; }
    }

    private SpasStudent requireLoginStudent()
    {
        SpasStudent self = currentStudentOrNull();
        if (self == null)
        {
            throw new ServiceException("请使用学生账号登录");
        }
        return self;
    }

    private SpasStudent currentStudentOrNull()
    {
        try
        {
            Long userId = SecurityUtils.getUserId();
            if (userId == null)
            {
                return null;
            }
            return studentMapper.selectSpasStudentByUserId(userId);
        }
        catch (Exception e)
        {
            return null;
        }
    }
}
