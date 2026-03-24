#!/usr/bin/env bash
set -euxo pipefail

SOLUTION_FILE="${1:-MachSoft.Template.sln}"
E2E_DIR="${2:-tests/e2e}"

if command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
else
  SUDO=""
fi

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
  . /etc/os-release

  if [[ "${ID:-}" != "ubuntu" && "${ID_LIKE:-}" != *"ubuntu"* ]]; then
    echo "ERROR: This script expects an Ubuntu-compatible image for apt-based .NET installation."
    echo "Detected distro: ID=${ID:-unknown}, VERSION_ID=${VERSION_ID:-unknown}"
    exit 1
  fi

  UBUNTU_VERSION="${VERSION_ID}"

  wget "https://packages.microsoft.com/config/ubuntu/${UBUNTU_VERSION}/packages-microsoft-prod.deb" -O /tmp/packages-microsoft-prod.deb
  $SUDO dpkg -i /tmp/packages-microsoft-prod.deb
  rm /tmp/packages-microsoft-prod.deb

  $SUDO apt-get update
  $SUDO apt-get install -y dotnet-sdk-8.0
else
  echo "dotnet already installed"
fi

echo "=============================="
echo "Verifying .NET"
echo "=============================="
command -v dotnet
dotnet --info
dotnet --list-sdks
dotnet --list-runtimes

echo "=============================="
echo "Checking workloads"
echo "=============================="
dotnet workload list || true

echo "=============================="
echo "NuGet sources"
echo "=============================="
dotnet nuget list source || true

echo "=============================="
echo "Verifying Node/NPM"
echo "=============================="
node --version
npm --version

echo "=============================="
echo "Installing browser/system dependencies"
echo "=============================="
$SUDO apt-get install -y \
  libnss3 \
  libnspr4 \
  libatk-bridge2.0-0 \
  libcups2 \
  libdrm2 \
  libdbus-1-3 \
  libxkbcommon0 \
  libxcomposite1 \
  libxdamage1 \
  libxfixes3 \
  libxrandr2 \
  libgbm1 \
  libasound2 \
  libatspi2.0-0 \
  libxshmfence1 \
  libgtk-3-0 \
  libx11-xcb1 \
  fonts-liberation \
  libu2f-udev \
  libvulkan1 || true

if [ -f "$SOLUTION_FILE" ]; then
  echo "=============================="
  echo "Restoring solution: $SOLUTION_FILE"
  echo "=============================="
  dotnet restore "$SOLUTION_FILE"

  echo "=============================="
  echo "Building solution: $SOLUTION_FILE"
  echo "=============================="
  dotnet build "$SOLUTION_FILE" --no-restore -c Release
else
  echo "=============================="
  echo "Solution file not found: $SOLUTION_FILE"
  echo "Skipping restore/build"
  echo "=============================="
fi

if [ -d "$E2E_DIR" ]; then
  echo "=============================="
  echo "Preparing E2E environment in: $E2E_DIR"
  echo "=============================="

  pushd "$E2E_DIR" >/dev/null

  if [ -f package-lock.json ]; then
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

echo "=============================="
echo "Recommended environment variables"
echo "=============================="
echo "PLAYWRIGHT_BROWSERS_PATH=${PLAYWRIGHT_BROWSERS_PATH:-<not set>}"
echo "CI=${CI:-<not set>}"

echo "=============================="
echo "Bootstrap completed"
echo "=============================="