# 知脉学情分析系统 — 功能完备性排查报告

> 评估视角：作为可面向学校正式上线的成熟学情产品，对照「采集 → 标注 → 掌握度分析 → 预警 → 干预 → 一生一册/报告」全链路。  
> 生成日期：2026-09-25  
> 代码基线：RuoYi-Vue 3.9.2 + `ruoyi-spas` / `ruoyi-ui/src/views/spas`

---

## 1. 总体结论

当前系统已具备可信的**中期成熟度**：

- 主链路打通：学科/知识点 → 试卷标注 → 小题成绩 → 掌握度分析 → 预警 → 干预 → 一生一册/报告导出  
- 辅链路较强：题库导入/OCR/AI 辅助标注、校次趋势、错因标签、质量看板、家长 OpenAPI（默认关闭）

相对「完善成熟的校本学情产品」，主要缺口集中在：

1. **家长端产品化**（仅有 OpenAPI，无 H5/App/推送）  
2. **多学科内容运营就绪度**（种子偏 MATH/PHYS）  
3. **通知通道过窄**（基本只有系统通知）  
4. **运维/隐私/测试/CI  hardening**  
5. **部分页面仍是入口壳**（如报告中心）

**一句话：**可支撑教研试点与单校深度试用；要称「成熟量产产品」，需补齐家长触达、学科内容包、通知与运维验收。

---

## 2. 已具备能力清单（模块地图）

### 2.1 前端（`ruoyi-ui/src/views/spas/`）

| 模块 | 路径 | 能力摘要 |
|------|------|----------|
| 学科 | `subject/` | 学科与题型目录 |
| 知识点 | `knowledge/` | 章节树、依赖边 |
| 学生/教师 | `student/` `teacher/` | 档案、任课/班主任、导入导出 |
| 试卷 | `paper/` | 结构、知识点权重、Bloom/题型、发布 |
| 小题成绩 | `score/` | Excel 导入导出、重算跳转 |
| 实考校次 | `examScore/` | 宽表导入、校次趋势数据源 |
| 班级/学生分析 | `analysis/class|student` | 雷达、薄弱、Bloom/题型、错因、PDF |
| 知识点/频次 | `analysis/knowledge|frequency` | 汇总下钻、频次×掌握优先矩阵 |
| 预警 | `warning/rule|record` | 规则、执行、处理、转干预 |
| 干预 | `intervene/` | 任务、效果评估、教练话术 |
| 一生一册 | `portfolio/` `portfolio/mine` | 教师册 / 学生自助册 + PDF |
| 报告中心 | `report/` | **导航入口**（非独立导出工作台） |
| 质量 | `quality/` | 标注/成绩质量与工单 |
| 开放平台 | `open/` | 家长客户端、绑定、联调面板 |
| 题库 | `qb/**` | 题库、组卷、框选标注、智能选题 |

另：系统 LLM 配置在 `views/system/llm/`；首页看板消费 `api/spas/dashboard.js`。

### 2.2 后端（`ruoyi-spas`）

- 业务 Controller/Service：学科、知识点、学生、教师、试卷、成绩、分析、预警、干预、档案、报告、质量、错因、看板、开放接口等  
- 分析引擎：`analysis/`（掌握度、相对薄弱、分科阈值、校次交叉诊断）  
- 预警：`warning/WarningEngine` + Quartz `SpasWarningTask`  
- 题库：`qb/`（导入/OCR/AI/组卷发布）  
- 测试：约 10 个单测/IT（计算器、相对薄弱、校次、标注门禁等），**无 spas 前端单测**

### 2.3 关键支撑脚本

见 `docs/spas-sql-checklist.md`：基础 schema、菜单角色、预警任务、干预/报告/质量、校次、错因、题库、数学/物理种子、Open 演示客户端等。**生产环境必须按清单全量落库，否则会出现「菜单有、功能空」的假完备。**

---

## 3. 缺失与薄弱功能（按领域）

### 3.1 明确延期 / 非目标（文档已写）

| 项 | 说明 | 依据 |
|----|------|------|
| N7 家长 App / 推送 | 未做，仅 OpenAPI | `docs/spas-next-features.md` |
| N6 跨年级对比素材包 | 未产品化 | 同上 |
| 在线考试 / 自适应 / IRT | 非目标 | `README.md`、进阶分析文档 |
| E10 错因自动推断 / 过程挖掘 | 未启动 | `docs/spas-evaluation-report.md` |

建议：在对外材料中明确「范围边界」，避免被当成缺失缺陷。

### 3.2 标注门禁：软提示 vs 硬拦截

| 项 | 现状 | 风险 |
|----|------|------|
| 知识点绑定 + 权重和=1 | **硬门禁**（发布/导入） | — |
| 题型 `question_type` | 默认 **硬**（`spas.paper.require-question-type=true`） | — |
| Bloom 能力层级 | 默认 **硬**（`require-bloom-level=true`） | 题库卷发布后需在分析卷补全 Bloom，否则导分拦截 |
| 标注覆盖率 | 降置信度、禁止正式薄弱定级，不拦发布 | 口径易被误解 |

