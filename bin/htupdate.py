#!/usr/bin/env python3
#
# Copyright (c) 2016-2018 Antonio Alvarado Hernández - All rights reserved
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# -*- coding: utf-8 -*-


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
                command = "/usr/bin/date --utc -Rs".split()
                command.append(srvdate)
                output = check_output(command).decode()
    except HTTPError as ex:
        print("Oops: can't retrieve date from Google ({})".format(str(ex)))

    except CalledProcessError as ex:
        print("Oops: can't call `date` command ({})".format(str(ex)))

# EOF