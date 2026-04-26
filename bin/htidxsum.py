#!/usr/bin/env python3

# Copyright 2026, Antonio Alvarado <tnotstar+copyright@gmail.com>
# -*- coding: utf-8 -*-

import urllib.request
from argparse import ArgumentParser
from html.parser import HTMLParser


# Estimated expansion factors by extension
EXPANSION_FACTORS = {
    ".gz":     5.0,
    ".bz2":    7.0,
    ".bzip2":  7.0,
    ".xz":    10.0,
    ".lzma":  10.0,
    ".zip":    4.0,
}


def get_expansion_factor(filename):
    """Returns the aproximated expansion factor according to the extension."""

    for ext, factor in EXPANSION_FACTORS.items():
        if filename.endswith(ext):
            return factor
    return 1.0  # unknown compression


def parse_size(size_str):
    """Convert '51K', '2.2M', '892M', etc. to bytes."""

    size_str = size_str.strip()
    if size_str in ("", "-"):
        return 0

    unit = size_str[-1].upper()
    number = float(size_str[:-1])

    if unit == "K":
        return int(number * 1024)
    elif unit == "M":
        return int(number * 1024**2)
    elif unit == "G":
        return int(number * 1024**3)
    else:
        return int(size_str)


class IndexParser(HTMLParser):
    """Simple parser for Apache/FTP type listings."""

    def __init__(self):
        super().__init__()
        self.in_td = False
        self.current_row = []
        self.rows = []

    def handle_starttag(self, tag, attrs):
        if tag == "td":
            self.in_td = True
            self.current_data = ""

    def handle_endtag(self, tag):
        if tag == "td":
            self.in_td = False
            self.current_row.append(self.current_data.strip())

        if tag == "tr":
            if len(self.current_row) >= 3:
                self.rows.append(self.current_row)
            self.current_row = []

    def handle_data(self, data):
        if self.in_td:
            self.current_data += data


def fetch_and_sum(url):
    """Downloads an HTML index from a URL, parses its file list, and calculates total sizes."""
    
    print(f"Downloading HTML from: {url}")
    with urllib.request.urlopen(url) as response:
        html = response.read().decode("utf-8", errors="ignore")

    parser = IndexParser()
    parser.feed(html)

    total_compressed = 0
    total_uncompressed = 0

    print("\nFile\t\tSize\t\tFactor\tDecompressed estimate")
    print("-" * 90)
    for row in parser.rows:
        if len(row) < 3:
            continue

        name = row[1]
        date = row[2]
        size = row[3]

        if name == "Parent Directory" or name == "":
            continue

        size_bytes = parse_size(size)
        factor = get_expansion_factor(name)
        est_uncompressed = int(size_bytes * factor)

        total_compressed += size_bytes
        total_uncompressed += est_uncompressed

        print(f"{name:30} {size:10}  x{factor:<4}  ~{est_uncompressed/1024**2:8.2f} MB")

    print("\n=== Totals ===")
    print(f"Total compressed: {total_compressed/1024**3:.2f} GB")
    print(f"Estimated decompressed: {total_uncompressed/1024**3:.2f} GB")


def main():
    """This is the program entry-point"""

    parser = ArgumentParser(description="calculate directory size from Apache/FTP listings")
    parser.add_argument("url", help="La URL de los listados de Apache/FTP")
    args = parser.parse_args()

    try:
        fetch_and_sum(args.url)

    except Exception as ex:
        print("Oops: " + str(ex))


if __name__ == "__main__":
    main()

# Ejemplo de uso:
# fetch_and_sum(r"https://ftp.ensembl.org/pub/grch37/current/mysql/homo_sapiens_core_115_37/")
#fetch_and_sum(r"https://ftp.ensembl.org/pub/grch37/current/mysql/homo_sapiens_core_115_37/")
#fetch_and_sum(r"https://ftp.ensembl.org/pub/grch37/current/mysql/homo_sapiens_variation_115_37/")
