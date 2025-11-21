#!/bin/bash
set -euo pipefail

echo "All arguments: $@"
YEAR_MONTH="$1"
shift # Move past first argument

echo "Value of username is: $NAME"
echo "Year-month = $YEAR_MONTH"
pwd
sh lib/new_month_folder.sh $YEAR_MONTH
