#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
E2E_DIR="$ROOT_DIR/tests/e2e"

echo "[bootstrap] Repo root: $ROOT_DIR"

echo "=============================="
echo "OS info"
echo "=============================="
uname -a || true
cat /etc/os-release || true

echo "=============================="
echo "Installing base prerequisites"
echo "=============================="
$SUDO apt-get update
$SUDO apt-get install -y \
  wget \
  gpg \
  ca-certificates \
  curl \
  unzip \
  git \
  jq \
  xvfb

echo "=============================="
echo "Installing Node.js LTS if missing"
echo "=============================="
if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | $SUDO bash -
  $SUDO apt-get install -y nodejs
else
  echo "Node already installed: $(node --version)"
fi

echo "=============================="
echo "Installing .NET SDK 8 if missing"
echo "=============================="
if ! command -v dotnet >/dev/null 2>&1; then
  echo "[bootstrap] ERROR: dotnet no está instalado" >&2
    exit 1
  fi

echo "[bootstrap] dotnet: $(dotnet --version)"

if ! command -v node >/dev/null 2>&1; then
  echo "[bootstrap] ERROR: node no está instalado" >&2
  exit 1
fi

echo "[bootstrap] node: $(node --version)"
echo "[bootstrap] npm: $(npm --version)"

if ! command -v xvfb-run >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    echo "[bootstrap] Instalando xvfb..."
    sudo apt-get update -y || apt-get update -y
    sudo apt-get install -y xvfb || apt-get install -y xvfb
  fi
fi

cd "$E2E_DIR"
echo "[bootstrap] npm ci en tests/e2e"
    npm ci
  else
    npm install
  fi

  npx playwright install chromium
  npx playwright --version || true
  npx playwright test --list || true

  popd >/dev/null
else
  echo "=============================="
  echo "E2E directory not found: $E2E_DIR"
  echo "Skipping Playwright setup"
  echo "=============================="
fi

echo "[bootstrap] Instalando Chromium de Playwright"
npx playwright install --with-deps chromium

echo "[bootstrap] Entorno listo"
