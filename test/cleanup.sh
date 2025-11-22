#!/bin/bash

find "$SUMMARY_TEST" -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} +
find "$ROTATION_TEST" -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} +
find "$ROTATION_TEST_TO_BE_IMPORTED" -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} +

echo "All data cleaned up"
