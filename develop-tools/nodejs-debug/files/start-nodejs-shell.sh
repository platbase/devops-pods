#!/bin/bash
echo "*** Development environment with NodeJS and Npm ***"
set -o errexit

# Env setup
/docker-base-init/docker-boot

/docker-base-init/set-PS1 NodeJS
/docker-base-init/set-CMD "cd /workspace"
/docker-base-init/set-PATH "./node_modules/.bin:/data/global/bin"
/docker-base-init/set-PATH "/opt/nodejs/node-v${VERSION}-linux-x64/bin:/opt/nodejs/node-v${VERSION}-linux-x64/bin/npm-global/bin"

# Save Chromium profile to /data/.chromium
echo ">>> Redirect chromium profile directory to /data ..."
mkdir -p /home/u01/.config; chown u01:u01 /home/u01/.config
mkdir -p /data/.chromium; chown u01:u01 /data/.chromium
ln -s /data/.chromium /home/u01/.config/chromium
ls -al ~u01/.config/chromium

echo "========"

su - u01
