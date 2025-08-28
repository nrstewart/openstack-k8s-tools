#!/bin/sh
set -e

echo "[entrypoint] Initializing credentials with 1Password..."

# Ensure OP_SERVICE_ACCOUNT_TOKEN is set
if [ -z "$OP_SERVICE_ACCOUNT_TOKEN" ]; then
  echo "[entrypoint] ERROR: OP_SERVICE_ACCOUNT_TOKEN is not set."
  echo "             Please export it or mount it from a secret before running the container."
  exit 1
fi

# =============================
# OpenStack Credentials
# =============================
echo "[entrypoint] Fetching OpenStack credentials..."
export OS_USERNAME=$(op item get "RAC" --vault Secrets --field username --reveal)
export OS_PROJECT_NAME=$(op item get "RAC" --vault Secrets --field username --reveal)
export OS_PASSWORD=$(op item get "RAC" --vault Secrets --field password --reveal)
export OS_PROJECT_ID=$(op item get "RAC" --vault Secrets --field project_id --reveal)
export OS_AUTH_URL=$(op item get "RAC" --vault Secrets --field auth_url --reveal)
export OS_USER_DOMAIN_NAME="Default"

# Optionally write clouds.yaml for tools that prefer it
mkdir -p ~/.config/openstack
cat > ~/.config/openstack/clouds.yaml <<EOF
clouds:
  mycloud:
    auth:
      auth_url: "$OS_AUTH_URL"
      username: "$OS_USERNAME"
      password: "$OS_PASSWORD"
      project_name: "$OS_PROJECT_NAME"
      project_id: "$OS_PROJECT_ID"
      domain_name: "$OS_USER_DOMAIN_NAME"
EOF

echo "[entrypoint] OpenStack credentials initialized."

# =============================
# Kubernetes Credentials (not yet implemented)
# =============================
#echo "[entrypoint] Fetching Kubernetes kubeconfig..."
#mkdir -p ~/.kube
#op document get "kubeconfig" --output ~/.kube/config

#chmod 600 ~/.kube/config
#echo "[entrypoint] Kubernetes credentials initialized."

# =============================
# Handoff
# =============================
echo "[entrypoint] Starting command: $@"
exec "$@"