#!/bin/bash

bash "$TESTS/correct-installation.sh"
bash "$TESTS/all-perform.sh"

sh "$TESTS/cleanup.sh"
