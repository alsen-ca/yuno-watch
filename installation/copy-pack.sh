#!/bin/bash

set -euo pipefail

CONF_FILE="/home/debrian/Downloads/yuno-watch/yuno-watch.conf"
if [[ -f "$CONF_FILE" ]]; then
    source "$CONF_FILE"
else
    echo "ERROR: "$CONF_FILE" not found" >&2
    exit 1
fi

sudo cp -R /home/debrian/Downloads/yuno-watch/lib $BASE_DIR
sudo cp -R /home/debrian/Downloads/yuno-watch/docker $BASE_DIR
sudo cp -R /home/debrian/Downloads/yuno-watch/action $BASE_DIR
sudo cp -R /home/debrian/Downloads/yuno-watch/perform $BASE_DIR
sudo cp -R /home/debrian/Downloads/yuno-watch/test $BASE_DIR
sudo chown -R $NAME:$NAME $BASE_DIR
sudo -u $NAME chmod -R 700 $BASE_DIR