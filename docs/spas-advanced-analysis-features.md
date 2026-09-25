# 知脉 · SPAS 多维学情增强功能开发方案

> 文档编码：UTF-8  

> 版本：v1.1 · 2026-09-22  

> 依托：现有「小题成绩 → 知识点掌握度 → 预警 → 干预 / 一生一册 / 报告导出」与「实考校次」两条数据链  

> 目标：在不改主掌握度公式的前提下，补充错因、题型、能力层、知识依赖与纵向对比，提升「为什么弱、弱在哪一层、根因在哪、怎么变」的可解释性。

---

## 1. 背景

当前学生/班级分析与报告已能回答「哪些知识点得分低」，但仍有五类常见追问未系统覆盖：

1. **为什么错**——只有轻量错因标签（审题/计算/概念/未做），未对齐教学常用的知识性 / 技能性 / 策略性 / 心理性分类。  

2. **能力在哪一层弱**——仅有知识点与难度，没有按认知层级（记忆 → 理解 → 应用 → 分析）拆解。  

3. **题型短板**——卷面已录题型，分析侧未按选择题 / 填空 / 计算等聚合表现。  

4. **知识点依赖**——薄弱点并列展示；章节树可近似「同章共弱」，无法表达「A 是 B 的前置」。  

5. **纵向对比**——已有多场趋势、章节雷达、反复薄弱；缺单元进步/退步榜与跨学期对比产品。

本期按 P0 → P1 → P2 分阶段交付。标注与元数据仍是底座：未标注的题型 / 能力层 / 错因不参与结论，或明确标记「证据不足」。

---

## 2. 原则与非目标

### 2.1 原则

| 原则 | 说明 |

| :--- | :--- |

| 不改主模型 | 掌握度仍为「小题得分 × 知识点权重分摊」（含难度/衰减等既有增强） |

| 口径一致 | 新维度分析复用 `window` / `paperIds` / `subjectId` / 置信度门槛 |

| 可下钻 | 汇总 → 题型/层级/错因 → 题目明细 → 已有证据链 |

| 先人工后自动 | 错因、能力层依赖教师标注；不做过程数据挖掘 |

| 内容与代码并行 | 知识依赖边、Bloom 标注需要学科内容建设，不可只交工程 |

### 2.2 非目标（本期不做）

- 在线答题 / 阅卷引擎 / 作答时长与选项轨迹  

- 完整 IRT、认知诊断、自适应组卷  

- 根据错题文本自动推断错因  

- 家长 App、把多维结论直接作为升学奖惩依据  

- N6 年级对比材料、N7 家长推送（仍见 `docs/spas-next-features.md`）

---

## 3. 优先级与交付清单

| 优先级 | 编号 | 功能 | 接受标准（摘要） | 预估 |

| :--- | :--- | :--- | :--- | :--- |

| P0 | D1 | 题型维度分析 | 学生/班级可按题型看得分率与样本；报告含题型一节；支持实验题类型 | 3–5 人日 |

| P0 | D2 | 错因归因升级 | 四级分类（可含子码）可打标、汇总、进报告；旧四码可迁移或并存 | 2–4 人日 |

| P1 | D3 | 纵向趋势增强 | 章节进步/退步榜；可配置「上学期」与本学期对比 | 4–6 人日 |

| P2 | D4 | 能力维度（布鲁姆轻量） | 题目可标认知层级；学生/班级按层聚合；试点学科强制新卷标注 | 5–8 人日 + 标注 |

| P2 | D5 | 知识点前置依赖 | 依赖边可维护；薄弱列表可提示「根因前置弱」；章节共弱解释保留 | 6–10 人日 + 内容 |

状态（2026-09-22）：D1–D5 工程已落地可试用；Bloom 标注与依赖边种子需学科组继续补齐。详细验收见第 10 节。

---

## 4. 现状基线（复用资产）

| 能力 | 现状 | 关键落位 |

| :--- | :--- | :--- |

| 轻量错因 N4 | 表 `spas_error_tag`，字典 `reading/calc/concept/skip`，题目明细可写 | `sql/spas_error_tag.sql`，`SpasErrorTag*`，`student.vue` |

| 题型目录 | `spas_subject_question_type`；题目字段 `question_type` | `sql/spas_subject_question_type.sql`，试卷编辑 |

