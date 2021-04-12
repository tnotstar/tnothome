# Copyright (c) 2020 Antonio Alvarado Hernández - All rights reserved

<#
.NAME
    takeown

.SYNOPSIS
    Take the ownership of an item at given path.

.SYNTAX
    takeown [[-To] <String>]

.PARAMETER To
    The path of the item to take the ownership from.

.DESCRIPTION
    takeown is a replacement of the legacy `cmd.exe` command: `takeown`

.EXAMPLE
    takeown _vimrc
#>
param (
    [string]$To
)

# Check mandatory command line arguments
if ("$To" -eq "") {
    Write-Error "Missing command line argument"
    Exit 1
}

# Check for elevated priviledges
$Principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-Not ($Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Error "This command needs to run with elevated priviledges"
    Exit 2
}

# This is the main control sequence
$Owner = New-Object System.Security.Principal.NTAccount("$Env:USERNAME")
$Item = Get-Item $To
$ACL = Get-ACL $Item
$ACL.SetOwner($Owner)
Set-ACL -Path $Item -AclObject $ACL
