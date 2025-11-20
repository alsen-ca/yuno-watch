#!/usr/bin/env bats

@test "Directory lib with correct owner and permissions" {
    run [ -d "lib" ]
    [ "$status" -eq 0 ]

    run stat -c "%U %G" "lib"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    run stat -c "%a" "lib"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}

@test "Directory docker with correct owner and permissions" {
    run [ -d "docker" ]
    [ "$status" -eq 0 ]

    run stat -c "%U %G" "docker"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    run stat -c "%a" "docker"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}

@test "Directory deletion with correct owner and permissions" {
    run [ -d "deletion" ]
    [ "$status" -eq 0 ]

    run stat -c "%U %G" "deletion"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    run stat -c "%a" "deletion"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}

@test "Directory action with correct owner and permissions" {
    run [ -d "action" ]
    [ "$status" -eq 0 ]

    run stat -c "%U %G" "action"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    run stat -c "%a" "action"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}

@test "Directory perform with correct owner and permissions" {
    run [ -d "perform" ]
    [ "$status" -eq 0 ]

    run stat -c "%U %G" "perform"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    run stat -c "%a" "perform"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}