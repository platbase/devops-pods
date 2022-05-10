#!/bin/bash
set -o nounset
set -o errexit

# replace fpm worker to u01
cp /etc/php/7.4/fpm/pool.d/www.conf /etc/php/7.4/fpm/pool.d/www.conf.orig
sed -i 's/= www-data$/= u01/' /etc/php/7.4/fpm/pool.d/www.conf
echo "Worker of fpm changed from 'www-data' to 'u01':"
diff /etc/php/7.4/fpm/pool.d/www.conf /etc/php/7.4/fpm/pool.d/www.conf.orig || [ $? -eq 1 ]

echo "Starting php-fpm ..."
php-fpm7.4 -D

ps -ef | grep php
