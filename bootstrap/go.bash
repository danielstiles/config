#!/bin/bash

GO_VERSION=$1
if [ -z $GO_VERSION ]; then
    GO_VERSION="1.22.5"
fi

if [ ! -d /usr/local/go ]; then
    wget -c https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local
fi

# reload config to get path set up
source ~/.bash_local
pathadd ~/go/bin
pathadd /usr/local/go/bin

if [ ! -e ~/go/bin/gopls ]; then
    go install golang.org/x/tools/gopls@latest
fi
