# .devcontainer/Dockerfile
FROM mcr.microsoft.com/devcontainers/base:noble

# Install OpenStack Python clients
RUN pip install --no-cache-dir \
      python-openstackclient \
      python-heatclient \
      python-magnumclient \
      python-cinderclient \
      python-novaclient \
      python-neutronclient \
      python-glanceclient \
      python-swiftclient \
      python-designateclient

# Install 1Password CLI
RUN curl -sS https://downloads.1password.com/linux/keys/1password.asc -o /tmp/1password.asc \
    && ARCH=$(dpkg --print-architecture) \
    && gpg --dearmor < /tmp/1password.asc > /usr/share/keyrings/1password-archive-keyring.gpg \
    && echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/${ARCH} stable main" \
    | tee /etc/apt/sources.list.d/1password.list \
    && apt-get update \
    && apt-get install -y 1password-cli \
    && rm -rf /var/lib/apt/lists/* /tmp/1password.asc