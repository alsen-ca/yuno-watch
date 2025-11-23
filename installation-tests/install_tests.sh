#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

bats $SCRIPT_DIR/installation/user_test.bats
bats $SCRIPT_DIR/installation/folders_test.bats
bats $SCRIPT_DIR/installation/src_paths_test.bats
bats $SCRIPT_DIR/installation/wrapper_test.bats