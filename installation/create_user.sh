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

if id "$NAME" &>/dev/null; then
    echo "This user already exists, passing."
else
    sudo useradd --system --no-create-home --shell /sbin/nologin "$NAME"
    echo "User $NAME created."
fi
