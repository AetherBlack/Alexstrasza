#!/bin/bash

# Security
PATH=$(/usr/bin/getconf PATH || kill $$)

# Default
VOLUME="$(mktemp -d)"

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

# Check if the docker already exists
sudo docker ps -a | grep alexstrasza 1>/dev/null

if [ $? -eq 0 ]; then
    sudo docker exec -it alexstrasza zsh
else
    echo "$VOLUME:/share"
    sudo docker run -it --rm --name alexstrasza --hostname alexstrasza --cap-add SYS_PTRACE --security-opt seccomp=unconfined -v $VOLUME:/share reverse:0.1
fi
