# 学生学情分析系统（SPAS）

基于 **RuoYi-Vue 3.9.2 + PostgreSQL** 的中学学情分析平台：覆盖作业/考试管理、知识点标注、成绩导入、多维薄弱点分析、学情预警与「一生一册」，并预留家长端开放接口。

| 项 | 说明 |
| :--- | :--- |
| 仓库 | https://github.com/jattymao-droid/StudentPerformanceAnalysisSystem |
| 上游 | [RuoYi-Vue v3.9.2](https://gitee.com/y_project/RuoYi-Vue)（MySQL → PostgreSQL 适配） |
| 架构 | 前后端分离 · Spring Boot + Vue |
| 默认端口 | 后端 `8080` · 前端 `1024` |
| 数据库 | PostgreSQL · 默认库名 `spas-sql` |

[开发方案](./docs/学生学情分析系统-开发方案.md) · [部署说明](./docs/spas-deploy.md) · [OpenAPI](./docs/spas-open-api.md) · [验收要点](./docs/spas-acceptance.md)

---

## 业务闭环

```text
学科 / 知识点树  →  试卷出题与知识点标注  →  小题成绩导入
        ↓                    ↓                    ↓
   组织与角色权限      一题多知识点（权重）      得分率分摊统计
        ↓                    ↓                    ↓
   学生 / 班级 / 年级分析看板  →  规则预警  →  一生一册 / 干预记录
```

本期明确不做：在线答题阅卷、自适应组卷、家长端 App（仅预留 `/open/v1/**` 契约）。

---

## 功能概览

| 模块 | 说明 |
| :--- | :--- |
| 学科管理 | 学科基础数据、题型配置 |
| 知识点 | 版本 → 章节 → 知识点树；支持人教版物理等 TOC 导入 |
| 学生 / 教师 | 组织树（学校→年级→班级）；学生绑定独立登录账号；教师可挂多班 |
| 试卷 / 作业 | 题目结构、难度；一题可绑定多个知识点并设权重 |
| 成绩导入 | Excel 按小题导入；支持班级路径预填 |
| 学情分析 | 学生 / 班级 / 知识点多维统计与趋势 |
| 学情预警 | 规则配置、触发记录与处理 |
| 一生一册 | 学生档案；学生本人登录只读查看 |
| 命题质量 / 干预 | 试卷质量相关分析、辅导干预记录 |
| 开放接口 | 家长端 Stub（`/open/v1/**`） |
| 系统管理 | 沿用若依：用户、角色、部门、菜单、字典、任务、监控等 |

### 角色（节选）

| 角色 | role_key | 能力概要 |
| :--- | :--- | :--- |
| 管理员 | `admin` | 全模块 |
| 教务 | `spas_jw` | 学科、知识点、教师、成绩、分析、预警 |
| 任课教师 | `spas_teacher` | 本班/多班试卷、成绩、分析、预警处理 |
| 班主任 | `spas_bzr` | 本班学生、成绩、一生一册、预警 |
| 年级 / 校级 | `spas_grade_leader` / `spas_school_leader` | 范围学情；校级默认只读 |
| 学生 | `spas_student` | 仅本人学情 / 一生一册 |

---

## 技术栈

| 层 | 技术 |
| :--- | :--- |
| 后端 | Spring Boot 4.x · Spring Security · JWT · MyBatis · Druid · Redis · PageHelper |
| 业务模块 | `ruoyi-spas`（学情核心） |
| 前端 | Vue 2 · Element UI · ECharts · Vuex · Axios |
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

编辑 `ruoyi-admin/src/main/resources/application-druid.yml`，将数据库密码改为本机值：

```yaml
spring:
  datasource:
    druid:
      master:
        url: jdbc:postgresql://localhost:5432/spas-sql?stringtype=unspecified&TimeZone=Asia/Shanghai
        username: postgres
        password: your_password
```

按需修改 `application.yml` 中的 `ruoyi.profile`（上传目录）与 Redis 连接。

### 2. 初始化数据库

脚本会读取 `application-druid.yml` 中的库名（默认 `spas-sql`），创建库并导入若依基础表：

```bash
python sql/init_postgresql.py
```

再导入学情业务表与菜单（按需追加演示数据）：

```bash
# Windows PowerShell 示例；将密码换成你的
$env:PGPASSWORD = "your_password"
psql -U postgres -d "spas-sql" -v ON_ERROR_STOP=1 -f sql/spas_schema.sql
psql -U postgres -d "spas-sql" -v ON_ERROR_STOP=1 -f sql/spas_menu.sql
psql -U postgres -d "spas-sql" -v ON_ERROR_STOP=1 -f sql/spas_menu_buttons.sql
# 可选：学科题型、组织/演示账号、知识点等
psql -U postgres -d "spas-sql" -v ON_ERROR_STOP=1 -f sql/spas_subject_question_type.sql
psql -U postgres -d "spas-sql" -v ON_ERROR_STOP=1 -f sql/spas_demo_seed.sql
```

更多脚本说明见 `sql/` 目录与 [开发方案](./docs/学生学情分析系统-开发方案.md)。

### 3. 启动后端

```bash
mvn clean package -DskipTests
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

---

## 默认账号

| 账号 | 密码 | 说明 |
| :---: | :---: | :--- |
| `admin` | `admin123` | 超级管理员 |
| `teacher001` / `bzr001` / `grade001` / `school001` | `123456` | 演示教师与管理角色（需导入对应 seed） |
| `demo001` 等 | `123456` | 演示学生（需导入对应 seed） |

生产环境请修改默认密码；**勿将真实数据库口令提交到仓库**。

---

## 目录结构

```text
StudentPerformanceAnalysisSystem
├── ruoyi-admin          # 启动入口
├── ruoyi-spas           # 学情业务（分析 / 预警 / 开放接口等）
├── ruoyi-system         # 若依系统模块
├── ruoyi-framework      # 安全、数据源、AOP
├── ruoyi-common         # 公共工具
├── ruoyi-quartz         # 定时任务
├── ruoyi-generator      # 代码生成
├── ruoyi-ui             # Vue 管理端（含 views/spas、api/spas）
├── sql                  # PostgreSQL 脚本与导入工具
├── docs                 # 方案、部署、OpenAPI、验收
├── docker / Dockerfile  # 容器相关
└── scripts              # 辅助脚本
```

---

## 文档索引

| 文档 | 内容 |
| :--- | :--- |
| [学生学情分析系统-开发方案.md](./docs/学生学情分析系统-开发方案.md) | 目标、角色、领域模型、阶段计划 |
| [spas-deploy.md](./docs/spas-deploy.md) | 部署与演示账号提示 |
| [spas-open-api.md](./docs/spas-open-api.md) | 家长端开放接口说明 |
| [spas-acceptance.md](./docs/spas-acceptance.md) | 验收清单 |
| [spas-open-api.postman_collection.json](./docs/spas-open-api.postman_collection.json) | Postman 集合 |

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
<summary>登录后没有学情菜单</summary>

确认已执行 `sql/spas_menu.sql`（及按钮脚本），并为角色分配对应菜单权限。

</details>

---

## 致谢

本项目基于 [RuoYi-Vue](https://gitee.com/y_project/RuoYi-Vue) 二次开发，感谢原作者与社区。官方文档：http://doc.ruoyi.vip

## License

详见 [LICENSE](./LICENSE)。
