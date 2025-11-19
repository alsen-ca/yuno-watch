#!/usr/bin/env bats

setup() {
    CONF_FILE="/home/debrian/Downloads/yuno-watch/yuno-watch.conf"
    if [[ -f "$CONF_FILE" ]]; then
        source "$CONF_FILE"
    else
        echo "ERROR: $CONF_FILE not found" >&2
        exit 1
    fi
}

@test "Directory log-output exists" {
    run [ -d "$LOG_OUTPUT" ]
    [ "$status" -eq 0 ]
}

@test "Directory rotation-root exists" {
    run [ -d "$ROTATION_ROOT" ]
    [ "$status" -eq 0 ]
}

@test "Directory summary-root exists" {
    run [ -d "$SUMMARY_ROOT" ]
    [ "$status" -eq 0 ]
}

@test "Directory conf exists" {
    run [ -d "$CONF" ]
    [ "$status" -eq 0 ]
}

