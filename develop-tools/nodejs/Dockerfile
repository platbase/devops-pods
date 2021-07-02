# NodeJS and npm, As the basic environment for development.
# ----
# build image:
#   docker build --force-rm -t platbase.com/dev.nodejs:1.2-14.17.1 .
# run test:
#   dc-run test-nodejs

FROM platbase.com/dev.base:1.2-20.04
LABEL maintainer="https://github.com/platbase"

# The version of node js
ENV NODE_VERSION=14.17.1

ENV DEVOPS_FIXED_ENVS "NODE_VERSION"

# The npm registry server
ENV NPM_REG=https://registry.npm.taobao.org

# Mappings
EXPOSE 8080
VOLUME ["/workspace", "/data", "/tmp/.X11-unix"]

# Entry - force work with user "u01"
CMD /start-nodejs-shell.sh

###############################################################################

# Install NodeJS
RUN wget -O "/tmp/node-v${NODE_VERSION}-linux-x64.tar.xz" https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz
RUN tar xvJf "/tmp/node-v${NODE_VERSION}-linux-x64.tar.xz" -C /opt
RUN chown -Rv u01:u01 /opt/node-v${NODE_VERSION}-linux-x64
RUN export PATH=$PATH:/opt/node-v${NODE_VERSION}-linux-x64/bin; npm config set prefix /data/nodejs/global --global
RUN export PATH=$PATH:/opt/node-v${NODE_VERSION}-linux-x64/bin; npm config set cache  /data/nodejs/cache  --global
RUN export PATH=$PATH:/opt/node-v${NODE_VERSION}-linux-x64/bin; npm config set registry ${NPM_REG} --global

# Clean up
RUN rm "/tmp/node-v${NODE_VERSION}-linux-x64.tar.xz"

# Add nodejs-init shell scripts
ADD files/docker-nodejs-init /docker-nodejs-init
RUN chmod +x /docker-nodejs-init/*

# Prepare starting commands
ADD files/start-nodejs-shell.sh /start-nodejs-shell.sh
RUN chmod +x /start-nodejs-shell.sh
