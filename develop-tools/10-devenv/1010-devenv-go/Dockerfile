# Development environment for golang with code-server.
# ----
# build image:
#   docker build --force-rm -t platbase.com/dev.env-go:1.4-1.16.5 .
# run test:
#   dc-start -

FROM platbase.com/dev.code-server:1.4-3.10.2
LABEL maintainer="https://github.com/platbase"

# The version of golang
ENV GO_VERSION=1.16.5

# Mappings
EXPOSE 8080
VOLUME ["/workspace", "/data", "/tmp/.X11-unix"]

# Entry - force work with user "u01"
CMD /start-cdr-go.sh

###############################################################################

# Install go-lang
RUN wget -O /tmp/go${GO_VERSION}.linux-amd64.tar.gz https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar xzvf /tmp/go${GO_VERSION}.linux-amd64.tar.gz -C /opt && \
    rm -f "/tmp/go${GO_VERSION}.linux-amd64.tar.gz"
RUN echo "export GOROOT=/opt/go"                                                     >> /etc/profile && \
    echo "export GOARCH=amd64"                                                       >> /etc/profile && \
    echo "export GOOS=linux"                                                         >> /etc/profile && \
    echo "export GOTOOLS=\$GOROOT/pkg/tool"                                          >> /etc/profile && \
    echo "export GOPATH=/workspace/go:/opt/GOPATH/u01"                               >> /etc/profile && \
    echo "export PATH=\$PATH:\$GOROOT/bin:/workspace/go/bin:/opt/GOPATH/u01/bin"     >> /etc/profile

# Install extensions
RUN code-server --extensions-dir /usr/local/share/code-server/extensions --install-extension golang.go && \
    chown -Rv u01:u01 /usr/local/share/code-server/extensions

# Install packages
RUN GOROOT="/opt/go" && \
    GOPATH="/opt/GOPATH/u01" $GOROOT/bin/go get -v github.com/uudashr/gopkgs/v2/cmd/gopkgs     && \
    GOPATH="/opt/GOPATH/u01" $GOROOT/bin/go get -v github.com/ramya-rao-a/go-outline           && \
    GOPATH="/opt/GOPATH/u01" $GOROOT/bin/go get -v github.com/cweill/gotests/gotests           && \
    GOPATH="/opt/GOPATH/u01" $GOROOT/bin/go get -v github.com/fatih/gomodifytags               && \
    GOPATH="/opt/GOPATH/u01" $GOROOT/bin/go get -v github.com/josharian/impl                   && \
    GOPATH="/opt/GOPATH/u01" $GOROOT/bin/go get -v github.com/haya14busa/goplay/cmd/goplay     && \
    GOPATH="/opt/GOPATH/u01" $GOROOT/bin/go get -v github.com/go-delve/delve/cmd/dlv           && \
    GOPATH="/opt/GOPATH/u01" $GOROOT/bin/go get -v -d github.com/go-delve/delve/cmd/dlv@master && \
    GOPATH="/opt/GOPATH/u01" $GOROOT/bin/go get -v honnef.co/go/tools/cmd/staticcheck          && \
    GOPATH="/opt/GOPATH/u01" $GOROOT/bin/go get -v golang.org/x/tools/gopls

# Add shell scripts
ADD files /
RUN chmod +x /docker-cdr-init/docker-cdr-install-ext.sh && \
    chmod +x /start-cdr-go.sh
