# 知脉 · 学生学情精确指导改进方案

> 编写日期：2026-10-24  
> 范围：学生分析页 → 学习处方 → 补弱/干预/作业/练习 → 学生端今日任务  
> 基线：`docs/spas-analysis-remediation.md`、`docs/spas-analysis-optimization.md`（O1–O12 已落地）  
> 原则：**不改** `KnowledgeStatCalculator` 与正式 `weak_level`；自主练**不写入**掌握度；处方主清单**仅** formalWeak（不含综合低分/样本不足）

---

## 1. 目标与边界

### 1.1 目标

把「教师诊断台」升级为「可执行学习指导」：

1. **学什么**：按正式薄弱 + 先修依赖排序的知识点清单。
2. **怎么学**：每点可一键跳转补弱选题 / 建干预 / 作业主题（复用现有入口）。
3. **练多久**：处方写明学科 `min-attempts`，避免「练了但不定级」。
4. **何时过关**：目标得分率（默认 0.6） + 复测后该点退出正式薄弱。

### 1.2 非目标（本期不做）

- IRT / 全自适应推题 / 在线考试
- 错因自动挖掘并写入加权率
- 自主练写入掌握度公式
- 家长 App、短信/企微通道
- 独立「智能路径引擎」服务（先用现有 weak-top + edges 聚合）

---

## 2. 现状基线

| 能力 | 状态 | 说明 |
| :--- | :---: | :--- |
| 正式薄弱诊断 + 结论条 | 已有 | `student.vue` + `buildAnalysisVerdict` |
| 一键补弱 TopN | 已有 | 跳转 `/spas/qb/select`；处方卡也可点 |
| 一键建干预 | 已有 | `addIntervene`，目标率 0.6 |
| rootHint / 依赖边 | 已有 | 已软排序入处方（先修在前） |
| 练习 suggest/weak | 已有 | practice mine 与处方同源展示 |
| 作业主题填薄弱 | 已有 | 处方可带 knowledgeIds 深链 `/spas/biz/hw-task` |
| 学生端「今日任务」 | 已有 | `practice/mine.vue` 处方摘要 |
| 复测过关打勾 | 已有 | localStorage 快照差分「已退出」 |

---

## 3. 改进批次

### G1 · 学生分析「本周学习处方」卡（P0）— 已落地

| 项 | 内容 |
| :--- | :--- |
| 问题 | 结论明确但教师/学生仍要自己拼「先学哪几个」 |
| 改动 | 结论条下增处方卡：Top3–5 formalWeak（含先修 tip）、每点过关口径、学科次数门槛 |
| 落点 | `buildStudentPrescription`（`spasAnalysisScope.js`）、`student.vue` |
| 验收 | 有 formalWeak 时首屏可见处方清单；标注拦截/无薄弱时有空态文案 |
| 状态 | 已落地|

### G2 · 处方动作串（补弱 / 干预 / 作业主题）（P0）— 已落地

| 项 | 内容 |
| :--- | :--- |
| 改动 | 处方卡按钮：一键补弱、一键建干预（复用现逻辑）、带 knowledgeIds 跳转作业/选题；单点可行内动作 |
| 落点 | `student.vue`；作业页若支持 query 则深链，否则退化为 QB select |
| 验收 | 从处方卡可完成下发，无需翻到薄弱表再点 |
| 状态 | 已落地|

### G3 · 处方摘要共享（轻量 API 或前端工具复用）（P1）— 已落地

| 项 | 内容 |
| :--- | :--- |
| 改动 | `buildStudentPrescription` 供分析页与学生端共用；若需跨端则增 `GET /spas/analysis/student/{id}/prescription`（聚合 weak-top + edges，不新表） |
| 验收 | 教师端与学生端看到同序同点 |
| 状态 | 已落地（共享 `buildStudentPrescription`，暂不新增 API） |

### G4 · 学生端「今日/本周任务」（P1）— 已落地

| 项 | 内容 |
| :--- | :--- |
| 改动 | practice mine 或 portfolio mine 首屏展示处方摘要 + 进入练习；标明行为不等于掌握度过关 |
| 落点 | `practice/mine.vue`（首屏处方摘要 + 填入加练主题） |
| 验收 | 学生登录后不问老师也知道先练哪三个点 |
| 状态 | 已落地 |

### G5 · 复测后过关对照（P1）— 已落地

| 项 | 内容 |
| :--- | :--- |
| 改动 | 处方项展示「当前仍 formalWeak / 已退出」；可对比上次查询或干预 evaluate |
| 验收 | 复测后刷新学生分析，退出点在处方上标过关 |
| 状态 | 已落地（localStorage 快照差分） |

### G6 · 先修软排序加强（P2）— 已落地

| 项 | 内容 |
| :--- | :--- |
| 改动 | 有依赖边时处方项排序「先修未过则标注建议先练」；不做硬锁推题 |
| 验收 | 先修点（被依赖）排前并标「建议先练」；依赖点排后并标「依赖」 |
| 状态 | 已落地 |

---

## 4. 实施顺序与状态

| 顺序 | 批次 | 优先级 | 状态 |
| :---: | :--- | :---: | :---: |
| 1 | G1 处方卡 | P0 | 已落地 |
| 2 | G2 动作串 | P0 | 已落地 |
| 3 | G3 摘要共享 | P1 | 已落地 |
| 4 | G4 学生端任务 | P1 | 已落地 |
| 5 | G5 过关对照 | P1 | 已落地 |
| 6 | G6 先修强化 | P2 | 已落地 |

---

## 5. 明确不改

- 不改加权掌握度与 `weak_level` 公式
- 不把综合低分、样本不足、频次象限升为正式薄弱
- 不新建独立补弱包微服务（复用题库选题 + 干预 API）
- 自主练仅作行为对照，过关以小题/正式薄弱为准

---

## 6. 关联路径

| 主题 | 路径 |
| :--- | :--- |
| 本方案 | `docs/spas-student-guidance.md` |
| 分析优化 | `docs/spas-analysis-optimization.md` |
| 学生分析页 | `ruoyi-ui/src/views/spas/analysis/student.vue` |
| 口径/处方工具 | `ruoyi-ui/src/utils/spasAnalysisScope.js` |
| 依赖边 | `SpasKnowledgeEdgeServiceImpl` |
| 选题中心 | `ruoyi-ui/src/views/spas/qb/select/index.vue` |
| 干预 | `/spas/intervene` |
| 练习建议 | `/spas/practice/suggest/weak` |

