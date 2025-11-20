#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
sh $SCRIPT_DIR/installation/create_user.sh
sh $SCRIPT_DIR/installation/create_root_folders.sh
sh $SCRIPT_DIR/installation/copy-pack.sh
sh $SCRIPT_DIR/installation/copy-wrapper.sh