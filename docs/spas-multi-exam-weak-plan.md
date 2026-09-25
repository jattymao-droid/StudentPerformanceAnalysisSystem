# 多次考试薄弱点精准分析 · 完善方案

> 文档版本：v1.0 · 2026-09-18  
> 依托：现有 SPAS「采集 → 标注 → 导入 → 分析 → 预警 → 一生一册」闭环  
> 目标：在**多场考试证据**下，稳定、可解释地识别学生薄弱知识点，支撑教师精准补弱。  
> 关联：[`spas-analysis-enhancement.md`](./spas-analysis-enhancement.md)（E1–E9 已落地）、[`spas-evaluation-report.md`](./spas-evaluation-report.md)

---

# 知脉 · 多次考试薄弱点精准分析 · 完善方案

### 1.1 业务目标

教师希望：**根据学生多次考试成绩，准确分析出存在的薄弱点**。

可拆解为四句可验收表述：

1. **跨考试累计**：同一知识点在多场考试中的作答证据能合并计算掌握度  
2. **口径可选**：可按「本学期 / 近 N 天 / 指定试卷集合」限定分析范围  
3. **反复薄弱可见**：能看出「哪几个知识点在多次考试中持续偏低」  
4. **结论可解释**：薄弱结论可下钻到「哪场考试、哪道题、权重与得分率」

### 1.2 非目标（本期不做）

- 在线答题 / 自适应组卷 / 完整 IRT  
- 以薄弱结论直接做升学分流或奖惩的唯一依据  
- 错因标签体系（E10，依赖过程数据）

### 1.3 成功标准（验收口径）

| 场景 | 通过条件 |
| :--- | :--- |
| 三场单元测导入后 | 学生薄弱 Top 与全量快照一致方向；attempt≥配置阈值时有明确置信度 |
| 选定 2–5 份试卷 | 薄弱榜、雷达、优先干预均基于**同一试卷集合算法**，非「频次用选卷、掌握用全量」混口 |
| 知识点反复薄弱 | 可看到该知识点在各次考试的得分率折线，且标记「连续偏低 ≥N 场」 |
| 证据下钻 | 从薄弱知识点 → 各场相关题 → 得分/满分/权重/考试日，一跳可达 |
| 班级视角 | 班级薄弱榜 / 热力图与所选窗或试卷集合一致 |

---

## 2. 现状评估（相对需求）

### 2.1 已具备（可直接用）

| 能力 | 说明 | 落位 |
| :--- | :--- | :--- |
| 跨卷累计快照 | `spas_student_knowledge_stat` 按学生×知识点聚合全历史 | `KnowledgeStatCalculator` |
| 权重×难度×近因 | 导入后重算；可开关近因衰减 | 配置 `spas.analysis.*` |
| 时间窗 | 学生分析：`all / last30d / last90d / semester` | `SpasAnalysisWindowHelper` |
| 考查×掌握 | 多卷频次 + 优先干预象限 | `frequency.vue`、E1 |
| 证据链 | 知识点关联题含难度、考试日 | E4 |
| 整卷趋势 | 学生/班级按试卷时间线 | trend API |
| 样本与预警 | 置信度、WEAK_COUNT / AVG_RATE 等 | E2、WarningEngine |

### 2.2 关键缺口（导致「不够准 / 不好用」）

| 缺口 | 影响 | 优先级 |
| :--- | :--- | :---: |
| **G1 双口径** | 时间窗 live 用「裸均分」，与快照「加权算法」不一致 | P0 |
| **G2 掌握未按选卷重算** | 频次页选了卷，掌握度仍读全量快照 | P0 |
| **G3 缺知识点×考试趋势** | 看不到「反复薄弱」 | P0 |
| **G4 班级窗未落地** | 班级薄弱/热力基本忽略 window | P1 |
| **G5 无「稳定薄弱」标签** | 仅有瞬时薄弱等级，缺跨场稳定性 | P1 |
| **G6 决策前口径提示弱** | 教师不知当前是全量还是选卷结果 | P1 |

**结论**：日常「多场导入 → 看累计薄弱」**已基本满足**；若要求「选多次考试、算法一致、反复薄弱可证」→ 需按本方案补齐 G1–G5。

