#!/bin/bash
# new_month_folder.sh
# -------------------
# Create month‑specific directories for archived Nginx logs and
# for derived summary data.  Write a concise entry to the script’s own
# log file and (on the future) push a notification via ntfy.io on failure.
#
# Version: 1.1  (2025-11-14)

set -euo pipefail
umask 077 # directories become 700, files 600


DATE="$(date)"
YEAR_MONTH="$(date +%Y-%m)"
SCRIPT_NAME="new_month_folder"
LOG_OUTPUT="/var/log/alautentico_static/$SCRIPT_NAME.log"

timestamp() {
    # ISO-8601 timestamp, e.g. 2025-11-11T14:32:05+01:00
    date --iso-8601=seconds
}

log_success() {
    printf "[%s] %s succeeded - created:\n  %s\n  %s\n\n" \
        "$(timestamp)" "$SCRIPT_NAME" "$ARCHIEVED_LOGS" "$SUMMARIZED_LOGS" >> "$LOG_OUTPUT"
    echo "$DATE $SCRIPT_NAME finished successfully"
}

log_failure() {
    local rc=$1
    printf "[%s] %s FAILED (exit code %s)\n  Last command: %s\n\n" \
        "$(timestamp)" "$SCRIPT_NAME" "$rc" "$BASH_COMMAND" >> "$LOG_OUTPUT"
    # On the future, send alert to ntfy
    echo "$DATE $SCRIPT_NAME failed. Please view $LOG_OUTPUT for more details"
}

trap 'rc=$?; if (( rc != 0 )); then log_failure "$rc"; fi' EXIT


mkdir -p $ARCHIEVED_LOGS $SUMMARIZED_LOGS

log_success
