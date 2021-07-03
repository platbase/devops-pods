# Development environment with code-server.
# ----
# build image:
#   docker build --force-rm -t platbase.com/dev.code-server:1.2-3.10.2 .
# run test:
#   dc-start test-cdr

FROM platbase.com/dev.nodejs:1.2-14.17.1
LABEL maintainer="https://github.com/platbase"

# The version of node js
ENV CODE_SERVER_VER=3.10.2

# Mappings
EXPOSE 8080
VOLUME ["/workspace", "/data", "/tmp/.X11-unix"]

# Entry - force work with user "u01"
CMD /start-cdr.sh

###############################################################################

# Install code-server
RUN wget -O "/tmp/code-server_${CODE_SERVER_VER}_amd64.deb" \
	       https://github.com/cdr/code-server/releases/download/v${CODE_SERVER_VER}/code-server_${CODE_SERVER_VER}_amd64.deb
RUN dpkg -i "/tmp/code-server_${CODE_SERVER_VER}_amd64.deb"
RUN rm -f "/tmp/code-server_${CODE_SERVER_VER}_amd64.deb"

# Add shell scripts
ADD files /
RUN chmod +x /docker-cdr-init/*
RUN chmod +x /start-cdr.sh
