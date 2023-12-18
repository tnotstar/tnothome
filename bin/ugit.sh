#!/bin/sh
# Copyright (c) 2023, Antonio Alvarado Hernández <tnotstar@gmail.com>

UGIT_PROGRAM=$0

if [ $# -gt 0 ]; then
    UGIT_SUBCMD=$1 && shift
else
    UGIT_SUBCMD=usage
fi

echo "\$UGIT_PROGRAM:$UGIT_PROGRAM, \$UGIT_SUBCMD:$UGIT_SUBCMD..."

function error {
    echo "Error goes here!"
}

function usage {
    echo "Usage goes here!"
}

function git_status {
    echo "Git status goes here!"
}

function git_log {
    git log --graph --oneline --decorate --date-order --color --boundary @{u}.. --reflog
}

function git_rbranch {
    git branch --all
}


case "$UGIT_SUBCMD" in
    (usage)
        usage
        break
        ;;
    (log)
        git_log
        break
        ;;
    (status)
        git_status
        break
        ;;
    (rbranch)
        git_rbranch
        break
        ;;
    (*)
        error 1 "Unknown sub-command $UGIT_SUBCMD"
        usage
        break
        ;;
esac

