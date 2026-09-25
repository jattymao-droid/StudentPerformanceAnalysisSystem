# 题库 OCR / LLM 运维清单

> 配合 [`spas-question-bank-plan-b.md`](./spas-question-bank-plan-b.md) §8–9、[`spas-qb-acceptance.md`](./spas-qb-acceptance.md)

## 1. LLM（大模型配置）

1. 执行 `sql/spas_qb_ai_config.sql`（菜单 118 + `sys_config`）  
2. 重启 `ruoyi-admin`（确保 `SysLlmConfigController` 在 jar 内）  
3. 管理员重新登录 → **系统管理 → 大模型配置**  
4. 填写 endpoint / model / API Key，点「连通测试」后再启用  
5. 优先级：**sys_config（UI） > application.yml / 环境变量**

默认 `enabled=false` 时走本地启发式；导入智能标注远程预算约 20 题/批。

## 2. OCR（扫描件）

| 项 | 默认 | 环境变量 |
| :--- | ---: | :--- |
| max-pages | 30 | `SPAS_QB_OCR_MAX_PAGES` |
| dpi | 220 | `SPAS_QB_OCR_DPI` |
| session-ttl-hours | 24 | `SPAS_QB_OCR_TTL_HOURS` |

- 服务端仅渲染页图；浏览器 **tesseract.js**（chi_sim+eng）  
- 关闭导入对话框会清理 session；过期目录在下次 parse 时清理  
- 要求：清晰、正向扫描；避免单次 >30 页

## 3. 掌握度闸门（必守）

- 批量入库：须 `acceptAiKnowledge` 或行级 `knowledgeConfirmed`  
- 题库发布：未绑 / 权重≠1 拦截，仅教师勾选 **强制发布** 可跳过  
- AI 建议不直接写掌握度快照

## 4. 验收

按 [`spas-qb-acceptance.md`](./spas-qb-acceptance.md) 通路 + OCR A–D逐项打勾。
