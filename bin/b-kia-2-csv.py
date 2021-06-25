#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Copyright (c) 2017-2021 Antonio Alvarado Hernández - All rights reserved
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
from functools import cmp_to_key

import re
import sys
import csv
import glob
import locale

import decimal as dn
import datetime as dt
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
EXCEL_ES.quoting = csv.QUOTE_NONNUMERIC

RX_DATETIME = re.compile(r"^\d+/\d+/\d+(\s+\d+:\d+:\d+)?$")
RX_IMPORT = re.compile(r"^([-+]?\d+[0-9.,]*)(\s*\w*)$")

FT_DATETIME = r"%d/%m/%Y %H:%M:%S"
FT_DATE = r"%d/%m/%Y"


class HTMLStatementParser(html_parser.HTMLParser):
    """Parse a statement exported as an Excel XML Export file."""

    def __init__(self, processor):
        super().__init__()
        self.processor = processor
        self.state = ST_READY
        self.data = None
        self.in_header = True

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if self.state == ST_READY and tag == "html":
            namespaces = attrs.values()
            if all([NS_HTML in namespaces,
                    NS_EXCEL in namespaces,
                    NS_OFFICE in namespaces]):
                self.state = ST_IN_HTML
        elif self.state == ST_IN_HTML and tag == "body":
            self.state = ST_IN_BODY
        elif self.state == ST_IN_BODY and tag == "table":
            self.state = ST_IN_TABLE
        elif self.state == ST_IN_TABLE and tag == "thead":
            self.state = ST_IN_THEAD
        elif self.state == ST_IN_THEAD and tag == "tr":
            self.data = list()
            self.state = ST_IN_THTR
        elif self.state == ST_IN_THTR and tag == "th":
            self.state = ST_IN_TRTH
        elif self.state == ST_IN_TABLE and tag == "tbody":
            self.state = ST_IN_TBODY
        elif self.state == ST_IN_TBODY and tag == "tr":
            self.data = list()
            self.state = ST_IN_TBTR
        elif self.state == ST_IN_TBTR and tag == "td":
            self.state = ST_IN_TRTD

    def handle_data(self, data):
        if self.state in (ST_IN_TRTH, ST_IN_TRTD):
            self.data.append(data)

    def handle_endtag(self, tag):
        if self.state == ST_IN_TRTD and tag == "td":
            self.state = ST_IN_TBTR
        elif self.state == ST_IN_TBTR and tag == "tr":
            if self.data:
                if self.in_header:
                    self.processor.add_header(self.data)
                else:
                    self.processor.add_data(self.data)
                self.in_header = False
            self.state = ST_IN_TBODY
        elif self.state == ST_IN_TBODY and tag == "tbody":
            self.state = ST_IN_TABLE
        elif self.state == ST_IN_TRTH and tag == "th":
            self.state = ST_IN_THTR
        elif self.state == ST_IN_THTR and tag == "tr":
            self.processor.add_title(self.data)
            self.state = ST_IN_THEAD
        elif self.state == ST_IN_THEAD and tag == "thead":
            self.state = ST_IN_TABLE
        elif self.state == ST_IN_TABLE and tag == "table":
            self.state = ST_IN_BODY
        elif self.state == ST_IN_BODY and tag == "body":
            self.state = ST_IN_HTML
        elif self.state == ST_IN_HTML and tag == "html":
            self.state = ST_ENDED


