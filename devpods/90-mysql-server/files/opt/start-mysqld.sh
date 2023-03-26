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

# If volumn /data/mysql not exist, init mysql database ...
if [ ! -d "/data/mysql" ]
then
    mkdir -p /data/mysql/db
    mysqld --no-defaults --lower_case_table_names=1 --initialize --datadir=/data/mysql/db
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
cat /tmp/boot.sql

if [ "${FIRST_START}" = "YES" ]
then
    echo "system echo '>>>>>>>> This is the init sql for database, run once only ...';" > /tmp/init.sql
	echo "${MYSQL_INIT_SQL}" >> /tmp/init.sql
else
    echo "system echo '>>>>>>>> This is the init sql for database: show all databases ...';" > /tmp/init.sql
	echo "show databases ;" >> /tmp/init.sql
fi
echo "system echo '******** Init sql for database finished.';" >> /tmp/init.sql
# Review init.sql
#cat /tmp/init.sql

# Start mysqld
# --skip-host-cache/--skip-name-resolve :
#  * Disable Client TCP Cache, to avoid error such like:
#      "IP address '172.17.0.1' could not be resolved: Temporary failure in name resolution"
#/usr/sbin/mysqld --user=u01 --skip-host-cache --skip-name-resolve --init-file=/tmp/boot.sql &
mysqld --user=root --skip-host-cache --skip-name-resolve --init-file=/tmp/boot.sql &

set +o errexit
for (( _TIME = 1 ; _TIME <= 120 ; _TIME++ )); do
    echo quit | mysql -uroot -p"${MYSQL_ROOT_PWD}" # Test mysql server ready or not
    if [ $? -ne 0 ]; then
        echo "[$(date "+%Y-%m-%d %H:%M:%S")]: waiting for mysqld start ..."
        tail /data/mysql/error.log
        sleep 2;
    else
        echo "[$(date "+%Y-%m-%d %H:%M:%S")]: mysqld started ."
        break;
    fi
done
echo quit | mysql -uroot -p"${MYSQL_ROOT_PWD}" # Test mysql server ready or not
if [ $? -ne 0 ]; then
    echo "[$(date "+%Y-%m-%d %H:%M:%S")]: mysqld starting timeout, system exit ."
    exit -10;
fi
set -o errexit

# Run init sql
mysql -uroot -p"${MYSQL_ROOT_PWD}" --verbose --default-character-set=utf8 < /tmp/init.sql

# Tail error log, to prevent container exit
echo "

[$(date)]: MySQL service started successful .
*******************************************************************************
"
tail -f /data/mysql/error.log
