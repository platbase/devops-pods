# NodeJS and npm, As the basic environment for development
# ----
# build image:
#   docker build --force-rm -t platbase.com/dev.nodejs:1.0 .
# run:
#   docker run -it --rm -p 8080:8080 -v /tmp/nodejs.ws:/workspace -v /tmp/nodejs.data:/data platbase.com/dev.nodejs:1.0

FROM ubuntu:16.04
MAINTAINER https://github.com/platbase

# The version of node js
ENV VERSION=6.2.0

# The npm registry server
ENV NPM_REG=https://registry.npm.taobao.org

###############################################################################

# Add work user
RUN useradd -mU -u 1000 -d /home/u01 -s /bin/bash u01
RUN echo "u01:docker.io" | chpasswd     # Can't set password properly with "-p" argument in "useradd" command

# Preparing installation
ADD files/* /
RUN \
    apt-get update; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get install -y --allow-unauthenticated wget

# Install NodeJS
RUN \
    wget https://nodejs.org/dist/v${VERSION}/node-v${VERSION}-linux-x64.tar.gz -O /tmp/node-v${VERSION}-linux-x64.tar.gz; \
    mkdir -p /opt/nodejs; \
    tar xzvf /tmp/node-v${VERSION}-linux-x64.tar.gz -C /opt/nodejs
RUN chown -Rv u01:u01 /opt/nodejs
RUN export PATH=$PATH:/opt/nodejs/node-v${VERSION}-linux-x64/bin; npm config set prefix /data/global --global
RUN export PATH=$PATH:/opt/nodejs/node-v${VERSION}-linux-x64/bin; npm config set cache  /data/cache  --global
RUN export PATH=$PATH:/opt/nodejs/node-v${VERSION}-linux-x64/bin; npm config set registry ${NPM_REG} --global

# Env setup
ENV PS1_GREEN="\[$(tput bold)$(tput setaf 2)\]"
ENV PS1_RESET="\[$(tput sgr0)\]"
ENV _PS1="${PS1_GREEN}[NodeJS] ${PS1_RESET}\W${PS1_GREEN} > ${PS1_RESET}"
ENV _PATH="./node_modules/.bin:/opt/nodejs/node-v${VERSION}-linux-x64/bin:/opt/nodejs/node-v${VERSION}-linux-x64/bin/npm-global/bin"
RUN echo ""                                >> /home/u01/.bashrc
RUN echo "# Added by docker ******"        >> /home/u01/.bashrc
RUN echo "export PS1=\"${_PS1}\""          >> /home/u01/.bashrc
RUN echo "export PATH=\"\$PATH:${_PATH}\"" >> /home/u01/.bashrc
RUN echo "cd /workspace"                   >> /home/u01/.bashrc

# Clean up
RUN rm /tmp/node-v${VERSION}-linux-x64.tar.gz

# Mappings
EXPOSE 8080
VOLUME ["/workspace", "/data"]

# Entry - force work with user "u01"
CMD su - u01
