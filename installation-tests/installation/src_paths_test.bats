#!/usr/bin/env bats

setup() {
    SCRIPT_DIR="$BATS_TEST_DIRNAME"
    CONF_FILE="$SCRIPT_DIR/../../yuno-watch.conf"
    if [[ -f "$CONF_FILE" ]]; then
        source "$CONF_FILE"
    else
        echo "ERROR: $CONF_FILE not found" >&2
        exit 1
    fi
}

@test "Package location with correct owner and permissions" {
    # Check existence
    run [ -d "$BASE_DIR" ]
    [ "$status" -eq 0 ]

    # Check owner and group
    run sudo stat -c "%U %G" "$BASE_DIR"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    # Check permissions
    run sudo stat -c "%a" "$BASE_DIR"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}

@test "Directory lib with correct owner and permissions" {
    run sudo test -d "$BASE_DIR/lib"
    [ "$status" -eq 0 ]

    run sudo stat -c "%U %G" "$BASE_DIR/lib"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    run sudo stat -c "%a" "$BASE_DIR/lib"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}

@test "Directory docker with correct owner and permissions" {
    run sudo test -d "$BASE_DIR/docker"
    [ "$status" -eq 0 ]

    run sudo stat -c "%U %G" "$BASE_DIR/docker"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    run sudo stat -c "%a" "$BASE_DIR/docker"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}

@test "Directory action with correct owner and permissions" {
    run sudo test -d "$BASE_DIR/action"
    [ "$status" -eq 0 ]

    run sudo stat -c "%U %G" "$BASE_DIR/action"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    run sudo stat -c "%a" "$BASE_DIR/action"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}

@test "Directory perform with correct owner and permissions" {
    run sudo test -d "$BASE_DIR/perform"
    [ "$status" -eq 0 ]

    run sudo stat -c "%U %G" "$BASE_DIR/perform"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    run sudo stat -c "%a" "$BASE_DIR/perform"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}

@test "Configuration file exists with correct owner and permissions" {
    run sudo test -f "$CONF/yuno-watch.conf"
    [ "$status" -eq 0 ]

    run sudo stat -c "%U %G" "$CONF/yuno-watch.conf"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    run sudo stat -c "%a" "$CONF/yuno-watch.conf"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}