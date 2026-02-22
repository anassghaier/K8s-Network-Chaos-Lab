#!/usr/bin/env bash
set -euo pipefail

# Install Docker + kubectl + kind on Kali/Debian.
# Idempotent (safe to re-run).

echo "[INFO] Installing tools (Docker, kubectl, kind) for Kali/Debian..."

sudo apt-get update -y
sudo apt-get install -y --no-install-recommends ca-certificates curl gnupg lsb-release

# ---- Docker ----
if ! command -v docker >/dev/null 2>&1; then
  echo "[INFO] Installing Docker (docker.io)..."
  sudo apt-get install -y docker.io
  sudo systemctl enable --now docker || true
  sudo usermod -aG docker "$USER" || true
else
  echo "[INFO] Docker already installed."
fi

# ---- kubectl ----
if ! command -v kubectl >/dev/null 2>&1; then
  echo "[INFO] Installing kubectl (direct download)..."
  KVER="$(curl -fsSL https://dl.k8s.io/release/stable.txt)"
  curl -fsSLo kubectl "https://dl.k8s.io/release/${KVER}/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/kubectl
else
  echo "[INFO] kubectl already installed."
fi

# ---- kind ----
if ! command -v kind >/dev/null 2>&1; then
  echo "[INFO] Installing kind (direct download)..."
  # pinned version known to work with this lab
  KIND_VER="v0.23.0"
  curl -fsSLo kind "https://kind.sigs.k8s.io/dl/${KIND_VER}/kind-linux-amd64"
  chmod +x kind
  sudo mv kind /usr/local/bin/kind
else
  echo "[INFO] kind already installed."
fi

echo "[INFO] Done."
echo "[INFO] If this is your first Docker install, logout/login (or reboot) so your user is in the docker group."
