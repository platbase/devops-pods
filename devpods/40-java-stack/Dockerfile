# JDK, NodeJS and npm, As the basic environment for development.
# ----
# build image:
#   podman build --force-rm -t bizobj-container.net/pods/java-stack:latest -t bizobj-container.net/pods/java-stack:8-and-17 .
# run test by podman:
#   podman run -it --rm -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix bizobj-container.net/pods/java-stack:latest
# run test as Pod:
#   podman play kube ./test/test-pods.yaml ; podman attach devpods-40-test-java ; podman pod rm -f devpods-40-test

FROM bizobj-container.net/pods/frontend-stack:latest
LABEL maintainer="https://github.com/platbase"

# Volume for nodejs global cache (/data/nodejs)
VOLUME ["/data"]

###############################################################################
RUN apt-get update -y

# Install java
RUN apt-get install -y openjdk-17-jdk maven
RUN apt-get install -y software-properties-common && \
    wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
    add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
    apt-get update -y && apt-get install -y adoptopenjdk-8-hotspot

# Additional(libncurses5 is needed in embeded MySQL)
RUN apt-get install -y libncurses5

# Init scripts
RUN /pod-commons/set-PS1 Java
