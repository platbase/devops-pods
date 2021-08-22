#!/bin/bash
set -o errexit

# Java language setttings
echo ".... Java environment:"
echo " .... --------"
su - u01 -c "java -version"
su - u01 -c "mvn -v"
echo " .... --------"

# Copy default settings.json
USER_DIR="/data/home/.local/share/code-server/User"
if [ ! -d "${USER_DIR}" ]; then
	mkdir "${USER_DIR}"
	chown u01:u01 "${USER_DIR}"
fi
DEF_SETTINGS="${USER_DIR}/settings.json"
if [ ! -f "${DEF_SETTINGS}" ]; then
	
	cp /docker-cdr-init/settings.json "${DEF_SETTINGS}"
	chown u01:u01 "${DEF_SETTINGS}"
	
	echo ".... The default settings.json is created: '${DEF_SETTINGS}'"
	echo " .... --------"
	cat "${DEF_SETTINGS}"
	echo " .... --------"
fi