# 题库·方案 B 实施说明

> 源：SmartDocx `EduQb*`；目标：SPAS 内联 `ruoyi-spas`  
> 一期：题目库 → 组卷 → 发布分析卷 → AI 建议知识点（审阅）→ 录入分数

## 1. 范围

| 做第一期 | 不做第一期 |
| :--- | :--- |
| `spas_qb_question` / paper / item / question_knowledge | 公开题库 / VIP / 支付 / 优化 |
| content_hash 去重 | RuoYi-Cloud / Nacos / Gateway |
| 发布为 `SpasPaper` | OCR 服务端 Tess4J 原生库 / 答题卡 |
| AI 建议 ≠ 自动写权重 | 自适应练习优化 |

## 2. 字段对齐

| SmartDocx | SPAS 题库 | SPAS 分析 |
| :--- | :--- | :--- |
| `edu_qb_question` | `spas_qb_question` | — |
| `edu_qb_paper` | `spas_qb_paper` | `spas_paper.bank_paper_id` |
| `edu_qb_paper_item` | `spas_qb_paper_item` | → `spas_paper_question` |
| `knowledge_points` jsonb 标签 | `spas_qb_question_knowledge`（knowledge_id+weight） | → `spas_question_knowledge` |
| `edu_subject` | 使用 `spas_subject` | 同步 |

## 3. 发布主流程

1. 校验班级与题库题目的 `deptId` 等权限。  
2. 新建或按 `bank_paper_id` 复用 `spas_paper`（draft）。  
3. 清空并重建分析小题；`full_score`←item.score；`bank_question_id` 回填。  
4. 仅同步已人审知识点到 `spas_question_knowledge`。  
5. 若分析卷已有成绩：可同步注解类知识点重算；小题结构需教师确认。

## 4. 菜单

| menu_id | 名称 | 路径 |
| ---: | :--- | :--- |
| 2300 | 题库（目录） | qb |
| 2301 | 题目管理 | qb/question |
| 2310 | 组卷中心 | qb/paper |

权限前缀：`spas:qb:question:*` / `spas:qb:paper:*`

## 5. 配置

```yaml
spas:
  qb:
    ocr:
      max-pages: 30
      dpi: 220
      session-ttl-hours: 24
    ai:
      enabled: false
      endpoint: ""
      api-key: ""
      model: ""
      timeout-ms: 30000
      top-k: 5
```

`enabled=false` 时走本地启发式；配置远程模型时可切换。

## 6. SQL

- `sql/spas_qb_schema.sql`
- `sql/spas_qb_menu.sql`

已加入 `spas_apply_incremental.py` REQUIRED 列表。

## 7. 验收

见 [spas-qb-acceptance.md](./spas-qb-acceptance.md)。  
准确度口径见 [spas-core-accuracy-evaluation.md](./spas-core-accuracy-evaluation.md) §16。

## 8. QB AI suggest (DeepSeek)

Configure in UI: **System -> LLM config** (menu 118).
Values live in `sys_config` and apply immediately (Redis).

| UI | sys_config key | Default |
| :--- | :--- | :--- |
| enabled | `spas.qb.ai.enabled` | `false` |
| endpoint | `spas.qb.ai.endpoint` | DeepSeek chat/completions |
| api-key | `spas.qb.ai.api-key` | (empty) |
| model | `spas.qb.ai.model` | `deepseek-chat` |
| timeout-ms | `spas.qb.ai.timeout-ms` | `30000` |
| top-k | `spas.qb.ai.top-k` | `5` |

Priority: **sys_config (admin UI) > application.yml / env**.

When enabled, question AI-suggest uses remote; import **smart-annotate**
uses heuristic first, then remote for weak hits (max 20 remote calls/batch).

**Mastery gate:** batch insert / publish never write mastery from AI alone.
- Batch: `acceptAiKnowledge=true` or per-row `knowledgeConfirmed=true` required to persist KP.
- Publish: unbound items blocked unless `force=true` after teacher confirm.

SQL: `sql/spas_qb_ai_config.sql`

## 9. OCR for scanned PDF / image-only DOCX

When `parse-paper` finds no digital text:
1. Server renders up to `spas.qb.ocr.max-pages` (default 30) at `spas.qb.ocr.dpi` (default 220) under `/profile/qb-import/{session}/ocr-p-N.png`
2. Response sets `ocrNeeded=true` + `pageImageUrls` + `ocrSessionId`
3. Frontend runs **tesseract.js** (`chi_sim+eng`) page by page (no Tess4J natives)
4. Client posts text to `parse-ocr-text` -> split + optional formula polish + smart-annotate
5. Closing the import dialog calls `DELETE /spas/qb/question/ocr-session/{id}`; expired sessions also cleaned on next parse (`session-ttl-hours`)

Ops tips: clear scans, upright pages, avoid >30 pages per upload unless you raise `max-pages`.

## 10. 运维清单

见 [`spas-qb-ops-checklist.md`](./spas-qb-ops-checklist.md)。
