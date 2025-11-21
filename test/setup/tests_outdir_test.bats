#!/usr/bin/env bats

@test "Directory test rotated logs" {
    run [ -d "$ROTATION_TEST" ]
    [ "$status" -eq 0 ]

    run stat -c "%U %G" "$ROTATION_TEST"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    run stat -c "%a" "$ROTATION_TEST"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}

@test "Directory test wfor summaries" {
    run [ -d "$SUMMARY_TEST" ]
    [ "$status" -eq 0 ]

    run stat -c "%U %G" "$SUMMARY_TEST"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    run stat -c "%a" "$SUMMARY_TEST"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}