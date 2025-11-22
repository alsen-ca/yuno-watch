#!/usr/bin/env bats

setup() {
    YEAR="2025"
    MONTH="11"
    YEAR_MONTH="$YEAR-$MONTH"
    DAY="21"
    DATE="$YEAR_MONTH-$DAY"
    FILE_LOCATION="$NGINX_LOGS/access.log-20251121"
    echo "$FILE_LOCATION"
    touch $FILE_LOCATION
    sh "$BASE_DIR/perform/rotate.sh" $DATE
}

@test "Create daily Rotation directory" {
    run [ -d "$ROTATION_SUB/$YEAR_MONTH/$DAY" ]
    [ "$status" -eq 0 ]
}

@test "Create daily Summary directory" {
    run [ -d "$SUMMARY_SUB/$YEAR_MONTH/$DAY" ]
    [ "$status" -eq 0 ]
}
@test "Rotate log to package's Archive location" {
    ALL_DATE="$YEAR$MONTH$DAY"
    COMPLETE_PATH="$ROTATION_SUB/$YEAR_MONTH/$DAY/$NGINX_ORIGINAL_FILENAME-$ALL_DATE"
    echo "complete path: $COMPLETE_PATH"
    run [ -f "$COMPLETE_PATH" ]
    [ "$status" -eq 0 ]
}
