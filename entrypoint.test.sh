#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo $SCRIPT_DIR/Downloads/bats-core/install.sh /usr/local
sh $SCRIPT_DIR/Downloads/yuno-watch/installation-tests/setup_tests.sh
sh $SCRIPT_DIR/Downloads/yuno-watch/install.sh
sh $SCRIPT_DIR/Downloads/yuno-watch/installation-tests/install_tests.sh
yuno test activate
yuno test all-tests
