#!/bin/sh

sh "$TESTS/correct-installation.sh"
sh "$TESTS/all-perform.sh"

sh "$TESTS/cleanup.sh"
