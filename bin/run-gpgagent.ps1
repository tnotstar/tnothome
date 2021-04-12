# Copyright (c) 2021 Antonio Alvarado Hernández - All rights reserved

<#
.NAME
    run-gpgagent

.SYNOPSIS
    Launch the `gpg-agent` daemon process.

.SYNTAX
    run-gpgagent

.DESCRIPTION
    `run-gpgagent` is an utility to launch `gpg-agent` daemon process

.EXAMPLE
    run-gpgagent
#>

# This is the main control sequence
& gpgconf --launch gpg-agent
