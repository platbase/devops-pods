# NodeJS and npm, As the basic environment for development.
# ----
# build image:
#   podman build --force-rm -t bizobj-container.net/pods/bizobj-pod/frontend:latest -t bizobj-container.net/pods/bizobj-pod/frontend:20260815.node-24-go-1.26-python3 .
# run test by podman:
#   podman run -it --rm -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix bizobj-container.net/pods/bizobj-pod/frontend:latest
# run test as Pod:
#   podman play kube ./test/test-pods.yaml ; podman attach devpods-30-test-frontend ; podman pod rm -f devpods-30-test

FROM bizobj-container.net/pods/bizobj-pod/devbase:trixie-20260803
LABEL maintainer="https://github.com/platbase"

# The version of node js
ENV NODE_VERSION=24.19.0

# The version of go
ENV GO_VERSION=1.26.6

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
    rm -fv "/tmp/node-v${NODE_VERSION}-linux-x64.tar.xz"

RUN export PATH=$PATH:/opt/node-v${NODE_VERSION}-linux-x64/bin          && \
    npm config set registry ${NPM_REG} --location=global                && \
    npm install -g npm pnpm                                             && \
    npm install -g --allow-scripts=yarn yarn                            && \
    npm config set prefix /data/nodejs/global --location=global         && \
    npm config set cache  /data/nodejs/cache  --location=global         && \
    pnpm config set store-dir /data/nodejs/pnpm-store --location=global && \
    pnpm set registry ${NPM_REG} --location=global

# PATH allows the shell to find binaries from both locations:
#   - /data/nodejs/global/bin  (runtime user-installed modules and tools, mounted volume)
#   - /opt/node-v.../bin       (image-embedded Node.js + baked-in global modules and tools)
#   - /data/nodejs/pnpm/bin    (runtime user-installed pnpm global tools)
#   - /opt/pnpm/bin            (image-embedded pnpm global tools)
# NODE_PATH allows Node.js to require() modules from both locations.
#   - NOTE: Do not rely on pnpm global packages for require/import resolution.
#           Use pnpm only as a CLI tool installer.
# We put the runtime path first so users can override image-embedded versions.
RUN /container-init/set-PATH "/data/nodejs/global/bin"                  && \
    /container-init/set-PATH "/opt/node-v${NODE_VERSION}-linux-x64/bin" && \
    /container-init/set-PATH "/data/nodejs/pnpm/bin"                    && \
    /container-init/set-PATH "/opt/pnpm/bin"                            && \
    /container-init/set-ENV PNPM_HOME "/data/nodejs/pnpm"               && \
    /container-init/set-ENV NODE_PATH "/data/nodejs/global/lib/node_modules:/opt/node-v${NODE_VERSION}-linux-x64/lib/node_modules"

# Demonstration for install package to default global prefix (npm and pnpm)
#  -- so that these tools are pre-installed into docker-image
#     and remain available even when /data is mounted as a volume at runtime.
RUN export PATH="$PATH:/opt/node-v${NODE_VERSION}-linux-x64/bin"        && \
    npm install -g --prefix=/opt/node-v${NODE_VERSION}-linux-x64 tldr   && \
    export PNPM_HOME=/opt/node-v${NODE_VERSION}-linux-x64               && \
    pnpm add -g --global-dir /opt/node-v${NODE_VERSION}-linux-x64/lib/node_modules gtop

###############################################################################

# Install Go
RUN wget -O "/tmp/go${GO_VERSION}.linux-amd64.tar.gz" \
         https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar xzvf "/tmp/go${GO_VERSION}.linux-amd64.tar.gz" -C /opt && \
    rm -fv "/tmp/go${GO_VERSION}.linux-amd64.tar.gz"

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

# Demonstration for install package to default GOPATH
#   -- Bake Go tools into the docker-image by overriding GOBIN for this RUN layer only.
#      Without this override, 'go install' would write to /data/go/bin (mounted volume)
#      and the tools would be lost when the container starts with a fresh volume.
RUN export PATH="$PATH:/opt/go/bin" && \
    GOBIN=/opt/go/bin go install github.com/muesli/duf@latest

###############################################################################

