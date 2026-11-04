# 知脉 · 学情分析功能优化方案

> 编写日期：2026-10-23  
> 更新：2026-10-24  
> 范围：学生 / 班级 / 知识点 / 考查频次分析页 + 分析引擎摘要字段  
> 基线：`docs/spas-analysis-remediation.md` 展示整改已基本落地；本方案补剩余缺口与可落地增强  
> 原则：**不改** `KnowledgeStatCalculator` 主公式与正式 `weak_level` 定级；空白置零等只展示；补弱入口复用题库选题中心；练习行为不进掌握度

---

## 1. 目标与边界

### 1.1 目标

1. 关闭整改残留缺口（快照窗空白置零计数）。
2. 统一各分析页口径条与学科门槛展示。
3. 把「题型 / Bloom」结论提升为一句可读摘要。
4. 雷达 / 趋势可点选下钻；正式薄弱一键补弱 / 建干预。
5. 练习行为与掌握度对照；本窗与本学期薄弱人数对照。

### 1.2 非目标（本期不做）

- IRT / 自适应 / 错因自动挖掘 / 在线考试
- 把综合低分、章节偏低人数、频次象限改成正式薄弱
- 家长 App、短信/企微通道
- 练习行为写入掌握度公式

---

## 2. 现状基线（整改项）

| 项 | 状态 | 说明 |
| :--- | :---: | :--- |
| A1–A2 三指标 + 分科门槛 | 已完成 | student/class KPI |
| B1–B3 旁路说明 | 已完成 | 章节表 / 频次 / 综合低分提示 |
| C1–C2 校次分栏与空态 | 已完成 | student 校次卡 |
| D1 覆盖率拦截 + 质量深链 | 已完成 | paperId 跳转 |
| E1–E3 年级 / 预警窗 / 快照提示 | 已完成 | scope banner |
| F1–F2 实测难度 / 一题多点 | 已完成 | `buildScopeBanner` |
| F3 空白置零提示 | 已完成 | 快照路径已补 `blankZeroCount`（O1） |
| G1–G2 下钻 / 干预异步 | 已完成 | 雷达可点击（O4） |

---

## 3. 优化批次

### O1–O8 — 已落地

见上文与代码：`countBlankZeroDetails`、口径条、`buildDimWeakTip`、补弱入口、雷达下钻、一键补弱 TopN、空态引导。

### O9 · 练习行为 vs 掌握度对照（P1）— 已落地

| 项 | 内容 |
| :--- | :--- |
| 原则 | 自主练/检查单只作行为侧对照，**不写入**掌握度公式 |
| 改动 | 学生：近 14 天 `listPractice` 条数；班级：今日 `practiceDailyStat` 提交率；结论区对照条 +「看自主练」 |
| 落点 | `student.vue`、`class.vue` |
| 验收 | 有练习数据时出现对照条；文案标明「不等于掌握度」 |

### O10 · 正式薄弱 → 干预包草案（P1）— 已落地

| 项 | 内容 |
| :--- | :--- |
| 改动 | 学生：「一键建干预 Top5」依次 `addIntervene`；班级：「批量干预」走 `batch-weak` |
| 落点 | `student.vue`、`class.vue` |
| 验收 | 有 formalWeak / 班薄弱 Top 时可批量建任务；标注拦截时禁用 |

### O11 · 本窗 vs 本学期正式薄弱差（P1）— 已落地

| 项 | 内容 |
| :--- | :--- |
| 改动 | 当前时间窗 ≠ 本学期时，额外请求 `window=semester` 摘要，展示「当前窗 N / 本学期 M」与 Δ |
| 落点 | `student.vue`、`class.vue` |
| 验收 | 切到近 30 天可见与本学期薄弱人数差；选卷模式不强制对比 |

---


### O12 · 结论一眼看懂（直观化）（P1）— 已落地

| 项 | 内容 |
| :--- | :--- |
| 问题 | 分析页顶部 Alert 过多，教师难一眼抓住结论 |
| 改动 | 新增 SpasAnalysisVerdict：红绿灯状态 + 人话标题 + 得分率进度条 + 关键 KPI；次要口径收入「展开口径与说明」 |
| 落点 | `SpasAnalysisVerdict.vue`、`buildAnalysisVerdict` / `buildKnowledgeVerdict` / `buildFrequencyVerdict`、student / class / knowledge / frequency |
| 验收 | 四分析页首屏可见状态徽章与关键数字；次要口径收入「展开口径与说明」 |


## 4. 实施顺序与状态

| 顺序 | 批次 | 优先级 | 状态 |
| :---: | :--- | :---: | :--- |
| 1–8 | O1–O8 | P0–P2 | 已落地 |
| 9 | O9 练习行为对照 | P1 | 已落地 |
| 10 | O10 干预包草案 | P1 | 已落地 |
| 11 | O11 本窗vs本学期 | P1 | 已落地 |
| 12 | O12 结论直观化 | P1 | 已落地 |

---

## 5. 明确不改

- 不改加权掌握度与 `weak_level` 公式
- 不把空白置零从掌握度中剔除（仅提示）
- 不新建独立「补弱包」服务，复用题库选题与既有干预 API
- 覆盖率保持软门禁
- 自主练不参与掌握度计算

---

## 6. 关键路径

| 主题 | 路径 |
| :--- | :--- |
| 本方案 | `docs/spas-analysis-optimization.md` |
| 整改基线 | `docs/spas-analysis-remediation.md` |
| 分析页 | `ruoyi-ui/src/views/spas/analysis/` |
| 口径工具 | `ruoyi-ui/src/utils/spasAnalysisScope.js` |
| 编排 | `SpasAnalysisServiceImpl` |
| 选题中心 | `ruoyi-ui/src/views/spas/qb/select/index.vue` |
| 练习统计 | `/spas/practice/stat/daily`、`listPractice` |
| 批量干预 | `/spas/intervene/batch-weak` |
