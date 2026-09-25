# 知脉 · 学情分析精准度·功能强化开发方案

> 文档版本：v1.0 · 2026-09-17  
> 依托：现有「采集 → 标注 → 导入 → 分析 → 预警 → 一生一册」闭环  
> 目标：在不改变「小题得分 × 知识点权重分摊」主模型前提下，提升学情结论的可信度、可解释性与可操作性。

---

## 1. 背景与原则

精准学情的瓶颈不在「再多几张图」，而在：

1. **标注可信**：题-知识点权重是否合理  
2. **样本足够**：`attempt_count` / 置信度是否达标  
3. **口径一致**：年级卷 / 分班、时间窗、难度权重  
4. **结论可下钻**：薄弱 → 知识点 → 题 → 考试  
5. **考查强度×掌握度**：高频低掌握才是优先干预点  

### 1.1 非目标（本期不做）

- 在线答题 / 阅卷引擎  
- 完整 IRT / 认知诊断模型  
- 家长端 App 页面  

---

## 2. 优先级与交付清单

| 优先级 | 编号 | 功能 | 接受标准（摘要） | 状态 |
| :--- | :--- | :--- | :--- | :--- |
| P0 | E1 | 考查频次 × 掌握度交叉 | 可按班级+多卷看「高考查低掌握」二象限 | 已实现 |
| P0 | E2 | 样本不足标记 | 学生/班级/知识点分析明确标记低置信度 | 已实现 |
| P0 | E3 | 分析口径（年级/分班） | 分析页提示当前筛选是否含下级班；与成绩导入口径一致 | 已实现 |
| P1 | E4 | 知识点→题目证据链 | 知识点页可看得分率+权重+难度+考试日期 | 已实现 |
| P1 | E5 | 预警可解释 | 预警记录展示触发条件摘要（知识点/得分率/班均） | 已实现 |
| P1 | E6 | 命题/导入质检增强 | 质量中心补充「高频低掌握」、异常分清单 | 已实现 |
| P2 | E7 | 时间衰减与季度快照 | 重算可选衰减；分析默认推荐本学期窗 | 已实现 |
| P2 | E8 | 干预后复测 | 干预必挂知识点；复测后展示Δrate | 已实现 |
| P2 | E9 | 章节聚合看板 | 叶子噪声大时可按章节看掌握度 | 已实现 |
| P3 | E10 | 错因/过程数据 | 依赖在线作答或标注扩展 | 未启动 |

---

## 3. 功能详述

### E1 考查频次 × 掌握度交叉（P0）

**现状**：已有「考查频次」（结构统计）与「知识点/班级分析」（得分率），两者未联动。

**目标**：在考查频次页（或独立标签）展示二象限分类：

| 象限 | 条件（可配） | 含义 |
| :--- | :--- | :--- |
| 优先干预 | questionCount≥Qmin 且 avgRate&lt;0.60 且 attempt达标 | 考得多但不会 |
| 证据不足 | attempt&lt;Amin | 不要下结论 |
| 稳固 | avgRate≥0.75 且 questionCount≥Qmin | 可减少重复训练 |
| 关注 | 其余 | 持续观察 |

**接口**：`GET /spas/analysis/knowledge-priority?paperIds=&deptId=&subjectId=`  
**返回**：items[{ knowledgeId, knowledgeName, questionCount, weightSum, avgRate, attemptAvg, studentCount, quadrant, confidence }]

### E2 样本不足标记（P0）

**现状**：后端已有 `confidence(attempt)`，前端展示不足。

**目标**：

- 学生分析：薄弱 Top / 雷达图点标记低置信  
- 班级分析：热力图/薄弱榜标记  
- 知识点分析：学生明细表增加置信度列  
- 规则：attempt&lt;3 → `样本不足`；3–5 → `中`；≥6 → `高`

### E3 分析口径（P0）

**现状**：成绩导入已允许学生在试卷部门子树；分析页缺乏口径说明。

**目标**：

