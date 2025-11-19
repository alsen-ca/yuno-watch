#!/bin/bash

set -euo pipefail

CONF_NAME="yuno-watch.conf"
CONF_FILE="/home/debrian/Downloads/yuno-watch/$CONF_NAME"
if [[ -f "$CONF_FILE" ]]; then
    source "$CONF_FILE"
else
    echo "ERROR: "$CONF_FILE" not found" >&2
    exit 1
fi

sudo mkdir -p $LOG_OUTPUT $ROTATION_SUB $SUMMARY_SUB $CONF $MYLIB_HOME

sudo chown -R $NAME:$NAME $LOG_OUTPUT $ROTATION_ROOT $SUMMARY_ROOT $CONF $MYLIB_HOME

sudo -u $NAME chmod 700 $LOG_OUTPUT $ROTATION_ROOT $SUMMARY_ROOT $CONF $MYLIB_HOME

sudo cp $CONF_FILE $CONF/$CONF_NAME
