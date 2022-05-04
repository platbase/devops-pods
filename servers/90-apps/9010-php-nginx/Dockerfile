# php-nginx server
# ----
# build image:
#   docker build --force-rm -t platbase.com/apps.php-nginx:latest -t platbase.com/apps.php-nginx:20220426-20.04 .
# run test:
#   dc-start -

FROM platbase.com/server.base:latest
LABEL maintainer="https://github.com/platbase"

### Server runtime environment variables ######################################
ENV RT_WORK_PATH /php-app:/nginx-conf
ENV RT_WORK_COMMAND 'echo "Can not reach here !"'
###############################################################################

# php and content
VOLUME ["/php-app"]
# nginx conf
VOLUME ["/nginx-conf"]
# nginx port
EXPOSE 8080

# Prepare ...
RUN apt-get update && apt-get upgrade -y

# Install php for php-nginx
RUN apt-get install -y --allow-unauthenticated php-common php-curl php-fileinfo php-fpm php-gd php-iconv php-mbstring  php-xmlrpc  php-soap php-sqlite3 php-xml php-zip
# Install nginx
RUN apt-get install -y --allow-unauthenticated nginx

# register root.d
ADD resources/docker-init/etc/root.d/ /docker-init/etc/root.d/

# Prepare sample app
ADD resources/docker-init/sample-app/ /docker-init/sample-app/
