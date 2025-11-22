#!/bin/bash
set -euo pipefail

# Expect DATE to be YY-mm-dd, like 2025-11-21
DATE="$1"
YEAR="${DATE%%-*}" # 2025
MONTH="${DATE#*-}" # 11-21
MONTH="${MONTH%%-*}" # 11
DAY="${DATE##*-}" # 21

sh "$LIB_DIR/nginx_rotator.sh" $YEAR $MONTH $DAY
