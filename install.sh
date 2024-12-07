#!/bin/bash -e

BW_ACCOUNT=$(cat ~/.myinstaller/bw-email.txt)
SESSION_FILE=~/.bw_session

# If the session file exists, read the session token from it
if [ -f "$SESSION_FILE" ]; then
    echo "Using existing session key..."
    export BW_SESSION=$(cat "$SESSION_FILE")
else
    # If the session file doesn't exist, get a new session token
    if bw login --check;
    then
        echo "Unlocking vault..."
        export BW_SESSION=$(bw unlock --raw)
    else
        echo "Logging in..."
        export BW_SESSION=$(bw login $BW_ACCOUNT --raw)
    fi

    echo "$BW_SESSION" > "$SESSION_FILE"
    chmod go= "$SESSION_FILE"
fi

pushd wifi
./install.sh
popd

pushd wireguard
./install.sh
popd