文件：`application.yml`、`SpasPaperProperties`、`PaperAnnotationInspector`。

### 3.3 多学科就绪度

- Schema/CRUD 支持多学科；演示种子以 **MATH / PHYS** 为主，另有 **CHN / ENG / CHEM** 精简包（`spas_subject_pack_seed.sql`）+ 分科阈值覆盖  
- 缺语文/英语/化学等标准知识点树、题型目录、依赖边、阈值运营包  
- **产品可扩展 ≠ 内容已就绪**

### 3.4 角色与门户

| 角色 | 现状 | 缺口 |
|------|------|------|
| 管理员 / 教研 / 科任 / 班主任 / 校级领导 | SQL 角色与菜单较全 | 需用真实多班数据验收数据权限 |
| 学生 | 一生一册自助 + PDF | 缺练习入口、预警互动、移动端优先布局 |
| 家长 | **无登录角色 UI** | 仅 OpenAPI；无 H5/小程序/推送/认领预警 |

### 3.5 前后端表面不对称 / 薄页面

| 能力 | 问题 |
|------|------|
| 报告中心 `report/index.vue` | **已可筛选导出**单生/班级/档案 PDF·Excel；仍缺年级批量任务 |
| 班级干预摘要 / 错因热度 | 嵌在班级分析内，无独立教研专题页 |
| 题库框选标注 | 功能有，菜单发现性弱；**发布后会提示 Bloom 补标数量并引导去试卷管理** |
| Dashboard | 挂在首页，缺「校务运营大屏」级深度 |

### 3.6 导出与打印

- 已有：学生/班级/档案 PDF+XLSX、成绩/预警 Excel、频次 CSV、校次趋势 PDF  
- 缺口：报告中心**批量**导出、浏览器打印样式、家长侧 PDF、全校批量报告任务  
- **CJK 字体**：须打包 `fonts/spas-cjk.otf` 或配置 `spas.report.pdf-font-path`（见部署 §1.5）

### 3.7 通知与自动化

- 预警：系统通知 + **Webhook**（`spas.warning.webhook-url`）  
- 缺：短信 / 企微/钉钉内置适配 / 家长推送  
- 有：每日预警 Quartz、导入触发重算、**夜间全校重算** `spasRecalcTask`、干预异步评估  
- 缺：质量工单定时生成、家长摘要定时推送

### 3.8 安全与隐私

- 家长 Open 默认关闭；**演示 Open seed 已改为 `--with-demo` 可选**  
- 学生/家长手机：JSON `@Sensitive`；Open token 响应 **已脱敏**；写入侧有回写防护  
- DB 密码：`application-druid.yml` 改为环境变量占位；本地用 `.env.local`  
- 缺：同意书/留存策略、家长访问审计导出 UI、生产密钥轮换清单仍须人工执行

### 3.9 测试 / 国际化 / 运维文档

| 项 | 现状 |
|----|------|
| 自动化测试 | 后端单测偏分析公式；缺 Controller/预警引擎/报告 PDF 集成；无 spas Vue 测 |
| i18n | spas 页面硬编码中文 |
| 部署文档 | `docs/spas-deploy.md` 已含备份/任务/Open/字体；根目录 GameScreen checklist 勿用 |
| 监控备份 | 缺 SPAS 专用备份演练记录模板、任务失败外发告警、APM 指引 |

### 3.10 题库 / LLM / 图谱 / 错因

- 题库链路完整，但仍依赖 OCR 环境与 API Key 运营  
- LLM 仅辅助标注/建议，未进入报告叙事  
- 知识依赖边有 CRUD 与分析提示，缺独立图谱可视化页，内容仅 demo 级  
- 错因标签已落地，**无强制打标门禁、无校级错因专题报告**

---

## 4. 优先级建议

### P0 — 上线成熟度（建议上线前完成）

1. **运维清单矫正**：SPAS 备份/恢复、Quartz 健康检查、生产密钥；废弃或隔离无关 `deployment-checklist.md`  
2. **增量 SQL 验收**：按 `docs/spas-sql-checklist.md` 全量校验（可用 `sql/spas_apply_incremental.py --check`）  
3. **标注策略拍板**：生产是否将 Bloom 升硬门禁；质量看板 SLA  
4. **OpenAPI/隐私**：生产保持关闭直至密钥轮换与访问日志策略就绪  
5. **真实角色验收**：科任/班主任/领导在多班数据下的数据范围

### P1 — 产品完备性（下一版本）

1. 家长触达：H5/企微或明确「仅 API 对接」产品边界（承接 N7）  
2. ~~多学科内容包：知识树 + 题型 + 依赖边 + `subject-overrides`~~ → 附录 A（CHN/ENG/CHEM 精简包已落地）  
3. 预警多通道：短信/企微至少其一（Webhook 已落地，见附录 A）  
4. ~~定时全校重算 + 质量巡检自动化~~ → 附录 A（夜间重算任务）  
5. 学生端加深：练习入口、移动布局  
6. ~~报告中心产品化：筛选、批量导出~~ → 附录 A  
7. ~~学期/班级对比包（承接 N6 / D3）~~ → 附录 A（报告中心入口 + 章节进退 focus）  
8. 集成测试与 CI 冒烟（部分单测已补）  
9. ~~导出/UI 手机号脱敏与家长接口审计~~ → 附录 A

