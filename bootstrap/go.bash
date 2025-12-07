#!/bin/bash

GO_VERSION=$1
if [[ -z $GO_VERSION ]]; then
    GO_VERSION="1.25.5"
fi

if [[ ! -d /usr/local/go ]] || [[ $(go version | grep -oE '[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+') != $GO_VERSION ]]; then
    sudo rm -rf /usr/local/go
    wget -c https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local
else
    echo "Already at version " $(go version | grep -oE '[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+')
fi

# refresh gopls install
/usr/local/go/bin/go install golang.org/x/tools/gopls@latest

