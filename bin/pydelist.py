#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Copyright (c) 2019 Antonio Alvarado Hernández - All rights reserved
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

import os
import os.path


def delete_files_from(input_file):
    for entry in open(input_file, encoding="utf-8"):
        entry = entry.strip()
        if not entry:
            continue
        fname = os.path.abspath(os.path.expanduser(entry))
        if os.path.exists(fname):
            print("Removing: " + fname)
            os.remove(fname)


def main():
    parser = ArgumentParser(description="a list-based batch delete utility")
    parser.add_argument("-i", "--input-file", required=True,
        help="an input file with the list of files to be deleted")
    args = parser.parse_args()
    try:
        delete_files_from(args.input_file)
    except OSError as ex:
        print("Oops: " + str(ex))


if __name__ == "__main__":
    main()

# EOF