#!/bin/bash
set -o errexit

/docker-cdr-init/docker-cdr-boot

# To mark the environment variables which should be used in "u01"'s shell
/docker-base-init/set-fixed-ENVs http_proxy https_proxy

# code-server environment
/docker-base-init/set-PS1 code-server
/docker-base-init/set-CMD "cd /workspace"

echo "*** Starting code-server ***"
su - u01 -c ' \
/usr/bin/code-server \
    --auth none \
    --bind-addr 0.0.0.0:8080
'
