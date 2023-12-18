#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pathlib import Path
from typing import Optional, List, Dict

import sys
import json


x = r"""
DEFAULT_DUPLICATES_FILENAME = "jdupes-New-20221216.json"


def read_duplicates_from(filename: str) -> list[dict[str, str]]:
    with Path(filename).open() as stream:
        data = json.load(stream)
        if "matchSets" in data:
            return data["matchSets"]
    return []

def select_files_to_delete(entries: list[Path]) -> list[Path]:
    candidate = None
    entries_nr = len(entries)
    for idx, lhs in enumerate(entries[:-1]):
        lhs = Path(lhs).relative_to(".")
        lhs_parts = list(lhs.parts)
        print(type(lhs), lhs)
        for i in range(idx+1, entries_nr):
            rhs = Path(entries[i]).relative_to(".")
            rhs_parts = list(rhs.parts)
            print('>>>', lhs_parts, "versus", rhs_parts)
    return entries


if __name__ == "__main__":
    for match_set in read_duplicates_from(DEFAULT_DUPLICATES_FILENAME):
        entries = [
            Path(match["filePath"]) for match in match_set["fileList"]
                if "filePath" in match
        ]
        for entry in select_files_to_delete(entries):
            pass
"""

import io

def open_dupes(filename: str, encoding: str) -> io.TextIOWrapper:
    """Open a `jdupes` output file with given name and encoding."""

    if filename and filename != "-":
        filepath = Path(filename).expanduser().absolute()
        if not filepath.exists():
            raise ValueError(f"Oops: file {filepath} not found")
        return filepath.open(mode="r", encoding="latin1")
    return io.TextIOWrapper(sys.stdin.buffer, encoding=encoding)


def load_dupes(filename: Optional[str] = None, encoding: str = "utf-8") -> Dict[str, dict]:
    with open_dupes(filename, encoding) as stream:
        try:
            return json.load(stream)
        except:
            return {}


def filter_each_matchset(matchsets: Dict[str, dict]) -> Dict[str, dict]:
    for matchset in matchsets:
        if "fileList" in matchset:
            filelist = filter_each_filelist(matchset.get("fileList"))
            matchset["fileList"] = filelist
    return matchsets


def filter_each_filelist(filelist: List[dict]) -> List[dict]:
    readings = []
    for file in filelist:
        path = Path(file["filePath"])
        if "Readings" in path.parts:
            readings.append(path)
    print(readings)
    return filelist


def main():
    dupes = read_dupes()
    if "matchSets" in dupes:
        matchsets = filter_each_matchset(dupes.get("matchSets"))
        dupes["matchSets"] = matchsets
    print(json.dumps(dupes))
    sys.exit(0)
    for match in dupes["matchSets"]:
        to_delete = []
        for index, entry in enumerate(match["fileList"]):
            path = Path(entry["filePath"])
            if path.parts[0] == "Readings":
                to_delete.append(index)
        for index in reversed(sorted(to_delete)):
            print(f"Removing file {match['fileList'][index]['filePath']}...", file=sys.stderr)
            del match["fileList"][index]
    print(json.dumps(dupes))


if __name__  == "__main__":
    main()

# EOF
