#!/bin/bash
# Usage: upload.sh /dev/ttyUSBx 

#python ../../luatool/luatool/luatool.py --port $1 --src luatz_timetable.lua --dest luatz_timetable.lua --verbose 
#python ../../luatool/luatool/luatool.py --port $1 --src credentials.lua --dest credentials.lua --verbose 
python ../../luatool/luatool/luatool.py --port $1 --src main.lua --dest main.lua --verbose 
#python ../../luatool/luatool/luatool.py --port $1 --src init.lua --dest init.lua --verbose 

#python ../../luatool/luatool/luatool.py --port $1 --delete init.lua --verbose
#python ../../luatool/luatool/luatool.py --port $1 --list
