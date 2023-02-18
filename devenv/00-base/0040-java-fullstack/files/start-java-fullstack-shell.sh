#!/bin/bash
set -o errexit

# Initialization scripts
/docker-base-init/docker-boot
/docker-nodejs-init/docker-node-boot
/docker-java-fullstack-init/docker-java-fullstack-boot

# To mark the environment variables which should be used in "u01"'s shell
/docker-base-init/set-fixed-ENVs http_proxy https_proxy

/docker-base-init/set-PS1 "FullStack"
/docker-base-init/set-CMD 'test "$(cd ~; pwd)" = "$(pwd)" && cd /workspace || true'

su - u01
