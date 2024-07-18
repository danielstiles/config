#!/bin/bash

GCM_VERSION=$1
if [ -z $GCM_VERSION ]; then
    GCM_VERSION="2.5.1"
fi

sudo apt-get update
sudo apt-get install -y keychain git-all
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v$GCM_VERSION/gcm-linux_amd64.$GCM_VERSION.tar.gz
sudo tar -xvf gcm-linux_amd64.$GCM_VERSION.tar.gz -C /usr/local/bin
git-credential-manager configure
