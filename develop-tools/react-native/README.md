# React-Native development environment

## build image

### Prepare - if http proxy needed
```
# The ip address of docker host OS which can access internet
export _internet_ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
export ARG_http_proxy="--build-arg http_proxy=http://$_internet_ip:8123 --build-arg https_proxy=http://$_internet_ip:8123"
```
## build
```
docker build $ARG_http_proxy --force-rm -t platbase.com/dev.react-native:1.0 .
```

## run container
### Prepare - if http proxy needed
```
# The ip address of docker host OS which can access internet
export _internet_ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
export ENV_http_proxy="-e http_proxy=http://$_internet_ip:8123 -e https_proxy=http://$_internet_ip:8123"
```
### Run
```
docker run -it --rm -p 8081:8081 \
    -v /tmp/react-native.ws:/workspace      \
    -v /tmp/react-native.data:/data         \
    -v /tmp/.X11-unix:/tmp/.X11-unix        \
    $ENV_http_proxy \
    platbase.com/dev.react-native:1.0
```

## About accessing physical device
 - privileged
 - mapping `/dev/bus/usb:/dev/bus/usb`

### Reference
 - https://github.com/gilesp/docker/tree/master/react_native

#### TRY following operation(Maybe not needed)
```
sudo -i

echo '# adb protocol on Huawei honor4
SUBSYSTEM=="usb", ATTR{idVendor}=="12d1", ATTR{idProduct}=="1052", MODE="0600", OWNER="<user, not root>"
' > /etc/udev/rules.d/51-honor4.rules

echo '# adb protocol on OPPO 7
SUBSYSTEM=="usb", ATTR{idVendor}=="22d9", ATTR{idProduct}=="2774", MODE="0600", OWNER="<user, not root>"
' > /etc/udev/rules.d/51-oppo7.rules

ls -al /etc/udev/rules.d

udevadm control --reload-rules
service udev restart
```
