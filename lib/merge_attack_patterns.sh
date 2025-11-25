#!/bin/bash
# Merge all attacks.log and 4xx.log files into a single attack_patterns.log containing only unique lines.

SRC_NAME="attacks.log"
SRC_NAME2="4xx.log"
TARGET="${SUMMARY_SUB}/attack_patterns.log"

TMP=$(mktemp) || exit 1

find "$SUMMARY_SUB" -type f \( -name "$SRC_NAME" -o -name "$SRC_NAME2" \) -exec cat {} + | \
    grep -v '^$' >> "$TMP"

[ -f "$TARGET" ] && cat "$TARGET" >> "$TMP"

sort "$TMP" | uniq > "${TARGET}.new"
mv "${TARGET}.new" "$TARGET"

rm -f "$TMP"
echo "Done.. Unique patterns stored in $TARGET"
