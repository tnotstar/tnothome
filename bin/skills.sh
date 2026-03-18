#!/bin/sh

# Copyright 2026, Antonio Alvarado <tnotstar+copyright@gmail.com>

# check if `deno` is installed
if ! command -v deno &> /dev/null; then
    echo "Error: Deno is missing. Set it up at https://docs.deno.com/runtime/getting_started/installation"
    exit 1
fi

# Execute the skills.sh package using Deno's npm registry
# -A grants necessary permissions to write to .antigravity or .cursor
exec deno run -A npm:skills "$@"
