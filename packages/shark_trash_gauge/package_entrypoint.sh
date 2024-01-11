#!/bin/bash
set -e

# setup ros2 environment
source "/ran/install/setup.bash" --
exec "$@"
