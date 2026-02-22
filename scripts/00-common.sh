#!/usr/bin/env bash
set -euo pipefail

NS="netchaos"

require() {
  command -v "$1" >/dev/null 2>&1 || { echo "Missing: $1"; exit 1; }
}

info() { echo -e "\n[INFO] $*\n"; }
