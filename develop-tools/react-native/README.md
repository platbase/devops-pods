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
 - https://github.com/rajendarreddyj/etc-udev-rules.d
 - https://github.com/gilesp/docker/tree/master/react_native

#### TRY following operation(Maybe not needed)
```
sudo -i

echo '## Huawei
SUBSYSTEM=="usb", ATTR{idVendor}=="12d1", MODE="0666", GROUP="plugdev"
' > /etc/udev/rules.d/51-Huawei.rules

echo '# OPPO
SUBSYSTEM=="usb", ATTR{idVendor}=="22d9", MODE="0666", GROUP="plugdev"
' > /etc/udev/rules.d/51-OPPO.rules

chmod a+r /etc/udev/rules.d/51-*.rules
ls -al /etc/udev/rules.d

udevadm control --reload-rules
service udev restart
```
