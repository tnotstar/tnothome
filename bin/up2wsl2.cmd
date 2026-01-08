@rem Copyright 2025, Antonio Alvarado <tnotstar@gmail.com>

@setlocal enableextensions
@setlocal disabledelayedexpansion

@net session > NUL 2>&1
@if %errorlevel% neq 0 (
	@echo Error: Please, execute this script as Administrator.
	@pause
	@exit /b
)

@echo Info: Checking WSL2 features...

@echo Info: Enabling Windows Subsystem for Linux...
@dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

@echo:
@echo Info: Enabling Vitual Machine Platform...
@dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

@echo:
@echo Info: Enabling Microsoft Hyper-V...
@dism.exe /online /enable-feature /featurename:Microsoft-Hyper-V /all /norestart

@echo:
@echo Info: Updating WSL kernel...
@wsl --update

@echo:
@echo Info: Installation successful. Please reboot the system.

@goto :eof
@endlocal

:eof
