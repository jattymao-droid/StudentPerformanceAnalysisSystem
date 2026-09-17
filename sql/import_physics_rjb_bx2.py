# -*- coding: utf-8 -*-
import re, json, html
from pathlib import Path
from urllib.request import Request, urlopen
import psycopg2

ROOT = Path(r"d:\AI\StudentPerformanceAnalysisSystem\sql")
URL = "http://www.dzkbw.com/books/rjb/wuli/pgzd2c/"

req = Request(URL, headers={"User-Agent": "Mozilla/5.0"})
data = urlopen(req, timeout=30).read()
text = None
for enc in ("gbk", "gb18030", "utf-8"):
    try:
        cand = data.decode(enc)
        if "\u7b2c\u4e94\u7ae0" in cand or "\u629b\u4f53\u8fd0\u52a8" in cand:
            text = cand
            break
    except Exception:
        pass
if text is None:
    raise SystemExit("decode failed")

raw = re.sub(r"<script[\s\S]*?</script>", "", text, flags=re.I)
raw = re.sub(r"<style[\s\S]*?</style>", "", raw, flags=re.I)
plain = re.sub(r"<br\s*/?>", "\n", raw, flags=re.I)
plain = re.sub(r"</p>|</div>|</li>|</h\d>|</tr>", "\n", plain, flags=re.I)
plain = re.sub(r"<[^>]+>", "", plain)
plain = html.unescape(plain)
lines = [re.sub(r"\s+", " ", ln).strip() for ln in plain.splitlines()]
lines = [ln for ln in lines if ln]
start = next(i for i, l in enumerate(lines) if l.startswith("\u7b2c") and "\u7ae0" in l)
end = next(i for i, l in enumerate(lines) if i > start and ("\u4eba\u6559\u7248\u9ad8\u4e00\u7535\u5b50\u8bfe\u672c" in l or "\u8d5e\u52a9\u5546" in l))
toc_lines = lines[start:end]

chapters = []
cur = None
for l in toc_lines:
    if re.match(r"^[\u7b2c].+\u7ae0", l) or l in ("\u8bfe\u9898\u7814\u7a76", "\u5b66\u751f\u5b9e\u9a8c"):
        cur = {"name": l, "children": []}
        chapters.append(cur)
    elif re.match(r"^\d+[\.\u3001]", l) and cur is not None:
        cur["children"].append(re.sub(r"^\d+[\.\u3001]\s*", "", l))

out = {
    "source": URL,
    "title": "\u4eba\u6559\u7248\u9ad8\u4e00\u7269\u7406\u5fc5\u4fee \u7b2c\u4e8c\u518c",
    "version": "\u5fc5\u4fee\u4e8c",
    "chapters": chapters,
}
toc_path = ROOT / "rjb_physics_bx2_toc.json"
toc_path.write_text(json.dumps(out, ensure_ascii=False, indent=2), encoding="utf-8")
print("chapters", len(chapters), "sections", sum(len(c["children"]) for c in chapters))
print(json.dumps(out, ensure_ascii=False, indent=2))

# import DB
conn = psycopg2.connect(host="localhost", dbname="spas-sql", user="postgres", password="mm5621528")
conn.autocommit = False
cur = conn.cursor()
cur.execute("SELECT subject_id FROM spas_subject WHERE subject_code='physics'")
sid = cur.fetchone()[0]
vcode = "PHY-RJ-BX2"
vname = out["version"]
cur.execute("SELECT knowledge_id FROM spas_knowledge WHERE knowledge_code=%s", (vcode,))
row = cur.fetchone()
if row:
    vid = row[0]
    cur.execute(
        "UPDATE spas_knowledge SET knowledge_name=%s, subject_id=%s, parent_id=0, ancestors='0', node_type='0', order_num=2, status='0', update_time=now() WHERE knowledge_id=%s",
        (vname, sid, vid),
    )
else:
    cur.execute(
        """
        INSERT INTO spas_knowledge(subject_id,parent_id,ancestors,knowledge_name,knowledge_code,node_type,order_num,difficulty_default,status,create_by,create_time)
        VALUES (%s,0,'0',%s,%s,'0',2,'2','0','admin',now()) RETURNING knowledge_id
        """,
        (sid, vname, vcode),
    )
    vid = cur.fetchone()[0]

ins_ch = 0
ins_sec = 0
for ci, ch in enumerate(out["chapters"], start=1):
    ch_code = "PHY-RJ-BX2-CH{:02d}".format(ci)
    cur.execute("SELECT knowledge_id FROM spas_knowledge WHERE knowledge_code=%s", (ch_code,))
    crow = cur.fetchone()
    anc = "0,%s" % vid
    if crow:
        ch_id = crow[0]
        cur.execute(
            "UPDATE spas_knowledge SET knowledge_name=%s, subject_id=%s, parent_id=%s, ancestors=%s, node_type='1', order_num=%s, status='0', update_time=now() WHERE knowledge_id=%s",
            (ch["name"], sid, vid, anc, ci, ch_id),
        )
    else:
        cur.execute(
            """
            INSERT INTO spas_knowledge(subject_id,parent_id,ancestors,knowledge_name,knowledge_code,node_type,order_num,difficulty_default,status,create_by,create_time)
            VALUES (%s,%s,%s,%s,%s,'1',%s,'2','0','admin',now()) RETURNING knowledge_id
            """,
            (sid, vid, anc, ch["name"], ch_code, ci),
        )
        ch_id = cur.fetchone()[0]
        ins_ch += 1
    for si, sec in enumerate(ch.get("children") or [], start=1):
        sec_code = "%s-S%02d" % (ch_code, si)
        sanc = "0,%s,%s" % (vid, ch_id)
        cur.execute("SELECT knowledge_id FROM spas_knowledge WHERE knowledge_code=%s", (sec_code,))
        srow = cur.fetchone()
        if srow:
            cur.execute(
                "UPDATE spas_knowledge SET knowledge_name=%s, subject_id=%s, parent_id=%s, ancestors=%s, node_type='2', order_num=%s, status='0', update_time=now() WHERE knowledge_id=%s",
                (sec, sid, ch_id, sanc, si, srow[0]),
            )
        else:
            cur.execute(
                """
                INSERT INTO spas_knowledge(subject_id,parent_id,ancestors,knowledge_name,knowledge_code,node_type,order_num,difficulty_default,status,create_by,create_time)
                VALUES (%s,%s,%s,%s,%s,'2',%s,'2','0','admin',now())
                """,
                (sid, ch_id, sanc, sec, sec_code, si),
            )
            ins_sec += 1

conn.commit()
print("imported version_id=%s chapters+=%s sections+=%s" % (vid, ins_ch, ins_sec))
cur.close()
conn.close()
