#!/bin/sh
set -eu

cd /home/debrian/Downloads
chmod +x yuno-watch/tests/*.sh
chmod +x yuno-watch/tests/setup/*.bats
chmod +x yuno-watch/tests/installation/*.bats
chmod +x yuno-watch/install.sh

exec sleep infinity
