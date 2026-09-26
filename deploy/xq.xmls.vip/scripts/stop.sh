#!/bin/bash
# Stop 知脉 SPAS backend; also frees SERVER_PORT if an orphan Java process holds it.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
# shellcheck source=/dev/null
source "${ROOT_DIR}/config/env.sh"
PID_FILE="${ROOT_DIR}/logs/ruoyi-admin.pid"
PORT="${SERVER_PORT:-9093}"

find_port_pid() {
  local port="$1"
  local line pid
  if command -v ss >/dev/null 2>&1; then
    line="$(ss -tlnp 2>/dev/null | grep ":${port} " | head -n 1 || true)"
    if [[ -n "${line}" ]]; then
      pid="$(echo "${line}" | sed -n 's/.*pid=\([0-9][0-9]*\).*/\1/p' | head -n 1)"
      [[ -n "${pid}" ]] && echo "${pid}" && return 0
    fi
  fi
  if command -v lsof >/dev/null 2>&1; then
    pid="$(lsof -t -iTCP:"${port}" -sTCP:LISTEN 2>/dev/null | head -n 1 || true)"
    [[ -n "${pid}" ]] && echo "${pid}" && return 0
  fi
  if command -v fuser >/dev/null 2>&1; then
    pid="$(fuser "${port}/tcp" 2>/dev/null | tr -s ' ' '\n' | grep -E '^[0-9]+$' | head -n 1 || true)"
    [[ -n "${pid}" ]] && echo "${pid}" && return 0
  fi
  return 1
}

stop_pid() {
  local pid="$1"
  [[ -z "${pid}" ]] && return 0
  if kill -0 "${pid}" 2>/dev/null; then
    echo "Stopping pid=${pid}..."
    kill "${pid}" 2>/dev/null || true
    sleep 2
    kill -9 "${pid}" 2>/dev/null || true
    echo "Stopped pid=${pid}"
  fi
}

STOPPED=0
if [[ -f "${PID_FILE}" ]]; then
  PID="$(cat "${PID_FILE}" || true)"
  if [[ -n "${PID}" ]]; then
    stop_pid "${PID}"
    STOPPED=1
  fi
  rm -f "${PID_FILE}"
fi

PORT_PID="$(find_port_pid "${PORT}" || true)"
if [[ -n "${PORT_PID}" ]]; then
  echo "Found process on port ${PORT}: pid=${PORT_PID}"
  stop_pid "${PORT_PID}"
  STOPPED=1
fi

if [[ "${STOPPED}" -eq 0 ]]; then
  echo "Not running (no pid file, port ${PORT} free)"
fi
