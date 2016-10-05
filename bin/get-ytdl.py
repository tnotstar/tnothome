#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from os import chmod
from os.path import abspath, dirname, join, exists
from html.parser import HTMLParser
from urllib.parse import urljoin
from urllib.request import urlopen, urlretrieve

import re
import sys
import subprocess
import logging as log
import contextlib as ctx


YTDL_LATEST_URL = r"https://yt-dl.org/downloads/latest/"
YTDL_PROGRAM = r"youtube-dl"
YTDL_VERSION = r"--version"
YTDL_VERSION_RX = re.compile(r"\d{4}\.\d{2}\.\d{2}(?:\.\w+)?")


def get_current_path():
    base = dirname(abspath(sys.argv[0]))
    if not exists(base):
        return None
    return join(base, YTDL_PROGRAM)


def get_current_version(path):
    current_version = None
    try:
        output = subprocess.check_output([path, YTDL_VERSION]).decode()
        current_version = output.strip()
    finally:
        return current_version


def get_latest_url():
    class LatestUrlParser(HTMLParser):
        def __init__(self):
            super().__init__()
            self.inside_downloads = False
            self.latest_url = None
        def handle_starttag(self, tag, attrs):
            if not self.latest_url:
                if not self.inside_downloads and tag == "ul":
                    values = [ b for a, b in attrs if a == "class" ]
                    if len(values) > 0:
                        clazz = values.pop()
                        self.inside_downloads = (clazz == "release-downloads")
                elif self.inside_downloads and tag == "a":
                    values = [ b for a, b in attrs if a == "href" ]
                    if len(values) > 0:
                        url = values.pop()
                        self.latest_url = url.endswith(YTDL_PROGRAM) and url
    latest_url = None
    try:
        with ctx.closing(urlopen(YTDL_LATEST_URL)) as page:
            parser = LatestUrlParser()
            parser.feed(page.read().decode("utf-8"))
            latest_url = urljoin(page.url, parser.latest_url)
            parser.close()
    finally:
        return latest_url


def get_latest_version(url):
    match = YTDL_VERSION_RX.search(url)
    if not match:
        return None
    return match.group(0)


if __name__ == '__main__':
    log.basicConfig(level=log.INFO, format="%(asctime)s %(levelname)s %(message)s")

    latest_url = get_latest_url()
    log.info("latest yt-dl's url is {}".format(latest_url))

    latest_version = get_latest_version(latest_url)
    log.info("its yt-dl's version is {}".format(latest_version))

    current_path = get_current_path()
    log.info("yt-dl's binary should be at {}".format(current_path))

    current_version = get_current_version(current_path)
    if current_version:
        log.info("yt-dl's version seems to be {}".format(current_version))
    else:
        log.info("unable to guess yt-dl's version string")

    if current_version and current_version == latest_version:
        log.warn("nothing to do! aborting...")
        sys.exit(0)

    try:
        log.info("downloading yt-dl from {}".format(latest_url))
        urlretrieve(latest_url, current_path)
        chmod(current_path, 0o755)
        log.info("yt-dl gotten successfully!")
    except Exception as ex:
        log.error("unable to retrieve yt-dl, system says {}".format(ex))
        sys.exit(1)

# EOF
