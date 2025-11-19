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

@test "User $NAME exists" {
    run id "$NAME"
    [ "$status" -eq 0 ]
}

@test "User $NAME has no sudo rights" {
    run sudo -l -U $NAME 2>&1
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
    [[ "$output" == *"User $NAME is not allowed to run sudo"* ]]
}
