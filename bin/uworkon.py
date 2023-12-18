#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Copyright (c) 2023, Antonio Alvarado Hernández <tnotstar@gmail.com>

from argparse import ArgumentParser, Namespace
from pathlib import Path
from typing import Optional

import os
import sys
import json
import logging as log
import subprocess as sp


PROGRAM = "uworkon"
VERSION = "0.1.0"


def main(args: Namespace) -> int:
    if not args.config_file or not args.config_file.exists():
        log.error(f"missing configuration file '{args.config_file}'")
        return 1

    config = {}
    with args.config_file.open() as stream:
        try:
            config = json.load(stream)
        except json.JSONDecodeError as ex:
            log.error(ex)

    if not config or "workspaces" not in config:
        log.error("invalid configuration file")
        return 2

    workspaces = config["workspaces"]
    if len(workspaces) == 0:
        log.warning("no workspace specified")
        return 0

    captions = []
    paths = []
    for workspace in workspaces:
        parameters = workspaces[workspace]
        if "caption" not in parameters:
            continue
        if "path" not in parameters:
            continue

        captions.append(parameters["caption"])
        paths.append(parameters["path"])

    captions_nr = len(captions)
    if captions_nr == 0 or captions_nr != len(paths):
        log.warning("invalid workspace parameters")
        return 0

    selected_caption = select_from_captions(captions)
    print(selected_caption)

    log.info(str(config))
    return exec("fish -C ~/Public -c pwd".split())


def select_from_captions(captions: list[str]) -> Optional[str]:
    try:
        command = "fzf".split()
        p = sp.Popen(command, stdin=sp.PIPE, stdout=sp.PIPE,
                universal_newlines=True)
#                universal_newlines=True, shell=True)

        input_data = os.linesep.join(captions)
        output_data, _ = p.communicate(input=input_data)

        rs = p.wait()
        if rs != 0:
            log.error("something is wrong!")
            return None

        return output_data.strip()

    except Exception as ex:
        log.error(ex)
        return None


def exec(vargs: list[str]) -> int:
    log.debug("exec: %s", vargs)
    return os.execvp(vargs[0], vargs)


def user_config_dir(program: str) -> Path:
    path = Path(os.getenv("XDG_CONFIG_HOME", "~/.config"))
    path = path.expanduser()
    if program:
        path /= program
    return path.absolute()


if __name__ == '__main__':
    log.basicConfig(level=log.DEBUG, format=r"%(asctime)s: %(levelname)-8s %(message)s")

    parser = ArgumentParser(description="A simple tool to manage working `tmux` sessions")
    parser.add_argument("-V", "--version", action="version", version=f"{PROGRAM} {VERSION}")

    default_config_file = user_config_dir(PROGRAM) / Path(PROGRAM).with_suffix(".json")
    parser.add_argument("-c", "--config-file", default=default_config_file,
        help="the configuration file")

    args = parser.parse_args()

    try:
        log.info(f"Running {PROGRAM} v{VERSION}...")
        rs = main(args)
        sys.exit(rs)

    except KeyboardInterrupt:
        log.warning("Interrupted by user")
        sys.exit(1)

