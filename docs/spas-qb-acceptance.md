# 题库方案 B · 可执行验收剧本

> 前置：执行 `sql/spas_qb_schema.sql` + `sql/spas_qb_menu.sql`，重启后端并重新登录刷新菜单。  
> 详设：[`spas-question-bank-plan-b.md`](./spas-question-bank-plan-b.md)

## 主路径（一期必通）

| 步 | 操作 | 期望 |
| ---: | :--- | :--- |
| 1 | 菜单 **题库 → 题目管理**，选物理学科，录入含公式的 3–5 题 | 列表可见；`content_hash` 有值 |
| 2 | 再尝试录入一道相同题干 | 拦截「题干重复」；check-dup 显示已有 ID |
| 3 | 对一道题 **AI 建议**（默认启发式） | 返回叶子候选；**未点采纳前** 不写 `spas_qb_question_knowledge`；不触发掌握度 |
| 4 | **人审** 选定知识点并保存 | 权重和≈1；列表「知识点」列有内容 |
| 5 | **组卷中心** 选题并赋分 | `spas_qb_paper_item` 顺序与分值 |
| 6 | **发布到分析** 选班级+考试日 | 调用 `annotation-check`；未绑/权重≠1 时仅可勾选强制发布；生成 `spas_paper` |
| 7 | 试卷页导入成绩 | 得分率按 `score/full_score` |
| 8 | 学生/班级分析弱项 Top | 仅出现已绑定题；未发布卷不入样 |

## 导入与 OCR

| 步 | 操作 | 期望 |
| ---: | :--- | :--- |
| A | 上传数字版 docx/pdf | 拆题预览；可整理公式、智能标注 |
| B | 上传扫描 PDF | `ocrNeeded` + 页图；点 OCR 后拆题 |
| C | 带智能标注入库 | 需确认已校对才写 KP；或选「不带知识点入库」 |
| D | 关闭导入对话框 | OCR 临时页图 session 被清理 |

## 回退（不倒退）

- 直接在「试卷管理」手工新建分析卷仍可用。  
- `spas.qb.ai.enabled=false` 时仍可完成主路径。

## SQL 自检

```bash
python sql/spas_apply_incremental.py --check
```

## 验收打勾

- [ ] 主路径 1–8 全通
- [ ] OCR A–D 全通
- [ ] LLM 关闭时启发式可用；开启后远程可测试
- [ ] 入库未确认不写 KP；发布未绑/权重异常被拦截
- [ ] 关闭导入框后 OCR 临时页图被清理

## 运维

OCR/LLM 见 [`spas-qb-ops-checklist.md`](./spas-qb-ops-checklist.md)。
