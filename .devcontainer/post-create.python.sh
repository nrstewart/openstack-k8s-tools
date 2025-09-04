#!/usr/bin/env bash
set -euo pipefail

echo "[postCreate] Installing Python tooling (ansible + openstack clients)…"

# Use the Python installed by the Feature (on PATH)
python --version
python -m pip install --upgrade pip

# Ansible + ansible-lint (via the dev tools meta-package)
python -m pip install --no-cache-dir ansible-dev-tools

# OpenStack client set
python -m pip install --no-cache-dir \
  python-openstackclient \
  python-heatclient \
  python-magnumclient \
  python-cinderclient \
  python-novaclient \
  python-neutronclient \
  python-glanceclient \
  python-swiftclient \
  python-designateclient

echo "[postCreate] Done."
