#!/bin/bash
# Make a summary for a file. This scripts centrally decides which python scripts will be called

set -euo pipefail
umask 077
source $LIB_DIR/global-functions.sh

YEAR="$1"
MONTH="$2"
DAY="$3"
YMD=$YEAR$MONTH$DAY
YEAR_MONTH="$YEAR-$MONTH"
FULL_ROT_PATH="$ROTATION_SUB/$YEAR_MONTH/$DAY"
FULL_SUM_PATH="$SUMMARY_SUB/$YEAR_MONTH/$DAY"

INPUT_FILE="$FULL_ROT_PATH/$NGINX_ORIGINAL_FILENAME-$YMD"


$LIB_DIR/summary/entry_summary.py $INPUT_FILE $FULL_SUM_PATH
