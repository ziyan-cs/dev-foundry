#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

command -v go >/dev/null 2>&1 || { printf 'go is not on PATH.\n' >&2; exit 1; }
root="$(cd "$(dirname "$0")/../.." && pwd)"
manifest="$root/manifests/go-tools.txt"
mapfile -t tools < <(manifest_entries "$manifest")
confirm_setup_action 'Go tools' "${tools[@]}"
for tool in "${tools[@]}"; do go install "$tool"; done