| 知识树 | 版本/章节/叶子；章节雷达与章节概览 | `spas_knowledge`，`chapter-radar` / `chapter-overview` |

| 多场趋势 | 整卷趋势、知识点跨卷趋势、反复薄弱、口径对比、校次进退 | `SpasAnalysis*`，`SpasExamRankTrendService` |

| 时间窗 | `all` / `last30d` / `last90d` / `semester`（配置 `semester-start`） | `SpasAnalysisWindowHelper`，`application.yml` |

| 报告 | 学生报告预览/PDF/XLSX 已挂载摘要、薄弱、趋势、校次、错因分布 | `SpasReportServiceImpl`，`SpasReportPdfWriter` |

---

## 5. 功能详述

### D1 题型维度分析（P0）

#### 5.1 目标

按题目类型拆分得分率，解释「概念尚可但运算不足」等题型短板。

建议默认类型（按学科配置，可增减）：

| type_code | 名称 | 备注 |

| :--- | :--- | :--- |

| single / multi / judge | 单选 / 多选 / 判断 | 已有 |

| fill | 填空 | 已有 |

| short | 简答 | 已有 |

| calc | 计算 | 已有 |

| experiment | 实验 | **新增种子**；物理等学科启用 |

#### 5.2 数据与规则

- 数据源：`spas_score_detail` ? `spas_paper_question.question_type`。  

- `question_type` 为空的题目：计入「未标注题型」桶，或从聚合中排除并在 summary 提示覆盖率。  

- 指标：题量、满分合计、实得分合计、得分率、attempt（有分题次数）、低置信标记（复用 attempt 门槛）。  

- 口径：与学生/班级分析相同的 `subjectId` / `window` / `paperIds`。

#### 5.3 接口（建议）

| 方法 | 路径 | 说明 |

| :--- | :--- | :--- |

| GET | `/spas/analysis/student/{studentId}/question-type` | 学生题型表现 |

| GET | `/spas/analysis/class/{deptId}/question-type` | 班级题型表现 |

返回示例字段：

```text

items[{ typeCode, typeName, questionCount, attemptCount, avgRate, fullScoreSum, scoreSum, confidence }]

summary: { coverageRate, unlabeledCount }

```

#### 5.4 前端与报告

- 学生分析、班级分析各增「题型表现」卡片（柱状或表格）。  

- 学生报告 PDF/预览增加「题型表现」一节；全科模式下可按科再拆或仅当前科。  

- 试卷编辑：未选题型时，发布/导入门禁可选「警告」或「拒绝」（建议 P0 警告 + 覆盖率展示，P1 与学科配置联动强制）。

#### 5.5 脚本

- 增量：`sql/spas_question_type_experiment.sql`（为需要实验题的学科插入 `experiment`）。  

- 列入 `sql/spas_apply_incremental.py` 与 `docs/spas-sql-checklist.md`。

#### 5.6 验收

1. 某生计算题均分明显低于选择题时，题型表可见差异。  

2. `paperIds` / `window` 切换后题型结果随之变化。  

3. 报告导出含题型一节；无题型数据时显示空态而非报错。  

4. 配置了实验题的学科，卷面可选「实验」。

---

### D2 错题归因升级（P0）

#### 5.7 目标

在 N4 基础上对齐教学归因框架，支持报告级「错因结构」分析。仍为**人工主错因**，一题一码（可保留 `remark`）。

#### 5.8 分类设计

推荐「大类 + 子码」；大类用于报表，子码用于教学精细标注。

| 大类 code | 大类名 | 子码示例 | 说明 |

| :--- | :--- | :--- | :--- |

| knowledge | 知识性错误 | `concept_unclear` 概念不清、`formula_wrong` 公式记错 | 对应理解/记忆问题 |

| skill | 技能性错误 | `calc_slip` 计算失误、`reading_miss` 审题遗漏、`unit_convert` 单位换算 | 程序性失误 |

| strategy | 策略性错误 | `time_alloc` 时间分配、`hard_first` 难题耗时过多 | 无过程数据时纯主观 |

| psychology | 心理性因素 | `anxiety` 焦虑、`careless` 粗心 | 纯主观，覆盖率预期偏低 |

