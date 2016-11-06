#!/bin/bash

# SHELL_ROOT - Location(Path) of this batch file
SHELL_ROOT=$(cd "$(dirname "$0")"; pwd)

# Find avaliable ports between 27017 to 28017
LOWERPORT=27017
UPPERPORT=28017
# FIXME: "netstat -ntpl" warning:
#   Not all processes could be identified, non-owned process info will not be shown, you would have to be root to see it all..
lp=null
for (( port = LOWERPORT ; port <= UPPERPORT ; port++ )); do
    netstat -ntpl 2>/dev/null | grep ":$port "
    [ $? -eq 1 ] && { lp=$port; break; }
done
[ "$lp" = "null" ] && { echo "No free local ports available(between $LOWERPORT and $UPPERPORT)"; exit 2; }

echo ">>> Find avaliable local port: $port ."

mkdir -p "${SHELL_ROOT}/.runtime/$port"
docker run -it --rm -p $port:27017 -v "${SHELL_ROOT}/.runtime/$port":/data platbase.com/dev.mongodb:1.0
