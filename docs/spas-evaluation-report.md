# 知脉 · 学生学情分析系统(SPAS) · 功能完整性与准确度评估报告

> 评估日期：2026-09-22（含 D1–D5 回写）  
> 评估范围：对照一期开发方案、二期增强方案、学情精准度强化方案（E1–E10）与当前代码与配置  
> 技术栈：RuoYi-Vue 3.9.2 + PostgreSQL + `ruoyi-spas`  
> 结论摘要：**一期主闭环 + 二期 F1–F6 + 精准度 E1–E9 已基本落地；可作为日常教学辅助系统使用。准确度受标注质量、样本量和配置口径影响较大，不宜当作升学/奖惩的唯一依据。**  
> 互补报告：操控性/交互性见 [`spas-operability-interactivity-report.md`](./spas-operability-interactivity-report.md)；**算法专项**见 [`spas-analysis-algorithm-evaluation.md`](./spas-analysis-algorithm-evaluation.md)；**核心准确度总评**见 [`spas-core-accuracy-evaluation.md`](./spas-core-accuracy-evaluation.md)（综合约 8.2）。

---

## 1. 评估方法与口径

| 维度 | 说明 |
| :--- | :--- |
| 完整性 | 对照文档承诺功能是否已有前后端闭环（菜单/API/页面/表结构） |
| 准确度 | 统计模型、阈值、时间窗、权限口径是否与方案一致，以及误判风险 |
| 可运维性 | 部署脚本、配置面、验收自动化、文档一致性 |
| 非目标 | 方案明确不做的能力不按缺失扣分（在线答题、IRT、家长 App、E10） |

主要依据：`docs/` 一期/二期/强化方案、`README.md`、`spas-acceptance.md`、`spas-open-api.md`。

---

## 2. 总体结论

| 包 | 完整性 | 说明 |
| :--- | :---: | :--- |
| 一期主闭环（采集→标注→导入→分析→预警→一生一册） | **~95%** | 主链路齐备；OpenAPI 默认关闭；验收以人工为主 |
| 二期 F1–F6 | **~95%** | 与二期验收说明一致；增量 SQL 需完整执行 |
| 精准度强化 E1–E9 | **~95%** | 核心能力已实现；学生页置信度标签已对齐 |
| E10 / 家长 App / 在线作答 | **0%（非目标）** | 方案明确不做或未启动 |
| 多维学情 D1–D5 | **~90%** | 题型/错因v2/章节进退/Bloom/依赖边已落地；内容标注待补 |

**一句话**：功能面已覆盖中学「成绩驱动学情」场景；结论可信度取决于知识点标注规范、成绩录全、时间窗与阈值调校，以及教师对「样本不足」的重视程度。

---

## 3. 功能完整性矩阵

### 3.1 一期核心

| 功能 | 状态 | 主要落位 | 备注 |
| :--- | :---: | :--- | :--- |
| 学科 / 题型 | 已完成 | `SpasSubject*`、`views/spas/subject` | — |
| 知识点树（版本/章节/叶子） | 已完成 | `SpasKnowledge*`、`views/spas/knowledge` | 章节不可绑题 |
| 学生档案 + 独立账号 | 已完成 | `SpasStudent*`、`views/spas/student` | — |
| 教师多班 | 已完成 | `SpasTeacher*`、`SpasTeacherScopeService` | 依赖教师 SQL/菜单 |
| 试卷 + 多知识点权重 | 已完成 | `SpasPaper*`、`views/spas/paper` | — |
| 成绩导入 / 撤销 | 已完成 | `SpasScore*`、`views/spas/score` | 空单元格默认记 0 |
| 学生 / 班级 / 知识点分析 | 已完成 | `SpasAnalysis*`、`analysis/*.vue` | — |
| 预警规则 + 引擎 | 已完成 | `WarningEngine`、`warning/*` | — |
| 一生一册 / 辅导 | 已完成 | `SpasPortfolio*`、`portfolio/*` | — |
| 家长 OpenAPI | 预留已实现 | `/open/v1/**`、`views/spas/open` | `enabled=false` |
| 在线答题 / 自适应组卷 | 非目标 | — | — |

### 3.2 二期与精准度强化

| 编号 | 功能 | 状态 | 主要落位 |
| :--- | :--- | :---: | :--- |
| F1/E8 | 干预闭环 + Δrate | 已完成 | `SpasIntervene*`、`effect_json` |
| F2 | 学情报告 PDF/Excel | 已完成 | `SpasReport*` |
| F3/E6 | 数据质量看板 | 已完成 | `SpasQuality*` |
| F4/E9 | 章节聚合 | 已完成 | chapter-overview / radar |
| F5/E7 | 时间窗 + 近因衰减 | 已完成 | `default-window: semester` |
| F6 | 班级趋势 | 已完成 | `/class/{deptId}/trend` |
| E1 | 考查频次 × 掌握度 | 已完成 | `frequency.vue` |
| E2 | 样本不足 / 置信度 | 部分 | 学生页偏百分比 |
| E3 | 年级/班级口径提示 | 已完成 | Alert |
| E4 | 证据链 | 已完成 | 难度/考试日 |
| E5 | 预警可解释 | 已完成 | 触发说明 |
| E10 | 错因 / 过程数据 | 未启动 | — |

