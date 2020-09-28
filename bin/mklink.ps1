# Copyright (c) 2020 Antonio Alvarado Hernández - All rights reserved

<#
.NAME
    mklink

.SYNOPSIS
    Makes a symbolic link to given target and stores it in given path.

.SYNTAX
    mklink [[-To] <String>] [[-From] <String>]

.PARAMETER To
    The path of the symbolic link to be created.

.PARAMETER From
    The path of the target to be created.

.DESCRIPTION
    mklink is a replacement of the legacy `cmd.exe` command `mklink`

.EXAMPLE
    mklink _vimrc Local\etc\vimrc
#>
param (
    [string]$To,
    [string]$From
)
# Check mandatory parameters
if ("$To" -eq "" -or "$From" -eq "") {
    Write-Error "Missing command line arguments"
    Exit 1
}

# Check elevated priviledges
$Principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-Not ($Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Error "This command needs to run with elevated priviledges"
    Exit 2
}

# This is the main control sequence
$Item = New-Item -ItemType SymbolicLink -Path "$To" -Target "$From"
$Owner = New-Object System.Security.Principal.NTAccount("$Env:USERNAME")
$ACL = Get-ACL $Item
$ACL.SetOwner($Owner)
Set-ACL -Path $Item -AclObject $ACL

# EOF