---

## 3. 目标架构

### 3.1 统一分析引擎（单一算法、多种范围）

```text
                    ┌─────────────────────────────┐
  score_detail  ──► │  KnowledgeStatEngine        │
  + question_kw     │  (weight × difficulty ×     │
  + exam_date       │   optional recency)         │
                    └─────────────┬───────────────┘
                                  │
          ┌───────────────────────┼───────────────────────┐
          ▼                       ▼                       ▼
   scope=ALL                 scope=WINDOW            scope=PAPER_SET
   (写快照表)                 (即时聚合不落库)         (即时聚合不落库)
   一生一册/预警默认          学生/班级分析默认        「选卷分析」模式
```

原则：

1. **同一套加权公式**（与现 `KnowledgeStatCalculator.aggregate` 对齐）  
2. 范围只改变**参与聚合的 score 行**，不改公式  
3. `all` 继续写 `spas_student_knowledge_stat`；其它范围默认**即时计算**（可缓存）

### 3.2 产品形态：三种分析模式

| 模式 | 入口 | 范围参数 | 适用 |
| :--- | :--- | :--- | :--- |
| A 累计画像 | 学生/班级分析，窗=`all` | 全历史快照 | 一生一册、默认预警 |
| B 学期/近因 | 窗=`semester` 等 | 考试日 ≥ from | 本学期薄弱 |
| C 选卷诊断 | 新「考试集合」选择器 | `paperIds[]` | **多次指定考试找薄弱**（本方案核心） |

C 模式是本次完善的主交付。

---

## 4. 功能方案（按优先级）

### 4.1 P0-M1 统一口径引擎（修 G1）

**目标**：`window≠all` 与 `paperIds` 均走加权引擎，废弃「裸 sum(score)/sum(full)」作为薄弱结论来源。

**改造点**：

1. 扩展 `KnowledgeStatCalculator`（或新建 `KnowledgeStatQueryService`）：  
   - `aggregate(studentIds, Scope)`  
   - `Scope = { type: ALL|FROM_DATE|PAPER_IDS, from?, paperIds?, useRecency }`  
2. 学生雷达 / 薄弱 Top / summary 在非 `all` 时调用该服务，返回结构与快照一致（含 `weakLevel`、`attemptCount`、`confidence`）  
3. 配置项保留；文档明确：`all=快照`；其它=`即时加权`

**验收**：同一学生、同一学期窗，重算近因开/关时结果变化可解释；与手工抽 2–3 个知识点验算误差可接受（相对误差 &lt; 1% 或绝对值差 &lt; 0.5 分摊分）。

---

### 4.2 P0-M2 选卷诊断模式（修 G2）

**目标**：教师勾选多份已发布试卷后，薄弱结论仅基于这些考试。

**接口（建议）**：

```http
GET /spas/analysis/student/{id}/scope-summary?subjectId=&paperIds=1,2,3&useRecency=false
GET /spas/analysis/student/{id}/scope-radar?...
GET /spas/analysis/student/{id}/scope-weak-top?limit=10&...
GET /spas/analysis/class/{deptId}/scope-weak-top?...
GET /spas/analysis/knowledge-priority?paperIds=...&masteryScope=papers
```

`masteryScope=papers`：优先干预的掌握度与频次使用同一 `paperIds`（修混口）。

**前端**：

- 学生/班级分析页增加「考试集合」多选（默认最近本学科已发布卷，上限 30）  
- 与时间窗互斥提示：选卷时隐藏或禁用时间窗；页头 Alert：「当前为选卷诊断 · N 场考试」  
- 考查频次页「优先干预」默认 `masteryScope=papers`

**验收**：只含高分卷 vs 只含薄弱卷时，薄弱 Top 明显不同；与全量模式结果可对比展示（可选「对照全量」开关）。

---

### 4.3 P0-M3 知识点×考试趋势与「反复薄弱」（修 G3/G5）

**目标**：证明薄弱不是单次发挥失常。

**数据**：按 `(studentId, knowledgeId, paperId)` 即时聚合（或物化视图，二期再落表）。

**接口**：

