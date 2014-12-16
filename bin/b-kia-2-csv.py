#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright (c) 2014 Antonio Alvarado Hernández - All rights reserved
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

from __future__ import absolute_import, unicode_literals, print_function

from six.moves import html_parser

import re
import sys


RX_TITLE_ID = re.compile(r"movimientos\s+de\s+la\s+cuenta\s+(.+)", re.I)
RX_TITLE_DATE = re.compile(r"reporte\s+generado\s+a\s+(.+)\.", re.I)

ST_READY       = 0
ST_IN_TABLE    = 1
ST_IN_TTTLID   = 2
ST_IN_TTTLDATE = 3
ST_IN_TTABLE   = 4
ST_IN_TBODY    = 5
ST_IN_TROW     = 6
ST_IN_TCOLUMN  = 7


class HTMLStatementParser(html_parser.HTMLParser, object):
    """TODO: Blah, blah, blah, ..."""

    def __init__(self):
        super(HTMLStatementParser, self).__init__()
        self._state = ST_READY
        self._account_no = None
        self._report_dt = None
        self._current = None

    def handle_starttag(self, tag, attrs):
        if self._state == ST_READY:
            if tag == "table":
                self._state = ST_IN_TABLE
        elif self._state == ST_IN_TABLE:
            if tag == "span":
                xid = dict(attrs).get('id', None)
                if xid == "tituloDocumento":
                    self._state = ST_IN_TTTLID
                elif xid == "tituloFecha":
                    self._state = ST_IN_TTTLDATE
            elif tag == "table":
                self._state = ST_IN_TTABLE
        elif self._state == ST_IN_TTABLE:
            if tag == "tbody":
                self._state = ST_IN_TBODY
        elif self._state == ST_IN_TBODY:
            if tag == "tr":
                self._state = ST_IN_TROW
        elif self._state == ST_IN_TROW:
            if tag == "td":
                self._state = ST_IN_TCOLUMN

    def handle_endtag(self, tag):
        if self._state == ST_IN_TCOLUMN:
            if tag == "td":
                self._state = ST_IN_TROW
        elif self._state == ST_IN_TROW:
            if tag == "tr":
                self._state = ST_IN_TBODY
        elif self._state == ST_IN_TBODY:
            if tag == "tbody":
                self._state = ST_IN_TTABLE
        elif self._state == ST_IN_TTABLE:
            if tag == "table":
                self._state = ST_IN_TABLE
        elif self._state in (ST_IN_TTTLID, ST_IN_TTTLDATE):
            if tag == "span":
                self._state = ST_IN_TABLE
        elif self._state == ST_IN_TABLE:
            if tag == "table":
                self._state = ST_READY

    def handle_data(self, data):
        if self._state == ST_IN_TTTLID:
            match = RX_TITLE_ID.search(data)
            if match:
                self._account_no = match.group(1)
            print("###", self._account_no)
        elif self._state == ST_IN_TTTLDATE:
            match = RX_TITLE_DATE.search(data)
            if match:
                self._report_date = match.group(1)
            print("###", self._report_date)
        elif self._state == ST_IN_TCOLUMN:
            print("===", data)


def parse_statement_from_html(fname):
    """TODO: Blah, blah, blah, ..."""
    parser = HTMLStatementParser()
    with open(fname) as stream:
        buffer = stream.read()
        parser.feed(buffer)
        parser.close()
    return None


if __name__ == "__main__":
    stmt = parse_statement_from_html(sys.argv[1])
    print(stmt)

# EOF
