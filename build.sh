#!/bin/bash

# run this script from within nodemcu-firmware
docker run --rm -ti -e "INTEGER_ONLY=1" -e "IMAGE_NAME=ssl" -v `pwd`:/opt/nodemcu-firmware marcelstoer/nodemcu-build