```http
GET /spas/analysis/student/{id}/knowledge-exam-trend?knowledgeId=&subjectId=&paperIds=
GET /spas/analysis/student/{id}/persistent-weak?subjectId=&paperIds=&minPapers=3&rateThreshold=0.60
```

**「稳定薄弱 / 反复薄弱」定义（可配置）**：

| 标签 | 默认规则 |
| :--- | :--- |
| 反复薄弱 | 在选定集合中，该知识点有效作答场次 ≥ `minPapers`，且得分率 &lt; `rateThreshold` 的场次占比 ≥ `persistRatio`(默认 0.67) |
| 单次探底 | 仅 1 场偏低，其余正常或样本不足 |
| 波动型 | 高低交替，标准差高于阈值 |

**前端**：

- 学生薄弱榜增加标签：`反复` / `单次` / `样本不足`  
- 点击知识点抽屉：折线（各场得分率）+ 题明细表  
- 班级页：按知识点汇总「反复薄弱人数」

**验收**：构造 3 场考试，知识点 K 连续 3 场 &lt;60%，榜上标记「反复」；仅 1 场低分不标记反复。

---

### 4.4 P1-M4 班级与预警对齐（修 G4）

1. 班级薄弱榜 / 热力图 / 章节汇总：接受 `window` 或 `paperIds`，走统一引擎  
2. 预警新增指标（可选启用）：  
   - `PERSISTENT_WEAK`：学生在近 N 场对知识点持续偏低  
   - 保留现有 `WEAK_COUNT`（全量快照）作默认  
3. 报告导出：选卷诊断结果可写入 PDF/Excel 附录「考试清单 + 反复薄弱」

---

### 4.5 P1-M5 可解释与质检增强（修 G6）

1. 分析页固定展示口径条：范围、近因开闭、最低作答次数、薄弱阈值  
2. 质量中心：  
   - 选卷集合中「未标注知识点题占比」  
   - 「有效样本不足的薄弱结论」计数，提醒勿过度解读  
3. 一生一册：增加「本学期反复薄弱」小节（读 M3 结果）

---

## 5. 算法与口径说明（对外可讲）

### 5.1 单场单题对知识点的贡献（保持现状）

```text
rate_i          = score_i / full_score_i
w_i             = knowledge_weight_i × difficulty_w(difficulty_i) × recency(exam_date_i)
weighted_rate   = Σ(rate_i × w_i) / Σ(w_i)
attempt_count   = 不同题目数（或配置为有效作答次数）
weak_level      = 按 weighted_rate 与 min_attempts 阈值
```

选卷 / 时间窗：仅过滤进入 Σ 的 `i`。

### 5.2 准确度边界（必须写进产品文案）

- 结论依赖**题-知识点标注质量**；权重乱标会扭曲薄弱点  
- 一题多点为**分摊模型**，非分技能实测  
- `blank-as-zero` 会把缺考当 0，需教研约定  
- 样本不足时只展示「证据不足」，不进「反复薄弱」

---

## 6. 实施计划

### 6.1 阶段划分

| 阶段 | 周期（建议） | 交付 | 依赖 |
| :--- | :--- | :--- | :--- |
| **S1** | 3–5 天 | M1 统一引擎；学生窗口径对齐 | 现 Calculator |
| **S2** | 4–6 天 | M2 选卷诊断 API + 学生/频次页 | S1 |
| **S3** | 3–5 天 | M3 知识点×考试趋势 + 反复薄弱标签 | S1 |
| **S4** | 3–4 天 | M4 班级对齐 + 可选预警 | S2/S3 |
| **S5** | 2–3 天 | M5 口径条/报告/一生一册摘要 + 验收用例 | S2–S4 |

合计约 **3–4 周**（1 人全职后端偏分析 + 前端联调）；可先上 S1+S2 即对教师可见改善。

### 6.2 工程任务清单（开发用）

**后端**

