#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Copyright (c) 2019 Antonio Alvarado Hernández - All rights reserved
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

from urllib.parse import urlparse
from argparse import ArgumentParser
from pathlib import Path

import os
import socket
import threading
import logging as log


LOG_FORMAT = r"%(asctime)s: %(name)-15s %(levelname)-8s %(processName)-10s %(message)s"

DEFAULT_LOG_FILENAME = os.environ.get("_3PARENT_LOG_", None)
DEFAULT_PARENT_PROXY = os.environ.get("_3PARENT_PROXY_", None)
DEFAULT_CONFIG_FILENAME = os.environ.get("_3PARENT_CONFIG_", None)


def lookup(host, port, timeout=None):
    """Try to resolve given host name and port number with a given timeout."""

    # define a worker function with a result closure
    result = None
    def _internal_lookup():
        nonlocal result
        try:
            result = socket.getaddrinfo(host, port, family=socket.AF_INET)
        except socket.gaierror:
            result = None

    # prepare and start worker thread
    t = threading.Thread(target=_internal_lookup)
    t.daemon = True
    t.start()

    # wait to finish or timeout
    t.join(timeout=timeout)
    if not t.is_alive():
        return result
    else:
        return None


def generate_parent_proxy_config(stream, proxy_url):
    """Detect if given proxy settings are valid in curremt context
    and then generate a statement for 3proxy configuration file."""
    log.debug("Entering proxy config generation w/url: {}...".format(proxy_url))

    # parse given proxy url
    p = urlparse(proxy_url)
    log.debug("Proxy url parsed: {}".format(p))

    # check proxy name resolution
    ipaddr = portno = None
    addresses = lookup(p.hostname, p.port, 0.25)
    log.debug("Proxy lookup results: {}".format(addresses))
    if addresses:
        first_address = addresses.pop(0)
        log.debug("Selected address: {}".format(first_address))
        if len(first_address) > 0:
            ipaddr = first_address[-1][0]
            portno = first_address[-1][1]
        log.debug("ipaddr = {} and portno = {}".format(ipaddr, portno))

    # generate parent statement
    if ipaddr and portno:
        template = "parent 1000 {} {} {} {} {}"
        buffer = template.format(p.scheme, ipaddr, portno, p.username, p.password)
    else:
        buffer = str()
    log.debug("Generated parent configuration is: \"{}\"".format(buffer))

    # write detected configuration to the output stream
    print(buffer, sep="", end="\n", file=stream)
    log.debug("Configuration has been written!!")


if __name__ == "__main__":
    # prepare the command line parser
    description = "A selective parent proxy configurator for 3proxy."
    parser = ArgumentParser(description=description)
    parser.add_argument("-p", "--parent-proxy", default=DEFAULT_PARENT_PROXY,
        help="indicates the tentative parent proxy url")
    parser.add_argument("-o", "--output", default=DEFAULT_CONFIG_FILENAME,
        help="set up an output file for the generated configuration fragment")
    parser.add_argument("-l", "--log", default=DEFAULT_LOG_FILENAME,
        help="set up a file for the generation process log")

    # parse arguments, open output stream and generate statement(s)
    args = parser.parse_args()
    if not args.log:
        args.log = r"C:\Users\66948571\dale.log"
    log.basicConfig(level=log.DEBUG, format=LOG_FORMAT, filename=args.log)
    log.info("Beginning parent proxy configuration...")
    log.debug("> Using log file: {}".format(args.log))
    log.debug("> Using proxy url: {}".format(args.parent_proxy))
    log.debug("> Using output file: {}".format(args.output))

    # running the config generation process
    output = Path(args.output).resolve()
    with output.open("w") as stream:
        generate_parent_proxy_config(stream, args.parent_proxy)
    log.info("Process finished!!\n--oOo--")

# EOF