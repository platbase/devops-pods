# The basic environment for servers
# ----
# build image:
#   docker build --force-rm -t platbase.com/server.base:latest -t platbase.com/server.base:1.0-20.04 .
# run test:
#   dc-run -

FROM ubuntu:20.04
LABEL maintainer="https://github.com/platbase"

### Server runtime environment variables #############################################################
# RT_WORKER_UID: UID(User Identifier) to run command
ENV RT_WORKER_UID 1000
# RT_WORKER_GID: GID(Group Identifier) to run command
ENV RT_WORKER_GID 1000
# RT_WORK_PATH: Path list 
ENV RT_WORK_PATH /test1:/test2
# RT_WORK_COMMAND: Command line that /docker-init/start.sh should start it 
ENV RT_WORK_COMMAND "echo 'Hello, Workd!'"
###############################################################################

# Basic installations
RUN apt-get update

RUN \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get install -y --allow-unauthenticated apt-utils;
RUN \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get install -y --allow-unauthenticated sudo; \
    apt-get install -y --allow-unauthenticated wget;
RUN \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get install -y --allow-unauthenticated net-tools; \
    apt-get install -y --allow-unauthenticated inetutils-ping;
RUN \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get install -y --allow-unauthenticated telnet; \
    apt-get install -y --allow-unauthenticated nano;
RUN \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get install -y --allow-unauthenticated git;
RUN \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get install -y --allow-unauthenticated curl; \
    apt-get install -y --allow-unauthenticated gnupg2; \
    apt-get install -y --allow-unauthenticated xz-utils;

# Time Zone
RUN \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get install -y --allow-unauthenticated tzdata
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Charset to support Chinese
RUN apt-get install -y locales
RUN locale-gen zh_CN.UTF-8 &&\
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN locale-gen zh_CN.UTF-8  
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN:zh
ENV LC_ALL zh_CN.UTF-8

# Boot command
ADD resources/docker-init /docker-init
CMD ["/docker-init/start.sh"]
