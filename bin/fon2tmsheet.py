#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from datetime import datetime, timedelta

import sys
import csv


def convert_to_timesheet_filter(output_stream, input_stream):
    data = {}
    for line in [_.strip() for _ in input_stream]:
        if len(line) == 0:
            continue
        value = datetime.strptime(line, "%d/%m/%Y %H:%M")
        key = value.date()
        if key not in data:
            data[key] = [value.time()]
        else:
            data[key].append(value.time())

    with output_stream as writer:
        writer = csv.writer(output_stream)
        index = data.keys()
        first = min(index)
        last = max(index)
        days = (last - first).days
        for key in [first + timedelta(days=n) for n in range(days + 1)]:
            row = [key.strftime('%Y-%m-%d')]
            if key in index:
                row += sorted([_.strftime('%H:%M') for _ in data[key]])
            else:
                row += [None, None]
            writer.writerow(row)


if __name__ == "__main__":
    convert_to_timesheet_filter(sys.stdout, sys.stdin)

# EOF
