#!/bin/bash
# 导入高中化学知识点树到 PostgreSQL（xq.xmls.vip 云服务器）
# 幂等：已存在的 XKW-CHEM-* 不会重复插入。
#
# 用法：
#   1) 上传两个文件到服务器，例如：
#        /www/wwwroot/xq.xmls.vip/sql/spas_chem_xkw_knowledge.sql
#        /www/wwwroot/xq.xmls.vip/scripts/import_chem_xkw_knowledge.sh
#   2) 执行：
#        cd /www/wwwroot/xq.xmls.vip
#        chmod +x scripts/import_chem_xkw_knowledge.sh
#        bash scripts/import_chem_xkw_knowledge.sh
#      或指定 SQL 路径：
#        bash scripts/import_chem_xkw_knowledge.sh /path/to/spas_chem_xkw_knowledge.sql
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 兼容：放在 deploy/xq.xmls.vip/scripts 或仓库 scripts/
if [[ -f "${SCRIPT_DIR}/../config/env.sh" ]]; then
  ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
  # shellcheck source=/dev/null
  source "${ROOT_DIR}/config/env.sh"
elif [[ -f "/www/wwwroot/xq.xmls.vip/config/env.sh" ]]; then
  ROOT_DIR="/www/wwwroot/xq.xmls.vip"
  # shellcheck source=/dev/null
  source "${ROOT_DIR}/config/env.sh"
else
  ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
  export DB_HOST="${DB_HOST:-127.0.0.1}"
  export DB_PORT="${DB_PORT:-35432}"
  export DB_NAME="${DB_NAME:-spas_sql}"
  export DB_USERNAME="${DB_USERNAME:-postgres}"
  export DB_PASSWORD="${DB_PASSWORD:-}"
  export PGPASSWORD="${DB_PASSWORD}"
  export PG_DOCKER_CONTAINER="${PG_DOCKER_CONTAINER:-}"
fi

export PGPASSWORD="${DB_PASSWORD:-${PGPASSWORD:-}}"

