#!/usr/bin/env bats

@test "Create package's Rotation and Summary folder for month" {
    YEAR_MONTH="2025-11"
    sh "$BASE_DIR/perform/new-month.sh" $YEAR_MONTH
    
    run [ -d "$ROTATION_TEST/$YEAR_MONTH" ]
    [ "$status" -eq 0 ]

    run [ -d "$SUMMARY_SUB/$YEAR_MONTH" ]
    [ "$status" -eq 0 ]
}
