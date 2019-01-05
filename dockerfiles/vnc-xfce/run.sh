#!/bin/sh

VNCPASSWD=`cat $HOME/vncpasswd.txt`

expect -c "
set timeout 5
spawn env LANG=C vncpasswd
expect \"Password:\"
send \"${VNCPASSWD}\r\"
expect \"Verify:\"
send \"${VNCPASSWD}\r\"
expect eof
exit 0
"

vncserver $DISPLAY -geometry $RESOLUTION
cd
/bin/bash
