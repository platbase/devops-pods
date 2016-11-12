#!/bin/bash

# SHELL_ROOT - Location(Path) of this batch file
SHELL_ROOT=$(cd "$(dirname "$0")"; pwd)

# Text color variables
txtund=$(tput sgr 0 1)          # Underline
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldgrn=${txtbld}$(tput setaf 2) #  green
bldblu=${txtbld}$(tput setaf 4) #  blue
bldwht=${txtbld}$(tput setaf 7) #  white
txtrst=$(tput sgr0)             # Reset

# The volumes location
if [ -z $VOL_DATA ]; then
    VOL_DATA="${SHELL_ROOT}/.runtime"
fi
if [ -z $VOL_WS ]; then
    VOL_WS="`pwd`"
fi

echo ">>>${bldgrn} /data ${txtrst} should be mounted to ${bldgrn} $VOL_DATA ${txtrst}."
echo ">>>${bldgrn} /workspace  ${txtrst} should be mounted to ${bldgrn} $VOL_WS ${txtrst}."
read -p "${bldred} Continue to start NodeJS?${txtrst} [Y|n]: " CONFIRM_CHAR
case $CONFIRM_CHAR in 
Y|y)
    ;;
*)
    echo ">>> ${bldwht}User abort to start NodeJS: [$CONFIRM_CHAR] ${txtrst}."
    exit -100
    ;;
esac

# Prepare /data volume
mkdir -p "$VOL_DATA/cache"
mkdir -p "$VOL_DATA/global"
touch "$VOL_DATA/devops.platbase.com-docker-data"

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

echo ">>> Find avaliable local port: ${bldgrn} $port ${txtrst}."

docker run -it --rm -p $port:8080 -v "$VOL_WS":/workspace -v "$VOL_DATA":/data platbase.com/dev.nodejs:6.2.1
