#!/bin/sh
set -eu

cd /home/debrian/Downloads
chmod +x yuno-watch/tests/*.sh
chmod +x yuno-watch/tests/setup/*.bats
cd bats-core
sudo ./install.sh /usr/local
cd ../yuno-watch

sh install.sh
exec sleep infinity
