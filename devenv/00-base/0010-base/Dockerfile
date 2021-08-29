# The basic environment for development
# ----
# build image:
#   docker build --force-rm -t platbase.com/dev.base:latest -t platbase.com/dev.base:1.4-20.04 .
# run:
#   docker run -it --rm -v /tmp/dev-base.ws:/workspace -v /tmp/dev-base.data:/data platbase.com/dev.base
# run chromium:
#   dc-run test-chromium
# run chromium with --no-sandbox ( chromium --no-sandbox )
#   dc-run test-chromium-no-sandbox

FROM ubuntu:20.04
LABEL maintainer="https://github.com/platbase"

# Mappings
VOLUME ["/workspace", "/data"]

# Environment variables
#ENV DISPLAY ":0"  --> use "-e DISPLAY=unix$DISPLAY" instead

# Entry - force work with user "u01"
CMD /start-example.sh

###############################################################################
RUN apt-get update

# Install Chromium
#RUN apt-get install -y chromium-browser
#----
#RUN wget -O "/tmp/google-chrome-stable_current_amd64.deb" https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#RUN apt-get install -y /tmp/google-chrome-stable_current_amd64.deb
#RUN rm /tmp/google-chrome-stable_current_amd64.deb
#----
RUN apt-get install -y software-properties-common && \
    add-apt-repository ppa:xtradeb/apps && \
    apt-get install -y chromium

# Preparing installation and install basic tools
RUN \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --allow-unauthenticated sudo && \
    apt-get install -y --allow-unauthenticated wget

# Install necessary packages
RUN \
    export DEBIAN_FRONTEND=noninteractive&& \
    apt-get install -y --allow-unauthenticated net-tools      && \
    apt-get install -y --allow-unauthenticated iproute2       && \
    apt-get install -y --allow-unauthenticated inetutils-ping && \
    apt-get install -y --allow-unauthenticated python         && \
    apt-get install -y --allow-unauthenticated build-essential
RUN \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --allow-unauthenticated telnet && \
    apt-get install -y --allow-unauthenticated nano

# zh-CN TimeZone settings
RUN \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --allow-unauthenticated tzdata
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# zh-CN support(charset)
RUN apt-get install -y locales && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales && \
    locale-gen zh_CN.UTF-8  
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN:zh
ENV LC_ALL zh_CN.UTF-8

# zh-CN support(fonts)
RUN apt-get install -y language-pack-zh-hans            && \
    apt-get install -y ttf-ubuntu-font-family           && \
    apt-get install -y ttf-wqy-zenhei ttf-wqy-microhei

# Install git and svn
RUN apt-get install -y git subversion

# Install and prepare cron
RUN \
    export DEBIAN_FRONTEND=noninteractive&& \
    apt-get install -y --allow-unauthenticated cron && \
    touch /root/.crontab

# Add work user
RUN useradd -mU -u 1000 -d /home/u01 -s /bin/bash u01 && \
    usermod -a -G sudo u01 && \
    echo "u01:docker.io" | chpasswd     # Can't set password properly with "-p" argument in "useradd" command

# Prepare shell environment
RUN mkdir -p /home/u01/.config/ && \
    touch /home/u01/.config/.bashrc-docker-PATH && \
    touch /home/u01/.config/.bashrc-docker-PS1  && \
    touch /home/u01/.config/.bashrc-docker-CMD  && \
    echo "# Added by platbase.com/dev.base"                 >> /home/u01/.bashrc && \
    echo ". ~/.config/.bashrc-docker-PATH"                  >> /home/u01/.bashrc && \
    echo ". ~/.config/.bashrc-docker-PS1"                   >> /home/u01/.bashrc && \
    echo ". ~/.config/.bashrc-docker-CMD"                   >> /home/u01/.bashrc

# Add base-init shell scripts
ADD files /
RUN chmod +x /docker-base-init/* && \
    chmod +x /start-example.sh

# Finally
RUN apt-get -y upgrade

###############################################################################

# Environment variable
#  - To mark the environment variables which should be used in "u01"'s shell.
#  - because: su option "-, -l, --login" should build a new environment(see option "-m, -p, --preserve-environment")
#  - NOTE: default value "TERM LANG DISPLAY" was assumed in shell script "docker-boot"
ENV DEVOPS_FIXED_ENVS ""
