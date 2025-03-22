#!/bin/bash
set -o nounset
set -o errexit

echo "

[$(date)]: Begin to start MySQL service ...
*******************************************************************************
"

#set -x

FIRST_START="NO"

# Add mysql and mysqld to PATH
export PATH="/opt/mysql-server/bin:$PATH"

# Prepare mysqld run directory
mkdir -p /var/run/mysqld
#*chown -Rv u01:u01 /var/run/mysqld

# Prepare conf.d directory
mkdir -p /etc/mysql/conf.d/

# If volumn /data/mysql not exist, init mysql database ...
if [ ! -d "/data/mysql" ]
then
    mkdir -p /data/mysql/db
    echo "=> [MySQL Starting 1/5] $(date "+%Y-%m-%d %H:%M:%S") Begin to create database instance with --datadir=/data/mysql/db ..."

    # Prepare logs to make tail work fine
    touch /data/mysql/error.log
    touch /data/mysql/monitor.log

    mysqld --no-defaults ${MYSQL_DBINIT_ARGS} --initialize --datadir=/data/mysql/db
    #*chown -Rv u01:u01 /data/mysql

    # Mark container in the first starting process
    FIRST_START="YES"
fi

# Prepare the sql to make root can access mysql from remote host
#echo "use mysql;" > /tmp/boot.sql
#echo "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY '${MYSQL_ROOT_PWD}' WITH GRANT OPTION;" >> /tmp/boot.sql
#echo "GRANT ALL ON *.* TO root@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PWD}' WITH GRANT OPTION;" >> /tmp/boot.sql
#echo "flush privileges;" >> /tmp/boot.sql
cat > /tmp/boot.sql << EOF
use mysql;

-- MySQL 8.0 (MySQL 5.7 includes two root records: root@'%' and root@'localhost', but 8.0 has only one)
UPDATE user SET Host='%' WHERE User='root';
FLUSH PRIVILEGES;

SET PASSWORD FOR 'root'@'%' = '${MYSQL_ROOT_PWD}';
GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
# Review boot.sql
#cat /tmp/boot.sql

if [ "${FIRST_START}" = "YES" ]
then
    echo "system echo '>>>>>>>> This is the init sql for database, run once only ...';" > /tmp/init.sql
    echo "${MYSQL_INIT_SQL}" >> /tmp/init.sql
else
    echo "-- FIRST_START=${FIRST_START}" > /tmp/init.sql
fi
echo "system echo '>>>>>>>> This is the init sql for database ...';" >> /tmp/init.sql
echo "${MYSQL_START_SQL}" >> /tmp/init.sql
echo "system echo '******** Init sql for database finished.';" >> /tmp/init.sql
# Review init.sql
#cat /tmp/init.sql

# Start mysqld
# --skip-host-cache/--skip-name-resolve :
#  * Disable Client TCP Cache, to avoid error such like:
#      "IP address '172.17.0.1' could not be resolved: Temporary failure in name resolution"
# --skip-networking :
#  * Permits only local (non-TCP/IP) connections,
#      "all interaction with mysqld must be made using named pipes or shared memory (on Windows) or Unix socket files (on Unix)"
#/usr/sbin/mysqld --user=u01 --skip-host-cache --skip-name-resolve --init-file=/tmp/boot.sql &
#mysqld --user=root --skip-host-cache --skip-name-resolve --init-file=/tmp/boot.sql &
# The syntax '--skip-host-cache' is deprecated and will be removed in a future release. Please use SET GLOBAL host_cache_size=0 instead.
echo "==> [MySQL Starting 2/5] $(date "+%Y-%m-%d %H:%M:%S") Starting initialization mysqld with --skip-networking, and --init-file=/tmp/boot.sql ..."
mysqld --user=root --skip-name-resolve --skip-networking --init-file=/tmp/boot.sql &

set +o errexit
for (( _TIME = 1 ; _TIME <= ${MYSQL_DBCHECK_TIMES} ; _TIME++ )); do
    echo quit | mysql -uroot -p"${MYSQL_ROOT_PWD}" # Test mysql server ready or not
    if [ $? -ne 0 ]; then
        echo " > [$(date "+%Y-%m-%d %H:%M:%S")]: waiting for mysqld start ..."
        echo ">>> [$(date "+%Y-%m-%d %H:%M:%S")] Waiting mysqld ready for initialization data (${_TIME}/${MYSQL_DBCHECK_TIMES}) ..." >> /data/mysql/monitor.log
        tail -n 3 /data/mysql/error.log /data/mysql/monitor.log
        sleep 2;
    else
        echo " > [$(date "+%Y-%m-%d %H:%M:%S")]: mysqld started ."
        break;
    fi
done
echo quit | mysql -uroot -p"${MYSQL_ROOT_PWD}" # Test mysql server ready or not
if [ $? -ne 0 ]; then
    echo " > [$(date "+%Y-%m-%d %H:%M:%S")]: mysqld starting timeout, system exit ."
    exit -10;
fi
set -o errexit

# Run init sql
echo "===> [MySQL Starting 3/5] $(date "+%Y-%m-%d %H:%M:%S") Initialization mysqld started, begin to run /tmp/init.sql ..."
mysql -uroot -p"${MYSQL_ROOT_PWD}" --default-character-set=utf8 --skip-column-names --raw < /tmp/init.sql

# Shutdown initialization mysqld
echo "====> [MySQL Starting 4/5] $(date "+%Y-%m-%d %H:%M:%S") Initialization finished, begin to stop initialization mysqld ..."
mysqladmin shutdown -u root -p"${MYSQL_ROOT_PWD}"

# Restart working mysqld
echo "=====> [MySQL Starting 5/5] $(date "+%Y-%m-%d %H:%M:%S") Begin to start working mysqld instance ..."
echo ">>> [$(date "+%Y-%m-%d %H:%M:%S")] The working mysqld instance booting start ..." >> /data/mysql/monitor.log
mysqld --user=root --skip-name-resolve &

# Tail error log, to prevent container exit
echo "

[$(date)]: MySQL service started successful .
*******************************************************************************
"

# Prepare for health check
# Configuration to access with network(Note: MUST host = 127.0.0.1, if use "localhost", mysqladmin try to through socket '/tmp/mysql.sock')
mkdir -p /opt/tmp/mysql-server
echo "
[client]
user = root
password = ${MYSQL_ROOT_PWD}
host = 127.0.0.1
port = 3306
" > /opt/tmp/mysql-server/health-check-network.cnf
chmod 600 /opt/tmp/mysql-server/health-check-network.cnf
# Configuration to access with linux socket
echo "
[client]
user = root
password = ${MYSQL_ROOT_PWD}
socket = /var/run/mysqld/mysqld.sock
" > /opt/tmp/mysql-server/health-check-socket.cnf
chmod 600 /opt/tmp/mysql-server/health-check-socket.cnf
# Periodically health check
(
set +o errexit
while true; do
    /opt/scripts/mysql-server/healthcheck.sh >> /data/mysql/monitor.log
    sleep ${MYSQL_HEALTHCHECK_INTERVAL};
done
) &

# Last command to keep running  ...
tail -f /data/mysql/error.log /data/mysql/monitor.log
