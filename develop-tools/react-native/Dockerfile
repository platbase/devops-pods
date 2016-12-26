# React-Native develop environment
#
# See README.md for build and run.

FROM platbase.com/dev.nodejs:6.9.2
MAINTAINER https://github.com/platbase

# Mappings
EXPOSE 8081
VOLUME ["/workspace", "/data", "/tmp/.X11-unix"]

# Entry - force work with user "u01"
CMD /start-nodejs-shell-rn.sh

###############################################################################
RUN dpkg --add-architecture i386
RUN apt-get update

# IA32 library for run `adb`
RUN apt-get install -qy lib32gcc1 lib32ncurses5 lib32stdc++6 lib32tinfo5 libc6-i386

# JDK
RUN apt-get install -qy --no-install-recommends default-jdk

# To build watchman
RUN apt-get install -qy automake python-dev git

ENV ANDROID_SDK_FILE android-sdk_r24.0.1-linux.tgz
ENV ANDROID_SDK_URL https://dl.google.com/android/$ANDROID_SDK_FILE

# Install android-sdk
RUN cd /tmp &&	\
	wget $ANDROID_SDK_URL &&	\
	tar -xzf $ANDROID_SDK_FILE &&	\
	rm $ANDROID_SDK_FILE &&	\
	mv android-sdk-linux /home/u01/android-sdk &&	\
	chown -R u01:u01 /home/u01/android-sdk &&	\
	rm -rf android-sdk-linux

# Install watchman
RUN cd /tmp;	\
	git clone https://github.com/facebook/watchman.git &&	\
	cd watchman &&	\
	git checkout v4.7.0 &&	\
	./autogen.sh &&	\
	./configure &&	\
	make &&	\
	make install

# Add base-init shell scripts
ADD files/docker-react-native-init /docker-react-native-init
RUN chmod +x /docker-react-native-init/*

# Prepare starting commands
ADD files/start-nodejs-shell-rn.sh /start-nodejs-shell-rn.sh
RUN chmod +x /start-nodejs-shell-rn.sh

