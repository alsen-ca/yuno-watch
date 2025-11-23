#!/bin/bash
set -euo pipefail


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONF_FILE="$SCRIPT_DIR/../yuno-watch.conf"
if [[ -f "$CONF_FILE" ]]; then
    source "$CONF_FILE"
else
    echo "ERROR: "$CONF_FILE" not found" >&2
    exit 1
fi

sudo cp -R $SCRIPT_DIR/../lib $BASE_DIR
sudo cp -R $SCRIPT_DIR/../docker $BASE_DIR
sudo cp -R $SCRIPT_DIR/../action $BASE_DIR
sudo cp -R $SCRIPT_DIR/../perform $BASE_DIR
sudo cp -R $SCRIPT_DIR/../test $BASE_DIR
sudo chown -R $NAME:$NAME $BASE_DIR
sudo -u $NAME chmod -R 700 $BASE_DIR