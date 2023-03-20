# MySQL Server
# ----
# build image:
#   docker build --force-rm -t bizobj-container.net/srv/server.mysql:latest -t bizobj-container.net/srv/server.mysql:8.0-20230320 .
# run test:
#   dc-start -

FROM bizobj-container.net/srv/server.base:latest
LABEL maintainer="https://github.com/platbase"

### Server runtime environment variables ######################################
ENV RT_WORK_PATH /data
ENV RT_WORK_COMMAND 'echo "Can not reach here !"'

# The MySQL conf file name
ENV MY_CNF /opt/etc/mysql/my.cnf
# The default mysql root password
ENV MYSQL_ROOT_PWD root
# MySQL initialization SQL
ENV MYSQL_INIT_SQL 'show databases ;'
###############################################################################

# MySQL Data volume
VOLUME ["/data"]
# mysql port 3306
EXPOSE 3306

# Prepare ...
RUN apt-get update

# change invoke-rc.d to avoid mysql service startup error
RUN sed -i "s/^exit 101$/exit 0/" /usr/sbin/invoke-rc.d
RUN export DEBIAN_FRONTEND=noninteractive
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
# Install mysql
RUN apt-get install -y --allow-unauthenticated mysql-server

# Default MySQL configuration
ADD resources/ROOT/etc/mysql/my.cnf /opt/etc/mysql/my.cnf

# register root.d
ADD resources/docker-init/etc/root.d/ /docker-init/etc/root.d/
