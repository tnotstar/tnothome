#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from html import unescape
from argparse import ArgumentParser

import re


START_OF_HEADER = re.compile(r'^WEBVTT$')
PART_OF_HEADER = re.compile(r'^([\w]+)\s*:\s*(.+?)$')
START_OF_CHUNK = re.compile(r'^[\d]+:[\d]+:[\d.]+ --> [\d]+:[\d]+:[\d.]+$')

def convert_text_from_vtt(output_filename, input_filename):

    def parse_header(input):
        header = {}
        while line := input.readline().strip():
            if match := PART_OF_HEADER.search(line):
                groups = match.groups()
                if len(groups) > 1:
                    header[groups[0]] = groups[1]
        return header

    def parse_chunks(input):
        chunks = []
        while line := input.readline().strip():
            chunks.append(unescape(line))
        return chunks

    with open(input_filename, encoding='utf-8') as input:
        with open(output_filename, 'w', encoding='utf-8') as output:
            while line := input.readline().strip():
                if START_OF_HEADER.search(line):
                    header = parse_header(input)
                elif START_OF_CHUNK.search(line):
                    for chunk in parse_chunks(input):
                        output.write(chunk)
                else:
                    raise ValueError("Invalid file format")


if __name__ == "__main__":
    parser = ArgumentParser(description="convert .vtt to .txt file format")
    parser.add_argument("-i", "--input-filename", required=True,
        help="the filename of the input file")
    parser.add_argument("-o", "--output-filename", required=True,
        help="the filename of the output file")
    args = parser.parse_args()
    convert_text_from_vtt(args.output_filename, args.input_filename)

# EOF