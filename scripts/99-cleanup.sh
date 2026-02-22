#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00-common.sh"

if command -v kind >/dev/null 2>&1; then
  info "Deleting kind cluster..."
  kind delete cluster --name netchaos || true
fi
