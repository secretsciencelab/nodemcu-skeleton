#!/bin/bash

git clone https://github.com/nodemcu/nodemcu-firmware.git
git clone https://github.com/4refr0nt/luatool.git
cd nodemcu-firmware
../build.sh # builds nodemcu firmware with docker container
