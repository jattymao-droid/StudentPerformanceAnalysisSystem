#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
chmod +x "${HERE}/import_chn_xkw_knowledge.sh" 2>/dev/null || true
sed -i 's/\r$//' "${HERE}/import_chn_xkw_knowledge.sh" "${HERE}/run.sh" 2>/dev/null || true
bash "${HERE}/import_chn_xkw_knowledge.sh" "${HERE}/spas_chn_xkw_knowledge.sql"