- 班级/知识点/考查频次：选中年级节点时 Alert：「当前为年级/校级范围，统计含下级班级」  
- 选中班级：「仅本班」  
- 考查频次可选 deptId，与掌握度交叉时按班过滤  

### E4 证据链（P1）

知识点分析「关联题目」表增加：难度、满分、考试日期、题型；支持按试卷筛选。

### E5 预警可解释（P1）

`spas_warning_record.remark` 或独立 `reason_json` 写入触发摘要；前端记录页展示。

### E6 质检增强（P1）

质量中心新增指标：

- `Q_HIGH_FREQ_LOW_MASTERY`：高考查低掌握（依赖 E1）  
- 已有 Q_NO_KNOWLEDGE / Q_WEIGHT_SUM / Q_LOW_ATTEMPT 等保留并在首页引导  

### E7 时间衰减与学期窗（P2）

- 配置：`spas.analysis.default-window=semester`、`recency-half-life-days`
- 接口：`GET /spas/analysis/config`；重算 `useRecency` 参数覆盖近因加权
- 前端：学生/班级分析默认本学期；重算开关「近因衰减」

### E8 干预后复测（P2）

- 创建干预必须挂接知识点（前后端校验）
- 评估写入 `effect_delta` + `effect_json`（知识点级 baseline/effect/Δrate）
- 迁移：`sql/spas_intervene_effect_json.sql`

### E9 章节聚合看板（P2）

- 班级分析「章节汇总」柱图 + 明细表（班均/覆盖学生/薄弱人数）

### E10

未启动（错因/过程数据依赖在线作答）。

---

## 4. 技术落位

| 层 | 路径 |
| :--- | :--- |
| API | `ruoyi-spas/.../SpasAnalysisController` 增加 priority 接口 |
| Mapper | `SpasAnalysisMapper.xml` 联表 `spas_question_knowledge` + `spas_student_knowledge_stat` |
| 前端 | `views/spas/analysis/frequency.vue` 扩展交叉区；`student/class/knowledge.vue` 置信度列 |
| 预警 | `WarningEngine` 写入 reason 文本 |
| 质量 | `SpasQuality*` 新指标 |
| 配置 | `application.yml` 下 `spas.analysis.*` 阈值 |

### 4.1 默认阈值

```yaml
spas:
  analysis:
    min-attempt-high: 6
    min-attempt-mid: 3
    priority-question-min: 2
    priority-weak-rate: 0.60
    priority-solid-rate: 0.75
```

---

## 5. 实现顺序（本轮）

1. ~~本文档~~  
2. E1 API + 考查频次页交叉区  
3. E2 分析页置信度标记  
4. E3 口径 Alert + 频次页 dept 筛选  
5. E4 关联题目列扩展  
6. E5 预警 reason  
7. E6 质量指标  
8. 更新本表状态为「已实现」  
9. E7 默认学期窗 + 重算 useRecency  
10. E8 干预必挂知识点 + effect_json Δrate  
11. E9 章节汇总表  

---

## 6. 验收剧本

1. 选择含知识点标注的多份试卷 + 某班，交叉区出现「优先干预」行  
2. attempt=1 的学生在薄弱榜标「样本不足」  
3. 选中年级节点时 Alert 提示含下级  
4. 知识点关联题可见难度与考试日  
5. 触发预警后记录页可见原因摘要  
6. 质量中心可点开高频低掌握明细  
7. 分析页默认时间窗为本学期；重算可开关近因衰减  
8. 新增干预不选知识点应被拒绝；评估后详情可见知识点 Δrate  
9. 班级分析章节区有柱图+表格  

---

## 7. 风险

| 风险 | 应对 |
| :--- | :--- |
| 无成绩时交叉为空 | 仅展频次，quadrant=证据不足 |
| 阈值过敏/过慢 | yaml 可配，页面展示当前阈值 |
| 编码乱码 | 前端中文文件强制 UTF-8 |

---

*EOF*
