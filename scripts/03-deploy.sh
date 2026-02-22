#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00-common.sh"

require docker
require kind
require kubectl

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

info "Building images..."
docker build -t netchaos-api:1.0 "$ROOT/app/api"
docker build -t netchaos-frontend:1.0 "$ROOT/app/frontend"

info "Loading images into kind..."
kind load docker-image netchaos-api:1.0 --name netchaos
kind load docker-image netchaos-frontend:1.0 --name netchaos

info "Applying manifests..."
kubectl apply -f "$ROOT/k8s/00-namespace.yaml"
kubectl apply -f "$ROOT/k8s/10-api.yaml"
kubectl apply -f "$ROOT/k8s/20-frontend.yaml"

info "Waiting for pods..."
kubectl -n "$NS" rollout status deploy/api --timeout=180s
kubectl -n "$NS" rollout status deploy/frontend --timeout=180s
kubectl -n "$NS" get pods -o wide

info "Access:"
echo "  http://localhost:30080/"
