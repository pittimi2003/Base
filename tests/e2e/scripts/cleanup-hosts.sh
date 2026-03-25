#!/usr/bin/env bash
set -euo pipefail

pids=$(pgrep -f "MachSoft.Template.Starter --urls http://127.0.0.1:" || true)
if [ -n "${pids}" ]; then
  echo "Stopping stale MachSoft.Template.Starter processes: ${pids}"
  # shellcheck disable=SC2086
  kill ${pids} || true
fi

showcase_pids=$(pgrep -f "MachSoft.Template.Core.Control.Showcase --urls http://127.0.0.1:" || true)
if [ -n "${showcase_pids}" ]; then
  echo "Stopping stale MachSoft.Template.Core.Control.Showcase processes: ${showcase_pids}"
  # shellcheck disable=SC2086
  kill ${showcase_pids} || true
fi
