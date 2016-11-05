echo "*** Development environment with NodeJS and Npm ***"

cat /etc/hosts | grep "docker-host"
if [ $? > 0 ]; then
    echo "# Add docker host's IP address(The same as the default gateway)"
    echo "$(route | awk '/default/ { print $2 }')     docker-host" >> /etc/hosts
fi

su - u01
