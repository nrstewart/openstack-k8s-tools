#!/bin/bash
set -e

# Point to the 1Password SSH Agent socket explicitly
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# Capture current terminal size
COLUMNS=$(tput cols)
LINES=$(tput lines)

# Run container with env + socket forwarded + terminal settings
op run --env-file=.env -- docker run --rm -it \
  -e OP_SERVICE_ACCOUNT_TOKEN \
  -v "$SSH_AUTH_SOCK:/ssh-agent" \
  -e SSH_AUTH_SOCK=/ssh-agent \
  -e COLUMNS=$COLUMNS \
  -e LINES=$LINES \
  -e TERM=xterm-256color \
  ghcr.io/nrstewart/openstack-k8s-tools:main
