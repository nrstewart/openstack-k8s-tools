# syntax=docker/dockerfile:1.7
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Optional: non-root user that works well with devcontainers
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

USER ${USERNAME}
WORKDIR /workspaces/app

CMD ["/bin/bash"]