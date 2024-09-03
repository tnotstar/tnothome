#!/usr/bin/env pwsh

# Copyright (c) 2024, Antonio Alvarado Hernández

<#
.NAME
    lsfonts

.SYNOPSIS
    List fonts installed in the system.

.SYNTAX
    lsfonts

.DESCRIPTION
    lsfonts is a simple script that lists the fonts installed in the system.

.EXAMPLE
    lsfonts

.NOTES
    This script has been inspired by: https://superuser.com/a/760632/50903
#>

try {
    $dll = [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

    (New-Object System.Drawing.Text.InstalledFontCollection).Families | sort | foreach {
        Write-Host $_.Name
    }

}
catch {
    Write-Error "Oops: can't retrieve font families from Installed collection"
}

# EOF
