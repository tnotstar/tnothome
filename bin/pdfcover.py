#!/usr/bin/env python3
# /// script
# requires-python = ">=3.13"
# dependencies = [
#     "pdfrw",
#     "wand",
# ]
# ///

# Copyright 2023 - 2026, Antonio Alvarado <tnotstar+@gmail.com>
# -*- coding: utf-8 -*-

from collections.abc import Iterable
from pathlib import Path
from tempfile import mkstemp
from argparse import ArgumentParser

from pdfrw import PdfReader, PdfWriter
from wand.image import Image

import os
import math
from urllib.parse import urlparse
from urllib.request import urlopen


DEFAULT_IMAGE_FORMAT = r"pdf"
DEFAULT_QUALITY_PERCENT = 100
DEFAULT_DENSITY_POINTS = 96

INCHES_PER_POINT = 1./72.


def open_cover_image(image_arg: str) -> str:
    """Open a file or a remote stream to be used as the cover image."""
    
    image_url = urlparse(image_arg)
    if image_url.scheme in ("", "file"):
        image_fname = image_url.path if image_url.scheme == "file" else image_arg
        if not os.path.isfile(image_fname):
            raise FileNotFoundError(f"Image file not found: {image_fname}")
        return Image(filename=image_fname)
    else:
        with urlopen(image_arg) as response:
            image_blob = response.read()
            return Image(blob=image_blob)
    

def add_cover_page(output_arg, image_arg, input_arg: str, skip_firstpage: bool) -> None:
    """Add a cover page to given PDF file."""

    # create a temporary file to store the cover page
    cover_fd, cover_fname = mkstemp(suffix=".pdf")
    os.close(cover_fd)

    # retrieve the image dimensions
    pdf_reader = PdfReader(input_arg)
    start_at = 1 if skip_firstpage else 0
    width, height = get_most_frequent_dimensions(pdf_reader, start_at)

    # resize the image to fit the page
    with open_cover_image(image_arg) as cover:
        cover.format = DEFAULT_IMAGE_FORMAT
        cover.compression_quality = DEFAULT_QUALITY_PERCENT
        cover.resolution = DEFAULT_DENSITY_POINTS
        adj_width = math.ceil(DEFAULT_DENSITY_POINTS * INCHES_PER_POINT * width)
        adj_height = math.ceil(DEFAULT_DENSITY_POINTS * INCHES_PER_POINT * height)
        resize_geometry=f"{adj_width}!x{adj_height}!"
        cover.transform(resize=resize_geometry)
        cover.save(filename=str(cover_fname))

    # merge the cover page with the original PDF file
    pdf_writer = PdfWriter(output_arg, trailer=pdf_reader)
    pdf_writer.addpages(PdfReader(cover_fname).pages)
    pdf_writer.addpages(pdf_reader.pages[start_at:])
    pdf_writer.write()

    # remove the temporary cover page file
    os.remove(cover_fname)


def get_most_frequent_dimensions(pdf_reader: PdfReader, start_at: int) -> tuple:
    """Return the most frequent dimensions tuple in given PDFReader instance."""

    dimensions = {}
    for _, page in enumerate(pdf_reader.pages[start_at:]):
        if page.MediaBox:
            box = [ float(v) for v in page.MediaBox ]
        elif page.CropBox:
            box = [ float(v) for v in page.CropBox ]
        else:
            raise ValueError(f"Can't locate a valid crop or media box for page: {_}")

        key = (box[2] - box[0], box[3] - box[1])
        dimensions[key] = dimensions.get(key, 0) + 1

    return max(dimensions, key=lambda x: dimensions[x])


def main():
    """This is the program entry-point"""

    parser = ArgumentParser(description="add a cover image to give PDF file")
    parser.add_argument("-F", "--skip-firstpage", action="store_true", default=False,
        help="skip first page from the input file")
    parser.add_argument("-o", "--output-filename", required=True,
        help="the output pdf file name")
    parser.add_argument("-i", "--image-filename", required=True,
        help="the cover image file name")
    parser.add_argument("-p", "--input-filename", required=True,
        help="the input pdf file name")
    args = parser.parse_args()

    try:
        add_cover_page(
            args.output_filename, args.image_filename, args.input_filename, args.skip_firstpage,
        )

    except Exception as ex:
        print("Oops: " + str(ex))


if __name__ == "__main__":
    main()

# EOF
