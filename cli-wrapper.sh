#!/bin/bash

CONF_FILE="/etc/yuno-watch/yuno-watch.conf"
if [[ -f "$CONF_FILE" ]]; then
    source "$CONF_FILE"
else
    echo "ERROR: $CONF_FILE not found" >&2
    exit 1
fi

export $(cut -d= -f1 "$CONF_FILE")

if [ ! -d "$BASE_DIR" ]; then
    echo "Error: YunoWatch installation not found at $BASE_DIR" >&2
    exit 1
fi

if [ $# -lt 1 ]; then
    echo "Usage: yuno <command> [args...]"
    echo "Commands: tests, action, perform, docker"
    exit 1
fi

# Extract the command and arguments
COMMAND=$1
shift
ARGS=$@


case $COMMAND in
    tests)
        SCRIPT="$BASE_DIR/tests/$ARGS"
        ;;
    action)
        SCRIPT="$BASE_DIR/action/$ARGS.sh"
        ;;
    perform)
        SCRIPT="$BASE_DIR/perform/$ARGS.sh"
        ;;
    docker)
        SCRIPT="$BASE_DIR/docker/$ARGS.sh"
        ;;
    *)
        echo "Error: Unknown command '$COMMAND'"
        exit 1
        ;;
esac

if [ ! -f "$SCRIPT" ]; then
    echo "Error: Script not found: $SCRIPT" >&2
    exit 1
fi

sudo -u $NAME "$SCRIPT"
