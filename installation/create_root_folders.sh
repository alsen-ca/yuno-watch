#!/bin/bash

set -euo pipefail

CONF_NAME="yuno-watch.conf"
CONF_FILE="$(pwd)/$CONF_NAME"
if [[ -f "$CONF_FILE" ]]; then
    source "$CONF_FILE"
else
    echo "ERROR: "$CONF_FILE" not found" >&2
    exit 1
fi

sudo mkdir -p $LOG_OUTPUT $ROTATION_SUB $SUMMARY_SUB $CONF

sudo chown -R $NAME:$NAME $LOG_OUTPUT $ROTATION_ROOT $SUMMARY_ROOT $CONF

sudo -u $NAME chmod 700 $LOG_OUTPUT $ROTATION_ROOT $SUMMARY_ROOT $CONF

sudo cp $CONF_FILE $CONF/$CONF_NAME

sudo -u $NAME ls -l "$ROTATION_ROOT"
sudo -u $NAME ls -l "$ROTATION_SUB"
sudo -u $NAME ls -l "$SUMMARY_ROOT"
sudo -u $NAME ls -l "$SUMMARY_SUB"
sudo -u $NAME ls -l "$CONF"