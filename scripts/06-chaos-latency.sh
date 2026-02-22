#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00-common.sh"
require kubectl

ACTION="${1:-}"
if [[ "$ACTION" != "add" && "$ACTION" != "del" ]]; then
  echo "Usage: $0 add|del"
  exit 1
fi

POD="$(kubectl -n "$NS" get pod -l app=api -o jsonpath='{.items[0].metadata.name}')"

if [[ "$ACTION" == "add" ]]; then
  info "Adding latency: 250ms ±50ms (normal) on API pod $POD"
  kubectl -n "$NS" exec "$POD" -- sh -lc "tc qdisc replace dev eth0 root netem delay 250ms 50ms distribution normal"
  kubectl -n "$NS" exec "$POD" -- sh -lc "tc qdisc show dev eth0"
else
  info "Removing latency chaos on API pod $POD"
  kubectl -n "$NS" exec "$POD" -- sh -lc "tc qdisc del dev eth0 root || true"
  kubectl -n "$NS" exec "$POD" -- sh -lc "tc qdisc show dev eth0 || true"
fi
