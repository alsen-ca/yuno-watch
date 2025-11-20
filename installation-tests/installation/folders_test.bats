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

@test "Directory log-output correct" {
    run [ -d "$LOG_OUTPUT" ]
    [ "$status" -eq 0 ]

    run stat -c "%U %G" "$LOG_OUTPUT"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    run  stat -c "%a" "$LOG_OUTPUT"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}


@test "Directory rotation-root correct" {
    run [ -d "$ROTATION_ROOT" ]
    [ "$status" -eq 0 ]

    run stat -c "%U %G" "$ROTATION_ROOT"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    run  stat -c "%a" "$ROTATION_ROOT"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}

@test "Directory summary-root correct" {
    run [ -d "$SUMMARY_ROOT" ]
    [ "$status" -eq 0 ]

    run stat -c "%U %G" "$SUMMARY_ROOT"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    run  stat -c "%a" "$SUMMARY_ROOT"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}

@test "Directory conf correct" {
    run [ -d "$CONF" ]
    [ "$status" -eq 0 ]

    run stat -c "%U %G" "$CONF"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    run  stat -c "%a" "$CONF"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}