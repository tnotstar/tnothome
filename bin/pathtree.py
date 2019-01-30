#!/usr/bin/env python3
# -*- coding: utf-8 -*-

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


if __name__ == "__main__":
    descrpt = "export a json file with a folder tree loaded from given path"
    parser = ArgumentParser(description=descrpt)
    parser.add_argument("-o", "--output", help="a name for the output file")
    parser.add_argument("-p", "--path", help="a path to walk a tree from there")

    args = parser.parse_args()
    with args.output and open(args.output, "w") or sys.stdout as output:
        walk_path_and_dump_tree(output, Path(args.path or "."))

# EOF