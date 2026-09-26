#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
# shellcheck source=/dev/null
source "${ROOT_DIR}/config/env.sh"
PID_FILE="${ROOT_DIR}/logs/ruoyi-admin.pid"

echo "APP_HOME=${APP_HOME:-${ROOT_DIR}}"
echo "DOMAIN=${DOMAIN} PORT=${SERVER_PORT}"
echo "DB=${DB_HOST}:${DB_PORT}/${DB_NAME}"
echo "REDIS=${REDIS_HOST}:${REDIS_PORT}/${REDIS_DB}"
if [[ -f "${PID_FILE}" ]]; then
  PID="$(cat "${PID_FILE}")"
  if kill -0 "${PID}" 2>/dev/null; then
    echo "Backend: RUNNING pid=${PID}"
  else
    echo "Backend: STOPPED (stale pid file)"
  fi
else
  echo "Backend: STOPPED (no pid file)"
fi
if command -v ss >/dev/null 2>&1; then
  ss -tlnp 2>/dev/null | grep ":${SERVER_PORT} " || echo "Port ${SERVER_PORT}: free"
fi
curl -s -o /dev/null -w "HTTP captchaImage :%{http_code}\n" \
  "http://127.0.0.1:${SERVER_PORT}/captchaImage" || true
