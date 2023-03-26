# MySQL Database Server, As the basic environment for development.
# ----
# build image:
#   podman build --force-rm -t bizobj-container.net/pods/mysql-server:latest -t bizobj-container.net/pods/mysql-server:8.0.32 .
# run test by podman:
#   podman run -it --rm bizobj-container.net/pods/mysql-server:latest
# run test as Pod:
#   podman play kube ./test/test-pods.yaml ; podman attach devpods-90-test-mysql ; podman pod rm -f devpods-90-test

FROM bizobj-container.net/pods/dev.base:latest
LABEL maintainer="https://github.com/platbase"

# The version of mysql
ENV MYSQL_VERSION=8.0.32

# The default mysql root password
ENV MYSQL_ROOT_PWD=root
# MySQL initialization SQL
ENV MYSQL_INIT_SQL='show databases ;'

# MySQL port 3306
EXPOSE 3306

# Volume for mysql (/data/mysql)
VOLUME ["/data"]

###############################################################################

RUN apt-get update -y &&\
    apt-get install -y libaio1 libnuma1 libncurses5

# Install MySQL Community Server ( from https://dev.mysql.com/downloads/mysql/ )
RUN export MYSQL_PACKAGE_NAME="mysql-${MYSQL_VERSION}-linux-glibc2.17-x86_64-minimal" && \
    wget -O "/tmp/${MYSQL_PACKAGE_NAME}.tar.xz" https://dev.mysql.com/get/Downloads/MySQL-8.0/${MYSQL_PACKAGE_NAME}.tar.xz && \
    tar xvJf "/tmp/${MYSQL_PACKAGE_NAME}.tar.xz" -C /opt                              && \
    mv -v "/opt/${MYSQL_PACKAGE_NAME}" /opt/mysql-server                              && \
    rm -fv "/tmp/${MYSQL_PACKAGE_NAME}.tar.xz"

# Avoid mysqld:
#   mysqld: Can't open shared library '/usr/lib/plugin/component_reference_cache.so' (errno: 0 /usr/lib/plugin/component_reference_cache.so: cannot open shared object file: No such file or directory)
#   mysqld: Cannot load component from specified URN: 'file://component_reference_cache'.
RUN ln -s /opt/mysql-server/lib/plugin /usr/lib/plugin

# Default MySQL configuration and init scripts
ADD files /

# Startup command
CMD ["/opt/start-mysqld.sh"]
