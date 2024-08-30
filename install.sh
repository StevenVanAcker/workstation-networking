#!/bin/bash -e

BW_ACCOUNT=$(cat ~/.myinstaller/bw-email.txt)

if [ -e ~/.myinstaller/.bwsession ];
then
    echo "Using existing session key..."
    export BW_SESSION_KEY=$(cat ~/.myinstaller/.bwsession)
else
    if bw login --check;
    then
        echo "Unlocking vault..."
        export BW_SESSION_KEY=$(bw unlock --raw)
    else
        echo "Logging in..."
        export BW_SESSION_KEY=$(bw login $BW_ACCOUNT --raw)
    fi
fi

pushd wifi
./install.sh
popd

pushd wireguard
./install.sh
popd
