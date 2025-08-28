# Use an official, lightweight Python base image.
# Docker on your M1 will automatically pull the correct ARM64 version.
FROM python:3.9.23-slim-trixie

# Set the working directory inside the container.
WORKDIR /app

# Install required system packages
RUN apt-get update && apt-get install -y \
    curl \
    apt-transport-https \
    gnupg \
    python3-pip \
    python3-dev\
    && rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN apt-get update && apt-get install -y curl ca-certificates gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key \
       | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
       https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" \
       > /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install -y kubectl \
    && rm -rf /var/lib/apt/lists/*

# Install 1Password CLI
RUN apt-get update && apt-get install -y curl gnupg ca-certificates \
  && curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --dearmor -o /usr/share/keyrings/1password-archive-keyring.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main" \
    > /etc/apt/sources.list.d/1password.list \
  && apt-get update && apt-get install -y 1password-cli \
  && rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN apt-get update && apt-get install -y --no-install-recommends curl gnupg lsb-release \
 && curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list \
 && apt-get update && apt-get install -y terraform \
 && rm -rf /var/lib/apt/lists/*

# Install OpenStack clients
RUN pip3 install --no-cache-dir --upgrade \
    setuptools \
    python-openstackclient \
    python-heatclient \
    python-magnumclient \
    python-cinderclient \
    python-novaclient \
    python-neutronclient \
    python-glanceclient \
    python-swiftclient \
    python-designateclient

# Copy the entrypoint into the container
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# This is the default command that runs when the container starts.
CMD ["/bin/bash"]