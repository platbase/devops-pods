#!/bin/bash
set -e
set -u

# Use environment variable "DOCKER_DAEMON_ARGS" to pass command options of "dockerd"
#   - for example: podman run --privileged -it --rm -e DOCKER_DAEMON_ARGS="--storage-driver=vfs" ...
DOCKER_DAEMON_ARGS="${DOCKER_DAEMON_ARGS:-}"

nohup dockerd ${DOCKER_DAEMON_ARGS} --host=unix:///var/run/docker.sock > /var/log/dockerd.log 2>&1 &
