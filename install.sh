#!/bin/bash -e

BW_ACCOUNT=$(cat ~/.myinstaller/bw-email.txt)
SESSION_FILE=~/.bw_session

# ensure we are logged in and get the session token
~/bin/bw-login-and-unlock
export BW_SESSION=$(cat "$SESSION_FILE")

pushd wifi
./install.sh
popd

pushd wireguard
./install.sh
popd
