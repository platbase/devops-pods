#!/bin/bash
set -o errexit

/docker-base-init/set-crontab '*   *   *   *   *   su - u01 -c "/opt/code-server-sync-ext.sh" > /tmp/code-server-sync-ext.log'

# Start code-server
/start-cdr.sh
