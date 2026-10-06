# 知脉 · 学生学情分析系统（SPAS）

**知脉** 是基于 **RuoYi-Vue 3.9.2 + PostgreSQL** 的中学学情分析平台：覆盖作业/考试管理、知识点标注、成绩导入、多维薄弱点分析、学情预警与「一生一册」，并配套 **班级分组 + 每日自主练**（组长座位检查、教师抽检、一体机结账）与家长端开放接口预留。

| 项 | 说明 |
| :--- | :--- |
| 产品名 | 知脉 |
| 仓库 | https://github.com/jattymao-droid/StudentPerformanceAnalysisSystem |
| 上游 | [RuoYi-Vue v3.9.2](https://gitee.com/y_project/RuoYi-Vue)（MySQL → PostgreSQL 适配） |
| 架构 | 前后端分离 · Spring Boot + Vue · Electron 一体机客户端 |
| 默认端口 | 后端 `8080` · 前端 `1024` |
| 数据库 | PostgreSQL · 默认库名 `spas-sql` |
| 技术代号 | SPAS（代码包 / API 路径 `/spas` / 表前缀 `spas_` 保持不变） |

[开发方案](./docs/学生学情分析系统-开发方案.md) · [部署说明](./docs/spas-deploy.md) · [SQL 清单](./docs/spas-sql-checklist.md) · [组长检查方案](./docs/spas-leader-check-spot-supervision.md) · [一体机方案](./docs/spas-group-daily-practice-desktop.md) · [OpenAPI](./docs/spas-open-api.md)

---

## 业务闭环

```text
学科 / 知识点树  →  试卷出题与知识点标注  →  小题成绩导入
        ↓                    ↓                    ↓
   组织与角色权限      一题多知识点（权重）      得分率分摊统计
        ↓                    ↓                    ↓
   学生 / 班级 / 年级分析看板  →  规则预警  →  一生一册 / 干预记录

补充主路径（行为监管，不替代对错批改）：
教师布置小任务 → 座位上组长/检查员翻本抽问 → 一体机登记检查单
        → 组员当日 PIN 确认/异议 → 教师风险抽检 → 组周达标 / 核实积分
```

本期明确不做：在线答题阅卷、自适应组卷、家长端 App（仅预留 `/open/v1/**` 契约）。  
自主练 **不等于** 试卷成绩：练习发生在座位，一体机只是结账点。

---

## 功能概览

| 模块 | 说明 |
| :--- | :--- |
| 学科管理 | 学科基础数据、题型配置 |
| 知识点 | 版本 → 章节 → 知识点树；支持人教版物理等 TOC 导入 |
| 学生 / 教师 | 组织树（学校→年级→班级）；学生绑定独立登录账号；教师可挂多班 |
| 试卷 / 作业 | 题目结构、难度；一题可绑定多个知识点并设权重；新建时可多班各生成一份 |
| 成绩导入 | Excel 按小题导入；支持班级路径预填 |
| 实考校次 | 各科实考分与校次宽表导入/导出（按班姓名匹配；同班同名可覆盖） |
| 学情分析 | 学生 / 班级 / 知识点多维统计与趋势 |
| 学情预警 | 规则配置、触发记录与处理 |
| 一生一册 | 学生档案；学生本人登录只读查看 |
| 命题质量 / 干预 | 试卷质量相关分析、辅导干预记录；困难可转干预 |
| **学习小组** | 同班同科分组（建议 4～6 人）、指定组长；一人一科一活跃组 |
| **每日自主练** | 教师布置书名/页码/题号与「已完成」定义；组长座位检查后上机登记；组员当日确认属实或异议 |
| **抽检与组达标** | 教师默认抽检队列（一致/偏松/偏严）；偏松作废并影响组周达标；困难摘要可「已知晓 / 转干预」 |
| **积分与等级** | 核实后发分（确认属实、交单、抽检一致等）；日封顶与 `biz_key` 幂等；掌握度进步可自动发分 |
| **一体机客户端** | `spas-desktop`：PIN 登录、登记检查结果、组员确认、加练、断网队列、Kiosk |
| 开放接口 | 家长端 Stub（`/open/v1/**`） |
| 系统管理 | 沿用若依：用户、角色、部门、菜单、字典、任务、监控、站点信息等 |

### 角色（节选）

| 角色 | role_key | 能力概要 |
| :--- | :--- | :--- |
| 管理员 | `admin` | 全模块 |
| 教务 | `spas_jw` | 学科、知识点、教师、成绩、分析、预警 |
| 任课教师 | `spas_teacher` | 本班/多班试卷、成绩、分析、自主练布置与抽检、预警处理 |
| 班主任 | `spas_bzr` | 本班学生、成绩、一生一册、预警；可催组未结账 |
| 年级 / 校级 | `spas_grade_leader` / `spas_school_leader` | 范围学情；校级默认只读 |
| 学生 | `spas_student` | 本人学情 / 一生一册；一体机 PIN 登录、确认检查结果、加练 |

---

## 技术栈

| 层 | 技术 |
| :--- | :--- |
| 后端 | Spring Boot 4.x · Spring Security · JWT · MyBatis · Druid · Redis · PageHelper |
| 业务模块 | `ruoyi-spas`（学情核心 · 自主练 / 分组 / 积分） |
| 前端 | Vue 2 · Element UI · ECharts · Vuex · Axios |
| 一体机 | Electron（`spas-desktop/`，触屏友好） |
| 数据库 | PostgreSQL 14+（推荐 16） |
| 环境 | JDK 17+ · Maven 3.8+ · Node.js 16+ · Redis · Python 3（可选，用于初始化脚本） |

---

## 快速开始

**前置**：本机已启动 PostgreSQL、Redis；已安装 JDK 17+、Maven、Node.js。

### 1. 克隆与配置

```bash
git clone https://github.com/jattymao-droid/StudentPerformanceAnalysisSystem.git
cd StudentPerformanceAnalysisSystem
```

数据库账号密码可用环境变量（推荐），勿写入仓库：

```bash
export SPAS_DB_USER=postgres
export SPAS_DB_PASSWORD=your_password
# 可选：SPAS_DB_URL=jdbc:postgresql://localhost:5432/spas-sql?stringtype=unspecified&TimeZone=Asia/Shanghai
```

也可编辑 `ruoyi-admin/src/main/resources/application-druid.yml` 中的 `password`。按需修改 `application.yml` 中的 `ruoyi.profile`（上传目录）与 Redis 连接。

### 2. 初始化数据库

```bash
python sql/init_postgresql.py
```

再导入学情业务表与菜单（按需追加演示数据）：

```bash
# 将密码换成你的
export PGPASSWORD=your_password
psql -U postgres -d "spas-sql" -v ON_ERROR_STOP=1 -f sql/spas_schema.sql
psql -U postgres -d "spas-sql" -v ON_ERROR_STOP=1 -f sql/spas_menu.sql
psql -U postgres -d "spas-sql" -v ON_ERROR_STOP=1 -f sql/spas_menu_buttons.sql
# 可选演示
psql -U postgres -d "spas-sql" -v ON_ERROR_STOP=1 -f sql/spas_subject_question_type.sql
psql -U postgres -d "spas-sql" -v ON_ERROR_STOP=1 -f sql/spas_demo_seed.sql
```

增量脚本（含分组 / 积分 / 检查单，推荐一条龙）：

```bash
python sql/spas_apply_incremental.py
# 或仅检查：python sql/spas_apply_incremental.py --check
```

与自主练直接相关的脚本：

| 脚本 | 说明 |
| :--- | :--- |
| `sql/spas_group_practice.sql` | 学习小组 + 自主练打卡基础表/菜单 |
| `sql/spas_student_points.sql` | 积分账户与流水 |
| `sql/spas_practice_checkout.sql` | 教师布置、组长检查单、抽检 |

完整清单见 [docs/spas-sql-checklist.md](./docs/spas-sql-checklist.md)。

### 3. 启动后端

```bash
mvn -pl ruoyi-admin -am package -DskipTests
java -jar ruoyi-admin/target/ruoyi-admin.jar
```

或在 IDE 中运行 `com.ruoyi.RuoYiApplication`。

后端：http://localhost:8080

### 4. 启动前端

```bash
cd ruoyi-ui
npm install
npm run dev
```

前端：http://localhost:1024

### 5. 启动一体机客户端（可选）

```bash
cd spas-desktop
cp config.example.json config.json   # apiBase 填 http://127.0.0.1:8080
npm install
# macOS / 部分 Cursor 环境需去掉 ELECTRON_RUN_AS_NODE：
env -u ELECTRON_RUN_AS_NODE npm start
```

Windows 安装包：`npm run dist:win`（建议在 Windows 上构建）。详见 [spas-desktop/README.md](./spas-desktop/README.md)。

---

## 默认账号

| 账号 | 密码 | 说明 |
| :---: | :---: | :--- |
| `admin` | `admin123` | 超级管理员 |
| `teacher001` / `bzr001` / `grade001` / `school001` | `123456` | 演示教师与管理角色（需导入对应 seed） |
| `demo001` 等 | `123456` | 演示学生（需导入对应 seed）；一体机可用学号 + PIN |

学生需先在 Web「每日自主练」中设置一体机 PIN。生产环境请修改默认密码；**勿将真实数据库口令提交到仓库**。

---

## 目录结构

```text
StudentPerformanceAnalysisSystem
├── ruoyi-admin          # 启动入口（含 PIN 登录等）
├── ruoyi-spas           # 学情业务（分析 / 预警 / 自主练 / 分组 / 积分）
├── ruoyi-system         # 若依系统模块
├── ruoyi-framework      # 安全、数据源、AOP
├── ruoyi-common         # 公共工具
├── ruoyi-quartz         # 定时任务
├── ruoyi-generator      # 代码生成
├── ruoyi-ui             # Vue 管理端（含 views/spas、api/spas）
├── spas-desktop         # Electron 一体机客户端
├── sql                  # PostgreSQL 脚本与增量工具
├── docs                 # 方案、部署、OpenAPI、验收
├── deploy               # 站点部署相关脚本
├── docker / Dockerfile  # 容器相关
└── scripts              # 辅助脚本
```

---

## 文档索引

| 文档 | 内容 |
| :--- | :--- |
| [学生学情分析系统-开发方案.md](./docs/学生学情分析系统-开发方案.md) | 目标、角色、领域模型、阶段计划 |
| [spas-leader-check-spot-supervision.md](./docs/spas-leader-check-spot-supervision.md) | **组长座位检查 + 教师抽检**（现行主路径） |
| [spas-group-daily-practice-desktop.md](./docs/spas-group-daily-practice-desktop.md) | 分组、自主练、一体机、积分背景方案 |
| [spas-desktop/README.md](./spas-desktop/README.md) | 一体机客户端安装与打包 |
| [spas-sql-checklist.md](./docs/spas-sql-checklist.md) | 增量 SQL 清单与自检 |
| [spas-deploy.md](./docs/spas-deploy.md) | 部署与演示账号提示 |
| [spas-open-api.md](./docs/spas-open-api.md) | 家长端开放接口说明 |
| [spas-acceptance.md](./docs/spas-acceptance.md) | 验收清单 |

---

## 常见问题

<details>
<summary>PostgreSQL：character = integer</summary>

PG 对类型更严格，`char` / 状态字段请用字符串比较：

```sql
-- 错误: status = 0
-- 正确: status = '0'
```

</details>

<details>
<summary>数据库名含连字符（spas-sql）</summary>

`psql -d` 与 JDBC URL 可直接使用；在 SQL 中引用库名时需双引号：`"spas-sql"`。

</details>

<details>
<summary>登录后没有学情 / 自主练菜单</summary>

确认已执行 `sql/spas_menu.sql`、按钮脚本，以及增量 `spas_group_practice.sql` / `spas_practice_checkout.sql`，并为角色分配对应菜单权限。可用 `python sql/spas_apply_incremental.py --check` 自检。

</details>

<details>
<summary>一体机打不开或 require('electron') 异常</summary>

部分环境会注入 `ELECTRON_RUN_AS_NODE=1`，请用：

```bash
env -u ELECTRON_RUN_AS_NODE npm start
```

并确认 `config.json` 中 `apiBase` 指向可访问的后端。

</details>

<details>
<summary>组长检查是线上还是线下？</summary>

**线下。** 翻本、抽问在座位完成；一体机只登记「人 × 状态 × 卡点」。详见 [组长检查方案](./docs/spas-leader-check-spot-supervision.md)。

</details>

---

## 致谢

本项目基于 [RuoYi-Vue](https://gitee.com/y_project/RuoYi-Vue) 二次开发，感谢原作者与社区。官方文档：http://doc.ruoyi.vip

## License

详见 [LICENSE](./LICENSE)。
