#!/usr/bin/env python3
#
# Copyright (c) 2016 Antonio Alvarado Hernández - All rights reserved
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


from subprocess import CalledProcessError, check_output
from urllib.error import HTTPError
from urllib.request import Request, urlopen

if __name__ == "__main__":
    try:
        request = Request(url=r"http://www.google.com/", method="HEAD")
        with urlopen(request) as response:
            srvdate = response.info().get("Date")
            command = "/usr/bin/date --utc -Rs".split()
            command.append(srvdate)
            output = check_output(command).decode()
    except HTTPError as ex:
        print("Oops: can't retrieve date from Google ({})".format(str(ex)))

    except CalledProcessError as ex:
        print("Oops: can't call `date` command ({})".format(str(ex)))

# EOF
