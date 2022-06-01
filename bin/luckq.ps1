#!/usr/bin/env pwsh

# Copyright (c) 2021-2022, Antonio Alvarado Hernández

<#
.NAME
    luckq

.SYNOPSIS
    Launch `links` browser with results from a given query in `duckduckgo`.

.SYNTAX
    luckq [[-Query] query]

.PARAMETER Query
    The query term to be issued to `duckduckgo`.

.DESCRIPTION
    luckq is good to quick search terms from command line.

.EXAMPLE
    luckq python pathlib
#>
param (
    [string]$Query
)

$Part = '#'
if ($Query) {
    $Cleaned = @( $Query; $args ) | %{ "$_".Trim() } | Join-String -Separator ' '
    $Part = "?q=$($Cleaned.Replace(' ', '+'))"
}

$Url = "https://html.duckduckgo.com/html$Part"
try {
    $ErrorActionPreference = 'Stop'
    if (Get-Command links) {
        links "$Url"
    }
}
catch {
    Write-Error "Oops: the 'links' command not found"
}

# EOF
