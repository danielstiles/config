#!/bin/bash

on=$1
if [ -z $on ]; then
    on="1"
fi

f=""
r=""
if [ $on = "1" ]; then
    f="# "
else
    r="# "
fi
query="s;^$f{};$r{};"
sed -n "s/^deb\([^-]\)/deb-src\1/p" /etc/apt/sources.list | sed 's/\([][]\)/\\\\\1/g' | xargs -I {} sed -i "$query" /etc/apt/sources.list
