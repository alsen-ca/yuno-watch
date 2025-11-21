#!/bin/bash
set -euo pipefail

YEAR_MONTH="$1"
shift

sh lib/new_month_folder.sh $YEAR_MONTH
