#!/usr/bin/env bash
set -euo pipefail

APP_PROJECT="${1:-samples/MachSoft.Template.SampleApp/MachSoft.Template.SampleApp.csproj}"
BASE_URL="${2:-http://127.0.0.1:52922}"
PREVIEW_ROUTE="${3:-/premium-showcase}"
E2E_DIR="${4:-tests/e2e}"
ARTIFACTS_DIR="${5:-artifacts/ui-preview}"

mkdir -p "$ARTIFACTS_DIR"

echo "Starting sample app..."
dotnet run --project "$APP_PROJECT" --urls "$BASE_URL" > "$ARTIFACTS_DIR/sampleapp.log" 2>&1 &
APP_PID=$!

cleanup() {
  echo "Stopping sample app..."
  kill "$APP_PID" >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "Waiting for app to respond..."
READY=0
for i in {1..60}; do
  if curl -fsS "${BASE_URL}${PREVIEW_ROUTE}" >/dev/null 2>&1; then
    READY=1
    echo "App is ready."
    break
  fi
  sleep 2
done

if [ "$READY" -ne 1 ]; then
  echo "ERROR: Sample app did not become ready at ${BASE_URL}${PREVIEW_ROUTE}"
  exit 1
fi

if [ ! -d "$E2E_DIR" ]; then
  echo "ERROR: E2E directory not found: $E2E_DIR"
  exit 1
fi

pushd "$E2E_DIR" >/dev/null

export BASE_URL
export ARTIFACTS_DIR

echo "Running Playwright visual preview capture..."
xvfb-run -a npx playwright test preview.spec.ts --reporter=line

popd >/dev/null

echo "Artifacts generated in: $ARTIFACTS_DIR"