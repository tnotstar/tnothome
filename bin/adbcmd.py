#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Copyright 2023, Antonio Alvarado Hernández

import cmd


class AdbCmd(cmd.Cmd):
    def do_connect(self, args):
        print(f"Connecting {args}...")


if __name__ == "__main__":
    AdbCmd().cmdloop()
