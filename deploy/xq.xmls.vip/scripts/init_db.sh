#!/bin/bash
# Initialize PostgreSQL for 知脉 SPAS (xq.xmls.vip).
# Supports Docker-hosted PostgreSQL via docker exec (same host as bj.xmls.vip).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
# shellcheck source=/dev/null
source "${ROOT_DIR}/config/env.sh"

SQL_DIR="${ROOT_DIR}/sql"
USE_DOCKER=0
PSQL_BIN=""
DOCKER_BIN="$(command -v docker || true)"

container_exists() {
  local n="$1"
  [[ -n "${n}" && -n "${DOCKER_BIN}" ]] || return 1
  "${DOCKER_BIN}" inspect "${n}" >/dev/null 2>&1
}

detect_pg_container() {
  if [[ -z "${DOCKER_BIN}" ]]; then
    return 1
  fi
  if container_exists "${PG_DOCKER_CONTAINER}"; then
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
    "${PSQL_BIN:-}"
    /www/server/pgsql/bin/psql
    /usr/pgsql-16/bin/psql
    /usr/pgsql-15/bin/psql
    /usr/local/pgsql/bin/psql
  )
  local c ver
  for c in "${candidates[@]}"; do
    [[ -n "${c}" && -x "${c}" ]] || continue
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

psql_exec() {
  local db="$1"
  shift
  if [[ "${USE_DOCKER}" -eq 1 ]]; then
    "${DOCKER_BIN}" exec -e PGPASSWORD="${DB_PASSWORD}" -i "${PG_DOCKER_CONTAINER}" \
      psql -U "${DB_USERNAME}" -d "${db}" "$@"
  else
    PGPASSWORD="${DB_PASSWORD}" "${PSQL_BIN}" -h "${DB_HOST}" -p "${DB_PORT}" \
      -U "${DB_USERNAME}" -d "${db}" "$@"
  fi
}

run_sql_file() {
  local file="$1"
  local db="$2"
  echo "--> Import ${file} -> ${db}"
  if [[ "${USE_DOCKER}" -eq 1 ]]; then
    "${DOCKER_BIN}" exec -e PGPASSWORD="${DB_PASSWORD}" -i "${PG_DOCKER_CONTAINER}" \
      psql -U "${DB_USERNAME}" -d "${db}" -v ON_ERROR_STOP=1 < "${SQL_DIR}/${file}"
  else
    PGPASSWORD="${DB_PASSWORD}" "${PSQL_BIN}" -h "${DB_HOST}" -p "${DB_PORT}" \
      -U "${DB_USERNAME}" -d "${db}" -v ON_ERROR_STOP=1 -f "${SQL_DIR}/${file}"
  fi
}

# Ordered SPAS incremental (matches sql/spas_apply_incremental.py REQUIRED, after RuoYi base).
INCREMENTAL_SQL=(
  spas_schema.sql
  spas_menu.sql
  spas_menu_buttons.sql
  spas_knowledge_node_type.sql
  spas_subject_question_type.sql
  spas_teacher_dept.sql
  spas_teacher_migration.sql
  spas_teacher_roles.sql
  spas_teacher_homeroom.sql
  spas_warning_job.sql
  spas_score_revoke_fix.sql
  spas_score_source.sql
  spas_score_detail_crud.sql
  spas_intervene.sql
  spas_intervene_effect_json.sql
  spas_intervene_knowledge.sql
  spas_p1_score_reason.sql
  spas_quality.sql
  spas_quality_ticket.sql
  spas_report.sql
  spas_analysis_frequency_menu.sql
  spas_phase6_enhance.sql
  spas_route_name_fix.sql
  spas_ui_trim.sql
  spas_exam_score_init.sql
  spas_menu_exam_score.sql
  spas_error_tag.sql
  spas_question_type_experiment.sql
  spas_error_cause_v2.sql
  spas_bloom_level.sql
  spas_knowledge_edge.sql
  spas_brand_zhimai.sql
  spas_qb_schema.sql
  spas_qb_menu.sql
  spas_qb_annotate.sql
  spas_qb_select_center.sql
  spas_qb_ai_config.sql
  spas_report_hub.sql
  spas_recalc_job.sql
  spas_site_info.sql
  spas_group_practice.sql
  spas_student_points.sql
  spas_practice_checkout.sql
)

