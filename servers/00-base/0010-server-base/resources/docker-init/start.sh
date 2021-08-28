#!/bin/bash
#set -x
set -u

# Prepare work folders
prepareWorkerDirs() {
	OLD_IFS="$IFS"
    IFS=':'
    for p in $RT_WORK_PATH ; do
    	if [ -d "$p" ]; then
            chown -Rv u01:u01 "$p" | (sed -u 7q; echo "..."; tail -n 7)
        else
        	echo "Skip inexistent RT_WORK_PATH: $p ."
        fi
    done
   IFS="$OLD_IFS"
}

# Check and create worker(u01)
grep "\:${RT_WORKER_GID}\:" /etc/group
if [ $? -ne 0 ]
then
	groupadd -f -g ${RT_WORKER_GID} u01
fi
grep "^u01" /etc/passwd
if [ $? -ne 0 ]
then
	echo "useradd - u01 (${RT_WORKER_GID}:${RT_WORKER_UID}) ..."
	useradd -m -u ${RT_WORKER_UID} -g ${RT_WORKER_GID} -d /home/u01 -s /bin/bash u01
	echo "u01:docker.io" | chpasswd  # Can't set password properly with "-p" argument in "useradd" command
	usermod -a -G sudo u01
	# Change onwer of u01's script
	chown -Rv u01:u01 /docker-init/etc/u01*
	# Prepare work folders(RT_WORK_PATH)
	prepareWorkerDirs
	# Mark first boot
	echo "true" > /docker-init/info/ENV_FIRST_BOOT
else
	echo "false" > /docker-init/info/ENV_FIRST_BOOT
fi

# Prepare the last command in /docker-init/etc/u01.d/
echo "********************************************************************************"
echo "[$(date +%Y%m%d-%H%M%S)] >>> Prepare (as u01) [${RT_WORK_COMMAND}] ..."
echo "********************************************************************************"
echo "${RT_WORK_COMMAND}" > /docker-init/etc/u01.d/ZZ-RT_WORK_COMMAND.sh

# Commands for initialization
echo "[$(date +%Y%m%d-%H%M%S)] >>> Begin to run (as root) [/docker-init/etc/root.sh] ..."
/docker-init/etc/root.sh
echo "[$(date +%Y%m%d-%H%M%S)] >>> Begin to run (as u01) [/docker-init/etc/u01.sh] ..."
sudo -E -u u01 "/docker-init/etc/u01.sh"
