#!/bin/bash
set -o nounset
set -o errexit

echo "Starting php-fpm ..."

php-fpm7.4 -D

ps -ef | grep php
