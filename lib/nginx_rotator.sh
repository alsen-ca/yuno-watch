#!/bin/bash
# Move nginx's original logs and move them to the folder used by this package.
#
# Note that for nginx, the logs from yesterday are named with the date of today.
# Meaning that for logs of the day 2025-11-20 it would be called access.log-20251121

set -euo pipefail
umask 077
source $LIB_DIR/global-functions.sh

YEAR="$1"
MONTH="$2"
DAY="$3"
YEAR_MONTH="$YEAR-$MONTH"
FULL_ROT_PATH="$ROTATION_SUB/$YEAR_MONTH/$DAY"
FULL_SUM_PATH="$SUMMARY_SUB/$YEAR_MONTH/$DAY"

shopt -s nullglob
files=("$NGINX_LOGS"/*.log-"$YEAR$MONTH$DAY")
log_info "files to move: %s\n" "${files[@]}"

if (( ${#files[@]} )); then
    mkdir -p $FULL_ROT_PATH $FULL_SUM_PATH
    chown $NAME:$NAME $FULL_ROT_PATH $FULL_SUM_PATH
    mv "${files[@]}" $FULL_ROT_PATH/
    chown $NAME:$NAME $FULL_ROT_PATH/*
else
    log_info "Nothing to move"
fi
