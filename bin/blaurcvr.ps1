#!/usr/bin/env pwsh

# Copyright (c) 2025, Antonio Alvarado <tnotstar@gmail.com>

<#
.NAME
    bluerevcer.ps1

.SYNOPSYS
    Execute the `Bluetooth Audio Reveicer` --if installed--, on the current Windows machine.

.SYNTAX
    bluerevcer

.EXAMPLE
    bluerevcer
#>


try {
    $pkg = Get-AppxPackage '*BluetoothAudioReveicer*' -ErrorAction Stop
    $items = @(Get-ChildItem $($pkg.InstallLocation) -Recurse -Filter '*.exe' -ErrorAction Stop)
    foreach ($item in $items) {
        try {
            &  $item.FullName
            return $LASTEXITCODE
        }
        catch {
            Write-Error "Oops: I can''t execute command at: $($item.Location)"
        }
    }
}
catch {
    Write-Error "Oops: the `Bluetooth Audio Reveicer` isn''t installed"
}
