# 高中物理知识点（组卷网）导入说明

## 数据来源

- 页面：https://zujuan.xkw.com/gzwl/zsd41958/o2  
- 知识点树 JSON（组卷网前端静态资源）：https://static.zxxk.com/zujuan/tree/lk_13.json  

仅抓取**章节/知识点名称与树结构**，不含试题正文。

## 本地已生成文件

| 文件 | 说明 |
|------|------|
| `lk_13_gzwl.json` | 原始树 |
| `phys_knowledge_flat.json` | 扁平化节点（1273） |
| `../../sql/spas_phys_xkw_knowledge.sql` | 幂等导入 SQL |

节点映射：`knowledge_code = XKW-PHYS-{组卷网id}`  
- `node_type=0` 版本根：高中物理综合库  
- `node_type=1` 章节（非叶子）  
- `node_type=2` 知识点（叶子，962 个）

## 重新抓取

```bash
python3 scripts/scrape_xkw_phys_knowledge.py
```

## 服务器导入

上传以下文件到服务器（推荐放到站点目录）：

- `sql/spas_phys_xkw_knowledge.sql`
- `scripts/import_phys_xkw_knowledge.sh`（或已在 `deploy/xq.xmls.vip/scripts/`）

然后执行：

```bash
cd /www/wwwroot/xq.xmls.vip
# 若 SQL/脚本是新上传的：
# mkdir -p sql scripts
# 把两个文件放到 sql/ 与 scripts/ 下
chmod +x scripts/import_phys_xkw_knowledge.sh
bash scripts/import_phys_xkw_knowledge.sh
```

指定 SQL 路径：

```bash
bash scripts/import_phys_xkw_knowledge.sh /path/to/spas_phys_xkw_knowledge.sql
```

脚本会自动读取 `config/env.sh`，优先走 Docker 里的 PostgreSQL，导入后打印节点数量（期望约 1273）。

导入后在系统中打开「知识点管理」，学科选 **物理**，即可看到树。
