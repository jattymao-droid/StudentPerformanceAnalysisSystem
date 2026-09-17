# -*- coding: utf-8 -*-
import re, json, html
from pathlib import Path
from urllib.request import Request, urlopen
import psycopg2

ROOT = Path(r"d:\AI\StudentPerformanceAnalysisSystem\sql")

BOOKS = [
    {
        "url": "http://www.dzkbw.com/books/rjb/wuli/pgzd3c/",
        "vcode": "PHY-RJ-BX3",
        "vname": "\u5fc5\u4fee\u4e09",
        "title": "\u4eba\u6559\u7248\u9ad8\u4e00\u7269\u7406\u5fc5\u4fee \u7b2c\u4e09\u518c",
        "order": 3,
        "json": "rjb_physics_bx3_toc.json",
        "marker": "\u7b2c\u4e5d\u7ae0",
    },
    {
        "url": "http://www.dzkbw.com/books/rjb/wuli/pgzxbd1c/",
        "vcode": "PHY-RJ-XZBX1",
        "vname": "\u9009\u62e9\u6027\u5fc5\u4fee\u4e00",
        "title": "\u4eba\u6559\u7248\u9ad8\u4e8c\u7269\u7406\u9009\u62e9\u6027\u5fc5\u4fee \u7b2c\u4e00\u518c",
        "order": 4,
        "json": "rjb_physics_xzbx1_toc.json",
        "marker": "\u7b2c\u4e00\u7ae0 \u52a8\u91cf",
    },
    {
        "url": "http://www.dzkbw.com/books/rjb/wuli/pgzxbd2c/",
        "vcode": "PHY-RJ-XZBX2",
        "vname": "\u9009\u62e9\u6027\u5fc5\u4fee\u4e8c",
        "title": "\u4eba\u6559\u7248\u9ad8\u4e8c\u7269\u7406\u9009\u62e9\u6027\u5fc5\u4fee \u7b2c\u4e8c\u518c",
        "order": 5,
        "json": "rjb_physics_xzbx2_toc.json",
        "marker": "\u5b89\u57f9\u529b",
    },
    {
        "url": "http://www.dzkbw.com/books/rjb/wuli/pgzxbd3c/",
        "vcode": "PHY-RJ-XZBX3",
        "vname": "\u9009\u62e9\u6027\u5fc5\u4fee\u4e09",
        "title": "\u4eba\u6559\u7248\u9ad8\u4e09\u7269\u7406\u9009\u62e9\u6027\u5fc5\u4fee \u7b2c\u4e09\u518c",
        "order": 6,
        "json": "rjb_physics_xzbx3_toc.json",
        "marker": "\u5206\u5b50\u52a8\u7406\u8bba",
    },
]


def fetch_toc(url, marker):
    req = Request(url, headers={"User-Agent": "Mozilla/5.0"})
    data = urlopen(req, timeout=30).read()
    text = None
    for enc in ("gbk", "gb18030", "utf-8"):
        try:
            cand = data.decode(enc)
            if marker in cand:
                text = cand
                break
        except Exception:
            pass
    if text is None:
        # fallback: still try gbk
        text = data.decode("gbk", errors="ignore")

    raw = re.sub(r"<script[\s\S]*?</script>", "", text, flags=re.I)
    raw = re.sub(r"<style[\s\S]*?</style>", "", raw, flags=re.I)
    plain = re.sub(r"<br\s*/?>", "\n", raw, flags=re.I)
    plain = re.sub(r"</p>|</div>|</li>|</h\d>|</tr>", "\n", plain, flags=re.I)
    plain = re.sub(r"<[^>]+>", "", plain)
    plain = html.unescape(plain)
    lines = [re.sub(r"\s+", " ", ln).strip() for ln in plain.splitlines()]
    lines = [ln for ln in lines if ln]

    start = None
    for i, l in enumerate(lines):
        if re.match(r"^[\u7b2c].+\u7ae0", l):
            start = i
            break
    if start is None:
        raise RuntimeError("no chapter start for " + url)

    end = len(lines)
    for i, l in enumerate(lines):
        if i > start and ("\u4eba\u6559\u7248\u9ad8" in l and "\u7535\u5b50\u8bfe\u672c" in l) or ("\u8d5e\u52a9\u5546" in l):
            end = i
            break

    toc_lines = lines[start:end]
    chapters = []
    cur = None
    for l in toc_lines:
        if re.match(r"^[\u7b2c].+\u7ae0", l) or l in ("\u8bfe\u9898\u7814\u7a76", "\u5b66\u751f\u5b9e\u9a8c"):
            cur = {"name": l, "children": []}
            chapters.append(cur)
        elif re.match(r"^\d+[\.\u3001]", l) and cur is not None:
            cur["children"].append(re.sub(r"^\d+[\.\u3001]\s*", "", l))
    return chapters


def upsert_book(cur, sid, book, chapters):
    vcode, vname, order = book["vcode"], book["vname"], book["order"]
    cur.execute("SELECT knowledge_id FROM spas_knowledge WHERE knowledge_code=%s", (vcode,))
    row = cur.fetchone()
    if row:
        vid = row[0]
        cur.execute(
            "UPDATE spas_knowledge SET knowledge_name=%s, subject_id=%s, parent_id=0, ancestors='0', node_type='0', order_num=%s, status='0', update_time=now() WHERE knowledge_id=%s",
            (vname, sid, order, vid),
        )
    else:
        cur.execute(
            """
            INSERT INTO spas_knowledge(subject_id,parent_id,ancestors,knowledge_name,knowledge_code,node_type,order_num,difficulty_default,status,create_by,create_time)
            VALUES (%s,0,'0',%s,%s,'0',%s,'2','0','admin',now()) RETURNING knowledge_id
            """,
            (sid, vname, vcode, order),
        )
        vid = cur.fetchone()[0]

    ins_ch = ins_sec = 0
    for ci, ch in enumerate(chapters, start=1):
        ch_code = "%s-CH%02d" % (vcode, ci)
        anc = "0,%s" % vid
        cur.execute("SELECT knowledge_id FROM spas_knowledge WHERE knowledge_code=%s", (ch_code,))
        crow = cur.fetchone()
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
    return vid, ins_ch, ins_sec, len(chapters), sum(len(c.get("children") or []) for c in chapters)


def main():
    conn = psycopg2.connect(host="localhost", dbname="spas-sql", user="postgres", password="mm5621528")
    conn.autocommit = False
    cur = conn.cursor()
    cur.execute("SELECT subject_id FROM spas_subject WHERE subject_code='physics'")
    sid = cur.fetchone()[0]

    summary = []
    for book in BOOKS:
        chapters = fetch_toc(book["url"], book["marker"])
        payload = {
            "source": book["url"],
            "title": book["title"],
            "version": book["vname"],
            "chapters": chapters,
        }
        (ROOT / book["json"]).write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
        vid, ins_ch, ins_sec, nch, nsec = upsert_book(cur, sid, book, chapters)
        line = "%s vid=%s chapters=%s(+%s) sections=%s(+%s)" % (book["vname"], vid, nch, ins_ch, nsec, ins_sec)
        summary.append(line)
        print(line)

    conn.commit()
    cur.close()
    conn.close()
    (ROOT / "_batch_import_summary.txt").write_text("\n".join(summary), encoding="utf-8")


if __name__ == "__main__":
    main()
