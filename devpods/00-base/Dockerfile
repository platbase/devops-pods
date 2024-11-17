# The basic environment for development, based on podman
# ----
# build image:
#   podman build --force-rm -t bizobj-container.net/pods/dev.base:latest -t bizobj-container.net/pods/dev.base:bookworm-20241111 .
# run test by podman:
#   podman run -it --rm -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix bizobj-container.net/pods/dev.base:latest
# run test as Pod:
#   podman play kube ./test/test-pods.yaml ; podman attach devpods-00-test-base ; podman pod rm -f devpods-00-test

# https://hub.docker.com/_/debian
FROM debian:bookworm-20241111
LABEL maintainer="https://github.com/platbase"

# Environment variables
#ENV DISPLAY ":0"  --> use "-e DISPLAY=unix$DISPLAY" + "-v /tmp/.X11-unix:/tmp/.X11-unix" instead

# TimeZone
ENV TZ=Asia/Shanghai

# Input Chinese in command line
ENV LANG=C.UTF-8

# Terminal type
ENV TERM=xterm-256color

# Password for default user 'u01'
ENV PASSWORD_U01=docker.io

###############################################################################

# Prepare apt-get
#RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources
RUN apt-get update && apt-get -y upgrade

# Preparing installation and install basic tools
RUN apt-get install -y telnet nano cron at procps fontconfig           && \
    apt-get install -y net-tools iproute2 inetutils-ping lsof sysstat  && \
    apt-get install -y wget curl sudo                                  &&\
    apt-get install -y build-essential git subversion git-lfs          &&\
    apt-get install -y openssh-server sshfs rinetd nginx docker.io

# Additional(Chinese fonts, for Java Client such like JavaFX)
RUN apt-get install -y fonts-noto-cjk          &&\
    apt-get install -y fonts-noto-cjk-extra    &&\
    apt-get install -y fonts-wqy-microhei fonts-wqy-zenhei xfonts-intl-chinese xfonts-wqy

# Locales
RUN apt-get install -y locales                                              && \
    echo -e "\nzh_CN.UTF-8 UTF-8\nen_US.UTF-8 UTF-8" >> /etc/locale.gen     && \
    dpkg-reconfigure --frontend=noninteractive locales                      && \
    update-locale LANG=zh_CN.UTF-8

# VSCode copy/paste support
RUN apt-get install -y xclip

# Additional(libncurses5 is needed in embeded MySQL)
RUN apt-get install -y libncurses5 default-mysql-client

# Install Chromium
#RUN apt-get install -y chromium

# Add user "u01", sudo with no password
RUN useradd -mU -u 1000 -d /home/u01 -s /bin/bash u01 && \
    usermod -a -G sudo u01 && \
    echo "u01:${PASSWORD_U01}" | chpasswd     # Can not set password properly with "-p" argument in "useradd" command
RUN echo "u01 ALL= (ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/u01-nopasswd
RUN chown -Rv 1000:1000 ~u01

# Change bashrc
RUN mkdir -p /container-init/.config/                      &&\
    touch /container-init/.config/.bashrc-container-PS1    &&\
    touch /container-init/.config/.bashrc-container-PATH   &&\
    touch /container-init/.config/.bashrc-container-ENVS
RUN echo "\n\n"                                              >> /etc/bash.bashrc &&\
    echo "### $(date) ; $(id)"                               >> /etc/bash.bashrc &&\
    echo "### Default alias"                                 >> /etc/bash.bashrc &&\
    echo "alias ls='ls --color=auto'"                        >> /etc/bash.bashrc &&\
    echo "alias ll='ls --color=auto -al'"                    >> /etc/bash.bashrc &&\
    echo "### Command line Prompt"                           >> /etc/bash.bashrc &&\
    echo ". /container-init/.config/.bashrc-container-PS1"   >> /etc/bash.bashrc &&\
    echo ". /container-init/.config/.bashrc-container-PATH"  >> /etc/bash.bashrc &&\
    echo ". /container-init/.config/.bashrc-container-ENVS"  >> /etc/bash.bashrc

# Init scripts
ADD files /
RUN /container-init/set-PS1 "DevPod"

# Entry
ENTRYPOINT ["/container-entry/entry.base.sh"]
CMD ["--sshd", "--rinetd", "/container-entry/cmd.base.sh"]
