#!/usr/bin/env bats

setup() {
    YEAR_MONTH="2025-11"
    YEAR_MONTH2="2025-10"
    find "$ROTATION_TEST" -mindepth 1 -delete
    sh "$BASE_DIR/perform/new-month.sh" $YEAR_MONTH
    sh "$BASE_DIR/perform/new-month.sh" $YEAR_MONTH2
}

@test "Create package's Rotation and Summary folder for month" {
    run [ -d "$ROTATION_TEST/$YEAR_MONTH" ]
    [ "$status" -eq 0 ]

    run [ -d "$ROTATION_TEST/$YEAR_MONTH2" ]
    [ "$status" -eq 0 ]
}

@test "Don't create folders for other months" {
    INVALID_YEAR_MONTH="2025-09"
    INVALID_YEAR_MONTH1="2025-12"
    INVALID_YEAR_MONTH2="2025-13"
    
    run [ ! -d "$ROTATION_TEST/$INVALID_YEAR_MONTH" ]
    [ "$status" -eq 0 ]

    run [ ! -d "$SUMMARY_SUB/$INVALID_YEAR_MONTH1" ]
    [ "$status" -eq 0 ]

    run [ ! -d "$SUMMARY_SUB/$INVALID_YEAR_MONTH2" ]
    [ "$status" -eq 0 ]
}
