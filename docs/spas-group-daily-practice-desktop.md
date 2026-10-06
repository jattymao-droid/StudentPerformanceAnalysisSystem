# 知脉 · 班级分组 + 每日薄弱自主练 + 一体机桌面端 · 开发方案

> 文档编码：UTF-8  
> 版本：v1.5 · 日期：2026-10-04  
> 依托：现有 RuoYi-Vue + PostgreSQL + `ruoyi-spas`（试卷/成绩 → 知识点掌握度 → 薄弱/干预）  
> 前置文档：`docs/学生学情分析系统-开发方案.md`、`docs/二期增强功能-开发方案.md`  
> 目标：在一体机上让**学生/组长便捷登录并登记每日自主练作业**；教师可对班级做**分组管理**；记录可落到**知识主题 + 书名/页码/题号**；并以**异常驱动**方式提升学习监管有效性（未交 / 有困难 / 代提过多 / 练了仍弱）。  
> 监管主路径改进（组长检查单 + 教师风险抽检）：`docs/spas-leader-check-spot-supervision.md`

---

## 0. 需求解读（产品结论）

| 编号 | 用户诉求 | 产品落点 |
| :--- | :--- | :--- |
| R1 | 学生便捷提交作业；Windows 桌面端装到一体机 | 专用 **Win 桌面客户端（触屏友好）** + 云端 API；一体机固定放教室，支持学号/姓名快速登录或扫码/PIN |
| R2 | 对班级学生分组管理 | Web 管理端「班级分组」；组挂在班级（`sys_dept`）下，不新建部门 |
| R3 | 组长或组员登录并提交作业完成情况 | 组员均可提交本人记录；**组长可代本组成员登记**（可审计、可撤回） |
| R4 | 每天针对薄弱知识点自主找题训练，并记录主题与书本页题 | 「每日自主练打卡」：选薄弱主题 → 填教材/教辅名、页码、题号范围 → 可选完成度/自评 |

**业务本质：** 这不是「在线答题/自动阅卷」，而是 **线下自主练的结构化打卡与班级协同**。与现有「教师建卷 → Excel 导入小题分」互补，不替代。

**产品定位一句话：** 一体机负责**降低登记成本**；Web 负责让教师**30 秒内知道今天该找谁**——先做「学习行为管理系统」，再逐步接到「学习效果引擎」。

---

## 0A. 学习有效性评估（对学生是否有帮助）

### 0A.1 结论

本设计**有助于把学习行为组织起来、提高完成率**，但对「真正学会」在一期（只打卡、不核对对错）下只是**弱促进**。若停留在打卡，容易变成形式；须配套反馈、抽查与学情对照，才更有学习价值。

### 0A.2 为什么可能有用

| 点 | 说明 |
| :--- | :--- |
| 对准薄弱点 | 用 weak-top 作为「今日建议练」，比盲目刷整本更接近针对性巩固 |
| 可见习惯 | 一体机 + 组长协同，降低「忘了交、懒得记」；环境固定、流程短、同伴可见，完成率通常更高 |
| 小组与组长 | 同侪催交对自律弱的学生往往比教师一对一盯更可持续 |
| 书名/页码/题号 | 可复查痕迹，比只勾「已完成」更难空打卡，也便于讲评定位原题 |

### 0A.3 为什么对「学会」帮助有限（须正视）

| 点 | 说明 |
| :--- | :--- |
| 一期不进掌握度、不核对对错 | 系统只知「声称练了什么」，不知「做对多少」；有反馈的练习才显著提分 |
| 自主找题质量不可控 | 可能选简单题、重复旧题，或主题对了但题不对点 |
| 代提双刃剑 | 方便一体机，也可能组长代全体「交作业」，本人零投入 |
| 形式主义风险 | 表单过繁挤占真实练习；只追提交率会优化「交上」而非「学会」 |
| 动机外在化 | 看板/未交名单是外部压力；缺少进步感时易倦怠或造假 |

### 0A.4 效果粗评

| 维度 | 本设计大概效果 |
| :--- | :--- |
| 练的频率 / 完成率 | **较强** |
| 练的针对性（对准薄弱） | **中等**（依赖建议被认真用、选题靠谱） |
| 练的质量（懂与会） | **偏弱**（缺对错与反馈；靠抽查与困难备注补） |
| 长期习惯与内驱 | **看落地**（有复盘/进步可见才稳） |

**总评：** 更像「学习行为管理」，还不是完整「学习效果引擎」；对促进学习是必要条件的一部分，不是充分条件。以下 **§0B 监管增强** 与 **§0C 最小有效监管包** 用于把打卡接到有效督导。

---

## 0B. 学习监管增强方案（如何盯得更有效）

