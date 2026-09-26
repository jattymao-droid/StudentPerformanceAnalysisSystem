#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Download 组卷网高中物理知识点树并生成 SPAS 导入 SQL/JSON.

Source tree (public static JSON used by zujuan.xkw.com):
  https://static.zxxk.com/zujuan/tree/lk_13.json
Page context:
  https://zujuan.xkw.com/gzwl/zsd41958/o2

Outputs:
  data/xkw_phys/lk_13_gzwl.json
  data/xkw_phys/phys_knowledge_flat.json
  sql/spas_phys_xkw_knowledge.sql
"""
from __future__ import annotations

import json
import sys
import urllib.request
from collections import deque
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = ROOT / "data" / "xkw_phys"
SQL_PATH = ROOT / "sql" / "spas_phys_xkw_knowledge.sql"
TREE_URL = "https://static.zxxk.com/zujuan/tree/lk_13.json"
PAGE_URL = "https://zujuan.xkw.com/gzwl/zsd41958/o2"


def code_of(nid: str) -> str:
    return f"XKW-PHYS-{nid}"


def sql_str(s: str) -> str:
    return "'" + (s or "").replace("'", "''") + "'"


def flatten(root: dict) -> list[dict]:
    flat: list[dict] = []
    q = deque([(root, 0, None, 1)])
    while q:
        node, depth, parent_id, order_num = q.popleft()
        nid = str(node.get("id"))
        kids = node.get("children") or []
        is_leaf = len(kids) == 0
        if depth == 0:
            node_type = "0"
        elif is_leaf:
            node_type = "2"
        else:
            node_type = "1"
        flat.append(
            {
                "id": nid,
                "parent_id": None if depth == 0 else str(parent_id),
                "depth": depth,
                "title": node.get("title") or "",
                "is_knowledge": node.get("isKnowledge"),
                "tree_type": node.get("treeType"),
                "node_type": node_type,
                "knowledge_code": code_of(nid),
                "order_num": order_num,
                "child_count": len(kids),
                "source_url": f"https://zujuan.xkw.com/gzwl/zsd{nid}/o2" if nid.isdigit() else "",
            }
        )
        for i, c in enumerate(kids):
            q.append((c, depth + 1, nid, i + 1))
    return flat


def write_sql(flat: list[dict]) -> None:
    lines: list[str] = [
        "-- 高中物理知识点树（来源：组卷网 lk_13.json / gzwl）",
        "-- 幂等：按 knowledge_code=XKW-PHYS-{xkwId} 去重",
        "-- 导入示例：",
        "--   psql \"$DB\" -v ON_ERROR_STOP=1 -f sql/spas_phys_xkw_knowledge.sql",
        "--   python3 scripts/import_xkw_phys_knowledge.py",
        "",
        "INSERT INTO spas_subject(subject_code, subject_name, sort, status, create_by, create_time)",
        "SELECT 'PHYS', '物理', 2, '0', 'admin', now()",
        "WHERE NOT EXISTS (SELECT 1 FROM spas_subject WHERE subject_code = 'PHYS');",
        "",
    ]
    for n in flat:
        name = sql_str(n["title"])
        code = sql_str(n["knowledge_code"])
        nt = sql_str(n["node_type"])
        order = int(n["order_num"] or 1)
        remark = sql_str(f"xkw:{n['id']}")
        if n["parent_id"] is None:
            lines.append(
                f"""INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT s.subject_id, 0, '0', {name}, {code}, {nt}, {order}, '2', '0', 'admin', now(), {remark}
FROM spas_subject s
WHERE s.subject_code = 'PHYS'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = {code});
"""
            )
        else:
            pcode = sql_str(code_of(n["parent_id"]))
            lines.append(
                f"""INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, {name}, {code}, {nt}, {order}, '2', '0', 'admin', now(), {remark}
FROM spas_knowledge p
WHERE p.knowledge_code = {pcode}
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = {code});
"""
            )
    SQL_PATH.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    print(f"==> Download {TREE_URL}")
    req = urllib.request.Request(
        TREE_URL,
        headers={"User-Agent": "Mozilla/5.0 (compatible; SPAS-knowledge-import/1.0)"},
    )
    with urllib.request.urlopen(req, timeout=60) as resp:
        raw = resp.read()
    tree_path = OUT_DIR / "lk_13_gzwl.json"
    tree_path.write_bytes(raw)
    root = json.loads(raw.decode("utf-8"))
    flat = flatten(root)
    flat_path = OUT_DIR / "phys_knowledge_flat.json"
    flat_path.write_text(
        json.dumps(
            {
                "source": TREE_URL,
                "page": PAGE_URL,
                "subject": "PHYS",
                "root_title": root.get("title"),
                "count": len(flat),
                "nodes": flat,
            },
            ensure_ascii=False,
            indent=2,
        ),
        encoding="utf-8",
    )
    write_sql(flat)
    by_type = {t: sum(1 for x in flat if x["node_type"] == t) for t in ("0", "1", "2")}
    print(f"    tree  -> {tree_path} ({len(raw)} bytes)")
    print(f"    flat  -> {flat_path} ({len(flat)} nodes)")
    print(f"    sql   -> {SQL_PATH} ({SQL_PATH.stat().st_size} bytes)")
    print(f"    types -> version={by_type['0']} chapter={by_type['1']} leaf={by_type['2']}")
    print("Done. Upload sql/spas_phys_xkw_knowledge.sql to server and run import script.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
