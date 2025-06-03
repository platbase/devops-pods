# The basic environment for development, based on podman
# ----
# build image:
#   podman build --force-rm -t bizobj-container.net/pods/dev.base:latest -t bizobj-container.net/pods/dev.base:bookworm-20250520 .
# run test by podman:
#   podman run -it --rm -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix bizobj-container.net/pods/dev.base:latest
#   podman run -it --rm bizobj-container.net/pods/dev.base:latest --atd --crond --nginx -- iostat 10
#   podman run --privileged -it --rm bizobj-container.net/pods/dev.base:latest --dockerd -- iostat 10
# run test as Pod:
#   podman play kube ./test/test-pods.yaml ; podman attach devpods-00-test-base ; podman pod rm -f devpods-00-test

# https://hub.docker.com/_/debian
FROM debian:bookworm-20250520
LABEL maintainer="https://github.com/platbase"

# Environment variables
#ENV DISPLAY ":0"  --> use "-e DISPLAY=unix$DISPLAY" + "-v /tmp/.X11-unix:/tmp/.X11-unix" instead

# TimeZone
ENV TZ=Asia/Shanghai

# Input Chinese in command line
ENV LANG=C.UTF-8

# Terminal type
ENV TERM=xterm-256color

# Set non-interactive mode (for packages requiring configuration)
ENV DEBIAN_FRONTEND=noninteractive

# Password for default user "root"(NOTE: applied in /container-entry/entry.base.sh)
ENV SET_ROOT_PASS=docker.io

###############################################################################

# Prepare apt-get
#RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources
RUN apt-get update && apt-get -y upgrade && \
    apt-get clean && rm -rfv /var/lib/apt/lists/* /var/cache/apt/archives/*

# Preparing installation and install basic tools
RUN apt-get update                                                     && \
    apt-get install -y telnet nano cron at procps fontconfig           && \
    apt-get install -y net-tools iproute2 inetutils-ping lsof sysstat  && \
    apt-get install -y wget curl sudo                                  && \
    apt-get install -y build-essential git subversion git-lfs          && \
    apt-get install -y openssh-server sshfs rinetd nginx               && \
    apt-get clean && rm -rfv /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install docker for dind
# 1. Install basic dependencies
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release iptables libseccomp2 && \
    apt-get clean && rm -rfv /var/lib/apt/lists/* /var/cache/apt/archives/*
# 2. Add official GPG key
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | \
    gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# 3. Set up apt repository
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
    https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
# 4. Install Docker Engine
RUN apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io && \
    apt-get clean && rm -rfv /var/lib/apt/lists/* /var/cache/apt/archives/*
# 5. Install Docker Compose (optional)
RUN curl -L "https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose
# 6. Configure Docker storage driver (avoid conflicts with host machine) -- Less efficient, prefer default overlay2 for full internal DinD scenarios
#RUN mkdir -p /etc/docker && \
#    echo '{"storage-driver": "vfs"}' > /etc/docker/daemon.json

# Additional(Chinese fonts, for Java Client such like JavaFX)
RUN apt-get update && \
    apt-get install -y fonts-noto-cjk          &&\
    apt-get install -y fonts-noto-cjk-extra    &&\
    apt-get install -y fonts-wqy-microhei fonts-wqy-zenhei xfonts-intl-chinese xfonts-wqy && \
    apt-get clean && rm -rfv /var/lib/apt/lists/* /var/cache/apt/archives/*

# Locales
RUN apt-get update                                       && \
    apt-get install -y locales                           && \
    echo "zh_CN.UTF-8 UTF-8"   >> /etc/locale.gen        && \
    echo "en_US.UTF-8 UTF-8"   >> /etc/locale.gen        && \
    dpkg-reconfigure --frontend=noninteractive locales   && \
    update-locale LANG=zh_CN.UTF-8                       && \
    apt-get clean && rm -rfv /var/lib/apt/lists/* /var/cache/apt/archives/*

# VSCode copy/paste support
RUN apt-get update && \
    apt-get install -y xclip && \
    apt-get clean && rm -rfv /var/lib/apt/lists/* /var/cache/apt/archives/*

# Additional(libncurses5 is needed in embeded MySQL)
RUN apt-get update && \
    apt-get install -y libncurses5 default-mysql-client && \
    apt-get clean && rm -rfv /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install Chromium
#RUN apt-get install -y chromium

# Change sshd behaviors
RUN echo "PermitRootLogin yes      " >  /etc/ssh/sshd_config.d/00-base.conf &&\
    echo "AllowAgentForwarding yes " >> /etc/ssh/sshd_config.d/00-base.conf &&\
    echo "AllowTcpForwarding yes   " >> /etc/ssh/sshd_config.d/00-base.conf &&\
    echo "X11Forwarding yes        " >> /etc/ssh/sshd_config.d/00-base.conf

# Change bashrc settings
RUN mkdir -p /container-init/.config/                      &&\
    touch /container-init/.config/.bashrc-container-PS1    &&\
    touch /container-init/.config/.bashrc-container-PATH   &&\
    touch /container-init/.config/.bashrc-container-ENVS   &&\
    echo "\n\n### $(date) ; $(id)"                           >> /etc/bash.bashrc &&\
    echo "### Default alias"                                 >> /etc/bash.bashrc &&\
    echo "alias ls='ls --color=auto'"                        >> /etc/bash.bashrc &&\
    echo "alias ll='ls --color=auto -al'"                    >> /etc/bash.bashrc &&\
    echo "### Command line Prompt, PATH, and ENVs"           >> /etc/bash.bashrc &&\
    echo ". /container-init/.config/.bashrc-container-PS1"   >> /etc/bash.bashrc &&\
    echo ". /container-init/.config/.bashrc-container-PATH"  >> /etc/bash.bashrc &&\
    echo ". /container-init/.config/.bashrc-container-ENVS"  >> /etc/bash.bashrc

# Init scripts
ADD files /

# Add hostname into PS1
RUN /container-init/set-PS1 "\\h"   # "\h" means "hostname" of PS1

###############################################################################

# Entry
ENTRYPOINT ["/container-entry/entry.base.sh"]
CMD ["--sshd", "--rinetd", "/container-entry/cmd.base.sh"]
