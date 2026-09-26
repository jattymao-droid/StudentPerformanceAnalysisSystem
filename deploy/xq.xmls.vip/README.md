# 知脉云部署包（xq.xmls.vip）

## 解压方式（推荐）

压缩包根目录名为 `xq.xmls.vip`，请解压到 `/www/wwwroot/`：

```bash
cd /www/wwwroot
# 升级时建议先备份再解压，避免覆盖 uploadPath
# cp -a xq.xmls.vip/uploadPath /tmp/xq-uploadPath.bak
unzip -o /path/to/xq.xmls.vip.zip
# 若需保留旧上传文件：
# rsync -a /tmp/xq-uploadPath.bak/ xq.xmls.vip/uploadPath/
```

**站点根目录（Nginx root）** = `/www/wwwroot/xq.xmls.vip/web`  
**项目根目录（脚本/后端）** = `/www/wwwroot/xq.xmls.vip`

## 目录结构

```
/www/wwwroot/xq.xmls.vip/
  install.sh          # 一键：初始化数据库 + 启动后端
  config/env.sh       # 数据库 / Redis / 端口 / 密钥
  scripts/            # init_db / start / stop / status
  sql/                # PostgreSQL 脚本（含 SPAS 增量）
  app/ruoyi-admin.jar # 后端
  web/                # 管理端前端（网站根目录指向这里）
  nginx/              # 站点配置示例
  uploadPath/         # 上传目录
  logs/               # 运行日志
```

## 部署前前提（宝塔已配好）

与 `bj.xmls.vip` **共用**同一套 Docker 映射：

| 服务 | 端口 | 密码 |
|------|------|------|
| PostgreSQL | `35432` | 与 bj 相同（见 `config/env.sh`） |
| Redis | `26739` | 与 bj 相同 |

本项目使用独立库名 `spas_sql`，Redis 使用 `database=1`（避免与班鸽 `db=0` 键冲突）。后端监听本机 **`9093`**。

- 已安装 **JDK 17+**
- 域名 `xq.xmls.vip` 已解析到本机

## 一键安装 / 升级

```bash
cd /www/wwwroot/xq.xmls.vip
chmod +x install.sh scripts/*.sh
# 若 Windows 上传导致 CRLF：
# sed -i 's/\r$//' install.sh config/env.sh scripts/*.sh
bash install.sh
```

### 数据库说明

- 若检测到已有 `sys_user` 表：**跳过基础库**，只跑 SPAS 增量 SQL。
- 全新库：先导入 `ry_postgresql.sql` + `quartz_postgresql.sql`，再跑增量。

宝塔 → 网站 → `xq.xmls.vip`：

1. 根目录设为：`/www/wwwroot/xq.xmls.vip/web`
2. 配置文件合并 `nginx/xq.xmls.vip.conf` 中的 `location`（尤其 `/prod-api/` → `9093`）
3. 申请并开启 SSL

访问：`https://xq.xmls.vip/`  
默认账号：`admin` / `admin123`（登录后立刻改密）

## 日常运维

```bash
cd /www/wwwroot/xq.xmls.vip
bash scripts/status.sh
bash scripts/stop.sh
bash scripts/start.sh
tail -f logs/ruoyi-admin.out
```

## 说明

- 后端监听本机 `9093`，对外经 Nginx `/prod-api/` 暴露
- 打包命令（开发机）：`bash scripts/package-deploy.sh`
