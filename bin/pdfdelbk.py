#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Copyright (c) 2021 Antonio Alvarado Hernández

from pikepdf import Pdf
from argparse import ArgumentParser


def remove_bookmarks(output_fn, input_fn):
    pdf = Pdf.open(input_fn)
    with pdf.open_outline() as outline:
        outline.root.clear()
    pdf.save(output_fn)


if __name__ == "__main__":
    parser = ArgumentParser(description="a pdf's bookmarks remover")
    parser.add_argument("-i", "--input-file", required=True,
        help="the input filename")
    parser.add_argument("-o", "--output-file", required=True,
        help="the output filename")
    args = parser.parse_args()
    try:
        remove_bookmarks(args.output_file, args.input_file)
    except Exception as ex:
        print("Oops: ", str(ex))

# EOF