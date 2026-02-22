#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00-common.sh"

require docker
require kind
require kubectl

info "Creating kind cluster with NodePort and optional Ingress access..."
cat > /tmp/kind-netchaos.yaml <<'YAML'
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    extraPortMappings:
      # NodePort frontend
      - containerPort: 30080
        hostPort: 30080
        protocol: TCP
      # Optional Ingress (nginx) will listen on 80 inside the node
      # We map host 8081 -> node 80 (no root needed)
      - containerPort: 80
        hostPort: 8081
        protocol: TCP
YAML

kind create cluster --name netchaos --config /tmp/kind-netchaos.yaml
kubectl cluster-info
kubectl get nodes -o wide
info "Cluster ready."
echo "NodePort frontend: http://localhost:30080/"
echo "Optional Ingress:  http://localhost:8081/ (after installing ingress-nginx + applying ingress)"