### 3.3 前后端覆盖面

| 层 | 数量 | 说明 |
| :--- | :--- | :--- |
| 前端 `views/spas` | 17 | 覆盖主模块 |
| 后端 Controller | 19 | 含 OpenAPI/报告/仪表盘 |
| 自动化测试 | **部分** | Calculator / ExamRankMetrics / ScoreCellParser 等单测已有；缺 Analysis 集成测 |

---

### 3.x 多维学情增强（D1–D5，见 spas-advanced-analysis-features.md）

| 编号 | 功能 | 状态 | 说明 |
| :--- | :--- | :--- | :--- |
| D1 | 题型维度分析 | 已实现 | 学生/班级 API + 分析页 + 报告预览/PDF/Excel；质量看板 Q_NO_QUESTION_TYPE |
| D2 | 错因四级分类 | 已实现 | 字典迁移 + 大类汇总；一生一册/干预走大类 |
| D3 | 章节进退 / 上学期 | 已实现 | prev_semester 窗暴露解析区间；空基线提示；Excel |
| D4 | Bloom 轻量层级 | 已实现 | 卷面标注 + 聚合 + insight；质量看板 Q_NO_BLOOM；可配置硬门禁 |
| D5 | 知识点前置依赖 | 已实现 | 边 CRUD + 学科边总览 + 行内计数；rootHint |

## 4. 准确度评估

### 4.1 统计模型

核心模型与方案一致，`KnowledgeStatCalculator`：

```text
sample_w = knowledge_weight × difficulty_w × recency_decay
weighted_rate = Σ(rate × sample_w) / Σ(sample_w)
attempt_count = distinct questions
weak_level = thresholds + min attempts
```

已增强：置信度、考查×掌握、时间窗/近因、证据链、章节汇总、干预 Δrate。

### 4.2 准确度风险

| 风险 | 影响 | 建议 |
| :--- | :--- | :--- |
| **标注质量** | 权重乱标扭曲薄弱点 | 质量中心；权重和=1 |
| **blank-as-zero**（当前默认 **false**） | 若改为 true，空单元格按 0 分计入掌握 | 保持 false；缺考/未做用 score_source 4/5 |
| **一题多点分摊** | 非分技能实测 | 对外表述为辅助定位 |
| **查询窗 ≠ 快照全量重算** | 口径可分歧 | 说明口径；重要决策前重算 |
| **severe-min-attempts=3** | 与一期文档可不一致 | 更新文档或回写配置 |
| **学生页置信度** | 偏百分比，缺标签 | 对齐「样本不足/中/高」 |
| **年级聚合下级** | 信号可被稀释 | Alert + 优先选班 |
| **异步干预评估** | 效果可滞后 | 手动评估 / 提示 |
| **XSS 运算符** | 曾导致预警规则报错 | 已修复；回归必测 |
| **前端编码** | 考查频次页曾乱码 | Vue 强制 UTF-8 |

### 4.3 适用边界

**适合**：日常找相对薄弱点、班级对比、干预前后跟踪、命题/导入质检。

**不适合单独作为**：升学分流、奖惩、心理测量、精细认知诊断。

---

## 5. 运维与工程成熟度

| 项 | 现状 | 风险 |
| :--- | :--- | :--- |
| 增量 SQL | 多脚本分散 | 漏执行导致功能缺失假象 |
| 配置面 | `spas.*` 丰富 | 改默认即改结论 |
| 文档 | 一期/二期较新；GameScreen 残留 | 易误判完成度 |
| 测试 | 无自动化回归 | 算法/权限易回归 |

---

## 6. 改进建议

### P0 · 近期必做（1–2 周）

1. **固化部署清单**：~~一键脚本/检查表。~~ **已落地** → `sql/spas_apply_incremental.py`、`docs/spas-sql-checklist.md`
2. **学生分析置信度对齐 E2**：~~展示「样本不足/中/高」。~~ **已落地**（学生页标签 + 样本不足提示；摘要 `confidenceLabel`）
3. **对外口径说明**：~~时间窗/衰减/空单元格/分摊。~~ **已落地**（学生/班级/知识点分析页 Alert）
4. **预警规则回归**：运算符 `<` `<=` `>` `>=` 必测（编码运算符修复已合入，上线后人工抽检）

### P1 · 提升准确度（2–4 周）

