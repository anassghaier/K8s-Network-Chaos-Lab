#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00-common.sh"
require kubectl
require curl

info "Testing frontend health..."
curl -sS http://localhost:30080/health && echo

info "Testing API via frontend proxy..."
curl -sS "http://localhost:30080/api/compute?n=30000" | jq .
