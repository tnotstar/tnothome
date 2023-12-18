#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Copyright 2023, Antonio Alvarado Hernández <tnotstar@gmail.com>

from pdf2image.pdf2image import convert_from_path

from argparse import ArgumentParser

import sys


VERSION = "0.1.0"


def main(args):
    images = convert_from_path(args.input_filename, dpi=300)
    for image in images:
        image.save(args.output_filename)


if __name__ == "__main__":
    parser = ArgumentParser(description="Extract text from UNED's exam files")
    parser.add_argument("-V", "--version", action="version", version=f"%(prog)s {VERSION}")
    parser.add_argument("-i", "--input-filename", help="input file", required=True)
    parser.add_argument("-o", "--output-filename", help="output file", required=True)
    args = parser.parse_args()

    try:
        main(args)

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

