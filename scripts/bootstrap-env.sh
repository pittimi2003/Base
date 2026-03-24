#!/usr/bin/env bash
set -euo pipefail

SOLUTION_FILE="${1:-MachSoft.Template.sln}"
E2E_DIR="${2:-tests/e2e}"

echo "=============================="
echo "OS info"
echo "=============================="
uname -a || true
cat /etc/os-release || true

echo "=============================="
echo "Installing base prerequisites"
echo "=============================="
sudo apt-get update
sudo apt-get install -y \
  wget \
  gpg \
  apt-transport-https \
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
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt-get install -y nodejs
else
  echo "Node already installed: $(node --version)"
fi

echo "=============================="
echo "Installing .NET SDK 8 if missing"
echo "=============================="
if ! command -v dotnet >/dev/null 2>&1; then
  . /etc/os-release
  UBUNTU_VERSION="${VERSION_ID}"

  wget "https://packages.microsoft.com/config/ubuntu/${UBUNTU_VERSION}/packages-microsoft-prod.deb" -O /tmp/packages-microsoft-prod.deb
  sudo dpkg -i /tmp/packages-microsoft-prod.deb
  rm /tmp/packages-microsoft-prod.deb

  sudo apt-get update
  sudo apt-get install -y dotnet-sdk-8.0
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
sudo apt-get install -y \
  libnss3 \
  libnspr4 \
  libatk1.0-0 \
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
  libvulkan1

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

  npx playwright install --with-deps chromium
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