# Development environment for java with code-server.
# ----
# build image:
#   docker build --force-rm -t platbase.com/dev.env-java:1.4-08 .
# run test:
#   dc-start -

FROM platbase.com/dev.code-server:1.4-3.10.2
LABEL maintainer="https://github.com/platbase"

# Mappings
EXPOSE 8080
VOLUME ["/workspace", "/data", "/tmp/.X11-unix"]

# Entry - force work with user "u01"
CMD /start-cdr-java.sh

###############################################################################
RUN apt-get update

# Install java
RUN apt-get install -y openjdk-8-jdk maven
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /etc/profile && \
    echo "export PATH=\$JAVA_HOME/bin:\$PATH"                 >> /etc/profile

# Install extensions
RUN code-server --extensions-dir /usr/local/share/code-server/extensions --install-extension vscjava.vscode-java-pack && \
    code-server --extensions-dir /usr/local/share/code-server/extensions --install-extension redhat.vscode-xml && \
    code-server --extensions-dir /usr/local/share/code-server/extensions --install-extension vscjava.vscode-spring-initializr && \
    code-server --extensions-dir /usr/local/share/code-server/extensions --install-extension pivotal.vscode-spring-boot && \
    code-server --extensions-dir /usr/local/share/code-server/extensions --install-extension dgileadi.java-decompiler && \
    chown -Rv u01:u01 /usr/local/share/code-server/extensions

# Add shell scripts
ADD files /
RUN chmod +x /docker-cdr-init/docker-cdr-install-ext.sh && \
    chmod +x /start-cdr-java.sh