class InMemoryProcessor(object):
    """A memory-based processor to consolidate transactions data."""

    def __init__(self):
        self.title = []
        self.header = []
        self.data = []

    def add_title(self, title):
        title = self.normalize_title(title)
        if title and not title in self.title:
            self.title.append(title)

    def add_header(self, header):
        header = self.normalize_header(header)
        if header and not header in self.header:
            self.header.append(header)

    def add_data(self, data):
        data = self.normalize_data(data)
        if data and len(data) >= 7 \
                and not data[:7] in [ _[:7] for _ in self.data ]:
            self.data.append(data)

    def normalize_title(self, title):
        answer = []
        for value in map(str, title):
            if RX_DATETIME.search(value):
                value = ""
            answer.append(value)
        return answer

    def normalize_header(self, header):
        answer = []
        last_value = None
        for value in map(str, header):
            if value == "DESCRIPCIÓN":
                value = "DESCRIPCION"
            elif value == "CATEGORÍA":
                value = "CONCEPTO 1"
            elif value == "DIV.":
                value = "DIV"
            if value in ("DESCRIPCION",):
                if last_value != "FEC. VALOR":
                    answer.append("FEC. VALOR")
            if value in ("SALDO", "CONCEPTO 1"):
                if not last_value in ("DIV",):
                    answer.append("DIV")
            last_value = value
            answer.append(value)
        return answer

    def normalize_data(self, data):
        answer = []
        dates_nr = 0
        last_date = None
        for value in map(str, data):
            if RX_DATETIME.search(value):
                try:
                    value = dt.datetime.strptime(value, FT_DATETIME)
                except ValueError:
                    value = dt.datetime.strptime(value, FT_DATE)
                dates_nr += 1
                last_date = value
            elif match := RX_IMPORT.match(value):
                groups = match.groups()
                if groups[0]:
                    value = groups[0].replace(".","").replace(",",".")
                    if not value.find(".") < 0:
                        value = dn.Decimal(value)
                if groups[1]:
                    answer.append(value)
                    value = groups[1].strip()
                last_date = None
            else:
                if last_date and dates_nr == 1:
                    answer.append(last_date)
                last_date = None
            answer.append(value)
        return answer

    def write_csv(self, writer):
        locale.setlocale(locale.LC_ALL, "Spanish")
        for title in self.title:
            writer.writerow(title)
        for header in sorted(self.header):
            writer.writerow(header)
        for data in sorted(self.data, key=cmp_to_key(compare_data)):
            writer.writerow(format_data(data))


def format_data(data):
    answer = []
    for value in data:
        if isinstance(value, dt.datetime):
            value = value.strftime(FT_DATE)
        elif isinstance(value, dn.Decimal):
            value = "{0:n}".format(value)
        else:
            value = str(value)
        answer.append(value)
    return answer


def compare_data(a, b):
    answer = (a[0] - b[0]).total_seconds()
    if answer != 0.0:
        return answer
    answer = (a[1] - b[1]).total_seconds()
    if answer != 0.0:
        return answer
    balance_a = a[5] - a[3]
    balance_b = b[5] - b[3]
    print(">>", a[0], ":", a[3], "=>", a[5], "vs", b[3], "=>", b[5], ":", balance_a == b[5], "(a)", a[5] == balance_b, "(b)", balance_b - balance_a, "(b)")
    if balance_a == b[5]:
        return +1
    elif a[5] == balance_b:
        return -1
    else:
        return balance_b - balance_a


def create_output_datasheet(outfile, infiles):
    with open(outfile, "w", newline="") as output:
        processor = InMemoryProcessor()
        for infile in [i for s in [glob.glob(p) for p in infiles] for i in s]:
            parser = HTMLStatementParser(processor)
            with open(infile, encoding="utf-8") as input:
                print("Reading file \"{}\"...".format(infile))
                buffer = input.read()
                parser.feed(buffer)
                parser.close()
        print("Writting file \"{}\"...".format(outfile))
        writer = csv.writer(output, dialect=EXCEL_ES)
        processor.write_csv(writer)


if __name__ == "__main__":
    descrpt = "Convert a list of b-kia\"s input files to a merged .csv one."
    parser = ArgumentParser(description=descrpt)
    parser.add_argument("-o", "--output", type=str, metavar="output_file",
        help="the name of the output file", required=True)
    parser.add_argument("inputs", type=str, metavar="input_file", nargs="+",
        help="a bunch of input filenames to read for them")

    args = parser.parse_args()
    create_output_datasheet(args.output, args.inputs)

# EOF
