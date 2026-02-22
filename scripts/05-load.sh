#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00-common.sh"
require kubectl

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

info "Starting load generator Job (45s)..."
kubectl -n "$NS" delete job loadgen --ignore-not-found
kubectl apply -f "$ROOT/k8s/30-loadgen.yaml"
kubectl -n "$NS" logs -f job/loadgen
