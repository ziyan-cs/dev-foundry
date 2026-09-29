#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

if command -v uv >/dev/null 2>&1; then
  printf 'uv is already available.\n'
  exit 0
fi

confirm_setup_action 'uv' "Download and run Astral's official installer."
curl -LsSf https://astral.sh/uv/install.sh | sh