监管目标：**学习过程可看见、异常可催办、效果可对照**——不是多几个字段，而是让教师少翻明细、多处理名单。

### 0B.1 监管分层（别盯所有人）

| 层级 | 盯什么 | 谁处理 |
| :--- | :--- | :--- |
| 全班 | 当日/本周提交率 | 班主任一眼看板 |
| 小组 | 组提交率、连续未交 | 组长先催，教师看异常组 |
| 个人 | 连续 N 天未打卡、长期「有困难」、薄弱无改善 | 教师点名 / 转干预 |

原则：**默认看异常名单，不默认翻全班明细**。

### 0B.2 打卡可信度（从「交了」到「可信」）

1. **完成三态 + 困难必填**：已完成 / 部分完成 / 有困难；选「有困难」必须填卡点（题号或一句话）。  
2. **代提受限与标红**：代提记录标红；同一学生连续 3 天被代提 → 进入教师「代提过多」名单。  
3. **抽查**：教师每周随机抽 2～3 人，对照书页口头问或收练习；系统记「抽查通过 / 存疑」。  
4. **时间窗**：课堂时段提交标「当堂」；深夜补打可交但降权显示（降低代打/空刷观感）。  

没有抽查，监管会被「空打卡」击穿。

### 0B.3 与现有学情打通（行为 × 结果）

| 维度 | 指标 | 用途 |
| :--- | :--- | :--- |
| 行为 | 本周自主练天数；主题与 weak-top 重合度 | 是否在练、是否练对主题 |
| 结果 | 新成绩导入后对应知识点 `avg_rate` 是否上升 | 练了有没有会 |
| 闭环 | 仍弱 + 很少练 → 干预待办；常练仍弱 → 提示方法问题、转辅导 | 催交与辅导分流 |

教师监管页建议三列：**未交 | 有困难 | 练了仍弱**。比单一提交率有用得多。

### 0B.4 小组监管用法

- 组长职责：**催交 + 汇总困难**，不负责讲题对错（减少造假动机与负担）。  
- 教师先看「组」：某组连续落后 → 找组长；个人问题 → 找学生。  
- 用**达标制**（如「本组本周全员 ≥4 次」），避免公开羞辱式全班倒排。

### 0B.5 教师侧：少操作、多自动

- 每日自动生成：**未交名单**（可一键复制到班级群）。  
- 规则预警：连续 2 天未交；连续 3 天「有困难」；本周练习主题与薄弱 Top5 重合度 &lt; 30%。  
- 一键：**转干预任务**（复用 `/spas/intervene`）。  
- 周报：每生「应练 / 实练 / 困难次数 / 薄弱是否改善（有新成绩时）」。

**有效监管公式：** 系统先筛人，教师只处理名单。

### 0B.6 明确不建议

- 只靠提交率排名当唯一考核  
- 打卡直接计入掌握度（无对错会污染分析）  
- 每日超复杂表单（挤占真实练习）  
- 未经校方确认的家长端实时催作业（易变家校冲突）

---

## 0C. 最小有效监管包（P0 优先交付）

若资源有限，**优先做下面 5 项**（性价比最高）：

| 编号 | 能力 | 说明 | 建议阶段 |
| :--- | :--- | :--- | :--- |
| S1 | 三列异常看板 | 未交 / 有困难 / 代提过多 | **P0-B** |
| S2 | 连续未交标红 + 名单导出 | 连续 2 天未交；一键复制/导出 | **P0-B** |
| S3 | 「有困难」进待办，可转干预 | 困难备注必填；一键 `/spas/intervene` | **P0-B / P1** |
| S4 | 主题 vs 薄弱重合度（周） | 周维度统计，&lt;30% 标关注 | **P0-B** |
| S5 | 抽查结果字段 | 通过 / 存疑；支持周随机名单 | **P0-B** |

配套产品规则（写入实现与文案）：

- 打卡后鼓励填**轻反馈**（可选）：「大约对了几成」或「最卡一题」（一期可不进掌握度）。  
- 代提：允许代填完成情况，但代提过多进 S1；P1 可加「组员次日确认」。  
- 进步可见（P1）：有新成绩时展示「练过的主题掌握度是否上升」。

---

## 1. 现状与差距

### 1.1 可复用能力

| 能力 | 现状 | 复用方式 |
| :--- | :--- | :--- |
| 班级组织 | `sys_dept`（校→年级→班） | 分组、打卡均按 `dept_id` 隔离 |
| 学生身份 | `spas_student` ↔ `sys_user`，角色 `spas_student` | 桌面端走同一套 JWT `/login` |
| 教师权限 | `spas_teacher` + 班级绑定 + `SpasAccessService` | Web 端分组 CRUD、班级打卡看板 |
| 薄弱知识点 | `/spas/analysis/student/{id}/weak-top`、班级 weak-top | 打卡页「今日建议练」默认带出薄弱主题 |
| 知识点树 | `spas_knowledge` | 主题选择器（章节只读、末级可选） |
| 作业卷类型 | `spas_paper.paper_type=2` | **仅作对照语义**；自主练打卡**不默认**新建试卷 |

