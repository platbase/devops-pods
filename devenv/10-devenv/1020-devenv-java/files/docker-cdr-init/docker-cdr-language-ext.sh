#!/bin/bash
set -o errexit

# Java language setttings
echo ".... Java environment:"
echo " .... --------"
su - u01 -c "java -version"
su - u01 -c "mvn -v"
echo " .... --------"

# Copy default settings.json
MACHINE_DIR="/data/home/.local/share/code-server/Machine"
if [ ! -d "${MACHINE_DIR}" ]; then
	mkdir "${MACHINE_DIR}"
	chown u01:u01 "${MACHINE_DIR}"
fi
DEF_SETTINGS="${MACHINE_DIR}/settings.json"
if [ ! -f "${DEF_SETTINGS}" ]; then
	
	cp /docker-cdr-init/settings.json "${DEF_SETTINGS}"
	chown u01:u01 "${DEF_SETTINGS}"
	
	echo ".... The default settings.json is created: '${DEF_SETTINGS}'"
	echo " .... --------"
	cat "${DEF_SETTINGS}"
	echo " .... --------"
fi