#!/usr/bin/env bash
set -euo pipefail

# --- 1Password CLI install (idempotent) ---
if ! dpkg -s 1password-cli >/dev/null 2>&1; then
  curl -sS https://downloads.1password.com/linux/keys/1password.asc -o /tmp/1password.asc
  ARCH="$(dpkg --print-architecture)"
  gpg --dearmor < /tmp/1password.asc | sudo tee /usr/share/keyrings/1password-archive-keyring.gpg >/dev/null
  echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/${ARCH} stable main" \
    | sudo tee /etc/apt/sources.list.d/1password.list >/dev/null
  sudo apt-get update
  sudo apt-get install -y 1password-cli
  rm -f /tmp/1password.asc
fi

# --- Ansible Dev Tools install (idempotent) ---
if ! command -v adt >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y ansible-dev-tools libonig-dev

# --- pipx setup (idempotent) ------------------------------
# pipx needs python3-venv present. Install pipx if missing.
if ! command -v pipx >/dev/null 2>&1; then
  sudo apt-get install -y python3-venv pipx
fi

# Make sure ~/.local/bin is on PATH for future shells
# (pipx ensurepath is safe/idempotent)
pipx ensurepath || true

# Current session PATH might not include it yet
export PATH="$PATH:$HOME/.local/bin"

# List of packages to install via pipx
PIPX_PKGS=(
  python-openstackclient
  python-heatclient
  python-magnumclient
  python-cinderclient
  python-novaclient
  python-neutronclient
  python-glanceclient
  python-swiftclient
  python-designateclient
)

# Build a fast lookup of installed packages
#   - 'pipx list --short' prints one package name per line
#   - tolerate empty output on first run
installed="$(pipx list --short 2>/dev/null || true)"

for pkg in "${PIPX_PKGS[@]}"; do
  if echo "$installed" | grep -Fxq "$pkg"; then
    echo "[pipx] $pkg already installed; skipping."
  else
    echo "[pipx] Installing $pkg ..."
    # --pip-args passes args to pip inside the venv; include CA
    pipx install "$pkg"
  fi
done

# clean
sudo rm -rf /var/lib/apt/lists/*
