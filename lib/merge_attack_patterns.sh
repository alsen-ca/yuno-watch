#!/bin/bash
# sum_attack_patterns.sh
# ----------------------
# Merge all attacks.log files into a single attack_patterns.log containing only unique lines.
#
# Version: 1.0  (2025‑11‑15)

SRC_NAME="attacks.log"
TARGET="${BASE}/attack_patterns.log"

TMP=$(mktemp) || exit 1

find "$BASE" -type f -name "$SRC_NAME" -exec cat {} + | \
    grep -v '^$' >> "$TMP"

[ -f "$TARGET" ] && cat "$TARGET" >> "$TMP"

sort "$TMP" | uniq > "${TARGET}.new"
mv "${TARGET}.new" "$TARGET"

rm -f "$TMP"
echo "Done.. Unique patterns stored in $TARGET"