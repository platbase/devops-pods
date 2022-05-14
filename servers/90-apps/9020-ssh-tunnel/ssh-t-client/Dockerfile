# Simple ssh client for tunnel
# ----
# build image:
#   docker build --force-rm -t platbase.com/apps.ssh-t-client:latest -t platbase.com/apps.ssh-t-client:20220510-20.04 .
# run test:
#   dc-start -

FROM platbase.com/server.base:latest
LABEL maintainer="https://github.com/platbase"

### Server runtime environment variables ######################################
ENV RT_WORK_PATH /ssh-temp
ENV RT_WORK_COMMAND 'echo "Can not reach here !"'

ENV U01_SSH_PWD changeme

ENV U01_SSH_ARGS '-N -R 0.0.0.0:58080:www.example.com:80 u01@docker-host -p 30022'
ENV NET_DETECT_CMD 'delectWithNetcat docker-host 58080'
ENV NET_DETECT_SEC 30
ENV NET_CONFIRM_SEC 10
###############################################################################

# sshd port
EXPOSE 22

# Prepare ...
RUN apt-get update && apt-get upgrade -y

# Install sshd
RUN apt-get install -y --allow-unauthenticated openssh-client sshpass iproute2 netcat

# Automatically Accepts SSH Fingerprint
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# register root.d
ADD resources/docker-init/etc/root.d/ /docker-init/etc/root.d/
ADD resources/docker-init/etc/u01.d/ /docker-init/etc/u01.d/
