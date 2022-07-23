# Development environment with code-server.
# ----
# build image:
#   docker build --force-rm -t bizobj-container.net/dev/dev.code-server:latest -t bizobj-container.net/dev/dev.code-server:4.5.1 .
# run test:
#   dc-start -

FROM bizobj-container.net/dev/dev.nodejs:latest
LABEL maintainer="https://github.com/platbase"

# The version of code server
ENV CODE_SERVER_VER=4.5.1

# The directory to store default installed extensions
ENV CDR_EXT_CACHE=/usr/local/share/code-server-platbase-cache/extensions

# The server port - docker port mapping with same port is recommanded
ENV CDR_HTTPS_PORT=8443

# Proxy domain - ref: https://coder.com/docs/code-server/latest/guide#accessing-web-services
ENV CDR_PROXY_DOMAIN=localhost

# The password. NOTE: 'BLANK' means no password
ENV CDR_PASSWORD="*change*me*"

# code-server uses the Open-VSX extension gallery( https://open-vsx.org/ ) - https://github.com/coder/code-server/issues/5372
# https://github.com/coder/code-server/blob/main/docs/FAQ.md#how-do-i-use-my-own-extensions-marketplace
#     You can point code-server to it by setting $EXTENSIONS_GALLERY.
#     This corresponds directly with the extensionsGallery entry in in VS Code's product.json.
#         For example, to use the legacy Coder extensions marketplace:
#             export EXTENSIONS_GALLERY='{"serviceUrl": "https://extensions.coder.com/api"}'
ENV EXTENSIONS_GALLERY='{"serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery"}'

# Mappings
EXPOSE 8080
VOLUME ["/workspace", "/data", "/tmp/.X11-unix"]

# Entry - force work with user "u01"
CMD /start-cdr.sh

###############################################################################

# Install code-server
RUN wget -O "/tmp/code-server_${CODE_SERVER_VER}_amd64.deb" \
	       https://github.com/cdr/code-server/releases/download/v${CODE_SERVER_VER}/code-server_${CODE_SERVER_VER}_amd64.deb && \
    dpkg -i "/tmp/code-server_${CODE_SERVER_VER}_amd64.deb" && \
    rm -f "/tmp/code-server_${CODE_SERVER_VER}_amd64.deb"

# Yes, add builder signature
RUN echo "CODE SERVER Image built at $(date)" > /usr/lib/code-server/src/browser/_builder_.txt

# The pre-added commands
ADD commands/add-extensions.sh /opt/add-extensions.sh
RUN chmod +x /opt/add-extensions.sh

# Add common extensions
RUN /opt/add-extensions.sh vscode-icons-team.vscode-icons vincaslt.highlight-matching-tag alefragnani.bookmarks \
                           gruntfuggly.todo-tree esbenp.prettier-vscode

# Add shell scripts
ADD files /
RUN chmod +x /docker-cdr-init/* && \
    chmod +x /start-cdr.sh
