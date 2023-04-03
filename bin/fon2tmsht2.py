#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from datetime import datetime, timedelta
from calendar import monthrange
from argparse import ArgumentParser

import sys
import csv


ST_ON_DAYS = 1
ST_ON_STARTS = 2
ST_ON_ENDS = 3
ST_ON_DATA = 4


def convert_to_timesheet_filter(output_stream, input_stream, year, month):
    data = {}
    state = ST_ON_DAYS
    for line in [_.strip() for _ in input_stream]:
        if len(line) == 0:
            continue

        if state == ST_ON_DAYS:
            state = ST_ON_STARTS
            days = line.split()
            continue
        
        if state == ST_ON_STARTS:
            state = ST_ON_ENDS
            starts = line.split()
            continue

        if state == ST_ON_ENDS:
            state = ST_ON_DATA
            ends = line.split()

        if state == ST_ON_DATA:
            for (day, start, end) in zip(days, starts, ends):
                day = datetime(year, month, int(day))
                base = day.strftime('%Y-%m-%d')
                start = datetime.strptime(f"{base}T{start}:00", '%Y-%m-%dT%H:%M:%S')
                end = datetime.strptime(f"{base}T{end}:00", '%Y-%m-%dT%H:%M:%S')
                data[day] = (start, end)
            state = ST_ON_DAYS

    with output_stream as writer:
        writer = csv.writer(output_stream)
        first = datetime(year, month, 1)
        days = monthrange(year, month)[1]
        keys = data.keys()
        for key in [first + timedelta(days=n) for n in range(days)]:
            row = [key.strftime('%Y-%m-%d')]
            if key in keys:
                row += [_.strftime('%H:%M') for _ in data[key]]
            else:
                row += [None, None]
            writer.writerow(row)


if __name__ == "__main__":
    synopsis = "a fon's timesheet month ocr to .csv converter"
    parser = ArgumentParser(description=synopsis)
    parser.add_argument("-y", "--year", type=int, default=datetime.now().year,
        help="the calendar year base (or current year by default)")
    parser.add_argument("-m", "--month", type=int, default=datetime.now().month,
        help="the calendar month base (or current month by default)")
    args = parser.parse_args()
    convert_to_timesheet_filter(sys.stdout, sys.stdin, args.year, args.month)

# EOF
