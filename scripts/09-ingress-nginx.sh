#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00-common.sh"
require kubectl

ACTION="${1:-install}"

install_ingress() {
  info "Installing ingress-nginx (official manifest)..."
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.2/deploy/static/provider/kind/deploy.yaml
  info "Waiting for ingress-nginx controller..."
  kubectl -n ingress-nginx rollout status deploy/ingress-nginx-controller --timeout=180s
  kubectl -n ingress-nginx get pods -o wide
  info "Ingress installed. Access via http://localhost:8081/ after applying k8s/25-frontend-ingress.yaml"
}

uninstall_ingress() {
  info "Uninstalling ingress-nginx..."
  kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.2/deploy/static/provider/kind/deploy.yaml --ignore-not-found
}

case "$ACTION" in
  install) install_ingress ;;
  uninstall) uninstall_ingress ;;
  *) echo "Usage: $0 install|uninstall"; exit 1 ;;
esac
