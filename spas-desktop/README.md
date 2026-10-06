# 知脉 · Windows 一体机自主练客户端（spas-desktop）

基于 **Electron** 的 Windows 触屏客户端，对接云端 `/spas/practice/**` API。

## 功能（v1.5.9）

- 学号 + **PIN 快捷登录**（数字软键盘）/ 密码+验证码
- **登记检查结果**：检查在座位上翻本抽问完成，一体机只点状态、一次提交全组
- **组员确认页**：属实 / 异议（不再用系统对话框）；属实后发核实积分
- 加练仍可登记，**不计入组达标**
- 薄弱主题建议、本组进度、近 7 日记录
- 积分与等级（组员首页隐藏公开班榜）；掌握度进步发分
- 断网本地队列、设备心跳、Kiosk、空闲退出、Toast/日志

## 本地开发

```bash
cd spas-desktop
cp config.example.json config.json   # 本地可填 http://127.0.0.1:8080
npm install
# 若 Cursor 环境带 ELECTRON_RUN_AS_NODE，用：
env -u ELECTRON_RUN_AS_NODE npm start
```

前提：后端已启动，库已执行：

- `sql/spas_group_practice.sql`
- `sql/spas_practice_checkout.sql`（布置 / 检查单 / 抽检）

## 打 Windows 安装包

在 **Windows** 机器上：

```bash
cd spas-desktop
npm install
npm run dist:win
# 产物：release/知脉自主练-Setup-*-x64.exe
```

## 教室部署

1. 安装 Setup 包  
2. 首次打开填写 API（如 `https://xq.xmls.vip/prod-api`）与设备编号  
3. 可选：Kiosk 全屏、开机自启、空闲退出分钟数  
4. 学生在 Web「每日自主练」设置 PIN 后，一体机用学号+PIN 登录  

配置保存在用户目录 `config.json`；日志在同目录 `logs/`。

## 配置项

| 字段 | 说明 |
| :--- | :--- |
| `apiBase` | 后端根地址 |
| `deviceCode` | 一体机编号 |
| `kiosk` | 全屏；关闭窗口会二次确认 |
| `autoLaunch` | 开机自启 |
| `idleMinutes` | 空闲退出分钟（2～60，默认 8） |
| `title` | 窗口标题 |
