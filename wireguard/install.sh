#!/bin/bash -e

HERE=$(dirname $(readlink -f $0))
FOLDERNAME="AutoInstaller WireGuard"

STAGING=$HERE/staging
FILEPREFIX=autogen-wireguard-
FILESUFFIX=.conf

# cleanup in case of earlier failure
rm -f folders.json items.json
rm -rf $STAGING

# Get the folder ID for the wireguard folder
bw list folders > folders.json
FOLDERID=$(jq -r ".[] | select(.name == \"$FOLDERNAME\") | .id" folders.json)

# Get all items in this folder
bw list --folderid $FOLDERID items > items.json

# pass JSON to python, which creates file in a staging directory
./generate-wireguard.py items.json --hostname=$(hostname) --directory=$STAGING --prefix=$FILEPREFIX --suffix=$FILESUFFIX

# remove files from /etc
sudo rm -f /etc/NetworkManager/system-connections/$FILEPREFIX*$FILESUFFIX

# copy files from staging
sudo cp $STAGING/$FILEPREFIX*$FILESUFFIX /etc/NetworkManager/system-connections/ || true

# fix permissions
sudo chmod 600 /etc/NetworkManager/system-connections/$FILEPREFIX*$FILESUFFIX || true

# reload NM
sudo systemctl restart NetworkManager

# cleanup
rm -f folders.json items.json
rm -rf $STAGING
