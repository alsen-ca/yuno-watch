#!/bin/bash
set -e

sudo /home/debrian/Downloads/bats-core/install.sh /usr/local
sh /home/debrian/Downloads/yuno-watch/installation-tests/setup_tests.sh
sh /home/debrian/Downloads/yuno-watch/install.sh
sh /home/debrian/Downloads/yuno-watch/installation-tests/install_tests.sh