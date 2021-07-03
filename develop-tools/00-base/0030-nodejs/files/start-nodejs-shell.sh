#!/bin/bash
set -o errexit

/docker-nodejs-init/docker-node-boot

# To mark the environment variables which should be used in "u01"'s shell
/docker-base-init/set-fixed-ENVs http_proxy https_proxy

/docker-base-init/set-PS1 NodeJS
/docker-base-init/set-CMD "cd /workspace"

su - u01
