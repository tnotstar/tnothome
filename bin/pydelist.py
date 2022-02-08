#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Copyright 2019-2022, Antonio Alvarado Hernández
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

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
    parser.add_argument("-i", "--input-file", required=True,
        help="a `jdupes`' json result file with the entries to be deleted")
    args = parser.parse_args()
    try:
        delete_files_from(args.input_file)
    except OSError as ex:
        print("Oops: " + str(ex))


if __name__ == "__main__":
    main()

# EOF