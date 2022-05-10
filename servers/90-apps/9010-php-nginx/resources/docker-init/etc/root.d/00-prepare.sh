#!/bin/bash
set -o nounset
set -o errexit

# Prepare sample(If content is empty)
if [ ! -f "/php-app/index.php" ]; then
	echo "Prepare index.php: /docker-init/sample-app/index.php -> /php-app/ ..."
	cp /docker-init/sample-app/index.php /php-app/
fi
if [ ! -f "/nginx-conf/nginx.conf" ]; then
	echo "Prepare nginx.conf: /docker-init/sample-app/nginx.conf -> /nginx-conf/ ..."
	cp /docker-init/sample-app/nginx.conf /nginx-conf/
fi
