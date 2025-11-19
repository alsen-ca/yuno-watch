#!/bin/bash

set -euo pipefail

CONF_FILE="$(pwd)/yuno-watch.conf"
if [[ -f "$CONF_FILE" ]]; then
    source "$CONF_FILE"
else
    echo "ERROR: "$CONF_FILE" not found" >&2
    exit 1
fi

sudo useradd --system --no-create-home --shell /sbin/nologin "$NAME"