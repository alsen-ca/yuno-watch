#!/bin/bash
set -euo pipefail

# Expect DATE to be YY-mm, like 2025-11
YEAR_MONTH="$1"
sh $LIB_DIR/new_month_folder.sh $YEAR_MONTH

DIRECTORY_TO_IMPORT="$ROTATION_TO_BE_IMPORTED/$YEAR_MONTH"

# Read all files in directory DIRECTORY_TO_IMPORT
# Each file is named like access.log-20251120
shopt -s nullglob
files=("$DIRECTORY_TO_IMPORT/access.log-*")
# for file in files: # equivalently loop for sh
# Take the Date of each file, meaning that access.log-20251120 would be DATE="20251120"
for file in $DIRECTORY_TO_IMPORT/$NGINX_ORIGINAL_FILENAME-*; do
    DATE="${file##*-}"
    YEAR="${DATE:0:4}"
    MONTH="${DATE:4:2}"
    DAY="${DATE:6:2}"

    sh "$LIB_DIR/nginx_importer.sh" $YEAR $MONTH $DAY
done