### P2 — 打磨与进阶

1. spas i18n  
2. 知识图谱可视化页  
3. 题库标注菜单可见性、组卷体验  
4. LLM 报告叙事（策略可控）  
5. 错因强制覆盖率 + 校级错因看板  
6. CRUD 移动端适配  
7. E10 / 在线考 / IRT（若未来纳入范围）  
8. APM、多校 SaaS（若需要）

---

## 5. 建议的对外「已完成 / 未纳入」边界声明

**已完成（可对外承诺）：**

- 校本小题成绩驱动的掌握度分析（含分科阈值、相对薄弱、覆盖率门禁）  
- 班级/学生分析、预警规则、干预闭环、一生一册与 PDF/Excel 导出  
- 实考校次导入与趋势诊断  
- 题库导入与 AI 辅助标注（需配置）  
- 家长只读 OpenAPI（需开通与对接）

**未纳入或仅部分完成（勿过度承诺）：**

- 家长 App、消息推送、短信预警  
- 跨年级一键对比产品包  
- 全学科开箱内容  
- Bloom 默认硬门禁、错因强制门禁  
- 在线考试、自适应、IRT、错因自动挖掘

---

## 6. 关键路径索引

| 主题 | 路径 |
|------|------|
| 前端业务页 | `ruoyi-ui/src/views/spas/` |
| 后端模块 | `ruoyi-spas/src/main/java/com/ruoyi/spas/` |
| 分析/门禁配置 | `ruoyi-admin/src/main/resources/application.yml`（`spas.paper` / `spas.analysis`） |
| 下一期规划 | `docs/spas-next-features.md` |
| SQL 清单 | `docs/spas-sql-checklist.md` |
| 开放接口 | `docs/spas-open-api.md` |
| 部署 | `docs/spas-deploy.md` |
| 可运营性报告 | `docs/spas-operability-interactivity-report.md` |
| 评测文档 | `docs/spas-evaluation-report.md` |

---

## 7. 结语

知脉已从「能演示的学情系统」走到「可试点落地的分析平台」。  
距离「完善成熟的量产产品」，关键缺口不是再堆一个分析图表，而是：**家长触达、学科内容运营、通知与运维隐私 hardening，以及把软门禁/薄入口页收成可验收的产品契约。**

建议按 **P0 → P1** 排期，并在版本说明中显式列出第 5 节边界，避免验收口径漂移。

---

## 附录 A · 本轮已落地（2026-09-25）

| 优先级 | 项 | 状态 |
|--------|----|------|
| P0 | 运维文档 `docs/spas-deploy.md`；废弃根目录 GameScreen checklist | 完成 |
| P0 | Bloom 默认硬门禁 `require-bloom-level: true` | 完成 |
| P0 | 家长手机 JSON/导出脱敏；OpenAPI `SPAS_OPEN_AUDIT` 访问日志 | 完成 |
| P1 | 夜间全校重算任务 `spasRecalcTask` + `sql/spas_recalc_job.sql` | 完成 |
| P1 | 预警 Webhook 通道（`spas.warning.webhook-url`，规则渠道含 `webhook`） | 完成 |
| P1 | 报告中心可筛选导出 PDF/Excel | 完成 |
| P1 | 学生一生一册：预警条、跳转详细分析/查题目 | 完成 |
| P1b | 多学科内容包 CHN/ENG/CHEM（`sql/spas_subject_pack_seed.sql` + yml `subject-overrides`） | 完成 |
| P1b | 学期对比入口：报告中心 `prev_semester` + 跳转分析页 `focus=chapterDelta` | 完成 |
| P1b | 预警规则 UI 勾选 system/webhook；`SpasWarningNotifyProperties` 单测 | 完成 |
| UX | 题库/组卷/标注公式渲染；题型全学科 backfill（`spas_subject_qtype_backfill.sql`） | 完成 |
| UX | 组卷卷面完整题面预览/本地打印；选题中心配图与选项详情；选项配图上传 | 完成 |
| P1 | 预警 Webhook 配置状态 API + 规则列表渠道列 + 未配置告警 | 完成 |
| Fix | 题型 choice/blank ↔ single/fill 别名；家长手机脱敏回写防护；题库发布 Bloom 导分提示 | 完成 |

仍待后续版本：家长 H5/推送（N7）、全量 CI 集成测试、更多学科细粒度教材包、报告批量任务、企微/短信通道等。
题库侧暂无 Bloom 字段——发布后接口返回 `noBloomCount` 并引导到分析卷补全（硬门禁开启时）。
性能：全校重算已改为按批加载得分行；连续下滑预警改为部门范围一次查询。
