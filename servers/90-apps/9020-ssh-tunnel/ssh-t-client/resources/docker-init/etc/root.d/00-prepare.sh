#!/bin/bash
set -o nounset
set -o errexit

# Remove u01 from sudo
sudo -l -U u01
gpasswd -d u01 sudo
sudo -l -U u01

set +o errexit
# Detect the host IP and bind it to hostname "docker-host"
echo "... Detect IP of docker host and bind it's hostname to 'docker-host'"
cat /etc/hosts | grep "docker-host"
if [ $? > 0 ]; then
    echo "# Add docker host's IP address(The same as the default gateway)"    >> /etc/hosts
    echo "$(/sbin/ip route|awk '/default/ { print $3 }')     docker-host"     >> /etc/hosts
fi
