#!/bin/bash

source /etc/profile

for CMD in `ls "/docker-init/etc/root.d/"`
do
	echo "[$(date +%Y%m%d-%H%M%S)]     > /docker-init/etc/root.d/${CMD} ..."
	source "/docker-init/etc/root.d/${CMD}"
done
