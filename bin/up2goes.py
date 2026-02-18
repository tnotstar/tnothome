#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Copyright 2026, Antonio Alvarado <tnotstar@gmail.com>


import platform
import shutil
import subprocess
import sys
from collections import OrderedDict
from pathlib import Path
from typing import Optional

import tomllib

DEFAULT_SCRIPT_FILENAME = sys.argv[0]

GREEN = "\033[92m"
CYAN = "\033[96m"
YELLOW = "\033[93m"
RED = "\033[91m"
RESET = "\033[0m"


def check_go_installed():
    """Check if the 'go' command is available in the system. If not, raise an error."""

    if not shutil.which("go"):
        raise EnvironmentError("'go' has not been installed or is not in PATH.")


def load_packages(script_filename: Optional[str] = None) -> dict[str, dict]:
    """Load packages from the TOML file. Default path is determined based
    on the script's location."""

    reference_file = Path(script_filename or DEFAULT_SCRIPT_FILENAME)

    reference_dir = reference_file.parent
    if str(reference_dir) == ".":
        reference_dir = Path("..")
    else:
        reference_dir = reference_dir.parent

    packages_file = reference_dir / "etc" / reference_file.stem / "packages.toml"
    with open(packages_file, "rb") as f:
        packages = tomllib.load(f)

    selected_packages = OrderedDict()
    for k, v in packages["common"].items():
        if k not in selected_packages:
            selected_packages[k] = v

    os_name = platform.system().lower()
    for k, v in packages[os_name].items():
        if k not in selected_packages:
            selected_packages[k] = v

    return selected_packages


def install_package(uri, caption) -> None:
    # Install the package using the provided URI. This function uses subprocess
    # to call the 'go install' command, and it handles errors gracefully.

    print(f'{CYAN}- Installing "{caption}" from "{uri}"...{RESET}')
    try:
        # shell=True only on Windows to handle .exe and .bat files properly,
        # but it's generally safer to avoid it when not necessary.
        use_shell = True if platform.system() == "Windows" else False

        subprocess.run(
            ["go", "install", uri],
            check=True,
            shell=use_shell,
            stdout=subprocess.DEVNULL,  # Hide standard output for cleaner logs
            stderr=subprocess.PIPE,  # Catch errors to display them de manera más amigable
        )
        print(f"{GREEN}  > Package at {uri} installed successfully!{RESET}")

    except subprocess.CalledProcessError as err:
        print(f"{RED}  > Package at {uri} installation has failed: {err}{RESET}")

        err_msg = err.stderr.decode().strip() if err.stderr else "Unknown error"
        raise RuntimeError(f"Failed to install {uri}: {err_msg}")


if __name__ == "__main__":
    try:
        print(f"{YELLOW}Checking if 'go' is installed...{RESET}")
        check_go_installed()

        print(f"{YELLOW}Loading packages to install...{RESET}")
        packages = load_packages()

        print(f"{YELLOW}Beginning installation of {len(packages)} packages...{RESET}")
        for k, v in packages.items():
            install_package(k, v)

        print(f"{GREEN}> Installation completed successfully!{RESET}")
        sys.exit(0)

    except Exception as ex:
        print(f"{RED}> Fatal: {ex}{RESET}")
        sys.exit(1)
