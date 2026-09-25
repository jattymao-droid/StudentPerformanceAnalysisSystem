# -*- coding: utf-8 -*-
"""Apply SPAS incremental SQL scripts in order.

Fresh database only. Do NOT re-run this on an existing spas-sql database:
spas_schema.sql is not idempotent and will fail if tables/columns already exist.
On an existing database, apply only the new script files (see docs/spas-sql-checklist.md).

Usage:
  python sql/spas_apply_incremental.py           # fresh database
  python sql/spas_apply_incremental.py --check   # verify key objects
  python sql/spas_apply_incremental.py --with-demo
"""
from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
from pathlib import Path

SQL_DIR = Path(__file__).resolve().parent
DRUID_YML = SQL_DIR.parent / "ruoyi-admin/src/main/resources/application-druid.yml"

REQUIRED = [
    "spas_schema.sql",
    "spas_menu.sql",
    "spas_menu_buttons.sql",
    "spas_knowledge_node_type.sql",
    "spas_subject_question_type.sql",
    "spas_teacher_dept.sql",
    "spas_teacher_migration.sql",
    "spas_teacher_roles.sql",
    "spas_teacher_homeroom.sql",
    "spas_warning_job.sql",
    "spas_score_revoke_fix.sql",
    "spas_score_source.sql",
    "spas_intervene.sql",
    "spas_intervene_effect_json.sql",
    "spas_intervene_knowledge.sql",
    "spas_p1_score_reason.sql",
    "spas_quality.sql",
    "spas_quality_ticket.sql",
    "spas_report.sql",
    "spas_analysis_frequency_menu.sql",
    "spas_open_seed.sql",
    "spas_phase6_enhance.sql",
    "spas_route_name_fix.sql",
    "spas_ui_trim.sql",
    "spas_exam_score_init.sql",
    "spas_exam_paper_id.sql",
    "spas_menu_exam_score.sql",
    "spas_error_tag.sql",
    "spas_question_type_experiment.sql",
    "spas_error_cause_v2.sql",
    "spas_bloom_level.sql",
    "spas_knowledge_edge.sql",
    "spas_qb_schema.sql",
    "spas_qb_menu.sql",
    "spas_qb_annotate.sql",
    "spas_qb_select_center.sql",
    "spas_qb_ai_config.sql",
    "spas_report_hub.sql",
]

OPTIONAL_DEMO = [
    "spas_school_dept_seed.sql",
    "spas_demo_seed.sql",
    "spas_knowledge_chapter_seed.sql",
    "spas_teacher_demo_seed.sql",
    "spas_teacher_multi_class_seed.sql",
    "spas_class2_demo_seed.sql",
    "spas_class2_student2_seed.sql",
    "spas_physics_rjb_bx1_seed.sql",
]

CHECKS = [
    ("table", "spas_intervene_task", "select to_regclass('public.spas_intervene_task')"),
    (
        "column",
        "spas_intervene_task.effect_json",
        "select 1 from information_schema.columns where table_name='spas_intervene_task' and column_name='effect_json'",
    ),
    (
        "column",
        "spas_knowledge.node_type",
        "select 1 from information_schema.columns where table_name='spas_knowledge' and column_name='node_type'",
    ),
    (
        "column",
        "spas_score_detail.score_source",
        "select 1 from information_schema.columns where table_name='spas_score_detail' and column_name='score_source'",
    ),
    (
        "column",
        "spas_warning_record.reason_json",
        "select 1 from information_schema.columns where table_name='spas_warning_record' and column_name='reason_json'",
    ),
    ("menu", "analysis frequency menu_id=2081", "select 1 from sys_menu where menu_id=2081"),
    ("menu", "intervene perms", "select 1 from sys_menu where perms like 'spas:intervene%' limit 1"),
    ("menu", "quality perms", "select 1 from sys_menu where perms like 'spas:quality%' limit 1"),
    ("table", "spas_intervene_knowledge", "select to_regclass('public.spas_intervene_knowledge')"),
    ("table", "spas_quality_ticket", "select to_regclass('public.spas_quality_ticket')"),
    ("menu", "quality ticket perms", "select 1 from sys_menu where menu_id=2136"),
    ("table", "spas_exam", "select to_regclass('public.spas_exam')"),
    ("table", "spas_exam_score", "select to_regclass('public.spas_exam_score')"),
    (
        "column",
        "spas_exam.paper_id",
        "select 1 from information_schema.columns where table_name='spas_exam' and column_name='paper_id'",
    ),
    (
        "column",
        "spas_exam_score.subject_name",
        "select 1 from information_schema.columns where table_name='spas_exam_score' and column_name='subject_name'",
    ),
    ("menu", "exam score menu_id=2150", "select 1 from sys_menu where menu_id=2150"),
    ("table", "spas_error_tag", "select to_regclass('public.spas_error_tag')"),
    ("table", "spas_qb_question", "select to_regclass('public.spas_qb_question')"),
    ("table", "spas_qb_paper", "select to_regclass('public.spas_qb_paper')"),
    (
        "column",
        "spas_paper.bank_paper_id",
        "select 1 from information_schema.columns where table_name='spas_paper' and column_name='bank_paper_id'",
    ),
    (
        "column",
        "spas_paper_question.bank_question_id",
        "select 1 from information_schema.columns where table_name='spas_paper_question' and column_name='bank_question_id'",
    ),
    ("menu", "qb menu_id=2300", "select 1 from sys_menu where menu_id=2300"),
    ("table", "spas_qb_annotate_session", "select to_regclass('public.spas_qb_annotate_session')"),
    (
        "column",
        "spas_qb_question.stem_image",
        "select 1 from information_schema.columns where table_name='spas_qb_question' and column_name='stem_image'",
    ),
    ("menu", "qb select menu_id=2320", "select 1 from sys_menu where menu_id=2320"),
    ("menu", "open admin menu_id=2120", "select 1 from sys_menu where menu_id=2120"),
    ("menu", "llm menu_id=118", "select 1 from sys_menu where menu_id=118"),
    ("menu", "report hub menu_id=2130 visible", "select 1 from sys_menu where menu_id=2130 and visible='0'"),
    (
        "column",
        "spas_qb_question.source_year",
        "select 1 from information_schema.columns where table_name='spas_qb_question' and column_name='source_year'",
    ),
    (
        "column",
        "spas_qb_paper.section_json",
        "select 1 from information_schema.columns where table_name='spas_qb_paper' and column_name='section_json'",
    ),
]


