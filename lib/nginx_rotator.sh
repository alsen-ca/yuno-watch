#!/bin/bash
# nginx_rotator.sh
# -------------------
# Move nginx's access.log and error.log from the day before and move them to archive path
# Version: 1.0  (2025‑11‑14)

set -euo pipefail
umask 077 # directories become 700, files 600

source /etc/yuno-watch/yuno-watch.conf

DATE="$(date)"
YEAR_MONTH="$(date +%Y-%m)"
TODAY="$(date +%Y%m%d)"
YESTERDAY_DAY_ONLY="$(date --date="-1 day" +%d)"
SCRIPT_NAME="nginx_rotator"
ORIGINAL_LOGS="/var/log/nginx"
LOG_OUTPUT="/var/log/alautentico_static/$SCRIPT_NAME.log"

timestamp() {
    # ISO-8601 timestamp, e.g. 2025-11-11T14:32:05+01:00
    date --iso-8601=seconds
}

log_success() {
    printf "[%s] %s succeeded - moved from:  %s to %s\n\n" \
        "$(timestamp)" "$SCRIPT_NAME" "$ORIGINAL_LOGS" "$ARCHIVED_FOLDER" >> "$LOG_OUTPUT"
    echo "$DATE $SCRIPT_NAME.sh finished successfully"
}

log_failure() {
    local rc=$1
    printf "[%s] %s FAILED (exit code %s)\n  Last command: %s\n\n" \
        "$(timestamp)" "$SCRIPT_NAME" "$rc" "$BASH_COMMAND" >> "$LOG_OUTPUT"
    # On the future, send alert to ntfy
    echo "$DATE $SCRIPT_NAME.sh failed. Please view $LOG_OUTPUT for more details"
}

log_nothing() {
    printf '[%s] %s: no matching log file for %s\n' \
        "$(timestamp)" "$SCRIPT_NAME" "$TODAY" >>"$LOG_OUTPUT"
    echo "$DATE $SCRIPT_NAME.sh finished - nothing to move"
}

trap 'rc=$?; if (( rc != 0 )); then log_failure "$rc"; fi' EXIT


shopt -s nullglob
files=("$ORIGINAL_LOGS"/dev.*.log-"$TODAY")

mkdir -p "$ARCHIVED_FOLDER/$YESTERDAY_DAY_ONLY"
mkdir -p "$SUMMARIZED_LOGS/$YESTERDAY_DAY_ONLY"
chown $NAME:$NAME "$ARCHIVED_FOLDER/$YESTERDAY_DAY_ONLY"
chown $NAME:$NAME "$SUMMARIZED_LOGS/$YESTERDAY_DAY_ONLY"

if (( ${#files[@]} )); then
    mv "${files[@]}" "$ARCHIVED_FOLDER/$YESTERDAY_DAY_ONLY"/
    chmod 600 "$ARCHIVED_FOLDER/$YESTERDAY_DAY_ONLY"/*
    chown $NAME:$NAME "$ARCHIVED_FOLDER/$YESTERDAY_DAY_ONLY"/*
    log_success
else
    log_nothing
fi
