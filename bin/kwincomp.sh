#!/bin/sh
# Copyright 2023, Antonio Alvarado Hernández
#
# Based upon: https://unix.stackexchange.com/questions/597736
#

if [ "$1" = "on" ]; then
    qdbus org.kde.KWin /Compositor resume
elif [ "$1" = "off" ]; then
    qdbus org.kde.KWin /Compositor suspend
else
    echo -e "Oops: invalid command line argument(s)\n"
    echo -e "Syntax: $(basename $0) on|off"
    echo -e " where: on   resume Kwin compositor"
    echo -e "        off  suspend the Kwin compositor\n"
    exit 1
fi

