#!/bin/bash
set -u

if [[ "$(cat /docker-init/info/ENV_FIRST_BOOT)" == "true" ]]; then
	echo "*** It's the FIRST boot of container"
else
	echo "*** It's NOT the first boot of container"
fi

# Show date
date

# Show user infomation
id

# Outpot to /test
echo "Hello, World!" > /test/${USER}
echo "----" >> /test/${USER}
echo "$*"   >> /test/${USER}
echo "----" >> /test/${USER}
env         >> /test/${USER}

ls -al /test/${USER}

echo ">>> /test/${USER} created. Now waiting 120 seconds ..."
sleep 120
echo ">>> Bye!" 
