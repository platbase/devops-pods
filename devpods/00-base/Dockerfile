# The basic environment for development, based on podman
# ----
# build image:
#   podman build --force-rm -t bizobj-container.net/pods/dev.base:latest -t bizobj-container.net/pods/dev.base:20230325 .
# run test by podman:
#   podman run -it --rm -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix bizobj-container.net/pods/dev.base:latest
# run test as Pod:
#   podman play kube ./test/test-pods.yaml ; podman attach devpods-00-test-base ; podman pod rm -f devpods-00-test

# debian 11/bullseye
FROM debian:11
LABEL maintainer="https://github.com/platbase"

# Environment variables
#ENV DISPLAY ":0"  --> use "-e DISPLAY=unix$DISPLAY" + "-v /tmp/.X11-unix:/tmp/.X11-unix" instead

# TimeZone
ENV TZ=Asia/Shanghai

# Input Chinese in command line
ENV LANG=C.UTF-8

# Terminal type
ENV TERM=xterm-256color

# Entry
CMD /bin/bash

###############################################################################

# Prepare apt-get
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN apt-get update && apt-get -y upgrade

# Preparing installation and install basic tools
RUN apt-get install -y telnet nano cron procps fontconfig     && \
    apt-get install -y net-tools iproute2 inetutils-ping lsof && \
    apt-get install -y wget curl                              && \
    apt-get install -y build-essential git subversion

# Additional(Chinese fonts, for Java Client such like JavaFX)
RUN apt-get install -y fonts-wqy-microhei fonts-wqy-zenhei

# Install Chromium
#RUN apt-get install -y chromium

# Default alias
RUN echo "### Default alias"             >> /root/.bashrc &&\
    echo "alias ls='ls --color=auto'"    >> /root/.bashrc &&\
    echo "alias ll='ls --color=auto -l'" >> /root/.bashrc

# Add base-init shell scripts
ADD files /

# Init scripts
RUN mkdir /root/.config          && \
    /pod-commons/set-PS1 DevPod  && \
    echo "### Command line Prompt"         >> /root/.bashrc &&\
    echo ". ~/.config/.bashrc-docker-PS1"  >> /root/.bashrc
