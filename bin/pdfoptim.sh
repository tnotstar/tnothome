#!/bin/sh

# Copyright 2023, Antonio Alvarado Hernández <tnotstar@gmail.com>

error() {
    if [ $# -lt 2 ]; then
        echo "Oops: error handler called with bad arguments"
        exit -1
    fi

    ECODE=$1 && shift
    MSGTXT=$*

    if [ $ECODE -eq 0 ]; then
        printf "INFO: %s" "$MSGTXT" 1>&2 && exit 0
    fi

    printf "ERROR-%03x: %s" "$ECODE" "$MSGTXT" 1>&2 && exit $ECODE
}

if [ $# -lt 1 ]; then
    error 1 "invalid number of arguments"
fi

OUTPUTFN=$1 && shift

INPUTFN="$OUTPUTFN"
TEMPFN=$(mktemp -t "`basename $0 .sh`.XXXXXXXX")

if command -v pdftk 1> /dev/null; then
    pdftk "$INPUTFN" cat output "$TEMPFN" ||
       error 2 "pdftk processing failed with error $?"
fi

INPUTFN="$TEMPFN"
TEMPFN=$(mktemp -t "`basename $0 .sh`.XXXXXXXX")

if command -v qpdf 1> /dev/null; then
    qpdf \
        --decrypt \
        --remove-restrictions \
        --linearize \
        --stream-data=compress \
        --recompress-flate \
        --compression-level=9 \
        --object-streams=generate \
        --no-original-object-ids \
        --coalesce-contents \
        "$INPUTFN" "$TEMPFN" ||
            error 3 "qpdf processing failed with error $?"
fi

mv "$TEMPFN" "$OUTPUTFN" ||
    error 4 "failed to move file \"$TEMPFN\" to \"$OUTPUTFN\""

chmod 0444 "$OUTPUTFN" ||
    error 5 "can't fix permissions up for file: $OUTPUTFN"

# EOF
