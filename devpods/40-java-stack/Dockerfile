# JDK, NodeJS and npm, As the basic environment for development.
# ----
# build image:
#   podman build --force-rm -t bizobj-container.net/pods/java-stack:latest -t bizobj-container.net/pods/java-stack:20250520-8-and-21 .
# run test by podman:
#   podman run -it --rm -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix bizobj-container.net/pods/java-stack:latest
# run test as Pod:
#   podman play kube ./test/test-pods.yaml ; podman attach devpods-40-test-java ; podman pod rm -f devpods-40-test

FROM bizobj-container.net/pods/frontend-stack:20250520-22.16.0
LABEL maintainer="https://github.com/platbase"

# Volume for nodejs global cache (/data/nodejs)
VOLUME ["/data"]

###############################################################################

# Install java ( https://adoptium.net/zh-CN/installation/linux/ )
RUN wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
RUN echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list

RUN apt-get update -y && \
    apt-get install -y temurin-21-jdk && \
    apt-get install -y temurin-8-jdk  && \
    update-java-alternatives --set /usr/lib/jvm/temurin-8-jdk-amd64 && \
    apt-get install -y maven && \
    apt-get clean && rm -rfv /var/lib/apt/lists/* /var/cache/apt/archives/*

# Init scripts
RUN /container-init/set-PS1 "\\h|Java"
