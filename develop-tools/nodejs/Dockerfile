# NodeJS and npm, As the basic environment for development.
#
# See README.md for build and run.

FROM platbase.com/dev.base:1.1
MAINTAINER https://github.com/platbase

# The version of node js
ENV VERSION=6.9.2

# The npm registry server
ENV NPM_REG=https://registry.npm.taobao.org

# Mappings
EXPOSE 8080
VOLUME ["/workspace", "/data", "/tmp/.X11-unix"]

# Environment variables
ENV DISPLAY ":0"

# Entry - force work with user "u01"
CMD /start-nodejs-shell.sh

###############################################################################

# Download nodejs
RUN wget http://nodejs.org/dist/v${VERSION}/node-v${VERSION}-linux-x64.tar.gz -O /tmp/node-v${VERSION}-linux-x64.tar.gz;

# Install NodeJS
RUN mkdir -p /opt/nodejs; \
    tar xzvf /tmp/node-v${VERSION}-linux-x64.tar.gz -C /opt/nodejs
RUN chown -Rv u01:u01 /opt/nodejs
RUN export PATH=$PATH:/opt/nodejs/node-v${VERSION}-linux-x64/bin; npm config set prefix /data/nodejs/global --global
RUN export PATH=$PATH:/opt/nodejs/node-v${VERSION}-linux-x64/bin; npm config set cache  /data/nodejs/cache  --global
RUN export PATH=$PATH:/opt/nodejs/node-v${VERSION}-linux-x64/bin; npm config set registry ${NPM_REG} --global

# Clean up
RUN rm /tmp/node-v${VERSION}-linux-x64.tar.gz

# make sure the package repository is up to date
RUN apt-get update

# Install zh-CN support
RUN apt-get install -y language-pack-zh-hans
RUN apt-get install -y ttf-ubuntu-font-family
RUN apt-get install -y ttf-wqy-zenhei ttf-wqy-microhei

# Install Chromium
RUN apt-get install -y chromium-browser

# Add nodejs-init shell scripts
ADD files/docker-nodejs-init /docker-nodejs-init
RUN chmod +x /docker-nodejs-init/*

# Prepare starting commands
ADD files/start-nodejs-shell.sh /start-nodejs-shell.sh
RUN chmod +x /start-nodejs-shell.sh
