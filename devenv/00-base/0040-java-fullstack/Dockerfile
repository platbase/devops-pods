# JDK, NodeJS and npm, As the basic environment for development.
# ----
# build image:
#   docker build --force-rm -t bizobj-container.net/dev/dev.java-fullstack:latest -t bizobj-container.net/dev/dev.java-fullstack:20230219 .
# run test:
#   dc-run -

FROM bizobj-container.net/dev/dev.nodejs:latest
LABEL maintainer="https://github.com/platbase"

# Mappings
EXPOSE 8080
VOLUME ["/workspace", "/data", "/tmp/.X11-unix"]

# Entry - force work with user "u01"
CMD /start-java-fullstack-shell.sh

###############################################################################

# Install java
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y openjdk-17-jdk
RUN apt-get install -y maven
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64" >> /etc/profile && \
    echo "export JDK_HOME=/usr/lib/jvm/java-17-openjdk-amd64"  >> /etc/profile && \
    echo "export PATH=\$JAVA_HOME/bin:\$PATH"                  >> /etc/profile

# Additional(libncurses5 is needed in embeded MySQL)
RUN apt-get install -y libncurses5

# Add shell scripts
ADD files /
RUN chmod +x /docker-java-fullstack-init/* && \
    chmod +x /start-java-fullstack-shell.sh
