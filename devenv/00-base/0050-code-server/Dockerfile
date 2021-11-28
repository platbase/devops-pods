# Development environment with code-server.
# ----
# build image:
#   docker build --force-rm -t platbase.com/dev.code-server:latest -t platbase.com/dev.code-server:1.4-3.12.0-20211128 .
# run test:
#   dc-start -

FROM platbase.com/dev.nodejs:latest
LABEL maintainer="https://github.com/platbase"

# The version of node js
ENV CODE_SERVER_VER=3.12.0

# Mappings
EXPOSE 8080
VOLUME ["/workspace", "/data", "/tmp/.X11-unix"]

# Entry - force work with user "u01"
CMD /start-cdr.sh

###############################################################################

# The pre-added commands
ADD commands/add-extensions.sh /opt/add-extensions.sh
RUN chmod +x /opt/add-extensions.sh

# Install code-server
RUN wget -O "/tmp/code-server_${CODE_SERVER_VER}_amd64.deb" \
	       https://github.com/cdr/code-server/releases/download/v${CODE_SERVER_VER}/code-server_${CODE_SERVER_VER}_amd64.deb && \
    dpkg -i "/tmp/code-server_${CODE_SERVER_VER}_amd64.deb" && \
    rm -f "/tmp/code-server_${CODE_SERVER_VER}_amd64.deb"
 
# Add common extensions
RUN /opt/add-extensions.sh vscode-icons-team.vscode-icons vincaslt.highlight-matching-tag alefragnani.bookmarks \
                           esbenp.prettier-vscode gruntfuggly.todo-tree

# Add shell scripts
ADD files /
RUN chmod +x /docker-cdr-init/* && \
    chmod +x /start-cdr.sh
