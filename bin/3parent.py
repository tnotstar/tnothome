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


def generate_parent_proxy_configuration(stream, proxy_url):
    """Detect if given proxy configuration settings are valid in curremt context
    and then generate a statement for 3proxy configuration file."""

    # parse given proxy url
    p = urlparse(proxy_url)

    # check proxy name resolution
    ipaddr = portno = None
    addresses = lookup(p.hostname, p.port, 0.25)
    if addresses:
        first_address = addresses.pop(0)
        if len(first_address) > 0:
            ipaddr = first_address[-1][0]
            portno = first_address[-1][1]

    # generate parent statement
    if ipaddr and portno:
        template = "parent 1000 {} {} {} {} {}"
        buffer = template.format(p.scheme, ipaddr, portno, p.username, p.password)
    else:
        buffer = str()

    # write detected configuration to the output stream
    print(buffer, file=stream)


if __name__ == "__main__":
    default_parent_proxy = os.environ.get("PARENT_PROXY", None)
    default_filename = Path(__file__).with_suffix(".cfg")

    # prepare the command line parser
    description = "A selective parent proxy configurator for 3proxy."
    parser = ArgumentParser(description=description)
    parser.add_argument("-p", "--parent-proxy", default=default_parent_proxy,
        help="indicates the tentative parent proxy url")
    parser.add_argument("-o", "--output", default=default_filename,
        help="set up an output file for the generated configuration fragment")

    # parse arguments, open output stream and generate statement(s)
    args = parser.parse_args()
    output = (Path(__file__).parent / args.output).resolve()
    with output.open("w") as stream:
        generate_parent_proxy_configuration(stream, args.parent_proxy)

# EOF