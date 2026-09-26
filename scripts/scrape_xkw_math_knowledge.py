#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Download 组卷网高中数学知识点树 -> sql/spas_math_xkw_knowledge.sql"""
from __future__ import annotations
import json, urllib.request
from collections import deque
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = ROOT / "data" / "xkw_math"
SQL_PATH = ROOT / "sql" / "spas_math_xkw_knowledge.sql"
TREE_URL = "https://static.zxxk.com/zujuan/tree/lk_11.json"
PAGE_URL = "https://zujuan.xkw.com/gzsx/zsd27925/"
PREFIX = "XKW-MATH"

def code_of(nid): return f"{PREFIX}-{nid}"
def sql_str(s): return "'" + (s or "").replace("'", "''") + "'"

def flatten(root):
    flat=[]; q=deque([(root,0,None,1)])
    while q:
        node,depth,parent_id,order_num=q.popleft()
        nid=str(node.get("id")); kids=node.get("children") or []
        node_type="0" if depth==0 else ("2" if not kids else "1")
        flat.append({"id":nid,"parent_id":None if depth==0 else str(parent_id),"depth":depth,"title":node.get("title") or "","node_type":node_type,"knowledge_code":code_of(nid),"order_num":order_num,"child_count":len(kids)})
        for i,c in enumerate(kids): q.append((c,depth+1,nid,i+1))
    return flat

def write_sql(flat):
    lines=["-- 高中数学知识点树（lk_11.json / gzsx）","-- 幂等 XKW-MATH-*","",
           "INSERT INTO spas_subject(subject_code, subject_name, sort, status, create_by, create_time)",
           "SELECT 'MATH', '数学', 3, '0', 'admin', now()",
           "WHERE NOT EXISTS (SELECT 1 FROM spas_subject WHERE subject_code = 'MATH');",""]
    for n in flat:
        name,code,nt,order,remark=sql_str(n["title"]),sql_str(n["knowledge_code"]),sql_str(n["node_type"]),int(n["order_num"] or 1),sql_str(f"xkw:{n['id']}")
        if n["parent_id"] is None:
            lines.append(f"INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)\nSELECT s.subject_id, 0, '0', {name}, {code}, {nt}, {order}, '2', '0', 'admin', now(), {remark}\nFROM spas_subject s\nWHERE s.subject_code = 'MATH'\n  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = {code});\n")
        else:
            pcode=sql_str(code_of(n["parent_id"]))
            lines.append(f"INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)\nSELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, {name}, {code}, {nt}, {order}, '2', '0', 'admin', now(), {remark}\nFROM spas_knowledge p\nWHERE p.knowledge_code = {pcode}\n  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = {code});\n")
    SQL_PATH.write_text("\n".join(lines), encoding="utf-8")

def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    req=urllib.request.Request(TREE_URL, headers={"User-Agent":"Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=60) as resp: raw=resp.read()
    (OUT_DIR/"lk_11_gzsx.json").write_bytes(raw)
    root=json.loads(raw.decode()); flat=flatten(root)
    (OUT_DIR/"math_knowledge_flat.json").write_text(json.dumps({"source":TREE_URL,"page":PAGE_URL,"subject":"MATH","root_title":root.get("title"),"count":len(flat),"nodes":flat},ensure_ascii=False,indent=2),encoding="utf-8")
    write_sql(flat); print(f"nodes={len(flat)} sql={SQL_PATH}"); return 0
if __name__=="__main__": raise SystemExit(main())
