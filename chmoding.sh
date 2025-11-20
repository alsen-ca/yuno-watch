#!/bin/sh
set -eu

cd /home/debrian/Downloads
chmod +x yuno-watch/install.sh
chmod +x yuno-watch/installation-tests/*.sh
chmod +x yuno-watch/installation-tests/setup/*.bats
chmod +x yuno-watch/installation-tests/installation/*.bats

exec sleep infinity
