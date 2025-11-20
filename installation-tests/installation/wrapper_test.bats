#!/usr/bin/env bats

setup() {
    WRAPPER="/usr/local/bin/yuno"
}

@test "Wrapper CLI exists" {
    run [ -f "$WRAPPER" ]
    [ "$status" -eq 0 ]
}


@test "Wrapper CLI belongs to root" {
    run stat -c "%U %G" "$WRAPPER"
    [ "$status" -eq 0 ]
    [ "$output" = "root root" ]

}

@test "Wrapper CLI can be executed" {
    run sudo stat -c "%a" "$WRAPPER"
    [ "$status" -eq 0 ]
    [ "$output" = "755" ]
}

