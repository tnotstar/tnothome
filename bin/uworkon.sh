#!/bin/sh
# Copyright (c) 2023, Antonio Alvarado Hernández <tnotstar@gmail.com>

UWORKONRC=~/.uworkonrc
if [ -r "$UWORKONRC" ]; then
    source "$UWORKONRC"
fi

if [ -z "$UWORKON_TERM" ]; then
    echo "Oops: unknown terminal program" && exit 1
fi

case "$UWORKON_TERM" in
    kitty)
        CURRENT_TERM_ID=$KITTY_PID
        ;;
    alacritty)
        CURRENT_TERM_ID=$ALACRITTY_WINDOW_ID
        ;;
    *)
        echo "Oops: invalid terminal program" && exit 2
        ;;
esac

if [ -z "$CURRENT_TERM_ID" ]; then
    exec $UWORKON_TERM -e "$0"
fi

if [ -z "$UWORKON_SPACES" ]; then
    echo "Oops: nothing to do" && exit 3
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
        exec $UWORKON_TERM -e fish -C "cd $UWORKON_DIR" -c "tmux new-session -s $UWORKON_NAME" &
    fi
fi
