# The basic environment for development
# ----
# build image:
#   docker build --force-rm -t platbase.com/dev.base:1.2-20.04 .
# run:
#   docker run -it --rm -v /tmp/dev-base.ws:/workspace -v /tmp/dev-base.data:/data platbase.com/dev.base:1.2-20.04
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

# Preparing installation and install basic tools
RUN apt-get update
RUN \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get install -y --allow-unauthenticated sudo; \
    apt-get install -y --allow-unauthenticated wget;

# Install necessary packages
RUN \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get install -y --allow-unauthenticated net-tools; \
    apt-get install -y --allow-unauthenticated iproute2; \
    apt-get install -y --allow-unauthenticated inetutils-ping; \
    apt-get install -y --allow-unauthenticated python; \
    apt-get install -y --allow-unauthenticated build-essential
RUN \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get install -y --allow-unauthenticated telnet; \
    apt-get install -y --allow-unauthenticated nano

# zh-CN TimeZone settings
RUN \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get install -y --allow-unauthenticated tzdata
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# zh-CN support(charset)
RUN apt-get install -y locales
RUN locale-gen zh_CN.UTF-8 &&\
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN locale-gen zh_CN.UTF-8  
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN:zh
ENV LC_ALL zh_CN.UTF-8

# zh-CN support(fonts)
RUN apt-get install -y language-pack-zh-hans
RUN apt-get install -y ttf-ubuntu-font-family
RUN apt-get install -y ttf-wqy-zenhei ttf-wqy-microhei

# Install Chromium
#RUN apt-get install -y chromium-browser
#----
#RUN wget -O "/tmp/google-chrome-stable_current_amd64.deb" https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#RUN apt-get install -y /tmp/google-chrome-stable_current_amd64.deb
#RUN rm /tmp/google-chrome-stable_current_amd64.deb
#----
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:xtradeb/apps
RUN apt-get install -y chromium

# Install git and svn
RUN apt-get install -y git subversion

# Install and prepare cron
RUN \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get install -y --allow-unauthenticated cron
RUN touch /root/.crontab

# Add work user
RUN useradd -mU -u 1000 -d /home/u01 -s /bin/bash u01
RUN echo "u01:docker.io" | chpasswd     # Can't set password properly with "-p" argument in "useradd" command
RUN usermod -a -G sudo u01

# Prepare shell environment
RUN touch /home/u01/.bashrc-docker-PATH
RUN touch /home/u01/.bashrc-docker-PS1
RUN touch /home/u01/.bashrc-docker-CMD
RUN echo "# Added by platbase.com/dev.base"         >> /home/u01/.bashrc
RUN echo ". ./.bashrc-docker-PATH"                  >> /home/u01/.bashrc
RUN echo ". ./.bashrc-docker-PS1"                   >> /home/u01/.bashrc
RUN echo ". ./.bashrc-docker-CMD"                   >> /home/u01/.bashrc

# Add base-init shell scripts
ADD files/docker-base-init /docker-base-init
RUN chmod +x /docker-base-init/*

# Prepare starting commands
ADD files/start-example.sh /start-example.sh
RUN chmod +x /start-example.sh

###############################################################################

# Environment variable
#  - To mark the environment variables which should be used in "u01"'s shell.
#  - because: su option "-, -l, --login" should build a new environment(see option "-m, -p, --preserve-environment")
#  - NOTE: default value "TERM LANG DISPLAY" was assumed in shell script "docker-boot"
ENV DEVOPS_FIXED_ENVS ""
