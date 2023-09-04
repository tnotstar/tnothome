#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Copyright 2016-2023, Antonio Alvarado Hernández

from calendar import timegm
from datetime import datetime
from subprocess import CalledProcessError, check_output
from email.utils import parsedate
from urllib.error import HTTPError
from urllib.request import Request, urlopen

import platform


if __name__ == "__main__":
    try:
        request = Request(url=r"http://www.google.com/", method="HEAD")
        with urlopen(request) as response:
            date_str = response.info().get("Date")
            date_dt = datetime.fromtimestamp(timegm(parsedate(date_str)))
            if platform.system() == 'Windows':
                command = 'cmd /c date '.split()
                command.append(date_dt.strftime("%Y-%m-%d"))
                output = check_output(command).decode()

                command = 'cmd /c time '.split()
                command.append(date_dt.strftime("%H:%M:%S"))
                output = check_output(command).decode()
            else:
                command = "/usr/bin/date --utc --iso-8601 -s".split()
                command.append(date_dt.isoformat())
                output = check_output(command).decode()
    except HTTPError as ex:
        print("Oops: can't retrieve date from Google ({})".format(str(ex)))

    except CalledProcessError as ex:
        print("Oops: can't call `date` command ({})".format(str(ex)))
