#!/bin/bash
# 在任意目录执行；优先读取 /www/wwwroot/xq.xmls.vip/config/env.sh
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
chmod +x "${HERE}/import_phys_xkw_knowledge.sh" 2>/dev/null || true
sed -i 's/\r$//' "${HERE}/import_phys_xkw_knowledge.sh" "${HERE}/run.sh" 2>/dev/null || true
bash "${HERE}/import_phys_xkw_knowledge.sh" "${HERE}/spas_phys_xkw_knowledge.sql"
