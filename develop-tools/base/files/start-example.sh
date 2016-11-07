#!/bin/bash
echo "*** The Basic Development Environment ***"
set -o errexit

/docker-base-init/docker-boot

/docker-base-init/set-PS1 Example
/docker-base-init/set-CMD "cd /workspace"
/docker-base-init/set-crontab '*   *   *   *   *   su - u01 -c "date; env" > /tmp/cron-alive-log'

# Start shell of u01
su - u01
