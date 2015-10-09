#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from html.parser import HTMLParser
from urllib.parse import urljoin, urlparse
from urllib.request import urlopen, urlretrieve

from datetime import date
from platform import system

import re
import six
import os.path
import logging as log
import contextlib as ctx


DMD_RELEASES_BASEURL = r"http://downloads.dlang.org/releases/"
DMD_PROGRAM = r"dmd"
DMD_VERSION_RX = re.compile(r"")


def get_latest_url():
    """Return the URL for the latest version of `dmd`."""

    class LatestParser(HTMLParser):
        def __init__(self, *args, **kwargs):
            super().__init__(*args, **kwargs)
            self._url = None
            self._system = system().lower()

        def geturl(self):
            if not self._url:
                return None
            return urljoin(DMD_RELEASES_BASEURL, self._url)

        def handle_starttag(self, tag, attrs):
            # omit tags different from "a"
            if tag != "a":
                return
            # omit "a" tags without "href"
            url = dict(attrs).get("href", None)
            if not url:
                return
            # omit urls to an invalid target
            urlparts = urlparse(url)
            fname, fext = os.path.splitext(urlparts.path)
            if self._system not in fname:
                return
            if fext != ".zip":
                return
            # check if the url is most recent than latest
            if not self._url or self._url < url:
                self._url = url

    parser = LatestParser(convert_charrefs=True)
    try:
        today = date.today()
        dmd_releases_url = urljoin(DMD_RELEASES_BASEURL, str(today.year))
        with ctx.closing(urlopen(dmd_releases_url)) as resource:
            page = resource.read().decode("utf-8")
            parser.feed(page)
    finally:
        return parser.geturl()


if __name__ == '__main__':
    logfmt = """%(asctime)s %(levelname)s %(message)s"""
    log.basicConfig(level=log.INFO, format=logfmt)

    latest_url = get_latest_url()
    log.info("latest dmd's url is {}".format(latest_url))

# EOF
