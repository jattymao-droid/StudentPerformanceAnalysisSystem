# 知脉 · SPAS SQL 清单

Use after base RuoYi import (`sql/init_postgresql.py`).

## 已有库不要重跑 spas_schema.sql

`spas_apply_incremental.py` 会从 `spas_schema.sql` 开始。库已经建过时，不要整包重跑，否则会因列已存在失败。
已部署环境只执行本次新增脚本，例如：

```bash
psql -U postgres -d spas-sql -f sql/spas_error_tag.sql
psql -U postgres -d spas-sql -f sql/spas_rank_warning_seed.sql
psql -U postgres -d spas-sql -f sql/spas_brand_zhimai.sql
```

全新空库仍可 `python sql/spas_apply_incremental.py`。

## Quick commands

```bash
# apply required incremental scripts (order fixed)
python sql/spas_apply_incremental.py

# optional demo data
python sql/spas_apply_incremental.py --with-demo

# verify key tables / columns / menus
python sql/spas_apply_incremental.py --check
```

## Required incremental order

| # | Script | Purpose |
| ---: | :--- | :--- |
| 1 | `spas_schema.sql` | Core SPAS tables |
| 2 | `spas_menu.sql` | Base menus |
| 3 | `spas_menu_buttons.sql` | Button perms |
| 4 | `spas_knowledge_node_type.sql` | Chapter / leaf node type |
| 5 | `spas_subject_question_type.sql` | Subject question types |
| 6 | `spas_teacher_dept.sql` | Teacher multi-class |
| 7 | `spas_teacher_migration.sql` | Teacher migration |
| 8 | `spas_teacher_roles.sql` | Teacher roles / menus |
| 8b | `spas_teacher_homeroom.sql` | Homeroom dept flag (dual 班主任+科任) |
| 9 | `spas_warning_job.sql` | Warning scheduler |
| 10 | `spas_score_revoke_fix.sql` | Score revoke |
| 11 | `spas_score_source.sql` | Score source column |
| 11b | `spas_score_detail_crud.sql` | 小题得分手工增删改权限 |
| 12 | `spas_intervene.sql` | Intervene loop |
| 13 | `spas_intervene_effect_json.sql` | Retest effect_json |
| 14 | `spas_intervene_knowledge.sql` | Intervene knowledge join (P2) |
| 15 | `spas_p1_score_reason.sql` | Score source absent/skip + warning reason_json |
| 16 | `spas_quality.sql` | Quality board |
| 17 | `spas_quality_ticket.sql` | Quality work-orders (P2) |
| 18 | `spas_report.sql` | Report export |
| 19 | `spas_analysis_frequency_menu.sql` | Knowledge frequency menu |
| 20 | `spas_open_seed.sql` | OpenAPI **演示**客户端（仅 `--with-demo`，生产勿默认灌入） |
| 20b | `spas_phase6_enhance.sql` | Open 管理菜单 2120–2128 + 学生导入导出按钮 |
| 21 | `spas_route_name_fix.sql` | Route name fix |
| 22 | `spas_ui_trim.sql` | UI / menu trim |
| 23 | `spas_exam_score_init.sql` | 实考分+校次表（幂等；`subject_name` 自由列） |
| 24 | `spas_menu_exam_score.sql` | 实考校次菜单与按钮权限 |
| 25 | `spas_error_tag.sql` | 轻量错因标签 |
| 26 | `spas_question_type_experiment.sql` | D1 实验题型 |
| 27 | `spas_error_cause_v2.sql` | D2 错因四级分类迁移 |
| 28 | `spas_bloom_level.sql` | D4 认知层级字段与字典 |
| 29 | `spas_knowledge_edge.sql` | D5 知识点前置依赖边 |
| 30 | `spas_brand_zhimai.sql` | 知脉品牌显示名（菜单根目录等） |
| 31 | `spas_qb_schema.sql` | 题库 Plan B：spas_qb_* + 分析卷桥接列 |
| 32 | `spas_qb_menu.sql` | 题库菜单 2300–2315 |
| 33 | `spas_qb_annotate.sql` | 可视框选：页图会话表 + 题目裁剪图字段 |
| 34 | `spas_qb_select_center.sql` | 选题中心菜单 + source_year/region/exam + section_json |
| 35 | `spas_qb_ai_config.sql` | 大模型配置菜单 118 + spas.qb.ai.* sys_config |
| 36 | `spas_report_hub.sql` | 报告导出目录可见 + 入口页组件 |
| 37 | `spas_recalc_job.sql` | 夜间全校掌握度重算定时任务 (job_id=101) |
| 38 | `spas_site_info.sql` | 登录页版权/ICP 参数 + 系统管理「站点信息」菜单 119 |
| 39 | `spas_group_practice.sql` | 班级分组 + 每日自主练打卡表/菜单（一体机客户端配套） |
| 40 | `spas_student_points.sql` | 学生积分账户/流水（打卡发分 + 掌握度进步发分 + 班内榜） |
| 41 | `spas_practice_checkout.sql` | 教师布置 + 组长检查单 + 抽检（见 `docs/spas-leader-check-spot-supervision.md`） |

全新环境也可直接执行 `spas_exam_score.sql`（会 DROP 重建）。旧库若仍含 `subject_id`，`spas_exam_score_init.sql` / `spas_exam_score_alter_subject_name.sql` 均可迁移。

可选预警种子（无新表）：`sql/spas_rank_warning_seed.sql`，见 `docs/spas-next-features.md`。  
多维学情（D1–D5）：见 `docs/spas-advanced-analysis-features.md`；已有库增量执行上表 26–29。  
题库方案 B：见 `docs/spas-question-bank-plan-b.md`；已有库增量执行上表 31–32。  
可视框选标注：已有库执行 `sql/spas_qb_annotate.sql`（脚本序号 33）。
选题中心/来源标签/大题分区：已有库执行 `sql/spas_qb_select_center.sql`（脚本序号 34）。

## Optional demo

`spas_school_dept_seed.sql`, `spas_demo_seed.sql`, `spas_knowledge_chapter_seed.sql`,
`spas_knowledge_edge_math_seed.sql`, `spas_knowledge_edge_physics_seed.sql`,
`spas_subject_pack_seed.sql`, teacher/class seeds, physics TOC seed.

### Existing DB patches (idempotent)

| 脚本 | 说明 |
|------|------|
| `spas_subject_qtype_backfill.sql` | 为仍缺题型的启用学科补默认题型（含 PHYS）；`pack_seed` 已同步为全学科 |

## After apply

1. Restart backend
2. Re-login (refresh menus / dicts)
3. Run `python sql/spas_apply_incremental.py --check` and expect all `OK`

See also: `docs/spas-evaluation-report.md` (P0 deploy item; P2 percentile / ticket / open status).

## Multi-exam weak (M series)

`docs/spas-multi-exam-weak-plan.md` S1–S5：**零 DDL**（趋势/反复薄弱/选卷诊断均为即时聚合，不新增快照表）。配置项见 `application.yml` → `spas.analysis.scope-max-papers` / `persistent-weak`。

OCR/LLM 运维见 [`spas-qb-ops-checklist.md`](./spas-qb-ops-checklist.md)。
