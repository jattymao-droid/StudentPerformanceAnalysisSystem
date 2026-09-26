#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Import sql/spas_phys_xkw_knowledge.sql into PostgreSQL (local or cloud).

Reads DB settings from (first hit wins):
  1) env SPAS_DB_URL / SPAS_DB_USER / SPAS_DB_PASSWORD
  2) env DB_HOST/DB_PORT/DB_NAME/DB_USERNAME/DB_PASSWORD (deploy/xq.xmls.vip/config/env.sh)
  3) .env.local
  4) application-druid.yml defaults

Usage on cloud:
  cd /www/wwwroot/xq.xmls.vip
  source config/env.sh
  # upload sql/spas_phys_xkw_knowledge.sql into project sql/ or pass path
  python3 /path/to/import_xkw_phys_knowledge.py

Or with psql only:
  PGPASSWORD=... psql -h 127.0.0.1 -p 35432 -U postgres -d spas_sql \\
    -v ON_ERROR_STOP=1 -f sql/spas_phys_xkw_knowledge.sql
"""
from __future__ import annotations

import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SQL = ROOT / "sql" / "spas_phys_xkw_knowledge.sql"
DRUID_YML = ROOT / "ruoyi-admin/src/main/resources/application-druid.yml"


def load_dotenv_local() -> None:
    p = ROOT / ".env.local"
    if not p.exists():
        return
    for line in p.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        k, v = line.split("=", 1)
        os.environ.setdefault(k.strip(), v.strip().strip('"').strip("'"))


def resolve_prop(raw: str) -> str:
    val = (raw or "").strip().strip('"').strip("'")
    m = re.fullmatch(r"\$\{([^:}]+)(?::([^}]*))?\}", val)
    if not m:
        return val
    return os.environ.get(m.group(1), m.group(2) if m.group(2) is not None else "")


def read_db() -> tuple[str, str, str, str, str]:
    load_dotenv_local()
    # deploy env.sh style
    if os.environ.get("DB_HOST") and os.environ.get("DB_NAME"):
        return (
            os.environ.get("DB_HOST", "127.0.0.1"),
            os.environ.get("DB_PORT", "5432"),
            os.environ["DB_NAME"],
            os.environ.get("DB_USERNAME") or os.environ.get("DB_USER", "postgres"),
            os.environ.get("DB_PASSWORD") or os.environ.get("PGPASSWORD", ""),
        )
    env_url = os.environ.get("SPAS_DB_URL", "").strip()
    env_user = os.environ.get("SPAS_DB_USER", "").strip()
    env_password = os.environ.get("SPAS_DB_PASSWORD", "")
    if env_url and env_user:
        m = re.search(r"jdbc:postgresql://([^:]+):(\d+)/([^\?\s]+)", env_url)
        if not m:
            raise SystemExit("Invalid SPAS_DB_URL")
        return m.group(1), m.group(2), m.group(3), env_user, env_password
    text = DRUID_YML.read_text(encoding="utf-8")
    url = re.search(r"url:\s*(\S+)", text)
    user = re.search(r"username:\s*(\S+)", text)
    password = re.search(r"password:\s*(\S+)", text)
    if not (url and user and password):
        raise SystemExit("Cannot resolve DB config")
    jdbc = resolve_prop(url.group(1))
    db_user = resolve_prop(user.group(1))
    db_password = resolve_prop(password.group(1)) or os.environ.get("SPAS_DB_PASSWORD", "")
    m = re.search(r"jdbc:postgresql://([^:]+):(\d+)/([^\?\s]+)", jdbc)
    if not m:
        raise SystemExit("Cannot parse JDBC url")
    return m.group(1), m.group(2), m.group(3), db_user, db_password


def main() -> int:
    sql_path = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_SQL
    if not sql_path.is_file():
        raise SystemExit(f"Missing SQL file: {sql_path}")
    host, port, db, user, password = read_db()
    print(f"==> Import {sql_path.name} -> {user}@{host}:{port}/{db}")
    env = os.environ.copy()
    env["PGPASSWORD"] = password
    # Prefer docker exec if PG_DOCKER_CONTAINER is set (cloud)
    docker = os.environ.get("PG_DOCKER_CONTAINER", "").strip()
    if docker and subprocess.run(["docker", "inspect", docker], capture_output=True).returncode == 0:
        print(f"    via docker exec {docker}")
        r = subprocess.run(
            [
                "docker",
                "exec",
                "-i",
                "-e",
                f"PGPASSWORD={password}",
                docker,
                "psql",
                "-U",
                user,
                "-d",
                db,
                "-v",
                "ON_ERROR_STOP=1",
            ],
            input=sql_path.read_text(encoding="utf-8"),
            text=True,
            env=env,
        )
    else:
        r = subprocess.run(
            [
                "psql",
                "-h",
                host,
                "-p",
                port,
                "-U",
                user,
                "-d",
                db,
                "-v",
                "ON_ERROR_STOP=1",
                "-f",
                str(sql_path),
            ],
            env=env,
        )
    if r.returncode != 0:
        raise SystemExit(r.returncode)
    # verify
    q = "SELECT count(*) FROM spas_knowledge k JOIN spas_subject s ON s.subject_id=k.subject_id WHERE s.subject_code='PHYS' AND k.knowledge_code LIKE 'XKW-PHYS-%';"
    if docker and subprocess.run(["docker", "inspect", docker], capture_output=True).returncode == 0:
        out = subprocess.check_output(
            ["docker", "exec", "-e", f"PGPASSWORD={password}", docker, "psql", "-U", user, "-d", db, "-tAc", q],
            text=True,
            env=env,
        )
    else:
        out = subprocess.check_output(
            ["psql", "-h", host, "-p", port, "-U", user, "-d", db, "-tAc", q],
            text=True,
            env=env,
        )
    print(f"==> OK. XKW-PHYS nodes in DB: {out.strip()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
