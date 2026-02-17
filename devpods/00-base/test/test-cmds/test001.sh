#!/bin/bash
set -e
set -u

echo "  > cat /etc/os-release ..."
cat /etc/os-release

echo -e "\n"

echo "  > cat /etc/containers/storage.conf ..."
cat /etc/containers/storage.conf

echo -e "\n"

echo "  > podman info | grep overlay ..."
podman info | grep overlay

echo -e "\n"

echo "  > podman info | grep -E '(runRoot|graphRoot)' ..."
podman info | grep -E '(runRoot|graphRoot)'

echo -e "\n"

echo "  > podman version ..."
podman version

echo -e "\n"

echo "  > podman-compose version ..."
podman-compose version

echo -e "\n"

echo "  > podman-compose up and others ..."
pushd /opt/test-cmds/test-compose
podman-compose up -d
podman ps
podman-compose down
popd

