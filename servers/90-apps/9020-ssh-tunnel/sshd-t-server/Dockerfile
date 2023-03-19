# Simple sshd server for tunnel
# ----
# build image:
#   docker build --force-rm -t bizobj-container.net/srv/apps.sshd-t-server:latest -t bizobj-container.net/srv/apps.sshd-t-server:20230319 .
# run test:
#   dc-start -

FROM bizobj-container.net/srv/server.base:latest
LABEL maintainer="https://github.com/platbase"

### Server runtime environment variables ######################################
ENV RT_WORK_PATH /ssh-temp
ENV RT_WORK_COMMAND 'echo "Can not reach here !"'

# The password for u01 user
ENV U01_SSH_PWD changeme
# The SSH Server Port
ENV SSH_PORT 22
###############################################################################

# sshd port
EXPOSE 22

# Prepare ...
RUN apt-get update && apt-get upgrade -y

# Install sshd
RUN apt-get install -y --allow-unauthenticated openssh-server lsof cutter

# PermitRootLogin no , GatewayPorts yes
RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config
RUN echo "GatewayPorts yes" >> /etc/ssh/sshd_config

# register root.d
ADD resources/docker-init/etc/root.d/ /docker-init/etc/root.d/