run_incremental_sql() {
  local db="$1"
  for f in "${INCREMENTAL_SQL[@]}"; do
    if [[ -f "${SQL_DIR}/${f}" ]]; then
      echo "--> Incremental ${f}"
      if [[ "${USE_DOCKER}" -eq 1 ]]; then
        "${DOCKER_BIN}" exec -e PGPASSWORD="${DB_PASSWORD}" -i "${PG_DOCKER_CONTAINER}" \
          psql -U "${DB_USERNAME}" -d "${db}" -v ON_ERROR_STOP=0 < "${SQL_DIR}/${f}" || true
      else
        PGPASSWORD="${DB_PASSWORD}" "${PSQL_BIN}" -h "${DB_HOST}" -p "${DB_PORT}" \
          -U "${DB_USERNAME}" -d "${db}" -v ON_ERROR_STOP=0 -f "${SQL_DIR}/${f}" || true
      fi
    else
      echo "    (skip missing ${f})"
    fi
  done
}

if CONT="$(detect_pg_container 2>/dev/null)"; then
  PG_DOCKER_CONTAINER="${CONT}"
  USE_DOCKER=1
  echo "==> PostgreSQL via Docker container: ${PG_DOCKER_CONTAINER}"
elif PSQL_BIN="$(resolve_psql_host)"; then
  USE_DOCKER=0
  echo "==> PostgreSQL via host psql: ${PSQL_BIN}"
else
  echo "[ERROR] Neither a usable host psql nor a PostgreSQL Docker container was found."
  echo "  List containers: docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Ports}}'"
  echo "  Then: export PG_DOCKER_CONTAINER=<name> && bash install.sh"
  if [[ -n "${DOCKER_BIN}" ]]; then
    "${DOCKER_BIN}" ps --format 'table {{.Names}}\t{{.Image}}\t{{.Ports}}' || true
  fi
  exit 1
fi

echo "==> Target DB=${DB_NAME} User=${DB_USERNAME} (app connects ${DB_HOST}:${DB_PORT})"

EXISTS="$(psql_exec postgres -tAc "SELECT 1 FROM pg_database WHERE datname='${DB_NAME}'" | tr -d '[:space:]' || true)"
if [[ "${EXISTS}" != "1" ]]; then
  echo "==> Create database ${DB_NAME}"
  psql_exec postgres -v ON_ERROR_STOP=1 -c "CREATE DATABASE ${DB_NAME} WITH ENCODING 'UTF8' TEMPLATE template0;"
else
  echo "==> Database ${DB_NAME} already exists"
fi

HAS_USER="$(psql_exec "${DB_NAME}" -tAc "SELECT 1 FROM information_schema.tables WHERE table_name='sys_user' LIMIT 1" | tr -d '[:space:]' || true)"
if [[ "${HAS_USER}" == "1" ]]; then
  echo "==> Detected existing sys_user — skip RuoYi base schema."
  echo "==> Applying SPAS incremental scripts only..."
  run_incremental_sql "${DB_NAME}"
  echo "==> Incremental SQL done."
  exit 0
fi

run_sql_file "ry_postgresql.sql" "${DB_NAME}"
if [[ -f "${SQL_DIR}/quartz_postgresql.sql" ]]; then
  run_sql_file "quartz_postgresql.sql" "${DB_NAME}"
fi
run_incremental_sql "${DB_NAME}"

echo "==> Database initialization completed."
echo "    Default admin: admin / admin123  (change immediately after login)"
echo "    App JDBC: ${DB_HOST}:${DB_PORT}/${DB_NAME}"
echo "    Redis: ${REDIS_HOST}:${REDIS_PORT} db=${REDIS_DB}"
