# Development environment with code-server.
# ----
# build image:
#   docker build --force-rm -t bizobj-container.net/dev/dev.code-server:latest -t bizobj-container.net/dev/dev.code-server:1.5-4.4.0-20220609 .
# run test:
#   dc-start -

FROM bizobj-container.net/dev/dev.nodejs:latest
LABEL maintainer="https://github.com/platbase"

# The version of code server
ENV CODE_SERVER_VER=4.4.0

# The directory to store default installed extensions
ENV CDR_EXT_CACHE=/usr/local/share/code-server-platbase-cache/extensions

# The password
ENV CDR_PASSWORD="*change*me*"

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
                           gruntfuggly.todo-tree esbenp.prettier-vscode

# Add shell scripts
ADD files /
RUN chmod +x /docker-cdr-init/* && \
    chmod +x /start-cdr.sh
