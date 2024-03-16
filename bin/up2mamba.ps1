#!/usr/bin/env pwsh

# Copyright (c) 2024, Antonio Alvarado Hernández

<#
.NAME
    up2mamba

.SYNOPSYS
    Launch all `mamba` commands to keep current installation and their local
    environments up to date.

.SYNTAX
    up2mamba

.EXAMPLE
    up2mamba
#>

try {
    $uMamba = Get-Command micromamba -ErrorAction Stop

    if (!(Get-Command Invoke-Mamba -ErrorAction SilentlyContinue)) {
        (& $uMamba "shell.powershell" "hook" -s powershell) | Out-String | Invoke-Expression
    }

    Write-Host "Running 'mamba' updating routines...`n" -ForegroundColor Yellow
    try {
        Write-Host "> Updating ``micromamba`` package..." -ForegroundColor DarkYellow
        Invoke-Mamba self-update -y

        Write-Host "> Updating environments:`n" -ForegroundColor DarkYellow
	$info = Invoke-Mamba info --json | ConvertFrom-Json
        Write-Host $info."base environment"
        $_ = Invoke-Mamba env list --json | ConvertFrom-Json
        foreach ($base in $_.envs) {
            if ($base -ne $info."base environment") {
                $name = [IO.Path]::GetFileNameWithoutExtension($base)
                Write-Host "   * Updating environment ``$name``..." -ForegroundColor Cyan
                #Invoke-Mamba update -y --name "$name" --all
            }
        }
        Write-Host "Info: All updates are finished ok!!" -ForegroundColor Green
    }
    catch {
        Write-Error "Oops: Mamba update command has been failed"
    }
}
catch {
    Write-Error "Oops: 'micromamba' executable is not in your PATH. Try (re)installing 'minimamba'"
}
