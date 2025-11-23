#!/usr/bin/env bats

setup() {
    SCRIPT_DIR="$BATS_TEST_DIRNAME"
    DIR="$SCRIPT_DIR/../.."
}

@test "Directory $DIR exists" {
    run [ -d "$DIR" ]
    [ "$status" -eq 0 ]
}
