# Development environment for java with code-server.
# ----
# build image:
#   docker build --force-rm -t platbase.com/dev.env-java:latest -t platbase.com/dev.env-java:1.4-0811 .
# run test:
#   dc-start -

FROM platbase.com/dev.code-server:latest
LABEL maintainer="https://github.com/platbase"

# Mappings
EXPOSE 8080
VOLUME ["/workspace", "/data", "/tmp/.X11-unix"]

# Entry - force work with user "u01"
CMD /start-cdr-java.sh

###############################################################################
RUN apt-get update

# Install java
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y openjdk-11-jdk maven
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> /etc/profile && \
    echo "export JDK_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> /etc/profile && \
    echo "export PATH=\$JAVA_HOME/bin:\$PATH"                 >> /etc/profile

# Install extensions
RUN /opt/add-extensions.sh vscjava.vscode-java-pack redhat.vscode-xml \
                           vscjava.vscode-spring-initializr pivotal.vscode-spring-boot dgileadi.java-decompiler

# Add shell scripts
ADD files /
RUN chmod +x /docker-cdr-init/docker-cdr-language-ext.sh && \
    chmod +x /start-cdr-java.sh
