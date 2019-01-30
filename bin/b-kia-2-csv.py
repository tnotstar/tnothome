#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Copyright (c) 2017-2019 Antonio Alvarado Hernández - All rights reserved
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

import html.parser as html_parser

import re
import sys
import csv
import glob
import html.parser as html_parser


ST_READY    = 0
ST_IN_HTML  = 1
ST_IN_BODY  = 2
ST_IN_TABLE = 3
ST_IN_THEAD = 4
ST_IN_THTR  = 5
ST_IN_TRTH  = 6
ST_IN_TBODY = 7
ST_IN_TBTR  = 8
ST_IN_TRTD  = 9
ST_ENDED    = -1

NS_HTML = r"http://www.w3.org/TR/REC-html40"
NS_EXCEL = r"urn:schemas-microsoft-com:office:excel"
NS_OFFICE = r"urn:schemas-microsoft-com:office:office"

EXCEL_ES = csv.excel
EXCEL_ES.delimiter = ";"


class HTMLStatementParser(html_parser.HTMLParser):
    """Parse a statement exported as an Excel XML Export file."""

    def __init__(self, writer):
        super().__init__()
        self._writer = writer
        self._state = ST_READY
        self._in_title = True
        self._in_header = True
        self._row = None
        self._title = None
        self._header = None

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if self._state == ST_READY and tag == "html":
            namespaces = attrs.values()
            if all([NS_HTML in namespaces, NS_EXCEL in namespaces,
                    NS_OFFICE in namespaces]):
                self._state = ST_IN_HTML
        elif self._state == ST_IN_HTML and tag == "body":
            self._state = ST_IN_BODY
        elif self._state == ST_IN_BODY and tag == "table":
            self._state = ST_IN_TABLE
        elif self._state == ST_IN_TABLE and tag == "thead":
            self._state = ST_IN_THEAD
        elif self._state == ST_IN_THEAD and tag == "tr":
            self._row = list()
            self._state = ST_IN_THTR
        elif self._state == ST_IN_THTR and tag == "th":
            self._state = ST_IN_TRTH
        elif self._state == ST_IN_TABLE and tag == "tbody":
            self._state = ST_IN_TBODY
        elif self._state == ST_IN_TBODY and tag == "tr":
            self._row = list()
            self._state = ST_IN_TBTR
        elif self._state == ST_IN_TBTR and tag == "td":
            self._state = ST_IN_TRTD

    def handle_data(self, data):
        if self._state == ST_IN_TRTH:
            self._row.append(data)
        elif self._state == ST_IN_TRTD:
            self._row.append(data)

    def handle_endtag(self, tag):
        if self._state == ST_IN_TRTD and tag == "td":
            self._state = ST_IN_TBTR
        elif self._state == ST_IN_TBTR and tag == "tr":
            if self._row:
                self._writer.writerow(self._row)
                if self._in_header:
                    self._header = self._row[:]
                    self._in_header = False
            self._state = ST_IN_TBODY
        elif self._state == ST_IN_TBODY and tag == "tbody":
            self._state = ST_IN_TABLE
        elif self._state == ST_IN_TRTH and tag == "th":
            self._state = ST_IN_THTR
        elif self._state == ST_IN_THTR and tag == "tr":
            if self._row:
                self._writer.writerow(self._row)
                if self._in_title:
                    self._title = self._row[:]
            self._state = ST_IN_THEAD
        elif self._state == ST_IN_THEAD and tag == "thead":
            self._in_title = False
            self._state = ST_IN_TABLE
        elif self._state == ST_IN_TABLE and tag == "table":
            self._state = ST_IN_BODY
        elif self._state == ST_IN_BODY and tag == "body":
            self._state = ST_IN_HTML
        elif self._state == ST_IN_HTML and tag == "html":
            self._state = ST_ENDED


def create_output_datasheet(outfile, infiles):
    with outfile and open(outfile, "w", newline="") or sys.stdout as output:
        writer = csv.writer(output, dialect=EXCEL_ES)
        for infile in [i for s in [glob.glob(p) for p in infiles] for i in s]:
            parser = HTMLStatementParser(writer)
            with open(infile, encoding="utf-8") as input:
                buffer = input.read()
                parser.feed(buffer)
                parser.close()
            print(infile, parser._header)


if __name__ == "__main__":
    descrpt = "Convert a list of b-kia's input files to a merged .csv one."
    parser = ArgumentParser(description=descrpt)
    parser.add_argument("-o", "--output", type=str, metavar="output_file",
        help="the name of the output file")
    parser.add_argument("inputs", type=str, metavar="input_file", nargs="+",
        help="a bunch of input filenames to read for them")

    args = parser.parse_args()
    create_output_datasheet(args.output, args.inputs)

# EOF