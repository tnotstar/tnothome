# Copyright 2021, Antonio Alvarado Hernández

<#
.NAME
    chmext

.SYNOPSIS
    Decompile a Microsoft CHM file into the directory at given path.

.SYNTAX
    chmext [-From] <SourceFile> [-To] <TargetDir>

.PARAMETER From
    The path of the source CHM file.

.PARAMETER To
    The path of the target directory.

.DESCRIPTION
    chmext decompiles and extracts assets from a given CHM Microsoft Help file.

.EXAMPLE
    chmext yourhelp.chm yourhelp_extracted
#>
param (
    [string]$From,
    [string]$To
)

# Check mandatory parameters
if ("$From" -eq "" -or "$To" -eq "") {
    Write-Error "Missing command line arguments"
    Exit 1
}
if (!(Test-Path -PathType Leaf $From)) {
    Write-Error "Invalid input file: $From"
    Exit 2
}
if (!(Test-Path -PathType Container $To)) {
    Write-Error "Invalid output directory: $To"
    Exit 3
}

# This is the main control sequence
if (!(Get-Command hh.exe -ErrorAction Continue)) {
    Write-Error "Command `hh.exe` not found"
    Exit 4
}
hh.exe -decompile $To $From

# EOF