### 1.2 缺失能力（本期新建）

| 缺口 | 说明 |
| :--- | :--- |
| 学生小组 | 无 `group` 表/API/UI |
| 自主练打卡 | 无书名/页码/题号提交模型；现有成绩链是「卷题得分」 |
| 一体机客户端 | 仅 Web；OpenAPI 面向家长只读，不适合教室一体机 |
| 组长代提 | 无组成员角色与代提审计 |

### 1.3 关键决策（需立项时确认）

| 决策项 | 推荐结论 | 备选 | 影响 |
| :--- | :--- | :--- | :--- |
| D1 桌面端技术 | **Electron + Vue**（复用 ruoyi-ui 组件与 API 封装，触屏大按钮皮肤） | .NET WPF / WinUI | Electron 交付快；体积更大，需签名与静默更新 |
| D2 打卡是否进掌握度 | **一期只存打卡证据，不进 `KnowledgeStatCalculator`** | 二期可选「教师确认后合成 homework 卷」 | 避免无满分/未对答案的脏数据污染薄弱分析 |
| D3 组长权限 | 组长可代提本组成员；代提标红，连续过多进异常名单；不可改他人密码 | 仅本人提交 | 一体机场景更顺；用监管包防代提滥用 |
| D4 教材库 | 一期 **自由文本书名** + 班级常用书名联想 | 二期建校级教材目录 | 降低录入成本，避免强依赖教材主数据 |
| D5 一体机账号模式 | 学生个人登录（学号+初始密码/PIN）为主；可选「一体机公共会话 + 学号切换」 | 仅公共账号 | 个人登录权限清晰、审计完整 |

---

## 2. 建设目标与范围

### 2.1 本期目标（P0）

1. **班级分组管理（Web）**：教师按班建组、指定组长、拖拽/勾选分组成员。  
2. **每日自主练打卡（API + 桌面端）**：登录 → 看本人/本组薄弱建议 → 登记知识主题 + 书名 + 页码 + 题号 → 提交；「有困难」必填卡点备注。  
3. **组长代提**：选组员 → 代填打卡；记录 `submit_by` / `proxy_flag`；代提过多进异常名单。  
4. **教师监管看板（Web）**：落实 **§0C 最小有效监管包（S1～S5）**——未交 / 有困难 / 代提过多、连续未交导出、主题-薄弱重合度、抽查结果；提交率仅作辅助指标。  
5. **（可选同期）轻反馈字段**：自评对了几成 / 最卡一题（不进掌握度）。

### 2.2 本期不做

- 在线作答、拍照阅卷、自适应抽题  
- 把打卡自动计入掌握度快照（见 D2）  
- 家长端实时催作业（除非校方单独立项）  
- 以提交率公开全班倒排作为唯一考核  
- Android/iOS 移动端（可后续复用同一 API）  
- 跨校区教材版权题库对接  

### 2.3 角色与权限

| 角色 | 能力 |
| :--- | :--- |
| 任课教师 / 班主任 | 本班分组 CRUD；监管看板（异常三列）；抽查录入；转干预；名单导出 |
| 年级 / 教务 / 校领导 | 只读统计（按现有数据范围） |
| 学生（组员） | 桌面端登录；提交**本人**打卡；查看本人历史与薄弱建议 |
| 学生（组长） | 组员能力 + 代提本组成员打卡 + 查看本组当日提交情况（催交，不负责判题） |
| 一体机 | 无独立系统账号；使用学生账号；可登记 `device_code` 便于运维 |

权限字建议：

```
spas:group:list / add / edit / remove
spas:practice:list / add / edit / remove / proxy
spas:practice:stat
spas:practice:spot     # 抽查录入
spas:practice:device   # 可选：一体机设备登记
```

菜单建议：

- 知脉 / 教务业务 / **班级分组**  
- 知脉 / 教务业务 / **自主练打卡**（教师看板）  
- 学生端菜单「我的学情」下增加 **每日自主练**（Web 备用；一体机用桌面端）

---

## 3. 业务场景与流程

### 3.1 教师：分组

```
选班级 → 新建组（如「物理1组」）→ 勾选学生 → 指定 1 名组长
         → 可调整成员 / 更换组长 / 解散组（历史打卡保留 group_id 快照名）
```

规则：

