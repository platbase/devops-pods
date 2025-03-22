#!/bin/bash

echo -e "\n[$(date "+%Y-%m-%d %H:%M:%S")] Begin health-check ..."

echo ">>> Check mysql status through /var/run/mysqld/mysqld.socket ..."
mysqladmin --defaults-file=/opt/tmp/mysql-server/health-check-socket.cnf status

echo ">>> Force ping through network 127.0.0.1:3306 to check health ..."
mysqladmin --defaults-file=/opt/tmp/mysql-server/health-check-network.cnf ping

if [ $? -eq 0 ]; then
    echo "[health-check] mysqladmin ping: MySQL server is healthy"
    exit 0
else
    echo "[health-check] mysqladmin ping: MySQL server is **unhealthy**"
    exit 1
fi
