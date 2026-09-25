# 活动大屏（GameScreen）启动指南

基于若依 PostgreSQL 版的活动大屏复刻工程，包含后端、管理端、大屏与 H5 四端。

## 端口一览

| 端 | 目录 | 地址 | 默认账号 |
|---|---|---|---|
| 后端 API | `ruoyi-admin` | http://localhost:8080 | — |
| 若依管理端 | `ruoyi-ui` | http://localhost:80 | admin / admin123 |
| 活动大屏 | `gamescreen-wall` | http://localhost:5173 | 口令 `screen123` |
| 手机 H5 | `gamescreen-h5` | http://localhost:5174 | mock 登录 |

多活动 URL 参数：`?activityId=1`

## 数据库初始化

按顺序执行（可重复执行增量脚本）：

```bash
psql -U postgres -d ry_vue -f sql/ry_postgresql.sql
psql -U postgres -d ry_vue -f sql/gamescreen_pg.sql
psql -U postgres -d ry_vue -f sql/gamescreen_align.sql
psql -U postgres -d ry_vue -f sql/gamescreen_menu_fix.sql   # 若 2000+ 菜单冲突
psql -U postgres -d ry_vue -f sql/gamescreen_fill.sql       # H5菜单/导出/活动扩展字段
psql -U postgres -d ry_vue -f sql/gamescreen_wechat.sql     # 微信配置菜单
```

Windows 连接 PostgreSQL 请使用 `127.0.0.1`（避免 `localhost` IPv6 认证失败）：

```powershell
$env:PGPASSWORD='your_password'
& "C:\Program Files\PostgreSQL\14\bin\psql.exe" -h 127.0.0.1 -U postgres -d ry_vue -f sql/gamescreen_fill.sql
```

活动大屏菜单将迁移到 **3000+** 段，避免与现有项目冲突（`gamescreen_menu_fix.sql` 已包含在上面的顺序中，按需执行）。

## 后端配置

`ruoyi-admin/src/main/resources/application.yml`：

```yaml
ruoyi:
  profile: e:/AI/gamescreen-ruoyi/uploadPath   # 上传目录

gamescreen:
  mock-wechat: true          # 开发环境 mock 微信
  default-activity-id: 1
```

编译启动：

```bash
mvn -pl ruoyi-admin -am package -DskipTests
java -jar ruoyi-admin/target/ruoyi-admin.jar
```

## 前端启动

```bash
# 管理端
cd ruoyi-ui && npm install && npm run dev

# 大屏（代理到 8080）
cd gamescreen-wall && npm install && npm run dev

# H5
cd gamescreen-h5 && npm install && npm run dev
```

## 菜单入口

若依左侧 **活动大屏** 为动态菜单（`sys_menu` 配置，无硬编码路由），包含：

| 菜单 | 说明 |
|---|---|
| 活动配置 | 多活动切换、新建、大屏/H5 参数 |
| 功能开关 | 各场景插件启用 |
| 签到用户 | 观众列表、性别/状态 |
| 上墙审核 | 弹幕审核 |
| 投票管理 | 投票 CRUD、开启/结束 |
| 奖品中台 | 各玩法奖品 |
| 抽奖玩法 | 配置、内定、抽取、中奖记录 |
| 竞速游戏 | 开始/结束、排行榜 |
| 红包雨 | 开轮、领取明细 |
| 展示内容 | 开闭幕/相册/单页/行程等 |
| 运营工具 | 签到字段、名单导入（CSV/Excel）、对对碰 |
| 3D签到配置 | Three.js 签到参数 |
| 幸运记录 | 幸运号/幸运手机号开奖记录 |
| 数据导出 | 签到/中奖/排行/投票/红包/幸运号 Excel |
| H5菜单 | 手机端底部 Tab 配置 |
| 微信配置 | 公众号 OAuth / 商户付款参数 |

非超级管理员可分配 **活动运营** 角色（`role_id=3`），仅含上述菜单权限。

执行 `gamescreen_align.sql` / `gamescreen_fill.sql` 可增量同步菜单与角色。执行后请**重新登录**刷新动态菜单。

## 典型流程

1. **活动配置**：设置大屏口令、H5 入口 URL、弹幕/上墙规则  
2. **插件开关**：启用需要的场景（签到墙、上墙、抽奖、对对碰等）  
3. **运营工具**：导入抽奖名单、幸运号内定、预留名单  
4. **大屏**：http://localhost:5173/?activityId=1 → 输入口令  
5. **H5**：http://localhost:5174/?activityId=1 → mock 登录 → 签到互动  

## 微信生产环境

见 [微信联调指南.md](./微信联调指南.md)。

## 相关文档

- [未对齐功能清单.md](./未对齐功能清单.md)
