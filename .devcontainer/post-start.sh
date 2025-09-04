#!/usr/bin/env sh
set -eu

echo "[postStart] Writing OpenStack clouds.yaml inside the container…"

: "${OS_USERNAME:?missing}"
: "${OS_PROJECT_NAME:?missing}"
: "${OS_PASSWORD:?missing}"
: "${OS_PROJECT_ID:?missing}"
: "${OS_AUTH_URL:?missing}"
: "${OS_USER_DOMAIN_NAME:?missing}"

umask 077
CFG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/openstack"
CLOUDS_FILE="$CFG_DIR/clouds.yaml"

mkdir -p "$CFG_DIR"
cat > "$CLOUDS_FILE" <<EOF
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
chmod 600 "$CLOUDS_FILE"

echo "[postStart] clouds.yaml written to $CLOUDS_FILE"
