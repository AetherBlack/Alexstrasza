#!/bin/bash

# Security
PATH=$(/usr/bin/getconf PATH || kill $$)

# Default
VOLUME="/tmp"

if [ -n "$1" ]; then
    if [ -d "$1" ]; then
        if [ "$1" = "." ]; then
            VOLUME="$PWD"
        else
            VOLUME="$1"
        fi
    else
        echo "[!] The folder '$1' doesn't exists!"
    fi
fi

sudo docker run -it --rm --name alexstrasza --hostname alexstrasza --cap-add SYS_PTRACE --security-opt seccomp=unconfined -v $VOLUME:/share reverse:0.1
