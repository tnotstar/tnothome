# Copyright 2020-22, Antonio Alvarado Hernández



function scoop {
    if ($args[0] -eq "search") {
        scoop-search.exe @($args | Select-Object -Skip 1)
    } else {
        scoop.ps1 @args
    }
}

function vcvars {
    Import-Module 'C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\Tools\Microsoft.VisualStudio.DevShell.dll'
    Enter-VsDevShell 09f6951e
}

function condavars {
    if (-not "$Env:_CONDA_ROOT") {
        $conda = Get-Command -Name "conda" -ErrorAction SilentlyContinue
        if ($conda) {
            (& $conda "shell.powershell" "hook") | Out-String | Invoke-Expression
        }
    }
    Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1"
}

function lsdsk {
    $DiskDrives = Get-CimInstance -Class Win32_DiskDrive
    foreach ($Drive in $DiskDrives | Sort-Object -Property Index) {
        "`nDrive: $($Drive.Name), Model: $($Drive.Model), Size: $($Drive.Size)"
        $DriveID = $Drive.DeviceID.Replace('\','\\')
        $Partitions = Get-CimInstance -Query @"
            ASSOCIATORS OF {Win32_DiskDrive.DeviceID=`"$($DriveID)`"}
                WHERE AssocClass = Win32_DiskDriveToDiskPartition
"@
        foreach ($Partition in $Partitions | Sort-Object -Property Index) {
            "  Partition: $($Partition.Name), Primary: $($Partition.PrimaryPartition), Boot: $($Partition.BootPartition), Bootable: $($Partition.Bootable), Size: $($Partition.Size)"
            $Volumes = Get-CimInstance -Query @"
                ASSOCIATORS OF {Win32_DiskPartition.DeviceID=`"$($Partition.DeviceID)`"}
                    WHERE AssocClass = Win32_LogicalDiskToPartition
"@
            foreach ($Volume in $Volumes | Sort-Object -Property Index) {
                "    $($Volume.Name) $($Volume.VolumeName), Type: $($Volume.DriveType), Size: $($Volume.Size), Free: $($Volume.FreeSpace)"
            }
        }
    }
}

function lsvol {
    Get-CimInstance -Class Win32_Volume | Format-List -Property Label,DriveLetter,DeviceID,SystemVolume,Capacity,Freespace
}

function Unalias {
    $cmd = Get-Alias -Name "$($args[0])" -ErrorAction SilentlyContinue

    if ($cmd -and $cmd.CommandType -eq 'Alias') {
        if (Get-Command -Name 'Remove-Alias' -ErrorAction SilentlyContinue) {
            Remove-Alias -Name "$($args[0])" -Force
        } else {
            Remove-Item -Path "Alias:$($args[0])" -Force
        }
    }
}

Unalias 'ls'
Unalias 'cp'
Unalias 'mv'
Unalias 'rm'
Unalias 'cat'
Unalias 'clear'

#New-Alias -Name pad -Value tnotpad.exe
#New-Alias -Name vi -Value C:\Scoop\apps\vim\current\gvim.exe
#New-Alias -Name nvim -Value C:\Scoop\apps\neovim\current\bin\nvim-qt.exe

Invoke-Expression (&starship init powershell)

# $PSDefaultParameterValues['Out-Default:OutVariable'] = '__'

# EOF
