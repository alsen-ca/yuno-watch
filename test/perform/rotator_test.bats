#!/usr/bin/env bats

setup() {
    YEAR="2025"
    MONTH="11"
    YEAR_MONTH="$YEAR-$MONTH"
    DAY="21"
    DATE="$YEAR_MONTH-$DAY"
    ALL_DATE="$YEAR$MONTH$DAY"
    ERROR_LOG="error.log"
    ANOTHER_THEORETICAL_LOG="info.log"
    FILE_LOCATION="$NGINX_LOGS/access.log-$ALL_DATE"
    touch $FILE_LOCATION
    touch "$NGINX_LOGS/$ERROR_LOG-$ALL_DATE"
    touch "$NGINX_LOGS/$ANOTHER_THEORETICAL_LOG-$ALL_DATE"
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
    COMPLETE_PATH="$ROTATION_SUB/$YEAR_MONTH/$DAY/$NGINX_ORIGINAL_FILENAME-$ALL_DATE"
    run [ -f "$COMPLETE_PATH" ]
    [ "$status" -eq 0 ]
}

@test "Rotate error and other logs to Archive location" {
    ERROR_PATH="$ROTATION_SUB/$YEAR_MONTH/$DAY/$ERROR_LOG-$ALL_DATE"
    run [ -f "$ERROR_PATH" ]
    [ "$status" -eq 0 ]

    ANOTHER_LOG_PATH="$ROTATION_SUB/$YEAR_MONTH/$DAY/$ANOTHER_THEORETICAL_LOG-$ALL_DATE"
    run [ -f "$ANOTHER_LOG_PATH" ]
    [ "$status" -eq 0 ]
}

@test "Log from today has not been moved" {
    TODAY_DATE="$(date +%Y%m%d)"
    COMPLETE_PATH="$ROTATION_SUB/$YEAR_MONTH/$DAY/$NGINX_ORIGINAL_FILENAME-$TODAY_DATE"
    run [ ! -f "$COMPLETE_PATH" ]
    [ "$status" -eq 0 ]
}