- 同一学科维度下，一名学生**同时只属于一个活跃组**（推荐按「班级 + 学科」约束；若不分科则按班级约束）。  
- 组长必须是组内成员。  
- 调班后：学生离开原班组（标记退出），须教师重新编入新班组。

### 3.2 学生/组长：一体机打卡（主路径）

```
打开桌面端 → 学号登录（或扫学生码）
  → 首页展示：今日是否已打卡、薄弱 TopN（来自 analysis weak-top）
  → 「登记今日自主练」
       · 学科（可默认上次）
       · 知识主题（多选，优先薄弱；也可自选知识点树）
       · 书本名称（输入 + 本班高频联想）
       · 页码起止（如 32–35）
       · 题号描述（如 1,2,5 / 练习三第 4 题）
       · 完成情况：已完成 / 部分完成 / 遇到困难（枚举）
       · 可选备注、用时（分钟）
  → 提交成功 → 展示本组今日提交进度（组长可见未交名单）
```

组长代提：

```
组长登录 → 「帮组员登记」→ 选组员 → 同上表单 → 提交（proxy=true）
```

### 3.3 教师：监管与督促（异常驱动）

```
打开「自主练打卡」看板 → 默认落在异常三列（未交 | 有困难 | 代提过多）
  → 未交：一键复制名单 / 导出；连续 2 天未交标红
  → 有困难：查看卡点备注 → 一键转干预任务（绑定 knowledge_ids）
  → 代提过多：约谈学生或限制代提
  → 「练了仍弱」（有新成绩时）：转辅导，而非继续催交
抽查：系统可生成周随机名单 → 教师录入「通过/存疑」
周报：应练 / 实练 / 困难次数 / 主题-薄弱重合度 / 薄弱是否改善
```

组长侧：只看本组已交/未交与困难汇总，不承担全班排名压力。

---

## 4. 数据模型（建议）

> 库：PostgreSQL。脚本建议：`sql/spas_group_practice.sql`。  
> 命名前缀统一 `spas_`。

### 4.1 班级分组

```sql
-- 学习小组
create table spas_study_group (
  group_id      bigserial primary key,
  dept_id       int8 not null,          -- 班级
  subject_id    int8,                   -- 可空：空=不分科通用组
  group_name    varchar(64) not null,
  leader_student_id int8,               -- 组长 spas_student.student_id
  status        char(1) default '0',    -- 0正常 1停用
  sort_order    int4 default 0,
  create_by     varchar(64),
  create_time   timestamp,
  update_by     varchar(64),
  update_time   timestamp,
  remark        varchar(500)
);
create index idx_spas_study_group_dept on spas_study_group(dept_id, subject_id);

-- 组成员（含进组/出组时间，便于审计）
create table spas_study_group_member (
  id            bigserial primary key,
  group_id      int8 not null,
  student_id    int8 not null,
  role_in_group char(1) default '0',    -- 0组员 1组长
  join_time     timestamp default now(),
  leave_time    timestamp,              -- 非空表示已退出
  unique(group_id, student_id)
);
create index idx_spas_sgm_student on spas_study_group_member(student_id);
```

**约束（服务层）：** 同一 `(dept_id, subject_id)` 活跃期内，一名学生仅能出现在一个组的 `leave_time is null` 记录中。

### 4.2 每日自主练打卡

```sql
-- 打卡主表（一天一人一科可多条；默认建议一人一科一天一条，允许多书）
create table spas_practice_log (
  log_id        bigserial primary key,
  practice_date date not null,          -- 业务日（教室本地日）
  dept_id       int8 not null,
  group_id      int8,                   -- 提交时所属组（可空：未分组也可打卡）
  student_id    int8 not null,
  subject_id    int8 not null,
  book_name     varchar(200) not null,  -- 书本/教辅名称
  page_from     int4,                   -- 起始页
  page_to       int4,                   -- 结束页
  question_text varchar(500) not null,  -- 题号描述（自由文本，规范化提示）
  finish_status char(1) not null,       -- 1已完成 2部分 3有困难
  difficulty_note varchar(500),         -- 有困难时必填：卡点题号或一句话
  self_correct_rate numeric(5,2),       -- 可选轻反馈：自评正确率 0~1，不进掌握度
  hardest_question  varchar(200),       -- 可选：最卡一题描述
  duration_min  int4,                   -- 用时分钟，可选
  submit_slot   char(1) default '0',    -- 0当堂 1补打（按配置时间窗判定）
  submit_by_student_id int8 not null,   -- 实际操作人（本人或组长）
  proxy_flag    char(1) default '0',    -- 0本人 1代提
  client_type   varchar(20),            -- desktop / web
  device_code   varchar(64),            -- 一体机编号，可选
  spot_status   char(1) default '0',    -- 0未抽查 1通过 2存疑
  spot_by       varchar(64),            -- 抽查教师
  spot_time     timestamp,
  spot_remark   varchar(500),
  status        char(1) default '0',    -- 0有效 1作废
  create_time   timestamp,
  update_time   timestamp,
  remark        varchar(500)
);
create index idx_spas_plog_day_dept on spas_practice_log(practice_date, dept_id);
create index idx_spas_plog_student on spas_practice_log(student_id, practice_date);

-- 打卡关联知识主题（多对多）
create table spas_practice_log_knowledge (
  id            bigserial primary key,
  log_id        int8 not null,
  knowledge_id  int8 not null,
  is_primary    char(1) default '0',
  unique(log_id, knowledge_id)
);
```

