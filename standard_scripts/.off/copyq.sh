#!/bin/bash

sleep 10
/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=copyq com.github.hluk.copyq --start-server show
