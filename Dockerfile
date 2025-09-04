# syntax=docker/dockerfile:1.7
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    LANG=C.UTF-8

# Core OS deps and useful tooling
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl gnupg lsb-release \
      git openssh-client sudo \
      build-essential pkg-config \
  && rm -rf /var/lib/apt/lists/*

# kubectl (v1.30 channel)
RUN set -eux; \
  apt-get update && apt-get install -y --no-install-recommends ca-certificates curl gnupg; \
  mkdir -p /etc/apt/keyrings; \
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key \
    | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg; \
  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" \
    > /etc/apt/sources.list.d/kubernetes.list; \
  apt-get update && apt-get install -y --no-install-recommends kubectl; \
  rm -rf /var/lib/apt/lists/*

# Terraform (HashiCorp apt)
RUN set -eux; \
  apt-get update && apt-get install -y --no-install-recommends curl gnupg; \
  curl -fsSL https://apt.releases.hashicorp.com/gpg \
    | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg; \
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/hashicorp.list; \
  apt-get update && apt-get install -y --no-install-recommends terraform; \
  rm -rf /var/lib/apt/lists/*

# Python tooling: OpenStack clients + Ansible dev tools (includes ansible-core & ansible-lint)
# Ref: ansible-dev-tools bundles ansible-core, ansible-lint, molecule, etc.
RUN python -m pip install --upgrade pip && \
    python -m pip install --no-cache-dir \
      ansible-dev-tools \
      python-openstackclient \
      python-heatclient \
      python-magnumclient \
      python-cinderclient \
      python-novaclient \
      python-neutronclient \
      python-glanceclient \
      python-swiftclient \
      python-designateclient

# Optional: non-root user that works well with devcontainers
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
RUN set -eux; \
  groupadd --gid ${USER_GID} ${USERNAME}; \
  useradd -m -s /bin/bash --uid ${USER_UID} --gid ${USER_GID} ${USERNAME}; \
  usermod -aG sudo ${USERNAME}; \
  echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-devcontainer; \
  chmod 0440 /etc/sudoers.d/90-devcontainer

USER ${USERNAME}
WORKDIR /workspaces/app

CMD ["/bin/bash"]