#!/bin/sh

export RETEXT_HOME="$HOME/.virtualenv/ReText"

if [ ! -d "$RETEXT_HOME" ]; then
    echo "Oops: where is retext's virtual environment?"
    exit 1
fi

source "$RETEXT_HOME/bin/activate"
exec "$RETEXT_HOME/bin/retext"

# EOF
