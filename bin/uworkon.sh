#!/bin/sh
# Copyright (c) 2023, Antonio Alvarado Hernández <tnotstar@gmail.com>

if [ -z "$ALACRITTY_WINDOW_ID" ]; then
    exec alacritty -e "$0"
fi

UWORKONRC=~/.uworkonrc
if [ -r "$UWORKONRC" ]; then
    source "$UWORKONRC"
fi

if [ -z "$UWORKON_SPACES" ]; then
    echo "Oops: nothing to do" && exit 1
fi

UWORKON_SELECTED=$(for WSP in `echo "$UWORKON_SPACES" | tr ':' '\n'`; do
    echo $WSP
done | fzf)

UWORKON_DIR="$HOME/Workspaces/$UWORKON_SELECTED"
if [ -d "$UWORKON_DIR" ]; then
    UWORKON_NAME=$(basename $UWORKON_DIR)
    if [ -z "$TMUX" ]; then
        exec fish -C "cd $UWORKON_DIR" -c "tmux new-session -As $UWORKON_NAME"
    else
        exec alacritty -e fish -C "cd $UWORKON_DIR" -c "tmux new-session -s $UWORKON_NAME" &
    fi
fi
