# Copyright (c) 2019 Antonio Alvarado Hernández

try {
    Get-Command Invoke-Conda -ErrorAction Stop | Out-Null

    try {
        Write-Host ">> Updating ``conda`` package..." -ForegroundColor DarkYellow
        Invoke-Conda update -y conda
        Write-Host ">> Updating ``base`` environment..." -ForegroundColor DarkYellow
        Invoke-Conda update -y --all

        $environments = Invoke-Conda info --json | ConvertFrom-Json
        foreach ($base in $environments.envs) {
            if ("$base" -ne "$Env:CONDA_PREFIX") {
                $name = [IO.Path]::GetFileNameWithoutExtension($base)
                Write-Host ">> Updating environment ``$name``..." -ForegroundColor DarkYellow
                Invoke-Conda update -y --name "$name" --all
            }
        }
        Write-Host ">> All updates are finished ok!!" -ForegroundColor Green
    }
    catch {
        Write-Error "Oops: Conda update command has been failed"
    }
}
catch {
    Write-Error "Oops: Conda shell integration not found. Try running `condavars` first"
}
