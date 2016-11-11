# NodeJS and npm, with chromium-browser, As the basic environment for development
# ----
# build image:
#   docker build --force-rm -t platbase.com/dev.nodejs-debug:6.2.1 .
# run:
#   docker run -it --rm -p 8080:8080 \
#              -v /tmp/nodejs.ws:/workspace -v /tmp/nodejs.data:/data \
#              -v /tmp/.X11-unix:/tmp/.X11-unix platbase.com/dev.nodejs-debug:6.2.1

FROM platbase.com/dev.nodejs:6.2.1
MAINTAINER https://github.com/platbase

# Mappings
EXPOSE 8080
VOLUME ["/workspace", "/data", "/tmp/.X11-unix"]

# DISPLAY
ENV DISPLAY ":0"

# Entry - force work with user "u01"
CMD /start-nodejs-shell.sh

###############################################################################

# make sure the package repository is up to date
RUN apt-get update

# Install zh-CN support
RUN apt-get install -y language-pack-zh-hans
RUN apt-get install -y ttf-ubuntu-font-family
RUN apt-get install -y ttf-wqy-zenhei ttf-wqy-microhei

# Install Chromium
RUN apt-get install -y chromium-browser

# Prepare starting commands
ADD files/start-nodejs-shell.sh /start-nodejs-shell.sh
RUN chmod +x /start-nodejs-shell.sh