### 4.3 书名联想（轻量）

```sql
-- 班级常用书名（提交时 upsert 计数）
create table spas_practice_book_stat (
  id            bigserial primary key,
  dept_id       int8 not null,
  subject_id    int8 not null,
  book_name     varchar(200) not null,
  use_count     int4 default 1,
  last_used     timestamp,
  unique(dept_id, subject_id, book_name)
);
```

### 4.4 一体机设备（可选 P1）

```sql
create table spas_kiosk_device (
  device_id     bigserial primary key,
  device_code   varchar(64) unique not null,
  device_name   varchar(100),
  dept_id       int8,                   -- 常驻教室班级
  status        char(1) default '0',
  last_seen     timestamp,
  remark        varchar(500)
);
```

### 4.5 与掌握度的关系（二期可选）

若未来要将「教师确认的自主练」并入掌握度，建议**不要**直接改 `spas_score_detail`，而是：

1. 教师在看板上「确认有效」→ 生成 `spas_paper(paper_type=2)` 快照卷 + 虚拟小题（按主题拆）+ `score_source=self_practice`；或  
2. 新增独立证据表 `spas_practice_evidence`，扩展 `KnowledgeStatCalculator` 读取（需单独算法与权重）。

**一期明确：只做打卡与统计，不进加权掌握度。**

---

## 5. 接口设计（草案）

基路径建议：`/spas/group/**`、`/spas/practice/**`。鉴权：Bearer JWT。写操作走 `SpasAccessService.assertCanWrite()` / 学生本人或组长校验。

### 5.1 分组（教师 Web）

| 方法 | 路径 | 说明 |
| :--- | :--- | :--- |
| GET | `/spas/group/list?deptId=&subjectId=` | 班内组列表（含人数、组长名） |
| GET | `/spas/group/{groupId}` | 组详情 + 成员 |
| POST | `/spas/group` | 新建组 |
| PUT | `/spas/group` | 改名/换组长/启停 |
| DELETE | `/spas/group/{ids}` | 解散（软停用） |
| PUT | `/spas/group/{groupId}/members` | 全量覆盖成员列表 |
| GET | `/spas/group/unassigned?deptId=&subjectId=` | 未入组学生 |

### 5.2 打卡（桌面端 + Web）

| 方法 | 路径 | 说明 |
| :--- | :--- | :--- |
| GET | `/spas/practice/mine/today` | 当前学生今日记录 + 所在组进度 |
| GET | `/spas/practice/suggest/weak` | 包装 weak-top，返回建议主题 |
| GET | `/spas/practice/books/suggest?deptId=&subjectId=&q=` | 书名联想 |
| POST | `/spas/practice` | 本人提交 |
| POST | `/spas/practice/proxy` | 组长代提（body 含 `studentId`）；写入 `confirm_status=1` 待组员次日确认 |
| PUT | `/spas/practice/proxy/{logId}/confirm` | 组员次日确认/驳回（`accept` true/false；驳回作废） |
| GET | `/spas/practice/proxy/pending` | 本人待确认代提列表 |
| PUT | `/spas/practice/pin` | 学生设置/修改一体机 PIN（4～6 位） |
| GET | `/spas/practice/pin/status` | 是否已设置 PIN |
| POST | `/spas/practice/pin/login` | **匿名** PIN 快捷登录（学号+PIN，限流） |
| PUT | `/spas/practice/{logId}` | 当日可改（本人或代提人；超时可禁改） |
| DELETE | `/spas/practice/{logId}` | 作废（status=1） |
| GET | `/spas/practice/group/today` | 组长：本组提交情况 |
| GET | `/spas/practice/list` | 教师分页查询 |
| GET | `/spas/practice/stat/daily` | 教师：按日提交率/分组统计 |
| GET | `/spas/practice/stat/alerts` | **监管包 S1～S4**：未交、有困难、代提过多、连续未交、周重合度低 |
| GET | `/spas/practice/stat/spot-sample` | **S5**：生成周随机抽查名单 |
| PUT | `/spas/practice/{logId}/spot` | **S5**：录入抽查结果（通过/存疑） |
| POST | `/spas/practice/alert/{studentId}/to-intervene` | **S3**：有困难/练了仍弱 → 转干预 |

