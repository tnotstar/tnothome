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

import sys


def fix_qdf_file(output, input):
    for line in input:
        output.write(line)


if __name__ == "__main__":
    descript = "repair PDF files in QDF form after editing (python version)"
    parser = ArgumentParser(description=descript)
    parser.add_argument("-o", "--output", help="path of the output file")
    parser.add_argument("-i", "--input", help="path of the input file")
    args = parser.parse_args()

    with args.input and open(args.input, "rb") or sys.stdin as input:
        with args.output and open(args.output, "wb") or sys.stdout as output:
            fix_qdf_file(output, input)

# EOF