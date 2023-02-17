#!/bin/bash
set -o errexit

# Initialization scripts
/docker-base-init/docker-boot

/docker-base-init/set-PS1 Example
/docker-base-init/set-CMD 'test "$(cd ~; pwd)" = "$(pwd)" && cd /workspace || true'
/docker-base-init/set-crontab '*   *   *   *   *   su - u01 -c "date; env" > /tmp/cron-alive-log'

# Start shell of u01
su - u01
