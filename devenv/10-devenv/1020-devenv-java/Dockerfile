# Development environment for java with code-server.
# ----
# build image:
#   docker build --force-rm -t bizobj-container.net/dev/dev.env-java:latest -t bizobj-container.net/dev/dev.env-java:08-17-20220703 .
# run test:
#   dc-start -

FROM bizobj-container.net/dev/dev.code-server:latest
LABEL maintainer="https://github.com/platbase"

# Mappings
EXPOSE 8080
VOLUME ["/workspace", "/data", "/tmp/.X11-unix"]

# Entry - force work with user "u01"
CMD /start-cdr-java.sh

###############################################################################
RUN apt-get update
RUN apt-get upgrade -y

# Install java
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y openjdk-17-jdk
RUN apt-get install -y maven
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64" >> /etc/profile && \
    echo "export JDK_HOME=/usr/lib/jvm/java-17-openjdk-amd64"  >> /etc/profile && \
    echo "export PATH=\$JAVA_HOME/bin:\$PATH"                  >> /etc/profile

# Install extensions
RUN /opt/add-extensions.sh vscjava.vscode-java-pack redhat.vscode-xml \
                           vscjava.vscode-spring-initializr pivotal.vscode-spring-boot dgileadi.java-decompiler \
                           redhat.fabric8-analytics

# Additional(libncurses5 is needed in embeded MySQL)
RUN apt-get install -y libncurses5

# Add shell scripts
ADD files /
RUN chmod +x /docker-cdr-init/docker-cdr-language-ext.sh && \
    chmod +x /start-cdr-java.sh
