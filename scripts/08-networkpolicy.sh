#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00-common.sh"
require kubectl

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ACTION="${1:-apply}"

case "$ACTION" in
  apply)
    info "Applying NetworkPolicies (default deny + allow rules)..."
    kubectl apply -f "$ROOT/k8s/40-networkpolicy.yaml"
    kubectl -n "$NS" get networkpolicy
    ;;
  delete)
    info "Deleting NetworkPolicies..."
    kubectl delete -f "$ROOT/k8s/40-networkpolicy.yaml" --ignore-not-found
    kubectl -n "$NS" get networkpolicy || true
    ;;
  *)
    echo "Usage: $0 apply|delete"
    exit 1
    ;;
esac
