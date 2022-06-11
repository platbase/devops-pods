#!/bin/bash
set -o nounset
set -o errexit

# Remove u01 from sudo
sudo -l -U u01
gpasswd -d u01 sudo
sudo -l -U u01

# Change password
echo "u01:${U01_SSH_PWD}" | chpasswd

# Change SSH Port
echo "Port ${SSH_PORT}" >> /etc/ssh/sshd_config

# Overwrite permission of private keys
ls -al /etc/ssh/ssh_host_*_key
chmod -v 600 /etc/ssh/ssh_host_*_key
ls -al /etc/ssh/ssh_host_*_key

# Start SSH Server
mkdir -p /var/run/sshd
/usr/sbin/sshd -D -e
