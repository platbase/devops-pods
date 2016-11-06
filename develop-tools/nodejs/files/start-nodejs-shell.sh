echo "*** Development environment with NodeJS and Npm ***"

# Env setup
/docker-base-init/docker-boot

/docker-base-init/set-PS1 NodeJS
/docker-base-init/set-CMD "cd /workspace"
/docker-base-init/set-PATH "./node_modules/.bin:/data/global/bin"
/docker-base-init/set-PATH "/opt/nodejs/node-v${VERSION}-linux-x64/bin:/opt/nodejs/node-v${VERSION}-linux-x64/bin/npm-global/bin"

su - u01
