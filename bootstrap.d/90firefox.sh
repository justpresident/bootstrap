#!/bin/bash

set -ex

PROFILE_PATH="/home/$USER/snap/firefox/common/.mozilla/firefox"

PROFILE_NAME=$(grep Path $PROFILE_PATH/profiles.ini | head -n1 | cut -f2 -d=)

PROFILE_PATH=$PROFILE_PATH/$PROFILE_NAME

if [ ! -d $PROFILE_PATH ]; then
    echo "Can't find firefox profile in $PROFILE_PATH"
    return
fi

mkdir -p $PROFILE_PATH/chrome
cp files/firefox/userChrome.css $PROFILE_PATH/chrome
