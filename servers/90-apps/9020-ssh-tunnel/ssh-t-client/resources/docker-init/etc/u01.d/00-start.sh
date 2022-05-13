#!/bin/bash
set -o nounset
set -o errexit

SSH_CMD="ssh -4 -v ${U01_SSH_ARGS}"
echo ">>> Starting SSH Tunnel: ${SSH_CMD} ..."
rm -f ~u01/.ssh/known_hosts
sshpass -v -p "${U01_SSH_PWD}" ${SSH_CMD}
