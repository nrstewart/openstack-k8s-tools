#!/usr/bin/env bash
set -euo pipefail

echo "[post-create] Installing OpenStack Python clients..."

pipenv install \
  python-openstackclient \
  python-heatclient \
  python-magnumclient \
  python-cinderclient \
  python-novaclient \
  python-neutronclient \
  python-glanceclient \
  python-swiftclient \
  python-designateclient

echo "[post-create] OpenStack clients installed successfully."