# MySQL Database Server, As the basic environment for development.
# ----
# build image:
#   podman build --force-rm -t bizobj-container.net/pods/mysql-server:latest -t bizobj-container.net/pods/mysql-server:20251103-8.4.7 .
# run test by podman:
#   podman run -it --rm bizobj-container.net/pods/mysql-server:latest
# run test as Pod:
#   podman play kube ./test/test-pods.yaml ; podman attach devpods-90-test-mysql ; podman pod rm -f devpods-90-test

FROM bizobj-container.net/pods/dev.base:trixie-20251103
LABEL maintainer="https://github.com/platbase"

# The version of mysql
ENV MYSQL_VERSION=8.4.7

# The default mysql root password
ENV MYSQL_ROOT_PWD=root
# MySQL initialization SQL (Run ONCE for first creating database)
ENV MYSQL_INIT_SQL="SHOW VARIABLES LIKE '%version%' ;"
# MySQL starting SQL (Run Every time database starting)
ENV MYSQL_START_SQL='source /opt/scripts/mysql-server/sql/default-server-summary.sql ;'

# The additional options for "mysql --no-defaults ${MYSQL_DBINIT_ARGS} --initialize --datadir=/data/mysql/db"
# NOTE: "--lower_case_table_names=1" is default, and it's closely related to /etc/mysql/conf.d/00-default.cnf.
#       If you mount /etc/mysql/conf.d with an external volume, ensure that the settings match.
ENV MYSQL_DBINIT_ARGS='--lower_case_table_names=1'

# To execute the initialization SQL (either ${MYSQL_INIT_SQL} or ${MYSQL_START_SQL}), start-mysqld.sh must
# verify if mysqld is ready every 2 seconds. The 'MYSQL_DBCHECK_TIMES' variable specifies the max retry count
# for this check. This is crucial for containers with large databases that have slow start-up times.
ENV MYSQL_DBCHECK_TIMES=120

# Interval (in seconds) for periodic health checks with opt/scripts/mysql-server/healthcheck.sh
ENV MYSQL_HEALTHCHECK_INTERVAL=60

# MySQL port 3306
EXPOSE 3306

# Volume for mysql (/data/mysql)
VOLUME ["/data"]

###############################################################################

RUN apt-get update -y && \
    apt-get install -y libaio1t64 libnuma1 libncurses6 && \
    apt-get clean && rm -rfv /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install MySQL Community Server ( from https://dev.mysql.com/downloads/mysql/ )
RUN export MYSQL_PACKAGE_NAME="mysql-${MYSQL_VERSION}-linux-glibc2.28-x86_64-minimal" && \
    wget -O "/tmp/${MYSQL_PACKAGE_NAME}.tar.xz" https://dev.mysql.com/get/Downloads/MySQL-8.4/${MYSQL_PACKAGE_NAME}.tar.xz && \
    tar xvJf "/tmp/${MYSQL_PACKAGE_NAME}.tar.xz" -C /opt                              && \
    mv -v "/opt/${MYSQL_PACKAGE_NAME}" /opt/mysql-server                              && \
    rm -fv "/tmp/${MYSQL_PACKAGE_NAME}.tar.xz"

# Avoid mysqld:
#   mysqld: Can't open shared library '/usr/lib/plugin/component_reference_cache.so' (errno: 0 /usr/lib/plugin/component_reference_cache.so: cannot open shared object file: No such file or directory)
#   mysqld: Cannot load component from specified URN: 'file://component_reference_cache'.
RUN ln -s /opt/mysql-server/lib/plugin /usr/lib/plugin

# Avoid mysqld:
#   mysqld: error while loading shared libraries: libaio.so.1: cannot open shared object file: No such file or directory
RUN ln -s /lib/x86_64-linux-gnu/libaio.so.1t64 /lib/x86_64-linux-gnu/libaio.so.1

# Default MySQL configuration and init scripts
ADD files /

# Startup command
CMD ["/opt/start-mysqld.sh"]
