#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

bats $SCRIPT_DIR/setup/os_user_test.bats
bats $SCRIPT_DIR/setup/os_downloads_test.bats