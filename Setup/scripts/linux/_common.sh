#!/usr/bin/env bash
set -euo pipefail

confirm_setup_action() {
  local title="$1"
  shift
  printf '\n%s\n' "$title"
  for item in "$@"; do printf '  - %s\n' "$item"; done
  read -r -p 'Continue? Type yes: ' answer
  [[ "$answer" == 'yes' ]] || { printf 'Cancelled.\n'; exit 0; }
}

manifest_entries() {
  sed -e '/^[[:space:]]*$/d' -e '/^[[:space:]]*#/d' "$1"
}
