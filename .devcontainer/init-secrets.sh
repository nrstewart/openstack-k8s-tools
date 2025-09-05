#!/usr/bin/env sh
set -eu

echo "[initializeCommand] Resolving secrets with 1Password on the host…"

# Optionally load a local .env if present (for OP_SERVICE_ACCOUNT_TOKEN)
if [ -f ".env" ]; then
  # shellcheck disable=SC1091
  . ".env"
fi

: "${OP_SERVICE_ACCOUNT_TOKEN:?[initializeCommand] OP_SERVICE_ACCOUNT_TOKEN is not set on the host (export it or put it in ./.env).}"

if ! command -v op >/dev/null 2>&1; then
  echo "[initializeCommand] ERROR: 'op' CLI not found on host."
  exit 1
fi

mkdir -p ".devcontainer/.secrets/openstack"

# Resolve everything from the template. Keep a full resolved dump (optional) for debugging.
op run --env-file ".devcontainer/.env.template" -- sh -lc 'env | sort' > ".devcontainer/.secrets/openstack/env.resolved"

# Extract only the OpenStack variables to the env file the container will consume.
awk -F= '/^(OS_USERNAME|OS_PROJECT_NAME|OS_PASSWORD|OS_PROJECT_ID|OS_AUTH_URL|OS_USER_DOMAIN_NAME)=/ {print}' \
  ".devcontainer/.secrets/openstack/env.resolved" > ".devcontainer/.secrets/openstack/openstack.env"

chmod 600 ".devcontainer/.secrets/openstack/openstack.env" ".devcontainer/.secrets/openstack/env.resolved" || true
echo "[initializeCommand] Wrote .devcontainer/.secrets/openstack/openstack.env"
