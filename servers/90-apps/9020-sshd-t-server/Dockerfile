# php-nginx server
# ----
# build image:
#   docker build --force-rm -t platbase.com/apps.sshd-t-server:latest -t platbase.com/apps.sshd-t-server:20220510-20.04 .
# run test:
#   dc-start -

FROM platbase.com/server.base:latest
LABEL maintainer="https://github.com/platbase"

### Server runtime environment variables ######################################
ENV RT_WORK_PATH /ssh-temp
ENV RT_WORK_COMMAND 'echo "Can not reach here !"'

ENV U01_SSH_PWD changeme
###############################################################################

# sshd port
EXPOSE 22

# Prepare ...
RUN apt-get update && apt-get upgrade -y

# Install sshd
RUN apt-get install -y --allow-unauthenticated openssh-server

# PermitRootLogin no
RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config

# register root.d
ADD resources/docker-init/etc/root.d/ /docker-init/etc/root.d/