5. **成绩来源语义**：~~缺考 / 未做 / 实得 0 / 补录。~~ **已落地**（导入支持「缺考/未做」；缺考未做不计入掌握度；字典扩展）
6. **快照与时间窗一致性**：~~说明/行为。~~ **已落地**（摘要 `dataMode=snapshot|live`；分析页口径提示）
7. **预警原因结构化** `reason_json`：~~。~~ **已落地**（引擎写入；详情页展示）
8. **关键路径自动化测试**：~~。~~ **已落地**（`SpasScoreCellParser` / `SpasOperatorNormalize` / `KnowledgeStatCalculator` 单元测试）
9. **清理过时文档**：~~GameScreen → `_archive`。~~ **已落地** → `docs/_archive_gamescreen/`

### P2 · 产品增强

10. 班级常模 / 百分位：~~。~~ **已落地**（学生摘要 `rankNo`/`classSize`/`percentile`；班级排名表）
11. 干预知识点独立表：~~。~~ **已落地**（`spas_intervene_knowledge` 双写；CSV 兼容）
12. 质量中心工单化：~~。~~ **已落地**（`spas_quality_ticket` CRUD；质量页「工单」页签）
13. OpenAPI 联调与生产开关策略：~~。~~ **已落地**（`/spas/open/status`；开放管理页状态横幅；配置注释）

### P3 · 中长期

14. E10 错因/过程数据。
15. 家长端 App。
16. IRT / 认知诊断。

---

## 7. 建议验收剧本（抽检）

1. 一题两知识点 0.6/0.4 分摊正确。
2. attempt&lt;3 标「样本不足」。
3. 年级节点「含下级」Alert。
4. 考查频次交叉「优先干预」且无乱码。
5. 预警运算符保存成功；触发说明可见。
6. 干预必挂知识点；Δrate 可见。
7. 章节柱图+表；默认本学期。
8. 质量中心高频低掌握；可从指标创建质量工单。
9. PDF 中文正常。
10. 学号登录仅本人；教师不越权。
11. 学生/班级页名次与百分位一致（1=最高得分率）。
12. 开放管理页显示 OpenAPI ON/OFF；`enabled=false` 时 `/open/v1` 不可用。
13. 学生分析「选卷诊断」勾选多场后，薄弱 Top 与全量/时间窗结果可区分；跨场标签可见「反复薄弱」。
14. 班级分析选时间窗/选卷后，概览、薄弱榜、热力图同源加权；考查频次优先干预 `masteryScope=papers`。
15. 预警规则可选 `PERSISTENT_WEAK`；一生一册可见「本学期反复薄弱」。

---

## 7.1 多次考试薄弱（M 系列）准确度补记

依托 [`spas-multi-exam-weak-plan.md`](./spas-multi-exam-weak-plan.md) 已落地：

| 能力 | 口径 |
| :--- | :--- |
| 时间窗 ≠ all | 即时加权（weight × difficulty × recency），与快照公式一致 |
| 选卷诊断 | `paperIds` 过滤参与聚合的 score 行；上限 30 卷 |
| 反复薄弱 | 有效场次 ≥ minPapers，偏低场次占比 ≥ persistRatio（默认 3 / 0.67，阈值 0.60） |
| 优先干预 | 默认掌握度与所选试卷同源，避免「频次选卷、掌握全量」混口 |
| DDL | **零新表**：趋势与反复薄弱即时计算 |

准确度边界不变：依赖题-知识点标注；一题多点为分摊模型；样本不足不进「反复薄弱」。

---

## 8. 评分卡

| 维度 | 分数（10） | 评语 |
| :--- | :---: | :--- |
| 业务闭环完整性 | 9.0 | 主链路齐全 |
| 分析准确度 | 8.5 | 统一加权引擎 + 选卷/反复薄弱已落地；仍依赖标注质量 |
| 可解释性 / 可操作性 | 8.5 | 证据链、跨场标签、趋势抽屉、干预、质量中心 |
| 权限与数据范围 | 8.0 | 角色与多班已实现 |
| 工程与文档成熟度 | 8.0 | SQL 清单 + M 系列方案；零 DDL 增强 |
| **综合（面向试点校）** | **8.7** | **可试点推广教学辅助；需配套教研规范** |

---

## 9. 附录关键配置

```yaml
spas:
  score:
    blank-as-zero: false
  analysis:
    default-window: semester
    recency-half-life-days: 60
    scope-max-papers: 30
    persistent-weak:
      min-papers: 3
      rate-threshold: 0.60
      persist-ratio: 0.67
    weak-thresholds:
      watch: 0.75
      weak: 0.60
      severe: 0.45
      min-attempts: 3
      severe-min-attempts: 3
  open:
    enabled: false
```

---

*本报告基于 2026-09-22 代码与文档快照；准确度深挖见 spas-core-accuracy-evaluation.md。*
