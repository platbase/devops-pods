#!/bin/bash
set -o nounset
set -o errexit

rm -rfv /etc/nginx/sites-enabled
ln -s /nginx-conf /etc/nginx/sites-enabled
ls -al /etc/nginx/

nginx -T
nginx -g 'daemon off;'
