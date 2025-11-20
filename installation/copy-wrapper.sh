#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
sudo cp "$SCRIPT_DIR/../cli-wrapper.sh" /usr/local/bin/yuno

sudo chmod 755 /usr/local/bin/yuno
