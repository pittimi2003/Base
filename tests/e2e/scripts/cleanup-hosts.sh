#!/usr/bin/env bash
set -euo pipefail

pids=$(pgrep -f "MachSoft.Template.Starter --urls http://127.0.0.1:" || true)
if [ -n "${pids}" ]; then
  echo "Stopping stale MachSoft.Template.Starter processes: ${pids}"
  # shellcheck disable=SC2086
  kill ${pids} || true
fi
