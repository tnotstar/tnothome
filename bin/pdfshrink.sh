#!/bin/sh
# Copyright (c) 2023, Antonio Alvarado Hernández <tnotstar@gmail.com>

usage() {
    echo "Usage: `basename $0` <input-file> <output-file>" 2>&1
    echo "" 2>&1
}

if [ $# -lt 2 ]; then
    usage
    echo "Oops: invalid arguments" 2>&1
    exit 1
fi

INPUTFILE=$1
OUTPUTFILE=$2

echo "Compressing \"$INPUTFILE\", into \"$OUTPUTFILE\"..."
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$OUTPUTFILE" "$INPUTFILE"
