#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONF_NAME="yuno-watch.conf"
CONF_FILE="$SCRIPT_DIR/../$CONF_NAME"

if [[ -f "$CONF_FILE" ]]; then
    source "$CONF_FILE"
else
    echo "ERROR: "$CONF_FILE" not found" >&2
    exit 1
fi

sudo mkdir -p $LOG_OUTPUT $ROTATION_SUB $SUMMARY_SUB $CONF $BASE_DIR $ROTATION_TO_BE_IMPORTED
sudo cp $CONF_FILE $CONF/$CONF_NAME

sudo chown -R $NAME:$NAME $ROTATION_ROOT $SUMMARY_ROOT $CONF $BASE_DIR $ROTATION_TO_BE_IMPORTED
sudo -u $NAME chmod -R 700 $ROTATION_ROOT $SUMMARY_ROOT $CONF $BASE_DIR $ROTATION_TO_BE_IMPORTED


sudo chown root:$NAME $LOG_OUTPUT
sudo chmod 770 $LOG_OUTPUT

sudo touch $SUCCESS_OUTPUT $ERROR_OUTPUT
sudo chown $NAME:$NAME $SUCCESS_OUTPUT $ERROR_OUTPUT
sudo -u $NAME chmod 640 $SUCCESS_OUTPUT $ERROR_OUTPUT