def read_db_config():
    text = DRUID_YML.read_text(encoding="utf-8")
    url = re.search(r"url:\s*jdbc:postgresql://([^:]+):(\d+)/([^\?\s]+)", text)
    user = re.search(r"username:\s*(\S+)", text)
    password = re.search(r"password:\s*(\S+)", text)
    if not (url and user and password):
        raise SystemExit("Failed to parse application-druid.yml")
    return url.group(1), url.group(2), url.group(3), user.group(1), password.group(1)


def psql(env, args, check=True):
    try:
        return subprocess.run(["psql", *args], env=env, check=check, text=True, capture_output=True)
    except FileNotFoundError:
        # Fallback: psycopg2 when psql CLI is not on PATH (common on Windows)
        return None


def run_sql_file(host, port, db, user, password, path):
    try:
        import psycopg2
    except ImportError as e:
        raise SystemExit("psql not found and psycopg2 not installed") from e
    sql = path.read_text(encoding="utf-8")
    conn = psycopg2.connect(host=host, port=port, dbname=db, user=user, password=password)
    conn.autocommit = True
    try:
        with conn.cursor() as cur:
            cur.execute(sql)
    finally:
        conn.close()


def run_sql_scalar(host, port, db, user, password, sql):
    try:
        import psycopg2
    except ImportError as e:
        raise SystemExit("psql not found and psycopg2 not installed") from e
    conn = psycopg2.connect(host=host, port=port, dbname=db, user=user, password=password)
    try:
        with conn.cursor() as cur:
            cur.execute(sql)
            row = cur.fetchone()
            return None if row is None else row[0]
    finally:
        conn.close()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true", help="only verify objects")
    ap.add_argument("--with-demo", action="store_true", help="also apply demo seeds")
    args = ap.parse_args()

    host, port, db, user, password = read_db_config()
    env = {**os.environ, "PGPASSWORD": password}
    base = ["-h", host, "-p", port, "-U", user, "-d", db]

    if args.check:
        missing = []
        for kind, name, sql in CHECKS:
            r = psql(env, base + ["-tAc", sql], check=False)
            if r is None:
                val = run_sql_scalar(host, port, db, user, password, sql)
                ok = val not in (None, 0, "0")
            else:
                ok = (r.stdout or "").strip() not in ("", "0")
            print(("OK  " if ok else "MISS") + f" [{kind}] {name}")
            if not ok:
                missing.append(name)
        sys.exit(1 if missing else 0)

    scripts = list(REQUIRED)
    if args.with_demo:
        scripts += OPTIONAL_DEMO

    for name in scripts:
        path = SQL_DIR / name
        if not path.exists():
            print(f"SKIP missing file: {name}")
            continue
        print(f"APPLY {name} ...")
        r = psql(env, base + ["-v", "ON_ERROR_STOP=1", "-f", str(path)], check=False)
        if r is None:
            try:
                run_sql_file(host, port, db, user, password, path)
            except Exception as e:
                print(e)
                raise SystemExit(f"Failed: {name}")
        elif r.returncode != 0:
            print(r.stderr or r.stdout)
            raise SystemExit(f"Failed: {name}")
        print(f"OK: {name}")

    print("Done. Run with --check to verify.")


if __name__ == "__main__":
    main()
