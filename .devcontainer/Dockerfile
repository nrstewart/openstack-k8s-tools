# .devcontainer/Dockerfile
FROM mcr.microsoft.com/devcontainers/base:noble

# 1) Copy the Netskope CA into the Debian/Ubuntu custom CA location
COPY nscacert_combined.pem /usr/local/share/ca-certificates/netskope.crt

# 2) Register it in the system trust store so all tools (apt, curl, git, Python requests) see it
#    Note: update-ca-certificates is available in the devcontainers base image.
RUN update-ca-certificates

# 3) (Optional but harmless) Tell APT explicitly to use the system CA bundle
RUN printf 'Acquire::https::CaInfo "/etc/ssl/certs/ca-certificates.crt";\n' \
    > /etc/apt/apt.conf.d/99-system-ca

# 4) (Optional) Set env vars for tools that honor these; the path is the merged bundle
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
    REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt \
    GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt \
    PIP_CERT=/etc/ssl/certs/ca-certificates.crt \
    NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt