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

def fix_qdf_file(output, input):
    for line in input:
        #print(line)
        output.write(line)


if __name__ == "__main__":
    with open("fichero-qdf_fix-qdf.pdf", "rb") as input:
        with open("dale.pdf", "wb") as output:
            fix_qdf_file(output, input)

# EOF