| skip | 未做 | `skip` | 兼容原「未做」 |

**兼容策略（二选一，实施时定稿）：**

| 方案 | 做法 | 适用 |

| :--- | :--- | :--- |

| A 映射迁移 | 旧 `concept→knowledge/concept_unclear`，`calc→skill/calc_slip`，`reading→skill/reading_miss`，`skip→skip` | 历史标签需连续统计 |

| B 并存双字典 | 保留旧码只读；新打标只用新码；汇总按大类折叠 | 上线更快、报表需处理两套 |

推荐 **A**：一次迁移脚本 + 更新 `SpasErrorTagServiceImpl` 白名单。

#### 5.9 接口与 UI

- 沿用 `PUT /spas/errorTag`；`error_code` 改为新子码；返回增加 `errorCategory` / `errorCategoryLabel`。  

- `GET` 错因汇总按**大类**聚合（报告主图），明细表仍显示子码标签。  

- 学生分析题目明细：级联选择「大类 → 子类」或分组下拉。  

- 可选：得分率低于阈值的题，未打标时提示「建议标注错因」（不阻断查询）。

#### 5.10 脚本与字典

- `sql/spas_error_cause_v2.sql`：更新 `sys_dict_type/data`，迁移 `spas_error_tag.error_code`。  

- 字典类型可仍用 `spas_error_cause`，或拆 `spas_error_category` + `spas_error_cause`。

#### 5.11 验收

1. 新四类（及子码）可保存、刷新可见。  

2. 一生一册 / 报告错因分布按大类展示，数量与明细一致。  

3. 旧数据按选定方案迁移或只读兼容，不丢标签。  

4. 干预备注中的「主错因」文案使用新标签。

---

### D3 纵向趋势增强（P1）

#### 5.12 目标

在现有趋势能力上补齐：

1. **单元/章节纵向**：力学 vs 热学 vs 电磁等章节掌握度对比，并标出进步最快 / 退步最明显。  

2. **跨学期**：本学期 vs 上学期（或自定义基线窗）的变化轨迹。

#### 5.13 章节进步/退步榜

- 数据：章节节点（`node_type=1`）下叶子掌握度 rollup（复用章节雷达逻辑）。  

- 对比轴：  

  - **近窗**：最近 K 场试卷（或最近 N 天）的章节率  

  - **基线窗**：更早的 K 场或上一时间窗  

- 输出：`deltaRate = recent - baseline`；排序 Top 进步 / Top 退步；样本不足章节标记不参与排名。

接口建议：

| 方法 | 路径 |

| :--- | :--- |

| GET | `/spas/analysis/student/{id}/chapter-delta` |

| GET | `/spas/analysis/class/{deptId}/chapter-delta` |

参数：`subjectId`，`recentPaperIds` 或 `recentWindow`，`baselinePaperIds` 或 `baselineWindow`。

#### 5.14 跨学期对比

- **P1 最小方案**：配置增加 `spas.analysis.prev-semester-start` / `prev-semester-end`（或 `baselineWindow=prev_semester` 由起止日期推导），复用 `scope-compare` 思路扩展到章节与薄弱榜。  

- **P2 可选**：正式学期表 `spas_term(term_id, name, start_date, end_date)`，试卷按 `exam_date` 归属学期。

不做：自动推断学校校历；多学年归档快照（除非性能不足再加）。

#### 5.15 前端与报告

- 学生/班级分析：「章节进退」表 + 简短 headline（如「进步最快：光学；退步最明显：力学」）。  

- 报告：纵向一节展示 Top3 进步/退步；跨学期对比表（有配置才显示）。

#### 5.16 验收

1. 人为构造「前弱后强」章节，进步榜可命中。  

2. 基线窗无数据时提示「基线样本不足」，不展示假 delta。  

3. 配置上学期区间后，本学期 vs 上学期薄弱差异可见。  

4. 与现有 `persistent-weak`、整卷 trend 口径说明不冲突（页面注明对比定义）。

---

### D4 能力维度分析·布鲁姆轻量（P2）

#### 5.17 目标

按认知层级看得分率，区分「基础不牢」与「高阶思维薄弱」。采用**轻量题目标签**，不做完整认知诊断。

