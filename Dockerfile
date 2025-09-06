# .devcontainer/Dockerfile
FROM mcr.microsoft.com/devcontainers/base:noble

# Install OpenStack Python clients
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    && pip3 install --no-cache-dir \
      python-openstackclient \
      python-heatclient \
      python-magnumclient \
      python-cinderclient \
      python-novaclient \
      python-neutronclient \
      python-glanceclient \
      python-swiftclient \
      python-designateclient \
    && rm -rf /var/lib/apt/lists/*

# Install 1Password CLI
RUN curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    gpg --dearmor | tee /usr/share/keyrings/1password-archive-keyring.gpg > /dev/null \
    && echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | tee /etc/apt/sources.list.d/1password.list \
    && apt-get update && apt-get install -y 1password-cli \
    && rm -rf /var/lib/apt/lists/*