resolve_sql() {
  if [[ $# -ge 1 && -n "${1:-}" ]]; then
    echo "$1"
    return 0
  fi
  local candidates=(
    "${ROOT_DIR}/sql/spas_chem_xkw_knowledge.sql"
    "${SCRIPT_DIR}/../sql/spas_chem_xkw_knowledge.sql"
    "${SCRIPT_DIR}/spas_chem_xkw_knowledge.sql"
    "./spas_chem_xkw_knowledge.sql"
    "/www/wwwroot/xq.xmls.vip/sql/spas_chem_xkw_knowledge.sql"
  )
  local f
  for f in "${candidates[@]}"; do
    if [[ -f "$f" ]]; then
      echo "$f"
      return 0
    fi
  done
  return 1
}

SQL_FILE="$(resolve_sql "${1:-}" || true)"
if [[ -z "${SQL_FILE}" || ! -f "${SQL_FILE}" ]]; then
  echo "[ERROR] 找不到 spas_chem_xkw_knowledge.sql"
  echo "  请先上传该文件，或：bash $0 /绝对路径/spas_chem_xkw_knowledge.sql"
  exit 1
fi
SQL_FILE="$(cd "$(dirname "${SQL_FILE}")" && pwd)/$(basename "${SQL_FILE}")"

# 去掉 Windows 换行（若有）
if command -v sed >/dev/null 2>&1; then
  if grep -q $'\r' "${SQL_FILE}" 2>/dev/null; then
    echo "==> 检测到 CRLF，转换为 LF..."
    sed -i 's/\r$//' "${SQL_FILE}" || true
  fi
fi

DOCKER_BIN="$(command -v docker || true)"
USE_DOCKER=0
PSQL_BIN=""

container_exists() {
  local n="$1"
  [[ -n "${n}" && -n "${DOCKER_BIN}" ]] || return 1
  "${DOCKER_BIN}" inspect "${n}" >/dev/null 2>&1
}

detect_pg_container() {
  if [[ -z "${DOCKER_BIN}" ]]; then
    return 1
  fi
  if container_exists "${PG_DOCKER_CONTAINER:-}"; then
    echo "${PG_DOCKER_CONTAINER}"
    return 0
  fi
  local cid names
  cid="$("${DOCKER_BIN}" ps --format '{{.Names}}\t{{.Ports}}' \
    | awk -F'\t' -v p=":${DB_PORT}->" '$2 ~ p {print $1; exit}')"
  if [[ -n "${cid}" ]]; then
    echo "${cid}"
    return 0
  fi
  names="$("${DOCKER_BIN}" ps --format '{{.Names}}')"
  cid="$(echo "${names}" | grep -E 'p5mm|postgresql_18|postgres' | head -n 1 || true)"
  if [[ -n "${cid}" ]]; then
    echo "${cid}"
    return 0
  fi
  cid="$("${DOCKER_BIN}" ps --format '{{.Names}}\t{{.Image}}' \
    | awk -F'\t' 'tolower($2) ~ /postgres|pgsql/ {print $1; exit}')"
  if [[ -n "${cid}" ]]; then
    echo "${cid}"
    return 0
  fi
  return 1
}

resolve_psql_host() {
  local candidates=(
    /www/server/pgsql/bin/psql
    /usr/pgsql-16/bin/psql
    /usr/pgsql-15/bin/psql
    /usr/local/pgsql/bin/psql
  )
  local c ver
  for c in "${candidates[@]}"; do
    [[ -x "${c}" ]] || continue
    ver="$("${c}" --version 2>/dev/null || true)"
    if echo "${ver}" | grep -Eq ' 9\.| 8\.'; then
      continue
    fi
    echo "${c}"
    return 0
  done
  if command -v psql >/dev/null 2>&1; then
    ver="$(psql --version 2>/dev/null || true)"
    if ! echo "${ver}" | grep -Eq ' 9\.| 8\.'; then
      command -v psql
      return 0
    fi
  fi
  return 1
}

psql_query() {
  local sql="$1"
  if [[ "${USE_DOCKER}" -eq 1 ]]; then
    "${DOCKER_BIN}" exec -e PGPASSWORD="${DB_PASSWORD}" -i "${PG_DOCKER_CONTAINER}" \
      psql -U "${DB_USERNAME}" -d "${DB_NAME}" -tAc "${sql}"
  else
    PGPASSWORD="${DB_PASSWORD}" "${PSQL_BIN}" -h "${DB_HOST}" -p "${DB_PORT}" \
      -U "${DB_USERNAME}" -d "${DB_NAME}" -tAc "${sql}"
  fi
}

run_sql_file() {
  echo "--> 执行 ${SQL_FILE}"
  if [[ "${USE_DOCKER}" -eq 1 ]]; then
    "${DOCKER_BIN}" exec -e PGPASSWORD="${DB_PASSWORD}" -i "${PG_DOCKER_CONTAINER}" \
      psql -U "${DB_USERNAME}" -d "${DB_NAME}" -v ON_ERROR_STOP=1 < "${SQL_FILE}"
  else
    PGPASSWORD="${DB_PASSWORD}" "${PSQL_BIN}" -h "${DB_HOST}" -p "${DB_PORT}" \
      -U "${DB_USERNAME}" -d "${DB_NAME}" -v ON_ERROR_STOP=1 -f "${SQL_FILE}"
  fi
}

# ---- 选择连接方式 ----
if CONT="$(detect_pg_container 2>/dev/null)"; then
  PG_DOCKER_CONTAINER="${CONT}"
  USE_DOCKER=1
  echo "==> PostgreSQL via Docker: ${PG_DOCKER_CONTAINER}"
elif PSQL_BIN="$(resolve_psql_host)"; then
  USE_DOCKER=0
  echo "==> PostgreSQL via host psql: ${PSQL_BIN}"
else
  echo "[ERROR] 未找到可用的 psql 或 PostgreSQL Docker 容器"
  echo "  查看容器: docker ps --format 'table {{.Names}}\t{{.Ports}}'"
  echo "  然后: export PG_DOCKER_CONTAINER=<容器名> && bash $0"
  exit 1
fi

echo "==> 目标库 ${DB_USERNAME}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
echo "==> SQL    ${SQL_FILE}"

# 库是否存在
EXISTS="$(psql_query "SELECT 1 FROM pg_database WHERE datname='${DB_NAME}'" | tr -d '[:space:]' || true)"
if [[ "${EXISTS}" != "1" ]]; then
  echo "[ERROR] 数据库 ${DB_NAME} 不存在。请先执行 bash install.sh 初始化。"
  exit 1
fi

HAS_USER="$(psql_query "SELECT 1 FROM information_schema.tables WHERE table_name='sys_user' LIMIT 1" | tr -d '[:space:]' || true)"
if [[ "${HAS_USER}" != "1" ]]; then
  echo "[ERROR] 未检测到 sys_user，请先完成系统基础库初始化（install.sh）。"
  exit 1
fi

HAS_KNOW="$(psql_query "SELECT 1 FROM information_schema.tables WHERE table_name='spas_knowledge' LIMIT 1" | tr -d '[:space:]' || true)"
if [[ "${HAS_KNOW}" != "1" ]]; then
  echo "[ERROR] 表 spas_knowledge 不存在，请先跑完 SPAS 增量 SQL（install.sh）。"
  exit 1
fi

BEFORE="$(psql_query "SELECT count(*) FROM spas_knowledge k JOIN spas_subject s ON s.subject_id=k.subject_id WHERE s.subject_code='CHEM' AND k.knowledge_code LIKE 'XKW-CHEM-%'" | tr -d '[:space:]' || echo 0)"
echo "==> 导入前 XKW-CHEM 节点数: ${BEFORE}"

run_sql_file

AFTER="$(psql_query "SELECT count(*) FROM spas_knowledge k JOIN spas_subject s ON s.subject_id=k.subject_id WHERE s.subject_code='CHEM' AND k.knowledge_code LIKE 'XKW-CHEM-%'" | tr -d '[:space:]')"
LEAVES="$(psql_query "SELECT count(*) FROM spas_knowledge k JOIN spas_subject s ON s.subject_id=k.subject_id WHERE s.subject_code='CHEM' AND k.knowledge_code LIKE 'XKW-CHEM-%' AND coalesce(k.node_type,'2')='2'" | tr -d '[:space:]')"
ROOT_NAME="$(psql_query "SELECT knowledge_name FROM spas_knowledge WHERE knowledge_code='XKW-CHEM-43452' LIMIT 1" | tr -d '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

echo ""
echo "=========================================="
echo " 导入完成"
echo " XKW-CHEM 总数 : ${AFTER}  (导入前 ${BEFORE})"
echo " 叶子知识点   : ${LEAVES}"
echo " 版本根名称     : ${ROOT_NAME}"
echo " 请到后台「知识点管理」选择学科「化学」查看"
echo "=========================================="

if [[ "${AFTER}" -lt 1581 ]]; then
  echo "[WARN] 节点数偏少（期望约 1731），请检查 SQL 是否完整、编码是否为 UTF-8。"
  exit 2
fi
