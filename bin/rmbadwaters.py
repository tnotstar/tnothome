#!/usr/bin/env python3
# Copyright 2023, Antonio Alvarado Hernández <tnotstar@gmail.com>
# -*- coding: utf-8 -*-

from pathlib import Path
from argparse import ArgumentParser

from pikepdf import open as openpdf

def remove_wattermarks(output_filename: str, input_filename: str) -> None:
    output_path = Path(output_filename).expanduser().absolute()
    input_path = Path(input_filename).expanduser().absolute()
    with openpdf(input_path) as pdf:
        num_pages = len(pdf.pages)
        print(num_pages)
    print(input_path)


if __name__ == "__main__":
    description = "remove bad wattermarks from given pdf file"
    parser = ArgumentParser(description=description)
    parser.add_argument("-i", "--input-filename", type=str, required=True,
        help="is the path of the input pdf file")
    parser.add_argument("-o", "--output-filename", type=str, required=True,
        help="is the path of the output pdf file")

    try:
        args = parser.parse_args()
        remove_wattermarks(args.output_filename, args.input_filename)
    except RuntimeError as ex:
        print(f"Oops: {str(ex)}. Aborting.")
