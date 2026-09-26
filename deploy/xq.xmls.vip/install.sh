#!/bin/bash
# One-click: init DB + start backend. Run on the cloud server after upload.
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "${ROOT_DIR}"

chmod +x scripts/*.sh config/env.sh 2>/dev/null || true
# shellcheck source=/dev/null
source "${ROOT_DIR}/config/env.sh"

export APP_HOME="${ROOT_DIR}"
export RUOYI_PROFILE="${ROOT_DIR}/uploadPath"

echo "=========================================="
echo " 知脉 SPAS cloud install"
echo " Domain : ${DOMAIN}"
echo " Home   : ${ROOT_DIR}"
echo " Port   : ${SERVER_PORT}"
echo "=========================================="

mkdir -p "${ROOT_DIR}/logs" "${ROOT_DIR}/uploadPath" "${ROOT_DIR}/uploadPath/avatar" \
  "${ROOT_DIR}/uploadPath/download" "${ROOT_DIR}/uploadPath/upload"

bash "${ROOT_DIR}/scripts/init_db.sh"
bash "${ROOT_DIR}/scripts/stop.sh" || true
bash "${ROOT_DIR}/scripts/start.sh"

echo ""
echo "Next steps (BaoTa):"
echo "  1) Website root -> /www/wwwroot/xq.xmls.vip/web"
echo "  2) Paste nginx config from nginx/xq.xmls.vip.conf (or include it)"
echo "  3) Apply SSL for ${DOMAIN}"
echo "  4) Open https://${DOMAIN}/  login admin / admin123"
echo ""
echo "Manage:"
echo "  bash scripts/status.sh"
echo "  bash scripts/stop.sh"
echo "  bash scripts/start.sh"
echo "=========================================="
