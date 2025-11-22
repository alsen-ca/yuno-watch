#!/bin/bash

timestamp() {
    date --iso-8601=seconds
}
log_info() {
    local custom_message="$1"
    printf "[%s] %s: %s\n" "$(timestamp)" "$SCRIPT_NAME" "$custom_message" >> "$SUCCESS_OUTPUT"
}