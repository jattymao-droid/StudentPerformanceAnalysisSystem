# -*- coding: utf-8 -*-
import json
from pathlib import Path
import psycopg2

ROOT = Path(__file__).resolve().parent
TOC = next(ROOT.glob("rjb_physics_*_toc.json"))


def main():
    data = json.loads(TOC.read_text(encoding="utf-8"))
    conn = psycopg2.connect(
        host="localhost", dbname="spas-sql", user="postgres", password="mm5621528"
    )
    conn.autocommit = False
    cur = conn.cursor()

    physics_name = "\u7269\u7406"
    cur.execute(
        """
        INSERT INTO spas_subject(subject_code, subject_name, sort, status, create_by, create_time)
        SELECT %s, %s, 2, '0', 'admin', now()
        WHERE NOT EXISTS (SELECT 1 FROM spas_subject WHERE subject_code=%s)
        """,
        ("physics", physics_name, "physics"),
    )
    cur.execute("SELECT subject_id FROM spas_subject WHERE subject_code='physics'")
    subject_id = cur.fetchone()[0]

    inserted_chapters = 0
    inserted_leaves = 0

    for ci, ch in enumerate(data["chapters"], start=1):
        ch_name = ch["name"]
        ch_code = "PHY-RJ-BX1-CH{:02d}".format(ci)
        cur.execute(
            "SELECT knowledge_id FROM spas_knowledge WHERE knowledge_code=%s",
            (ch_code,),
        )
        row = cur.fetchone()
        if row:
            ch_id = row[0]
            cur.execute(
                """
                UPDATE spas_knowledge
                SET knowledge_name=%s, subject_id=%s, parent_id=0, ancestors='0',
                    node_type='1', order_num=%s, status='0',
                    update_by='admin', update_time=now()
                WHERE knowledge_id=%s
                """,
                (ch_name, subject_id, ci, ch_id),
            )
        else:
            cur.execute(
                """
                INSERT INTO spas_knowledge(
                  subject_id, parent_id, ancestors, knowledge_name, knowledge_code,
                  node_type, order_num, difficulty_default, status, create_by, create_time
                ) VALUES (%s, 0, '0', %s, %s, '1', %s, '2', '0', 'admin', now())
                RETURNING knowledge_id
                """,
                (subject_id, ch_name, ch_code, ci),
            )
            ch_id = cur.fetchone()[0]
            inserted_chapters += 1

        for si, sec in enumerate(ch.get("children") or [], start=1):
            sec_code = "{}-S{:02d}".format(ch_code, si)
            ancestors = "0,{}".format(ch_id)
            cur.execute(
                "SELECT knowledge_id FROM spas_knowledge WHERE knowledge_code=%s",
                (sec_code,),
            )
            srow = cur.fetchone()
            if srow:
                cur.execute(
                    """
                    UPDATE spas_knowledge
                    SET knowledge_name=%s, subject_id=%s, parent_id=%s, ancestors=%s,
                        node_type='2', order_num=%s, status='0',
                        update_by='admin', update_time=now()
                    WHERE knowledge_id=%s
                    """,
                    (sec, subject_id, ch_id, ancestors, si, srow[0]),
                )
            else:
                cur.execute(
                    """
                    INSERT INTO spas_knowledge(
                      subject_id, parent_id, ancestors, knowledge_name, knowledge_code,
                      node_type, order_num, difficulty_default, status, create_by, create_time
                    ) VALUES (%s, %s, %s, %s, %s, '2', %s, '2', '0', 'admin', now())
                    """,
                    (subject_id, ch_id, ancestors, sec, sec_code, si),
                )
                inserted_leaves += 1

    conn.commit()

    cur.execute(
        """
        WITH RECURSIVE t AS (
          SELECT knowledge_id, parent_id, node_type, knowledge_code, knowledge_name,
                 order_num, 1 AS depth, ARRAY[order_num, knowledge_id]::bigint[] AS path
          FROM spas_knowledge
          WHERE subject_id=%s AND parent_id=0
          UNION ALL
          SELECT k.knowledge_id, k.parent_id, k.node_type, k.knowledge_code, k.knowledge_name,
                 k.order_num, t.depth+1, t.path || k.order_num || k.knowledge_id
          FROM spas_knowledge k
          JOIN t ON k.parent_id = t.knowledge_id
          WHERE k.subject_id=%s
        )
        SELECT knowledge_id, parent_id, node_type, knowledge_code, knowledge_name, depth
        FROM t ORDER BY path
        """,
        (subject_id, subject_id),
    )
    rows = cur.fetchall()
    print(
        "subject_id={} inserted_chapters={} inserted_leaves={} total={}".format(
            subject_id, inserted_chapters, inserted_leaves, len(rows)
        )
    )
    for r in rows:
        print(("  " * (r[5] - 1)) + "[{}] {} {}".format(r[2], r[3], r[4]))

    note = ROOT / "spas_physics_rjb_bx1_seed.sql"
    note.write_text(
        "-- Physics RJB BX1 knowledge seed\n"
        "-- source: {}\n"
        "-- python sql/import_physics_rjb_bx1.py\n"
        "-- codes: PHY-RJ-BX1-CHxx / PHY-RJ-BX1-CHxx-Syy\n".format(
            data.get("source", "")
        ),
        encoding="utf-8",
    )
    cur.close()
    conn.close()


if __name__ == "__main__":
    main()
