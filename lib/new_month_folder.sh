#!/bin/bash
# Recieves a month in the Argument and creates the Rotation and Summary folders based on it.

set -euo pipefail
umask 077


YEAR_MONTH="$1"
ARCHIVED_LOGS="$ROTATION_SUB/$YEAR_MONTH"
SUMMARIZED_LOGS="$SUMMARY_SUB/$YEAR_MONTH"

mkdir -p $ARCHIVED_LOGS $SUMMARIZED_LOGS
