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

@test "Directory test for summaries" {
    run [ -d "$SUMMARY_TEST" ]
    [ "$status" -eq 0 ]

    run stat -c "%U %G" "$SUMMARY_TEST"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    run stat -c "%a" "$SUMMARY_TEST"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}

@test "Directory ROTATION_TEST_TO_BE_IMPORTED for putting month's wort of logs" {
    run [ -d "$ROTATION_TEST_TO_BE_IMPORTED" ]
    [ "$status" -eq 0 ]

    run stat -c "%U %G" "$ROTATION_TEST_TO_BE_IMPORTED"
    [ "$status" -eq 0 ]
    [ "$output" = "$NAME $NAME" ]

    run stat -c "%a" "$ROTATION_TEST_TO_BE_IMPORTED"
    [ "$status" -eq 0 ]
    [ "$output" = "700" ]
}