- [x] `Scope` 模型与 `KnowledgeStatQueryService.aggregateByScope`
- [x] 改造 student/class live 查询改走引擎
- [x] `paperIds` 版 summary/radar/weak-top/priority
- [x] `knowledge-exam-trend`、`persistent-weak`
- [x] 配置：`min-papers`、`persist-ratio`、`rate-threshold`
- [x]（可选）`PERSISTENT_WEAK` 预警策略
- [x] 增量 SQL：仅配置/字典，原则上不改主快照表结构（趋势即时算）— **零 DDL**

**前端**

- [x] 考试集合多选组件（复用频次页选卷）
- [x] 学生/班级分析：模式切换 + 口径 Alert
- [x] 薄弱榜标签 + 知识点抽屉折线图
- [x] 频次页 `masteryScope=papers`
- [x] 报告预览附考试清单 / 反复薄弱（PDF 附录；一生一册小节）

**文档 / 验收**

- [x] 更新 `spas-evaluation-report` 准确度章节（见下文补记）
- [x] `sql` 清单无需新表则注明「零 DDL」
- [x] 演示脚本：3 场卷 × 2 生构造反复薄弱 → [`spas-persistent-weak-demo.md`](./spas-persistent-weak-demo.md)

> **落地状态（2026-09-18）**：S1–S5 主功能已合入代码。后续增强：班级章节汇总已对齐 window/paperIds；报告预览/导出随分析口径；选卷未标注题占比提示；演示脚本见 [`spas-persistent-weak-demo.md`](./spas-persistent-weak-demo.md)。

### 6.3 风险与对策

| 风险 | 对策 |
| :--- | :--- |
| 选卷即时聚合性能 | 限制 ≤30 卷；按学生过滤；必要时 Redis 短缓存 |
| 与旧 live SQL 结果突变 | S1 上线说明；默认窗仍 semester，提供「算法说明」 |
| 教师误用单次低分 | 强制样本与「反复」规则；UI 默认突出反复标签 |
| 标注质量差 | 继续依赖质量中心；选卷前拦截高「未绑定题」比例 |

---

## 7. 推荐落地路径（给你拍板）

若目标是「尽快让多次考试薄弱分析更准、更好用」：

1. **先做 S1+S2（统一口径 + 选卷诊断）** → 直接解决「混口」与「指定多场考试」  
2. **再做 S3（反复薄弱）** → 解决「准不准、稳不稳」的观感与教研说服力  
3. S4/S5 作为班级与报告收口  

不建议一上来做新表快照或 IRT；当前数据模型已够支撑「多场加权 + 选范围」。

---

## 8. 验收用例（摘要）

| ID | 步骤 | 期望 |
| :--- | :--- | :--- |
| A1 | 导入 3 场卷，学生分析窗=`all` | 薄弱 Top 与重算后快照一致 |
| A2 | 同学窗=`semester` | 结果与引擎验算一致，且含 weakLevel/confidence |
| A3 | 仅选薄弱相关 2 场 | Top 知识点偏向这些卷所考叶子；对照全量可切换 |
| A4 | 知识点 K 连续 3 场 &lt;60% | 标记「反复薄弱」；折线 3 点均低于阈值 |
| A5 | attempt&lt;3 | 不标反复，标「样本不足」 |
| A6 | 频次优先干预 | 掌握度与所选 paperIds 同源 |
| A7 | 班级选卷 | 薄弱人数与学生明细可对上 |

---

## 9. 文档与配置预留

```yaml
spas:
  analysis:
    default-window: semester
    recency-half-life-days: 45
    scope-max-papers: 30
    persistent-weak:
      min-papers: 3
      rate-threshold: 0.60
      persist-ratio: 0.67
    weak-thresholds:
      watch: 0.75
      weak: 0.60
      severe: 0.45
    severe-min-attempts: 3
```

---

## 10. 总结

| 问题 | 答案 |
| :--- | :--- |
| 现有功能能否用？ | **能**完成「多场累计找相对薄弱」 |
| 要「选多次考试准确分析」？ | 需补：**统一加权引擎、选卷诊断、知识点×考试趋势/反复薄弱** |
| 最小可行包 | **S1 + S2 + S3** |
| 与旧方案关系 | 在 E1–E9 之上的 **M 系列（Multi-exam）增强**，不推翻主模型 |

确认本方案后，可按 S1→S2→S3 直接开工实现。
