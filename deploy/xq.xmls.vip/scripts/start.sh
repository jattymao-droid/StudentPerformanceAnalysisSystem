#!/bin/bash
# Start 知脉 SPAS backend (Spring Boot jar).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
# shellcheck source=/dev/null
source "${ROOT_DIR}/config/env.sh"

JAR="${ROOT_DIR}/app/ruoyi-admin.jar"
PID_FILE="${ROOT_DIR}/logs/ruoyi-admin.pid"
LOG_FILE="${ROOT_DIR}/logs/ruoyi-admin.out"
PROFILE_DIR="${RUOYI_PROFILE:-${ROOT_DIR}/uploadPath}"

# Ensure datasource aliases are set for application-druid.yml
export SPAS_DB_URL="${SPAS_DB_URL:-${DB_URL}}"
export SPAS_DB_USER="${SPAS_DB_USER:-${DB_USERNAME}}"
export SPAS_DB_PASSWORD="${SPAS_DB_PASSWORD:-${DB_PASSWORD}}"
export RUOYI_PROFILE="${PROFILE_DIR}"

mkdir -p "${ROOT_DIR}/logs" "${PROFILE_DIR}"

if [[ ! -f "${JAR}" ]]; then
  echo "[ERROR] Missing ${JAR}"
  exit 1
fi

if [[ -f "${PID_FILE}" ]]; then
  OLD_PID="$(cat "${PID_FILE}" || true)"
  if [[ -n "${OLD_PID}" ]] && kill -0 "${OLD_PID}" 2>/dev/null; then
    echo "Already running (pid=${OLD_PID})"
    exit 0
  fi
  rm -f "${PID_FILE}"
fi

JAVA_BIN="$(command -v java || true)"
if [[ -z "${JAVA_BIN}" ]]; then
  echo "[ERROR] java not found. Install JDK 17+ (BaoTa Java manager or yum)."
  exit 1
fi

JAVA_MAJOR="$("${JAVA_BIN}" -version 2>&1 | awk -F '[\"\\.]' '/version/ {print $2; exit}')"
if [[ -n "${JAVA_MAJOR}" && "${JAVA_MAJOR}" -lt 17 ]]; then
  echo "[ERROR] JDK 17+ required, found Java ${JAVA_MAJOR}"
  exit 1
fi

if command -v ss >/dev/null 2>&1; then
  if ss -tln | grep -q ":${SERVER_PORT} "; then
    echo "[ERROR] Port ${SERVER_PORT} is already in use."
    echo "  Run: bash scripts/stop.sh"
    echo "  Or:  ss -tlnp | grep :${SERVER_PORT}"
    exit 1
  fi
fi

echo "==> Starting ruoyi-admin on :${SERVER_PORT}"
nohup "${JAVA_BIN}" ${JAVA_OPTS} -jar "${JAR}" \
  --spring.profiles.active="${SPRING_PROFILES_ACTIVE}" \
  --server.port="${SERVER_PORT}" \
  --ruoyi.profile="${PROFILE_DIR}" \
  > "${LOG_FILE}" 2>&1 &
echo $! > "${PID_FILE}"
sleep 4
if kill -0 "$(cat "${PID_FILE}")" 2>/dev/null; then
  echo "==> Started pid=$(cat "${PID_FILE}")"
  echo "    Log: ${LOG_FILE}"
  echo "    Admin UI: https://${DOMAIN}/   API: https://${DOMAIN}/prod-api/"
else
  echo "[ERROR] Process exited. Last log lines:"
  tail -n 40 "${LOG_FILE}" 2>/dev/null || true
  rm -f "${PID_FILE}"
  exit 1
fi
