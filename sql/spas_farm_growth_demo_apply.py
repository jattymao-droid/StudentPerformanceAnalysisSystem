# -*- coding: utf-8 -*-
"""Apply sql/spas_farm_growth_demo.sql (pg8000; same env as spas_apply_incremental).

Usage:
  set SPAS_DB_PASSWORD=your_password
  python sql/spas_farm_growth_demo_apply.py
"""
from __future__ import annotations

import os
import re
import sys
from pathlib import Path

SQL_DIR = Path(__file__).resolve().parent
DRUID_YML = SQL_DIR.parent / "ruoyi-admin/src/main/resources/application-druid.yml"


def _resolve_prop(raw: str) -> str:
    val = (raw or "").strip().strip('"').strip("'")
    m = re.fullmatch(r"\$\{([^:}]+)(?::([^}]*))?\}", val)
    if not m:
        return val
    key, default = m.group(1), m.group(2) if m.group(2) is not None else ""
    return os.environ.get(key, default)


def read_db_config():
    env_url = os.environ.get("SPAS_DB_URL", "").strip()
    env_user = os.environ.get("SPAS_DB_USER", "").strip() or "postgres"
    env_password = os.environ.get("SPAS_DB_PASSWORD", "")
    if env_url and env_password != "":
        m = re.search(r"jdbc:postgresql://([^:]+):(\d+)/([^\?\s]+)", env_url)
        if not m:
            raise SystemExit("Invalid SPAS_DB_URL")
        return m.group(1), int(m.group(2)), m.group(3), env_user, env_password

    text = DRUID_YML.read_text(encoding="utf-8")
    url = re.search(r"url:\s*(\S+)", text)
    user = re.search(r"username:\s*(\S+)", text)
    password = re.search(r"password:\s*(\S+)", text)
    if not (url and user and password):
        raise SystemExit("Failed to parse application-druid.yml")
    jdbc = _resolve_prop(url.group(1))
    db_user = _resolve_prop(user.group(1))
    db_password = _resolve_prop(password.group(1)) or os.environ.get("SPAS_DB_PASSWORD", "")
    if not db_password:
        raise SystemExit("Set SPAS_DB_PASSWORD then re-run")
    m = re.search(r"jdbc:postgresql://([^:]+):(\d+)/([^\?\s]+)", jdbc)
    if not m:
        raise SystemExit("Failed to parse JDBC url")
    return m.group(1), int(m.group(2)), m.group(3), db_user, db_password


def main():
    host, port, db, user, password = read_db_config()
    path = SQL_DIR / "spas_farm_growth_demo.sql"
    sql = path.read_text(encoding="utf-8")
    print(f"Applying {path.name} ¡ú {user}@{host}:{port}/{db}")
    import pg8000.native
    conn = pg8000.native.Connection(
        user=user, password=password, host=host, port=port, database=db
    )
    try:
        # pg8000 run may not support multiple statements in one go for DO blocks well ¡ª
        # execute whole script via cursor of dbapi
        import pg8000
        c = pg8000.connect(user=user, password=password, host=host, port=port, database=db)
        c.autocommit = True
        cur = c.cursor()
        cur.execute(sql)
        # fetch preview if available
        try:
            rows = cur.fetchall()
            print(f"preview rows: {len(rows)}")
            for r in rows[:20]:
                print(r)
        except Exception:
            print("OK (no preview resultset)")
        c.close()
    finally:
        try:
            conn.close()
        except Exception:
            pass
    print("Done. Reopen Å©³¡ to see stages.")


if __name__ == "__main__":
    main()
