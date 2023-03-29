#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Copyright 2019-2023, Antonio Alvarado Hernández <tnotstar@gmail.com>

from argparse import ArgumentParser

import json
import os
import os.path


def parse_jdupes_file(input_file):
    raw = json.load(open(input_file, encoding="utf-8"))
    matches = [ _['fileList'] for _ in raw['matchSets'] ]
    return [ _['filePath'] for l in matches for _ in l ]


def delete_files_from(input_file):
    for entry in parse_jdupes_file(input_file):
        if not entry:
            continue
        fname = os.path.abspath(os.path.expanduser(entry))
        if not os.path.exists(fname):
            continue
        print("Removing: " + fname)
        os.remove(fname)


def main():
    parser = ArgumentParser(description="a list-based batch delete utility")
    parser.add_argument("-i", "--input-list", required=True,
        help="a `jdupes`' json result file with the entries to be deleted")
    parser.add_argument("-D", "--delete-list", action='store_true', default=False,
        help="check if you want to delete the input file after clean-up")
    args = parser.parse_args()
    try:
        delete_files_from(args.input_list)
        if args.delete_list:
            os.remove(args.input_list)
    except OSError as ex:
        print("Oops: " + str(ex))


if __name__ == "__main__":
    main()

# EOF
