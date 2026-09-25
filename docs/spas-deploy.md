# 知脉 · SPAS 生产部署与运维指南

> 本文替代根目录过时的 `deployment-checklist.md`（该文件属于无关遗留项目 GameScreen，**请勿用于本系统**）。

## 1. 上线前检查（P0）

### 1.1 配置

| 项 | 建议生产值 | 说明 |
|----|------------|------|
| `spas.open.enabled` | `false` | 家长 OpenAPI 默认关闭；对接完成并轮换密钥后再开 |
| `spas.paper.require-question-type` | `true` | 题型硬门禁 |
| `spas.paper.require-bloom-level` | `true` | **P0 起默认硬门禁**，避免能力层分析空转 |
| `spas.warning.webhook-url` | 可选 | 规则渠道勾选 `webhook` 时 POST JSON；也可用 `SPAS_WARNING_WEBHOOK_URL` |
| `spas.qb.ai.enabled` | `false` 或密钥走环境变量 | 勿把 API Key 写入仓库 |
| DB / Redis 密码 | 环境变量或密钥库 | 用 `SPAS_DB_*` / `.env.local`（已 gitignore），**勿提交真实密码** |
| Druid 控制台 | `SPAS_DRUID_STAT_ENABLED=false` | 默认关闭；开启时限制 `SPAS_DRUID_ALLOW` |
| `ruoyi.profile` | 独立上传目录 | 与开发机路径隔离 |

### 1.2 数据库

按顺序执行：`docs/spas-sql-checklist.md`。

多学科精简包（语文/英语/化学）：`sql/spas_subject_pack_seed.sql`（已纳入 `spas_apply_incremental.py --with-demo`）。

**注意：** `spas_open_seed.sql`（演示 Open 客户端）已降级为 `--with-demo` 可选，**勿在生产 REQUIRED 流程中自动灌入演示密钥**。

验收命令（仓库根目录）：

```bash
# 本地可先：set -a && source .env.local && set +a
python3 sql/spas_apply_incremental.py --check
```

未通过 `--check` 不得上线。

### 1.3 角色与数据权限

用真实多班数据分别登录验收：

- `admin` / `spas_admin`
- `spas_teacher`（科任）
- `spas_bzr`（班主任）
- 年级/校级领导角色
- `spas_student`（一生一册自助）

确认只能看到授权范围内的班级与学生。

### 1.4 演示账号（仅开发/验收）

见开发方案文档。生产环境须禁用或改密：`admin123`、`123456`、Open 演示客户端密钥。

### 1.5 PDF 中文字体（必验）

导出报告 / 一生一册 PDF 需要 CJK 字体，解析顺序：

1. `classpath:/fonts/spas-cjk.otf`（推荐打包进 jar）  
2. 配置 `spas.report.pdf-font-path`（绝对路径，支持 `ttc,0`）  
3. 本机常见字体（Windows 宋体/微软雅黑、macOS PingFang、Linux Noto/文泉驿）

上线冒烟必须点一次 PDF 导出；失败日志会提示字体路径。仓库 `fonts/NOTICE.txt` 说明字体授权，**勿提交未授权字体二进制到公共仓库时请确认许可**。

---

## 2. 备份与恢复

### 2.1 备份（建议每日 + 重大变更前）

```bash
# 逻辑备份（PostgreSQL）
pg_dump -Fc -h <host> -U <user> -d <db> -f spas_$(date +%Y%m%d_%H%M).dump

# 上传目录
tar -czf upload_$(date +%Y%m%d).tar.gz -C <ruoyi.profile> .
```

保留策略建议：日备 7 份、周备 4 份、月备 3 份。RPO 目标按校方要求（常见 ≤ 24h）。

### 2.2 恢复演练（每学期至少一次）

```bash
pg_restore -c -h <host> -U <user> -d <db> spas_YYYYMMDD.dump
# 再恢复上传目录，重启后端，抽测登录/分析/导出
```

记录演练日期与耗时（RTO）。

---

## 3. 定时任务健康

| Job | invoke_target | 建议 Cron | 作用 |
|-----|---------------|-----------|------|
| 预警引擎 | `spasWarningTask.run()` | `0 0 2 * * ?` | 每日评估预警规则 |
| 全校重算 | `spasRecalcTask.run()` | `0 30 2 * * ?` | 夜间全量掌握度快照（见 `sql/spas_recalc_job.sql`） |

检查：

1. 若依「定时任务」中状态为正常、最近执行成功  
2. 后端日志出现 `spasWarningTask.run created=` / `spasRecalcTask.run`  
3. 连续失败应告警（可对接现有日志/监控）

---

## 4. 家长 OpenAPI 安全

- 文档：`docs/spas-open-api.md`  
- 产品边界：当前为 **API 对接**，无官方家长 App（N7 延期）  
- 启用前：轮换 `client_secret`、限制来源 IP（如网关层）、确认访问审计日志  
- UI：`/spas/open` 显示运行时开关状态  

访问审计：后端对 `/open/v1/**` 成功鉴权请求写 `INFO` 审计日志（client/parent/path）。

---

## 5. 发布步骤（简版）

1. 备份库 + 上传目录  
2. `mvn -pl ruoyi-admin -am package -DskipTests`  
3. 执行增量 SQL（若有）并 `--check`  
4. 停服 → 替换 jar → 启服  
5. 冒烟：登录、发卷门禁、导入成绩、学生/班级分析、PDF、预警任务状态  
6. 前端 `npm run build:prod` 部署静态资源  

回滚：还原上一 jar + 上一 dump（若结构变更需同步回滚 SQL）。

---

## 6. 相关文档

| 文档 | 用途 |
|------|------|
| `docs/spas-sql-checklist.md` | SQL 顺序 |
| `docs/spas-open-api.md` | 家长接口 |
| `docs/spas-feature-gap-report.md` | 功能完备性与优先级 |
| `docs/spas-qb-ops-checklist.md` | 题库 OCR/AI 运维 |