### 5.3 桌面端登录

复用现有：

- `POST /login`（学号/用户名 + 密码）  
- `GET /getInfo`、`GET /getRouters`（桌面端可忽略菜单，只用角色与 `studentId`）  
- 学生档案：现有学生查询或新增 `GET /spas/practice/session/profile` 返回 `studentId/deptId/groupId/isLeader`

一体机增强（P1）：

- 登录后上报 `device_code`  
- 可选 PIN 快捷登录（需另表存 PIN 哈希，严格限流）

---

## 6. 客户端方案（Windows 一体机）

### 6.1 形态

| 项 | 建议 |
| :--- | :--- |
| 技术 | Electron 28+ / Vue 2（与 ruoyi-ui 同栈）或独立 Vue3+TS |
| 安装 | NSIS / squirrel 安装包；开机自启；Kiosk 全屏可选 |
| 更新 | `electron-updater` + 静态资源托管（如 `xq.xmls.vip/client/`） |
| 分辨率 | 按 1080P/4K 触屏做大字号、≥48px 点击热区 |
| 网络 | 仅 HTTPS 调云 API；断网本地队列（P1） |

### 6.2 界面结构（少而大）

1. **登录页**：学号、密码/PIN、软键盘  
2. **首页**：欢迎语、今日状态、薄弱建议卡片、两个主按钮「本人打卡」「帮组员打卡」（非组长隐藏后者）  
3. **打卡表单**：分步或单页大表单；「有困难」展开必填卡点；可选轻反馈；提交二次确认  
4. **本组看板**：头像/姓名 + 已交/未交（达标制文案，不做羞辱排行）  
5. **历史**：最近 7 天本人记录  

### 6.3 运维

- 每台一体机配置：`API_BASE`、`DEVICE_CODE`、默认班级（可空）  
- 日志目录、崩溃上报  
- 账号策略：学生初始密码与 Web 一致；教室场景建议强制首次改密或 PIN  

### 6.4 仓库建议

新建目录（与后端解耦）：

```
spas-desktop/          # Electron 工程
  package.json
  src/main/
  src/renderer/        # 打卡 UI
docs/spas-group-daily-practice-desktop.md  # 本文档
```

---

## 7. Web 管理端（ruoyi-ui）

| 页面 | 路径建议 | 功能 |
| :--- | :--- | :--- |
| 班级分组 | `views/spas/group/index.vue` | 左班树/我的班级，右组卡片+成员穿梭框 |
| 自主练监管看板 | `views/spas/practice/index.vue` | **默认异常三列**（未交/有困难/代提过多）；提交率辅栏；明细、抽查、导出、转干预 |
| 学生 Web 备用 | `views/spas/practice/mine.vue` | 无一体机时用浏览器打卡（可选同期交付） |

看板交互要点：

- 进入页面默认 Tab =「异常」，不要默认「全班明细」  
- 未交名单支持一键复制文本（方便贴班级群）  
- 「有困难」行展示 `difficulty_note`，按钮「转干预」  
- 代提记录行样式标红；连续代提计数可见  
- 抽查：显示本周待抽名单，行内录入通过/存疑  

与分析联动：

- 打卡明细中的 `knowledge_id` 可跳转学生薄弱页  
- 「练了仍弱」依赖新成绩重算后的 weak-top 对比（P1 可做自动标签；P0 可先人工对照）  
- 「一键转干预」调用现有 `/spas/intervene`

---

## 8. 后端模块划分（ruoyi-spas）

```
domain/
  SpasStudyGroup.java
  SpasStudyGroupMember.java
  SpasPracticeLog.java
  SpasPracticeLogKnowledge.java
mapper/ + resources/mapper/spas/
service/
  ISpasStudyGroupService / Impl
  ISpasPracticeLogService / Impl
controller/
  SpasStudyGroupController
  SpasPracticeLogController
support/
  SpasGroupAccessHelper   # 是否同组、是否组长、代提校验
```

关键校验：

1. 代提：操作者必须是目标学生当前活跃组的组长，且同 `dept_id`。  
2. 学生写本人：`student.user_id == 当前用户`。  
3. 教师读班：现有 `checkDeptAccess(deptId)`。  
4. `practice_date` 默认服务器「亚洲/上海」当天；允许补打昨天（可配置窗口，如 36 小时）；补打标记 `submit_slot=1`。  
5. `finish_status=3`（有困难）时 `difficulty_note` 非空。  
6. 监管规则（可配置，默认如下）：连续未交 ≥2 天；连续被代提 ≥3 天；周主题与薄弱 Top5 重合度 &lt; 30%。

