package com.ruoyi.spas.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
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
import com.ruoyi.spas.domain.SpasPracticeLog;
import com.ruoyi.spas.domain.SpasPracticeLogKnowledge;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.domain.SpasStudentPointAccount;
import com.ruoyi.spas.domain.SpasStudentPointLedger;
import com.ruoyi.spas.domain.SpasStudentKnowledgeStat;
import com.ruoyi.spas.mapper.SpasAnalysisMapper;
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
        if (rawPoints <= 0 || StringUtils.isEmpty(bizKey))
        {
            return 0;
        }
        if (pointMapper.selectLedgerByBizKey(bizKey) != null)
        {
            return 0;
        }
        Date today = normalizeDay(new Date());
        int earnedToday = pointMapper.sumPointsToday(studentId, today);
        int remain = Math.max(0, DAILY_CAP - earnedToday);
        int points = Math.min(rawPoints, remain);
        String finalRemark = remark;
        if (points < rawPoints)
        {
            finalRemark = (remark == null ? "" : remark + "；") + "日封顶" + DAILY_CAP + "，原+" + rawPoints;
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

        SpasStudentPointAccount acc = ensureAccount(studentId);
        int total = (acc.getTotalPoints() == null ? 0 : acc.getTotalPoints().intValue()) + points;
        int week = (acc.getWeekPoints() == null ? 0 : acc.getWeekPoints().intValue()) + points;
        Date weekStart = mondayOf(today);
        if (acc.getWeekStart() == null || !sameDay(acc.getWeekStart(), weekStart))
        {
            week = points;
            acc.setWeekStart(weekStart);
        }
        acc.setTotalPoints(Integer.valueOf(total));
        acc.setWeekPoints(Integer.valueOf(week));
        acc.setLevelNo(Integer.valueOf(levelOf(total)));
        if ("PRACTICE_DAY".equals(reason) && practiceDay != null)
        {
            acc.setLastPracticeDate(practiceDay);
            if (streakOverride != null)
            {
                acc.setDayStreak(streakOverride);
            }
        }
        pointMapper.upsertAccount(acc);
        return points;
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
        return acc;
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
        if ("CHECKOUT_SUBMIT".equals(code)) return "提交检查单";
        if ("CHECKOUT_SPOT".equals(code)) return "抽检一致";
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
