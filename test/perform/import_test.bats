#!/usr/bin/env bats

setup() {
    YEAR="2025"
    MONTH="11"
    YEAR_MONTH="$YEAR-$MONTH"
    EMULATED_LOG_LOC="$ROTATION_TO_BE_IMPORTED/$YEAR_MONTH/$NGINX_ORIGINAL_FILENAME-"
    mkdir -p "$ROTATION_TO_BE_IMPORTED/$YEAR_MONTH"
    for DAY in {1..30}; do
        DAY_PADDED=$(printf "%02d" "$DAY")
        touch "$EMULATED_LOG_LOC"$YEAR$MONTH$DAY_PADDED
    done
    sh "$BASE_DIR/perform/import.sh" $YEAR_MONTH
    
}

@test "Created emulated logs on loop" {
    COMPLETE_PATH="$ROTATION_SUB/$YEAR_MONTH/01/$NGINX_ORIGINAL_FILENAME-$YEAR$MONTH"01
    run [ -f "$COMPLETE_PATH" ]
    [ "$status" -eq 0 ]

    COMPLETE_PATH="$ROTATION_SUB/$YEAR_MONTH/02/$NGINX_ORIGINAL_FILENAME-$YEAR$MONTH"02
    run [ -f "$COMPLETE_PATH" ]
    [ "$status" -eq 0 ]

    COMPLETE_PATH="$ROTATION_SUB/$YEAR_MONTH/07/$NGINX_ORIGINAL_FILENAME-$YEAR$MONTH"07
    run [ -f "$COMPLETE_PATH" ]
    [ "$status" -eq 0 ]

    COMPLETE_PATH="$ROTATION_SUB/$YEAR_MONTH/14/$NGINX_ORIGINAL_FILENAME-$YEAR$MONTH"14
    run [ -f "$COMPLETE_PATH" ]
    [ "$status" -eq 0 ]

    COMPLETE_PATH="$ROTATION_SUB/$YEAR_MONTH/20/$NGINX_ORIGINAL_FILENAME-$YEAR$MONTH"20
    run [ -f "$COMPLETE_PATH" ]
    [ "$status" -eq 0 ]

    COMPLETE_PATH="$ROTATION_SUB/$YEAR_MONTH/30/$NGINX_ORIGINAL_FILENAME-$YEAR$MONTH"30
    run [ -f "$COMPLETE_PATH" ]
    [ "$status" -eq 0 ]
}

@test "Did not create wrong emulated log files" {
    COMPLETE_PATH="$ROTATION_SUB/$YEAR_MONTH/00/$NGINX_ORIGINAL_FILENAME-$YEAR$MONTH"00
    run [ ! -f "$COMPLETE_PATH" ]
    [ "$status" -eq 0 ]

    COMPLETE_PATH="$ROTATION_SUB/$YEAR_MONTH/31/$NGINX_ORIGINAL_FILENAME-$YEAR$MONTH"31
    run [ ! -f "$COMPLETE_PATH" ]
    [ "$status" -eq 0 ]

    COMPLETE_PATH="$ROTATION_SUB/$YEAR_MONTH/40/$NGINX_ORIGINAL_FILENAME-$YEAR$MONTH"40
    run [ ! -f "$COMPLETE_PATH" ]
    [ "$status" -eq 0 ]
}

@test "Create daily Rotation directory" {
    run [ -d "$ROTATION_TEST/$YEAR_MONTH/06" ]
    [ "$status" -eq 0 ]

    run [ -d "$ROTATION_TEST/$YEAR_MONTH/09" ]
    [ "$status" -eq 0 ]

    run [ -d "$ROTATION_TEST/$YEAR_MONTH/11" ]
    [ "$status" -eq 0 ]
}

@test "Create daily Summary directory" {
    run [ -d "$SUMMARY_SUB/$YEAR_MONTH/06" ]
    [ "$status" -eq 0 ]

    run [ -d "$SUMMARY_SUB/$YEAR_MONTH/09" ]
    [ "$status" -eq 0 ]
    
    run [ -d "$SUMMARY_SUB/$YEAR_MONTH/11" ]
    [ "$status" -eq 0 ]
}

@test "Original logs have not been deleted" {
    ORIGINAL_COPIED_FOLDER="$ROTATION_TO_BE_IMPORTED/$YEAR_MONTH"
    run [ -d "$ORIGINAL_COPIED_FOLDER" ]
    [ "$status" -eq 0 ]

    YM="$YEAR$MONTH"
    EMULATED_LOG="$ROTATION_TO_BE_IMPORTED/$YEAR_MONTH/$NGINX_ORIGINAL_FILENAME-$YM"01
    run [ -f "$EMULATED_LOG" ]
    [ "$status" -eq 0 ]

    EMULATED_LOG="$ROTATION_TO_BE_IMPORTED/$YEAR_MONTH/$NGINX_ORIGINAL_FILENAME-$YM"03
    run [ -f "$EMULATED_LOG" ]
    [ "$status" -eq 0 ]

    EMULATED_LOG="$ROTATION_TO_BE_IMPORTED/$YEAR_MONTH/$NGINX_ORIGINAL_FILENAME-$YM"11
    run [ -f "$EMULATED_LOG" ]
    [ "$status" -eq 0 ]

    EMULATED_LOG="$ROTATION_TO_BE_IMPORTED/$YEAR_MONTH/$NGINX_ORIGINAL_FILENAME-$YM"28
    run [ -f "$EMULATED_LOG" ]
    [ "$status" -eq 0 ]
}
