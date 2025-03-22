# NodeJS and npm, As the basic environment for development.
# ----
# build image:
#   podman build --force-rm -t bizobj-container.net/pods/frontend-stack:latest -t bizobj-container.net/pods/frontend-stack:20250317-22.14.0 .
# run test by podman:
#   podman run -it --rm -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix bizobj-container.net/pods/frontend-stack:latest
# run test as Pod:
#   podman play kube ./test/test-pods.yaml ; podman attach devpods-30-test-frontend ; podman pod rm -f devpods-30-test

FROM bizobj-container.net/pods/dev.base:bookworm-20250317
LABEL maintainer="https://github.com/platbase"

# The version of node js
ENV NODE_VERSION=22.14.0

# The npm registry server
ENV NPM_REG=https://registry.npmmirror.com

# Volume for nodejs global cache (/data/nodejs)
VOLUME ["/data"]

###############################################################################

# Install NodeJS
RUN wget -O "/tmp/node-v${NODE_VERSION}-linux-x64.tar.xz" \
         https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz && \
    tar xvJf "/tmp/node-v${NODE_VERSION}-linux-x64.tar.xz" -C /opt && \
    rm "/tmp/node-v${NODE_VERSION}-linux-x64.tar.xz"
RUN export PATH=$PATH:/opt/node-v${NODE_VERSION}-linux-x64/bin  && \
    npm config set registry ${NPM_REG} --location=global        && \
    npm install -g yarn npm                                     && \
    npm config set prefix /data/nodejs/global --location=global && \
    npm config set cache  /data/nodejs/cache  --location=global && \
    /container-init/set-PATH "/data/nodejs/global/bin"          && \
    /container-init/set-PATH "/opt/node-v${NODE_VERSION}-linux-x64/bin"

# Init scripts
RUN /container-init/set-PS1 "\\h|Frontend"