建议层级（可配置）：

| code | 名称 | 典型题 |

| :--- | :--- | :--- |

| remember | 记忆/识记 | 概念、公式再现 |

| understand | 理解 | 解释、原理说明 |

| apply | 应用 | 套用公式解题 |

| analyze | 分析/综合 | 多知识点综合、实验设计 |

（评价/创造两层可按学科需要后续扩展，P2 可不启用。）

#### 5.18 数据模型

- `spas_paper_question.bloom_level varchar(32)`（可空）。  

- 字典 `spas_bloom_level`。  

- 质量门禁（试点学科）：新卷发布时 `bloom_level` 必填；老卷允许空，分析显示覆盖率。

#### 5.19 分析

- 聚合方式对齐 D1：按 `bloom_level` 求得分率与置信度。  

- 解读规则（可配置阈值）：  

  - 记忆/理解低、应用/分析尚可 → 提示「基础不牢」  

  - 记忆/理解尚可、分析低 → 提示「高阶薄弱」  

  - 样本不足 → 不输出定性结论

接口：`GET .../student/{id}/bloom`、`GET .../class/{deptId}/bloom`。

#### 5.20 验收

1. 卷面可编辑并保存认知层级。  

2. 学生分析可见各层得分率；覆盖率 &lt; 阈值时 Alert。  

3. 报告可选一节「能力层级」；未试点学科可隐藏入口。

---

### D5 知识点前置依赖（P2）

#### 5.21 目标

揭示薄弱点之间的依赖，定位**根本性薄弱点**，而非仅并列叶子。

两层能力：

| 层级 | 手段 | 交付 |

| :--- | :--- | :--- |

| L1 章节共弱 | 现有章节树 + 文案增强 | P1 可随 D3 附带：「同章多个叶子偏弱」 |

| L2 前置依赖 | 新建依赖边 | P2 正文 |

#### 5.22 数据模型

```text

spas_knowledge_edge

  edge_id

  subject_id

  from_knowledge_id   -- 前置（先修）

  to_knowledge_id     -- 后继（依赖前者）

  relation            -- prerequisite（默认）

  weight              -- 可选 0~1，默认同权

  status              -- 0 正常

  唯一：(from_knowledge_id, to_knowledge_id, relation)

```

约束：仅叶子?叶子（或章→叶需产品定稿）；保存时环检测；删除知识点时级联或阻删。

#### 5.23 维护

- 学科/知识树管理页：「依赖」抽屉，为当前叶子选择前置知识点。  

- 种子：物理等试点学科提供少量高价值边（如牛顿第二定律 → 牛顿定律应用）；不追求全图一次铺满。

#### 5.24 分析逻辑（建议）

对某生薄弱叶子集合 W：

1. 若存在边 `A → B` 且 A∈W、B∈W，则标记 B 的 `rootHint = A`（前置同弱）。  

2. 若仅 B∈W、A 不在 W 但 A 的 rate 也低于阈值，同样提示。  

3. 输出「根因候选」：入度边指向的薄弱点中，自身无更弱前置、或前置已掌握者。  

4. 章节 L1：同章 ≥2 个薄弱叶子 → 「整章性薄弱」提示（不依赖边表）。

接口：薄弱 Top / 学生摘要增加 `dependencyHints[]`；可选 `GET .../knowledge-graph/hints`。

#### 5.25 验收

1. 可增删依赖边，成环保存失败。  

2. 前置与后继同弱时，后继行显示根因提示。  

3. 无边数据时退化为章节共弱提示，功能不报错。  

4. 报告可列出「建议优先补的前置知识点」≤ N 条。

---

## 6. 落位清单（工程）

| 项 | 主要位置 |

| :--- | :--- |

| 题型聚合 | `SpasAnalysisMapper.xml`，`KnowledgeStatQueryService` / `SpasAnalysisServiceImpl`，`SpasAnalysisController` |

| 题型 UI | `views/spas/analysis/student.vue`，`class.vue` |

| 实验题种子 | `sql/spas_question_type_experiment.sql` |

| 错因 v2 | `sql/spas_error_cause_v2.sql`，`SpasErrorTagServiceImpl`，字典，题目明细 UI |

| 章节 delta | 分析 Service + Controller；复用 chapter rollup |

