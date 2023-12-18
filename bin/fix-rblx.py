#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pathlib import Path

DESKTOP_ENTRY_TEMPLATE = """\
[Desktop Entry]
Name=Roblox Player
Exec=env WINEPREFIX="/home/tnotstar/.wine" wine C:\\\\Program\\ Files\\ \\(x86\\)\\\\Roblox\\\\Versions\\\\version-0beb053becad47aa\\\\RobloxPlayerLauncher.exe %u
Type=Application
StartupNotify=true
Icon=9C72_RobloxPlayerLauncher.0
StartupWMClass=robloxplayerlauncher.exe"""

if __name__ == "__main__":
    print(DESKTOP_ENTRY_TEMPLATE)

