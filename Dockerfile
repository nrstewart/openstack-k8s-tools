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


# Install OpenStack clients
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

# This is the default command that runs when the container starts.
CMD ["/bin/bash"]