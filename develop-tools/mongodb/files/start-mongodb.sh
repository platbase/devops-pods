#!/bin/bash
echo "*** Development environment - mongodb server ***"
set -o errexit

/docker-base-init/docker-boot

/docker-base-init/set-PS1 MongoDB

su - u01 -c "mkdir -p /data/mongodb; mongod --dbpath /data/mongodb"