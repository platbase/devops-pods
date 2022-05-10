#!/bin/bash
set -o nounset
set -o errexit

rm -rfv /etc/nginx/sites-enabled
ln -s /nginx-conf /etc/nginx/sites-enabled
ls -al /etc/nginx/sites-enabled

# replace nginx worker to u01
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
sed -i 's/^user www-data;$/user u01;/' /etc/nginx/nginx.conf
echo "Worker of nginx changed from 'www-data' to 'u01':"
diff /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig || [ $? -eq 1 ]

nginx -t
nginx -g 'daemon off;'
