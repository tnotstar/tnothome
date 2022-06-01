#!/usr/bin/env pwsh

# Copyright (c) 2021-2022, Antonio Alvarado Hernández

<#
.NAME
    up2conda

.SYNOPSYS
    Launch all `conda` commands to keep current installation and their local
    environments up to date.

.SYNTAX
    up2conda

.EXAMPLE
    up2conda
#>

try {
    $Conda = Get-Command conda -ErrorAction Stop

    if (!(Get-Command Invoke-Conda -ErrorAction SilentlyContinue)) {
        (& $Conda "shell.powershell" "hook") | Out-String | Invoke-Expression
    }

    Write-Host "Running 'conda' updating routines...`n" -ForegroundColor Yellow
    try {
        Write-Host "> Updating ``conda`` package..." -ForegroundColor DarkYellow
        Invoke-Conda update -y conda

        Write-Host "> Updating ``base`` environment..." -ForegroundColor DarkYellow
        Invoke-Conda update -y --all

        Write-Host "> Updating remaining environments:`n" -ForegroundColor DarkYellow
        $info = Invoke-Conda info --json | ConvertFrom-Json
        foreach ($base in $info.envs) {
            if ($base -ne $info.root_prefix) {
                $name = [IO.Path]::GetFileNameWithoutExtension($base)
                Write-Host "   * Updating environment ``$name``..." -ForegroundColor Cyan
                Invoke-Conda update -y --name "$name" --all
            }
        }
        Write-Host "Info: All updates are finished ok!!" -ForegroundColor Green
    }
    catch {
        Write-Error "Oops: Conda update command has been failed"
    }
}
catch {
    Write-Error "Oops: 'conda' executable is not in your PATH. Try (re)installing 'miniconda'"
}
