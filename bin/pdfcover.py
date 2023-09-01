#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Copyright 2023, Antonio Alvarado Hernández <tnotstar@gmail.com>

from argparse import ArgumentParser
from pathlib import Path
from tempfile import mkstemp

from pdfrw import PdfReader, PdfWriter
from wand.image import Image

import os
import math


def add_cover_page(output_path: Path, image_path: Path, pdf_path: Path) -> None:
    """Add a cover page to given PDF file."""

    # create a temporary file to store the cover page
    cover_fd, cover_fname = mkstemp(suffix=".pdf")
    os.close(cover_fd)

    # retrieve the image dimensions
    pdf_reader = PdfReader(pdf_path)
    width, height = get_most_frequent_dimensions(pdf_reader)

    # resize the image to fit the page
    with Image(filename=str(image_path)) as cover:
        cover.compression_quality = 100
        cover.resolution = 96
        cover.format = "pdf"
        cover.resize(width, height)
        cover.save(filename=str(cover_fname))

    # merge the cover page with the original PDF file
    pdf_writer = PdfWriter(output_path, trailer=pdf_reader)
    pdf_writer.addpages(PdfReader(cover_fname).pages)
    pdf_writer.addpages(pdf_reader.pages)
    pdf_writer.write()

    # remove the temporary cover page file
    os.remove(cover_fname)


def get_most_frequent_dimensions(pdf_reader: PdfReader) -> tuple:
    """Return the most frequent dimensions tuple in given PDFReader instance."""
    dimensions = {}
    pages = pdf_reader.pages
    for pno, page in enumerate(pages, start=1):
        mediabox = [ math.floor(float(v)) for v in page.MediaBox ]
        key = (mediabox[2] - mediabox[0], mediabox[3] - mediabox[1])

        if key in dimensions:
            dimensions[key] += 1
        else:
            dimensions[key] = 1
    return max(dimensions, key=lambda x: dimensions[x])


def main():
    parser = ArgumentParser(description="add a cover image to give PDF file")
    parser.add_argument("-o", "--output-filename", required=True,
        help="the output file name")
    parser.add_argument("-i", "--image-filename", required=True,
        help="the cover image file name")
    parser.add_argument("-p", "--pdf-filename", required=True,
        help="the PDF file name")
    args = parser.parse_args()

    try:
        output_path = Path(args.output_filename)
        image_path = Path(args.image_filename)
        pdf_path = Path(args.pdf_filename)
        add_cover_page(output_path, image_path, pdf_path)
    except Exception as ex:
        print("Oops: " + str(ex))


if __name__ == "__main__":
    main()

# EOF