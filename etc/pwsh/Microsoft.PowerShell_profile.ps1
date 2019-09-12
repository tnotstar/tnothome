#
# Microsoft.PowerShell_profile.ps1
#

#region conda initialize
$Env:_CONDA_ROOT = "C:\Scoop\apps\miniconda3\current"
$Env:_CONDA_EXE = "$Env:_CONDA_ROOT\Scripts\conda.exe"
$Env:_CE_CONDA = ""
$Env:_CE_M = ""

$Env:CONDA_EXE = "$Env:_CONDA_EXE"

Import-Module "$Env:_CONDA_ROOT\Shell\condabin\Conda.psm1"

conda activate base
#endregion

try { $null = gcm pshazz -ea stop; pshazz init 'default' } catch { }

New-Alias -Name nvi -Value nvim-qt
New-Alias -Name pad -Value notepad

Remove-Alias ls
Remove-Alias cp
Remove-Alias mv
Remove-Alias rm
Remove-Alias cat
Remove-Alias clear

# EOF