# Copyright 2020-21, Antonio Alvarado Hernández


#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
#(& "C:\Library\Conda\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
$Env:_CONDA_ROOT = "C:\Library\Conda"
$Env:_CONDA_EXE = "$Env:_CONDA_ROOT\Scripts\conda.exe"
$Env:CONDA_EXE = "$Env:_CONDA_EXE"
#endregion

function scoop {
    if ($args[0] -eq "search") {
        scoop-search.exe @($args | Select-Object -Skip 1)
    } else {
        scoop.ps1 @args
    }
}

function condavars {
    Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1"
    conda activate base
    Add-CondaEnvironmentToPrompt
}

function vcvars {
    Import-Module 'C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\Tools\Microsoft.VisualStudio.DevShell.dll'
    Enter-VsDevShell 09f6951e
}

function Unalias {
    if (Get-Command 'Remove-Alias' -ErrorAction SilentlyContinue) {
        Remove-Alias -Name "$($args[0])" -Force
    } else {
        Remove-Item -Path "Alias:$($args[0])" -Force
    }
}

Unalias 'ls'
Unalias 'cp'
Unalias 'mv'
Unalias 'rm'
Unalias 'cat'
Unalias 'clear'

New-Alias -Name pad -Value tnotpad.exe
New-Alias -Name vi -Value C:\Scoop\apps\vim\current\gvim.exe
New-Alias -Name nvim -Value C:\Scoop\apps\neovim\current\bin\nvim-qt.exe

Invoke-Expression (&starship init powershell)

# $PSDefaultParameterValues['Out-Default:OutVariable'] = '__'


# EOF