| 学期基线 | `application.yml`，`SpasAnalysisWindowHelper` |

| Bloom 字段 | `spas_paper_question`，试卷编辑，分析聚合 |

| 依赖边 | 新 domain/mapper/controller；知识树 UI |

| 报告 | `SpasReportServiceImpl`，`SpasReportPdfWriter` |

| 清单回写 | `docs/spas-sql-checklist.md`，`docs/spas-evaluation-report.md` |

权限：读与现网分析权限一致（`spas:analysis:student` / `spas:analysis:class`）；依赖边写权限建议挂知识管理或学科管理既有 perm。

---

## 7. 数据与配置变更摘要

| 脚本/配置 | 内容 |

| :--- | :--- |

| `sql/spas_question_type_experiment.sql` | 学科题型增加 experiment |

| `sql/spas_error_cause_v2.sql` | 错因字典与历史码迁移 |

| `sql/spas_bloom_level.sql` | 字典 + `alter table spas_paper_question add bloom_level` |

| `sql/spas_knowledge_edge.sql` | 依赖边表 |

| `application.yml` | 可选 `prev-semester-start/end`；Bloom 覆盖率阈值；章节 delta 默认 K |

全部须 UTF-8；经 `spas_apply_incremental.py` 或 checklist 手工执行，**不在文档中写入数据库密码**。

---

## 8. 里程碑建议

| 里程碑 | 内容 | 出口标准 |

| :--- | :--- | :--- |

| M1 | D1 + D2 | 题型分析可查可导出；新错因可打标且报告按大类汇总 |

| M2 | D3 | 章节进退榜 + 上学期对比（配置驱动）上线 |

| M3 | D4 试点 | 单学科新卷强制 Bloom；分析/报告可读 |

| M4 | D5 试点 | 边可维护；薄弱列表有根因提示；种子边可用 |

并行：学科组准备实验题类型启用范围、错因打标规范、Bloom 标注指南、物理前置边清单。

---

## 9. 风险与对策

| 风险 | 对策 |

| :--- | :--- |

| 题型/Bloom/错因覆盖率低 | 覆盖率指标 + Alert；门禁分试点学科；不因空数据阻断主分析 |

| 策略性/心理性主观强 | 报表默认按大类；子码可选；不自动预警 |

| 依赖边维护成本高 | 先种子边 + 根因提示；L1 章节共弱兜底 |

| 跨学期配置易错 | 页面展示基线日期范围；无数据明确空态 |

| 与「非目标：认知诊断」冲突误解 | 对外口径统一为「轻量能力标签」，非 IRT/CDM |

---

## 10. 验收总表（发布前）

1. **D1**：学生/班级题型得分率与窗口口径一致；报告有题型节；实验题可选。  

2. **D2**：四级（子码）可写；大类汇总正确；旧码已迁移或只读兼容。  

3. **D3**：章节 Top 进步/退步可复现；上学期对比在配置后可用。  

4. **D4**：试点学科题目可标层级；层级聚合与覆盖率提示正确。  

5. **D5**：依赖边 CRUD + 环检测；同弱前置有提示；无边时不报错。  

6. 主掌握度、预警、干预、校次进退回归通过；中文界面无乱码（UTF-8）。

---

## 11. 文档关系

| 文档 | 关系 |

| :--- | :--- |

| `docs/spas-next-features.md` | N1–N4 已交付基线；本方案为其后的分析维增强 |

| `docs/spas-analysis-enhancement.md` | E1–E9 已实现；E10 过程数据仍非目标，D2 仅做人标注升级 |

| `docs/spas-analysis-algorithm-evaluation.md` | 主算法评估；本方案不修改核心公式 |

| `docs/spas-evaluation-report.md` | 功能完成度总表；各 Di 落地后回写状态 |

| `docs/spas-sql-checklist.md` | 增量 SQL 执行清单 |

---

## 12. 修订记录

| 版本 | 日期 | 说明 |

| :--- | :--- | :--- |

| v1.0 | 2026-09-22 | 初稿：D1–D5 范围、接口草案、里程碑与非目标 |

| v1.1 | 2026-09-22 | 工程落地：D1–D5 API/UI/SQL；错因 v2 迁移；prev_semester 窗 |

