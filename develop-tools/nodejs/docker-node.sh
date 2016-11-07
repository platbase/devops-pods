#!/bin/bash

# SHELL_ROOT - Location(Path) of this batch file
SHELL_ROOT=$(cd "$(dirname "$0")"; pwd)

mkdir -p "${SHELL_ROOT}/.runtime/cache"
mkdir -p "${SHELL_ROOT}/.runtime/global"
touch "${SHELL_ROOT}/.runtime/devops.platbase.com-docker-data"

# Find avaliable ports between 8080 to 9080
LOWERPORT=8080
UPPERPORT=9080
# FIXME: "netstat -ntpl" warning:
#   Not all processes could be identified, non-owned process info will not be shown, you would have to be root to see it all..
lp=null
for (( port = LOWERPORT ; port <= UPPERPORT ; port++ )); do
    netstat -ntpl 2>/dev/null | grep ":$port "
    [ $? -eq 1 ] && { lp=$port; break; }
done
[ "$lp" = "null" ] && { echo "No free local ports available(between $LOWERPORT and $UPPERPORT)"; exit 2; }

echo ">>> Find avaliable local port: $port ."

docker run -it --rm -p $port:8080 -v "`pwd`":/workspace -v "${SHELL_ROOT}/.runtime":/data platbase.com/dev.nodejs:1.0