# Install Python3
RUN apt-get update                                                     && \
    apt-get install -y python3 python3-pip python3-venv pipx           && \
    apt-get install -y libssl-dev libffi-dev python3-dev               && \
    apt-get clean && rm -rfv /var/lib/apt/lists/* /var/cache/apt/archives/*

# Create the image-embedded default venv at /opt/venv (NOT in /data)
#   * --system-site-packages allows the venv to access apt-installed system packages
#     (e.g. python3-pil, python3-lxml) without reinstalling them.
RUN python3 -m venv /opt/venv --system-site-packages && \
    /opt/venv/bin/pip install --upgrade pip

# Write the exact Python version (e.g. "3.11") to /etc/PYTHON_VERSION so that
# subsequent RUN layers can read it via $(cat /etc/PYTHON_VERSION).
# This avoids hard-coding the minor version in multiple places.
RUN /opt/venv/bin/python -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")' > /etc/PYTHON_VERSION

# Make python persistent directory structure:
# /opt/pipx/          # Pre-installed pipx tools in docker-image
# /opt/uv/            # Pre-installed uv tools in docker-image
RUN mkdir -pv /opt/pipx/{venvs,bin} && \
    mkdir -pv /opt/uv/{tools,bin}

# Install uv as the basic pipx tool into docker-image
RUN export PATH="/opt/venv/bin:${PATH}" && \
    PIPX_HOME=/opt/pipx \
    PIPX_BIN_DIR=/opt/pipx/bin \
    PIPX_DEFAULT_PYTHON=/opt/venv/bin/python \
    pipx install uv

# PYTHONUSERBASE:
#   Controls the base directory for 'pip install --user'.
#   Packages go to /data/python/global/lib/pythonX.Y/site-packages/
#
# PYTHONPATH:
#   We prepend the user site-packages directory so that Python's sys.path
#   searches it BEFORE the system site-packages. This allows runtime user
#   packages to override image-embedded packages of the same name.
#
# PIP_CACHE_DIR:
#   Controls where pip stores downloaded files (wheels, tarballs) between
#   installations. This is NOT the installation directory. Use --no-cache-dir
#   to disable caching entirely without changing where packages are installed.
#
# PATH includes all Python binary directories:
#   - /data/python/pipx/bin     (runtime pipx tools, mounted volume)
#   - /data/python/uv/bin       (runtime uv tools, mounted volume)
#   - /data/python/global/bin   (runtime pip --user binaries, mounted volume)
#   - /opt/pipx/bin             (image-embedded pipx tools)
#   - /opt/uv/bin               (image-embedded uv tools)
#   - /usr/local/bin            (system pip binaries)
RUN pip config set --global global.cache-dir /data/python/cache && \
    PIPX_HOME=/data/python/pipx PIPX_BIN_DIR=/data/python/pipx/bin pipx ensurepath && \
    /container-init/set-ENV PYTHONUSERBASE      /data/python/global && \
    /container-init/set-ENV PYTHONPATH          "/data/python/global/lib/python$(cat /etc/PYTHON_VERSION)/site-packages" && \
    /container-init/set-ENV PIP_CACHE_DIR       /data/python/cache && \
    /container-init/set-ENV PIPX_HOME           /data/python/pipx && \
    /container-init/set-ENV PIPX_BIN_DIR        /data/python/pipx/bin && \
    /container-init/set-ENV PIPX_DEFAULT_PYTHON /opt/venv/bin/python && \
    /container-init/set-ENV UV_CACHE_DIR        /data/python/uv && \
    /container-init/set-ENV UV_TOOL_DIR         /data/python/uv/tools && \
    /container-init/set-ENV UV_TOOL_BIN_DIR     /data/python/uv/bin && \
    /container-init/ins-PATH "/opt/venv/bin"            && \
    /container-init/set-PATH "/data/python/pipx/bin"    && \
    /container-init/set-PATH "/data/python/uv/bin"      && \
    /container-init/set-PATH "/data/python/global/bin"  && \
    /container-init/set-PATH "/opt/pipx/bin"            && \
    /container-init/set-PATH "/opt/uv/bin"

# Demonstration for install packages and tools to default Python location
# PIPX
#  -- Install uv via pipx into an image-embedded location (/opt/pipx).
#     We override PIPX_HOME and PIPX_BIN_DIR for this RUN only so the tool is baked
#     into the image, not written to the mounted volume.
RUN export PATH="/opt/venv/bin:$PATH" && \
    PIPX_HOME=/opt/pipx \
    PIPX_BIN_DIR=/opt/pipx/bin \
    PIPX_DEFAULT_PYTHON=/opt/venv/bin/python \
    pipx install glances
# UV
#  -- Install additional uv tools into an image-embedded location.
#     We override UV_TOOL_DIR and UV_TOOL_BIN_DIR for this RUN only.
RUN export PATH="/opt/venv/bin:/opt/pipx/bin:$PATH" && \
    UV_TOOL_DIR=/opt/uv/tools UV_TOOL_BIN_DIR=/opt/uv/bin uv tool install httpie
# PIP
#   -- 'pip install' (WITHOUT --user) installs into the system site-packages
#      (/usr/local/lib/python3.x/dist-packages). These packages are embedded in the
#      image and are available even when /data is mounted as an empty volume.
#  -- 'pip install --user' installs into the user site-packages directory controlled
#     by PYTHONUSERBASE (/data/python/global/...). These packages are written to
#     the mounted volume and persist across container restarts, but they are NOT
#     present in the image itself.
RUN export PATH="/opt/venv/bin:$PATH" && \
    pip install --no-cache-dir humanize

###############################################################################

# Install Bun to /opt/bun (image-embedded).
#  -- The bun binary is placed at /opt/bun/bin/bun and survives volume mounts.
RUN BUN_INSTALL=/opt/bun bash -c 'curl -fsSL https://bun.sh/install | bash'

# BUN_INSTALL:              Default root directory Bun uses for global operations.
# BUN_INSTALL_GLOBAL_DIR:   Where 'bun install -g' places package contents.
# BUN_INSTALL_BIN:          Where 'bun install -g' links executable binaries.
# BUN_INSTALL_CACHE_DIR:    Where downloaded package tarballs are cached.
#
# We point all mutable directories to /data/bun so they persist across
# container restarts when /data is mounted as a volume.
#
# PATH includes both runtime and image-embedded bin directories so that
# shell commands can resolve binaries from either location.
RUN /container-init/set-ENV BUN_INSTALL "/data/bun" && \
    /container-init/set-ENV BUN_INSTALL_GLOBAL_DIR "/data/bun/install/global" && \
    /container-init/set-ENV BUN_INSTALL_BIN "/data/bun/bin" && \
    /container-init/set-ENV BUN_INSTALL_CACHE_DIR "/data/bun/install/cache" && \
    /container-init/set-PATH "/data/bun/bin" && \
    /container-init/set-PATH "/opt/bun/bin"

# Demonstration for install global packages to default location
#  -- Bake new global packages into the image by overriding global directories
RUN export PATH="/opt/bun/bin:$PATH" && \
    BUN_INSTALL_GLOBAL_DIR=/opt/bun/install/global \
    BUN_INSTALL_BIN=/opt/bun/bin \
    bun add -g concurrently

# Hooks
ADD files /

# Init scripts
RUN /container-init/set-PS1 "\\h|Frontend"
