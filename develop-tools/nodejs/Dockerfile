# NodeJS and npm, As the basic environment for development
# ----
# build image:
#   docker build --force-rm -t platbase.com/dev.nodejs:1.0 .
# run:
#   docker run -it --rm -p 8080:8080 -v /tmp/nodejs.ws:/workspace -v /tmp/nodejs.data:/data platbase.com/dev.nodejs:1.0

FROM platbase.com/dev.base:1.0
MAINTAINER https://github.com/platbase

# The version of node js
ENV VERSION=6.2.0

# The npm registry server
ENV NPM_REG=https://registry.npm.taobao.org

# Mappings
EXPOSE 8080
VOLUME ["/workspace", "/data"]

# Entry - force work with user "u01"
CMD /start-nodejs-shell.sh

###############################################################################

# Download nodejs
RUN wget https://nodejs.org/dist/v${VERSION}/node-v${VERSION}-linux-x64.tar.gz -O /tmp/node-v${VERSION}-linux-x64.tar.gz;

# Install NodeJS
RUN mkdir -p /opt/nodejs; \
    tar xzvf /tmp/node-v${VERSION}-linux-x64.tar.gz -C /opt/nodejs
RUN chown -Rv u01:u01 /opt/nodejs
RUN export PATH=$PATH:/opt/nodejs/node-v${VERSION}-linux-x64/bin; npm config set prefix /data/global --global
RUN export PATH=$PATH:/opt/nodejs/node-v${VERSION}-linux-x64/bin; npm config set cache  /data/cache  --global
RUN export PATH=$PATH:/opt/nodejs/node-v${VERSION}-linux-x64/bin; npm config set registry ${NPM_REG} --global

# Clean up
RUN rm /tmp/node-v${VERSION}-linux-x64.tar.gz

# Prepare starting commands
ADD files/start-nodejs-shell.sh /start-nodejs-shell.sh
RUN chmod +x /start-nodejs-shell.sh
