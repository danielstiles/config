#!/bin/bash

cat /etc/apt/sources.list.d/ubuntu.sources | sed 's/^Types: deb$/Types: deb-src/' > /etc/apt/sources.list.d/ubuntu-src.sources