---

## 8B. 学生积分与等级（班内榜）

> SQL：`sql/spas_student_points.sql`（清单序号 40）  
> 原则：积分与掌握度解耦（打卡不写 `avg_rate`）；流水 `biz_key` 幂等；每日硬顶防刷。

### 8B.1 发分规则（默认）

| 事件 | 分值 | 说明 |
| :--- | ---: | :--- |
| 当日首条本人打卡（按 student+subject+date） | +10 | 含连击加成见下 |
| 同日额外打卡 | +3 | 每日额外最多 2 次 |
| 主题命中 weak-top | +5 | 按 log 幂等 |
| 连续打卡 ≥2 天 | +2×min(streak,7) | 仅记在当日首条 |
| 代提 | 本人规则 ×50% | **确认后**发放 |
| 掌握度进步（近 14 天练过的知识点升幅 ≥0.05） | +15 | 每知识点每 14 天窗口一次 |

每日积分硬顶 **40**（超出记 0 分流水并备注 capped）。  
等级：`level = 1 + floor((sqrt(1+8*total/50)-1)/2)`。

### 8B.2 API

- `GET /spas/practice/points/mine` — 本人账户 + 今日分 + 等级进度  
- `GET /spas/practice/points/ledger` — 近 30 条流水  
- `GET /spas/practice/points/leaderboard?deptId=&range=week|all` — 班内榜（学生默认本班；教师需班权限）  
- 打卡/代提确认响应附带 `awardedPoints`

### 8B.3 界面

- 一体机首页：等级条、积分规则折叠说明、本班周/总榜 Top10；今日/待确认/未交可点跳转  
- 提交成功页：展示本次 +N，升级提示；「继续登记」刷新积分后回表单  
- 代提确认文案标明 50% 积分；驳回二次确认  
- 学生 Web `practice/mine`：等级卡、流水、班榜  
- 教师监管 `practice/index`：「积分榜」只读 Tab  

### 8B.4 反刷分

- 流水 `biz_key` 唯一约束  
- 代提未确认不计分  
- 日封顶 40；额外打卡次数上限  
- 掌握进步需「近期练过该知识点」才发分  

---

## 9. 分期计划与工期（建议）

| 阶段 | 内容 | 工期 | 交付物 |
| :--- | :--- | :--- | :--- |
| **P0-A** | 表结构 + 分组 CRUD + Web 分组页 | 3～4 天 | SQL、菜单、分组可用 |
| **P0-B** | 打卡 API + **最小有效监管包 S1～S5** + 学生 Web 打卡页 | 5～6 天 | 浏览器可闭环；教师异常看板可用 |
| **P0-C** | Electron 一体机客户端（登录/打卡/代提/本组进度；困难必填） | 5～7 天 | **已交付 `spas-desktop/` v1.4**：设置页、PIN 数字键盘、历史、断网队列、空闲提醒、Toast/超时/日志、Kiosk 退出确认；`npm run dist:win` |
| **P1** | 设备登记、断网队列、PIN、进步可见、组员确认代提、自动「练了仍弱」标签 | 1 周 | **已交付**：设备心跳/`spas_kiosk_device`、桌面断网队列、会话超时、软键盘、看板「练了仍弱」、`spas_student_pin` + PIN 登录、代提 `confirm_status` 次日确认 |
| **P1+** | 学生积分/等级 + 班内榜（打卡发分 + 掌握进步发分） | — | **已交付**：`spas_student_points.sql`、发分钩子、桌面/Web 等级条与榜单 |
| **P2** | 打卡确认入掌握度 / 校级教材目录 / 移动端 | 视需求 | 算法与教研规则另立文档 |

合计 **P0 约 2.5～3.5 周**（1 名全栈 + 1 名前端/桌面可并行）。监管包与打卡 API 同属 P0-B，避免先上线「只会看提交率」的空壳看板。

---

## 10. 验收标准

### 10.1 分组

- [ ] 教师可为班级创建多个组，指定组长，调整成员  
- [ ] 同一约束维度下学生不会出现在两个活跃组  
- [ ] 解散组后历史打卡仍可按原 `group_id`/组名快照查询  

### 10.2 打卡

- [ ] 学生可提交：学科、≥1 知识主题、书名、页码、题号、完成状态  
- [ ] 选「有困难」时必须填写卡点备注，否则校验失败  
- [ ] 薄弱建议来自现有 weak-top（无数据时提示先有考试分析）  
- [ ] 组长可代提本组成员；非组长调用 proxy 返回 403；代提记录可识别  
- [ ] 打卡**不改变**原掌握度数值（一期）  
- [ ] 本人打卡后账户积分增加，响应含 `awardedPoints`；班内榜可见  
- [ ] 代提确认前不计分，确认后按 50% 发放  

