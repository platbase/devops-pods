# NodeJS and npm, As the basic environment for development.

## build image

### Prepare - if http proxy needed
```
# The ip address of docker host OS which can access internet
export _internet_ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
export ARG_http_proxy="--build-arg http_proxy=http://$_internet_ip:8123 --build-arg https_proxy=http://$_internet_ip:8123"
```
## build
```
docker build $ARG_http_proxy --force-rm -t platbase.com/dev.nodejs:6.9.2 .
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
docker run -it --rm -p 8080:8080 \
    -v /tmp/nodejs.ws:/workspace \
    -v /tmp/nodejs.data:/data    \
    -v /tmp/.X11-unix:/tmp/.X11-unix  \
     $ENV_http_proxy \
    platbase.com/dev.nodejs:6.9.2
```
