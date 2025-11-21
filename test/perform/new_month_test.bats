#!/usr/bin/env bats

@test "Directory lib with correct owner and permissions" {
    YEAR_MONTH="2025-11"
    sh "$BASE_DIR/perform/new-month.sh" $YEAR_MONTH
    
    run [ -d "$ROTATION_TEST/$YEAR_MONTH" ]
    [ "$status" -eq 0 ]
}