### 10.3 最小有效监管包（S1～S5）

- [ ] **S1** 教师看板默认展示异常三列：未交 / 有困难 / 代提过多  
- [ ] **S2** 连续 2 天未交标红，未交名单可一键复制或导出  
- [ ] **S3** 「有困难」可一键转干预（或进入待办后再转）  
- [ ] **S4** 可查看本周主题与薄弱 Top 重合度，过低有标识  
- [ ] **S5** 可生成抽查名单并录入通过/存疑  
- [ ] 不以全班提交率倒排作为唯一默认视图  

### 10.4 桌面端

- [ ] Windows 10/11 一体机可安装运行，触屏可完成登录与提交  
- [ ] 配置 API 地址后连现网  
- [ ] 异常（未分组、网络失败、困难未填备注）有明确中文提示  
- [ ] 组长可看本组已交/未交；非组长无「帮组员打卡」入口  

---

## 11. 风险与对策

| 风险 | 对策 |
| :--- | :--- |
| 一体机公共场合密码泄露 | PIN + 短会话超时；禁止记住密码；定期改密 |
| 书名/题号录入不规范 | 联想书名；题号占位符示例；教师抽查（S5） |
| 代提滥用 | 审计字段 + 代提过多异常列（S1）；教师可作废；P1 组员确认 |
| 空打卡 / 形式主义 | 困难必填；抽查；不以提交率为唯一考核；达标制代替羞辱排行 |
| 薄弱建议空 | UI 允许自选知识点树；引导教师先导入成绩 |
| 催交与辅导不分 | 「未交」催交、「有困难/练了仍弱」转干预或辅导 |
| Electron 体积/杀软 | 代码签名；内网分发；白名单说明 |
| 与「作业考试」概念混淆 | 菜单文案用「自主练打卡」；文档明确不等于试卷成绩 |

---

## 12. 推荐落地顺序（执行清单）

1. 评审确认 **D1～D5**（尤其 D2 不进掌握度、D1 Electron），并确认采纳 **§0C 最小有效监管包**。  
2. 出 `sql/spas_group_practice.sql`（含困难备注、抽查、补打标记等字段）+ 菜单权限 SQL。  
3. 实现分组后端 + Web 页（无桌面亦可演示）。  
4. 实现打卡 API + **异常驱动监管看板（S1～S5）** + 学生 Web 页联调。  
5. 拉起 `spas-desktop`，做触屏皮肤与安装包（困难必填、本组进度）。  
6. 选 1 个班试点：明确组长只催交不判题 → 培训抽查节奏 → 再全年级推广。  
7. 试点两周后复盘：空打卡比例、代提比例、有困难转干预转化率、教师日均处理时长。  

---

## 13. 附录：字段录入规范（给师生的文案）

| 字段 | 示例 | 说明 |
| :--- | :--- | :--- |
| 知识主题 | 牛顿第二定律、细胞膜的结构 | 尽量选系统知识点，便于统计 |
| 书本名称 | 《五年高考三年模拟》物理必修一 | 同班统一书名便于汇总 |
| 页码 | 32–35 | 单页填相同起止 |
| 题号 | 1,2,3 / 第 4 题 / 练习 B 第 5～7 题 | 自由文本，建议简短 |
| 完成情况 | 已完成 / 部分完成 / 有困难 | 「有困难」**必须**写卡点，并进入教师待办 |
| 困难说明 | 「第 5 题不会画受力分析」 | `finish_status=有困难` 时必填 |
| 轻反馈（可选） | 大约对了 70%；最卡第 2 题 | 不进掌握度，便于复盘 |
| 抽查结果 | 通过 / 存疑 | 仅教师填写；存疑需跟进 |

---

## 14. 文档变更记录

| 版本 | 日期 | 说明 |
| :--- | :--- | :--- |
| v1.0 | 2026-10-02 | 首版：分组 + 每日自主练打卡 + Win 一体机桌面端方案 |
| v1.1 | 2026-10-02 | 增补学习有效性评估、学习监管增强方案、最小有效监管包（S1～S5）；同步 P0 目标/表字段/API/验收 |
| v1.2 | 2026-10-02 | P0 代码落地：SQL/后端/Web 分组与打卡看板；新增 `spas-desktop/` Electron 一体机客户端 |
| v1.3 | 2026-10-04 | P1 部分：设备心跳表、断网队列、会话超时/软键盘、监管「练了仍弱」 |
| v1.5 | 2026-10-04 | 交叉引用组长检查+抽检改进方案 `docs/spas-leader-check-spot-supervision.md` |
