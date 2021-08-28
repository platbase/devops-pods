#!/bin/bash

source /etc/profile

for CMD in `ls "/docker-init/etc/u01.d/"`
do
	echo "[$(date +%Y%m%d-%H%M%S)]     > /docker-init/etc/u01.d/${CMD} ..."
	source "/docker-init/etc/u01.d/${CMD}"
done
