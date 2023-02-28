#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from datetime import datetime, timedelta
from calendar import monthrange

import sys
import csv


ST_ON_DAYS = 1
ST_ON_STARTS = 2
ST_ON_ENDS = 3


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
            state = ST_ON_DAYS
            ends = line.split()

        for (day, start, end) in zip(days, starts, ends):
            day = datetime(year, month, int(day))
            base = day.strftime('%Y%m%d')
            start = datetime.strptime(base + start, '%Y%m%d%H%M')
            end = datetime.strptime(base + end, '%Y%m%d%H%M')
            data[day] = (start, end)

    with output_stream as writer:
        writer = csv.writer(output_stream)
        first = datetime(year, month, 1)
        days = monthrange(year, month)[1]
        keys = data.keys()
        for key in [first + timedelta(days=n) for n in range(days + 1)]:
            row = [key.strftime('%Y-%m-%d')]
            if key in keys:
                row += [_.strftime('%H:%M') for _ in data[key]]
            else:
                row += [None, None]
            writer.writerow(row)


if __name__ == "__main__":
    convert_to_timesheet_filter(sys.stdout, sys.stdin, 2023, 2)

# EOF
