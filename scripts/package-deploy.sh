#!/usr/bin/env bash
# Build backend + admin UI and pack deploy/xq.xmls.vip.zip for cloud upload.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEPLOY_NAME="xq.xmls.vip"
DEPLOY_DIR="${ROOT}/deploy/${DEPLOY_NAME}"
ZIP_PATH="${ROOT}/deploy/${DEPLOY_NAME}.zip"
SQL_SRC="${ROOT}/sql"

echo "==> Package cloud deploy (${DEPLOY_NAME})"
[[ -d "${DEPLOY_DIR}" ]] || { echo "Missing ${DEPLOY_DIR}"; exit 1; }
[[ -f "${DEPLOY_DIR}/config/env.sh" ]] || { echo "Missing deploy skeleton"; exit 1; }

# ---- Backend ----
echo "==> Maven package (skip tests)..."
cd "${ROOT}"
mvn -pl ruoyi-admin -am package -DskipTests
JAR_SRC="${ROOT}/ruoyi-admin/target/ruoyi-admin.jar"
[[ -f "${JAR_SRC}" ]] || { echo "Missing ${JAR_SRC}"; exit 1; }
mkdir -p "${DEPLOY_DIR}/app"
cp -f "${JAR_SRC}" "${DEPLOY_DIR}/app/ruoyi-admin.jar"
echo "    JAR -> deploy/${DEPLOY_NAME}/app/ruoyi-admin.jar"

# ---- Admin UI ----
UI_DIR="${ROOT}/ruoyi-ui"
cd "${UI_DIR}"
if [[ ! -d node_modules ]]; then
  echo "==> npm ci..."
  npm ci
fi
echo "==> npm run build:prod..."
npm run build:prod
DIST_DIR="${UI_DIR}/dist"
[[ -d "${DIST_DIR}" ]] || { echo "Missing ruoyi-ui/dist"; exit 1; }
rm -rf "${DEPLOY_DIR}/web"
cp -R "${DIST_DIR}" "${DEPLOY_DIR}/web"
echo "    UI  -> deploy/${DEPLOY_NAME}/web/"

# ---- SQL scripts ----
SQL_DEST="${DEPLOY_DIR}/sql"
mkdir -p "${SQL_DEST}"
find "${SQL_DEST}" -maxdepth 1 -name '*.sql' -delete 2>/dev/null || true
cp -f "${SQL_SRC}"/*.sql "${SQL_DEST}/"
echo "    SQL -> deploy/${DEPLOY_NAME}/sql/ ($(ls "${SQL_DEST}"/*.sql | wc -l | tr -d ' ') files)"

# ---- Empty runtime dirs ----
for sub in logs uploadPath uploadPath/avatar uploadPath/download uploadPath/upload; do
  mkdir -p "${DEPLOY_DIR}/${sub}"
done
find "${DEPLOY_DIR}/logs" -type f -delete 2>/dev/null || true
find "${DEPLOY_DIR}/uploadPath" -type f -delete 2>/dev/null || true

# ---- Unix LF for shell scripts ----
find "${DEPLOY_DIR}" -type f -name '*.sh' -print0 | while IFS= read -r -d '' f; do
  perl -i -pe 's/\r\n/\n/g; s/\r/\n/g' "$f"
  chmod +x "$f"
done
echo "    Shell scripts normalized to LF"

# ---- Zip ----
rm -f "${ZIP_PATH}"
echo "==> Creating zip..."
(
  cd "${ROOT}/deploy"
  zip -r -q "${DEPLOY_NAME}.zip" "${DEPLOY_NAME}" \
    -x "${DEPLOY_NAME}/logs/*" \
    -x "${DEPLOY_NAME}/uploadPath/avatar/*" \
    -x "${DEPLOY_NAME}/uploadPath/download/*" \
    -x "${DEPLOY_NAME}/uploadPath/upload/*"
)
SIZE_MB="$(du -m "${ZIP_PATH}" | awk '{print $1}')"
echo ""
echo "Done: ${ZIP_PATH} (${SIZE_MB} MB)"
echo "Upload to server, then:"
echo "  cd /www/wwwroot && unzip -o ${DEPLOY_NAME}.zip"
echo "  cd /www/wwwroot/${DEPLOY_NAME} && bash install.sh"
