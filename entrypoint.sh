#!/bin/bash
set -eu

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR
chmod +x $SCRIPT_DIR/Downloads/yuno-watch/install.sh
chmod +x $SCRIPT_DIR/Downloads/yuno-watch/installation-tests/*.sh
chmod +x $SCRIPT_DIR/Downloads/yuno-watch/installation-tests/setup/*.bats
chmod +x $SCRIPT_DIR/Downloads/yuno-watch/installation-tests/installation/*.bats

exec sleep infinity
