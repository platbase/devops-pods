# mongodb server environment for development
# ----
# build image:
#   docker build --force-rm -t platbase.com/dev.mongodb:1.0 .
# run:
#   docker run -it --rm -p 27017:27017 -v /tmp/mongodb.data:/data platbase.com/dev.mongodb:1.0

FROM platbase.com/dev.base:1.0
MAINTAINER https://github.com/platbase

# Mappings
EXPOSE 27017
VOLUME ["/workspace", "/data"]

# Entry - force work with user "u01"
CMD /start-mongodb.sh

###############################################################################

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
RUN \
    echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" \
         | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
RUN apt-get update
RUN apt-get install -y --allow-unauthenticated mongodb-org

# Prepare starting commands
ADD files/start-mongodb.sh /start-mongodb.sh
RUN chmod +x /start-mongodb.sh
