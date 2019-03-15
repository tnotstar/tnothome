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

from argparse import ArgumentParser
from pathlib import Path
from hashlib import sha256

import sys
import json


def walk_path_and_dump_tree(output, path):
    def walk(path):
        results = dict()
        for entry in path.iterdir():
            try:
                key = str(entry.relative_to(path))
                if entry.is_dir():
                    value = walk(entry)
                else:
                    value = read_entry(entry)
                results[key] = value
            except OSError as ex:
                print("Oops: {} :: {}".format(ex, entry), file=sys.stderr)
                continue
        return results

    def read_entry(entry):
        output = dict(
            path     = str(entry.absolute()),
            name     = str(entry.name),
            parent   = str(entry.parent),
            size     = 0,
            created  = 0,
            modified = 0,
            hash     = None,
        )
        try:
            stat = entry.stat()
            output['size'] = stat.st_size
            output['created'] = stat.st_ctime
            output['modified'] = stat.st_mtime

            hash = sha256()
            hash.update(entry.read_bytes())
            output['hash'] = hash.hexdigest()
        finally:
            return output

    results = walk(path)
    json.dump(results, output)

if __name__ == "__main__2":
    decript = "export a json file with a folder tree loaded from given path"
    parser = ArgumentParser(decription=descript)
    parser.add_argument("-a", "--all", help="show hidden entries.")
    parser.add_argument("

if __name__ == "__main__":
    descrpt = "export a json file with a folder tree loaded from given path"
    parser = ArgumentParser(description=descrpt)
    parser.add_argument("-o", "--output", help="a name for the output file")
    parser.add_argument("-p", "--path", help="a path to walk a tree from there")

    args = parser.parse_args()
    with args.output and open(args.output, "w") or sys.stdout as output:
        walk_path_and_dump_tree(output, Path(args.path or "."))

# EOF