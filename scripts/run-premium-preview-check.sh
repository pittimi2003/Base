#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARTIFACT_DIR="$ROOT_DIR/artifacts/ui-preview"

mkdir -p "$ARTIFACT_DIR"
rm -f "$ARTIFACT_DIR"/*.png

export E2E_PREVIEW=1
export E2E_PORT="${E2E_PORT:-5310}"

pushd "$ROOT_DIR/tests/e2e" >/dev/null

if command -v xvfb-run >/dev/null 2>&1; then
  echo "[preview-check] Ejecutando Playwright con xvfb-run"
  xvfb-run -a npm run preview
else
  echo "[preview-check] Ejecutando Playwright sin xvfb-run"
  npm run preview
  fi
  sleep 2
done

popd >/dev/null

count=$(find "$ARTIFACT_DIR" -maxdepth 1 -type f -name '*.png' | wc -l | tr -d ' ')
if [[ "$count" -lt 3 ]]; then
  echo "[preview-check] ERROR: evidencia visual insuficiente ($count screenshots)" >&2
  exit 1
fi

echo "[preview-check] OK: $count screenshots generados en $ARTIFACT_DIR"
