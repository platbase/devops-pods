# NodeJS and npm, As the basic environment for development.
# ----
# build image:
#   podman build --force-rm -t bizobj-container.net/pods/frontend-stack:latest -t bizobj-container.net/pods/frontend-stack:20260217.node-2.13.1-go-1.26.0-python3 .
# run test by podman:
#   podman run -it --rm -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix bizobj-container.net/pods/frontend-stack:latest
# run test as Pod:
#   podman play kube ./test/test-pods.yaml ; podman attach devpods-30-test-frontend ; podman pod rm -f devpods-30-test

FROM bizobj-container.net/pods/dev.base:trixie-20260202
LABEL maintainer="https://github.com/platbase"

# The version of node js
ENV NODE_VERSION=24.13.1

# The version of go
ENV GO_VERSION=1.26.0

# The npm registry server
ENV NPM_REG=https://registry.npmmirror.com

# Volume for persistent data
#   - /data/nodejs/  (npm cache, global packages, pnpm store)
#   - /data/python/  (pip cache, pipx tools, user packages)
#   - /data/go/      (go executables, module cache, build cache)
VOLUME ["/data"]

###############################################################################

# Install NodeJS
RUN wget -O "/tmp/node-v${NODE_VERSION}-linux-x64.tar.xz" \
         https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz && \
    tar xvJf "/tmp/node-v${NODE_VERSION}-linux-x64.tar.xz" -C /opt && \
    rm "/tmp/node-v${NODE_VERSION}-linux-x64.tar.xz"
RUN export PATH=$PATH:/opt/node-v${NODE_VERSION}-linux-x64/bin          && \
    npm config set registry ${NPM_REG} --location=global                && \
    npm install -g yarn npm pnpm                                        && \
    npm config set prefix /data/nodejs/global --location=global         && \
    npm config set cache  /data/nodejs/cache  --location=global         && \
    pnpm config set store-dir /data/nodejs/pnpm-store --location=global && \
    pnpm set registry ${NPM_REG} --location=global                      && \
    /container-init/set-PATH "/data/nodejs/global/bin"                  && \
    /container-init/set-PATH "/opt/node-v${NODE_VERSION}-linux-x64/bin"

###############################################################################

# Install Go
RUN wget -O "/tmp/go${GO_VERSION}.linux-amd64.tar.gz" \
         https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar xzvf "/tmp/go${GO_VERSION}.linux-amd64.tar.gz" -C /opt && \
    rm "/tmp/go${GO_VERSION}.linux-amd64.tar.gz"

# Make go persistent directory structure:
# /data/go/
#   |- bin/          # executables from go install
#   |- pkg/          # compiled packages
#   |- cache/        # GOCACHE (build cache)
#   |- modcache/     # GOMODCACHE (module dependencies)
#   `- src/          # source code directory (traditional GOPATH)
RUN mkdir -p /data/go/{bin,pkg,cache,modcache,src} && \
    /container-init/set-ENV GOPATH        /data/go && \
    /container-init/set-ENV GOMODCACHE    /data/go/modcache && \
    /container-init/set-ENV GOCACHE       /data/go/cache && \
    /container-init/set-PATH "/data/go/bin" && \
    /container-init/set-PATH "/opt/go/bin"

###############################################################################

# Install Python3
RUN apt-get update                                                     && \
    apt-get install -y python3 python3-pip python3-venv pipx           && \
    apt-get install -y libssl-dev libffi-dev python3-dev               && \
    apt-get clean && rm -rfv /var/lib/apt/lists/* /var/cache/apt/archives/*

# Make python persistent directory structure:
# /data/python/
#   |- cache/         # pip cache directory
#   |- pipx/          # pipx directory
#   |   |- venvs/     # virtual environments for installed tools
#   |   `- bin/       # symlinks to pipx installed executables
#   |- uv/            # uv cache directory
#   `- global/        # user-installed Python packages
RUN PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install uv && \
    mkdir -p /data/python/{cache,pipx/{venvs,bin},uv,global} && \
    pip config set global.cache-dir /data/python/cache && \
    PIPX_HOME=/data/python/pipx PIPX_BIN_DIR=/data/python/pipx/bin pipx ensurepath && \
    /container-init/set-ENV PIPX_HOME       /data/python/pipx && \
    /container-init/set-ENV PIPX_BIN_DIR    /data/python/pipx/bin && \
    /container-init/set-ENV UV_CACHE_DIR    /data/python/uv && \
    /container-init/set-ENV PYTHONUSERBASE  /data/python/global && \
    /container-init/set-PATH "/data/python/pipx/bin" && \
    /container-init/set-PATH "/data/python/global/bin"

# Init scripts
RUN /container-init/set-PS1 "\\h|Frontend"
