#!/bin/bash
#Usage: flash.sh /dev/ttyUSB0

python nodemcu-firmware/tools/esptool.py --port $1 write_flash 0x00000 nodemcu-firmware/bin/nodemcu_integer_ssl.bin

