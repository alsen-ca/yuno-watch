#!/bin/bash
# install.sh
# -------------------
# Prepares yuno-watch to be used by the system.
# 
#   1. Creates user
#   2. Creates folders:
#       - /var/log
#       - /var/archive
#       - /var/cache

set -euo pipefail

sh /home/debrian/Downloads/yuno-watch/installation/create_user.sh
sh /home/debrian/Downloads/yuno-watch/installation/create_root_folders.sh
