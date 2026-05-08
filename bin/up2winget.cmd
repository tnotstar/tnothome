@rem Copyright 2025 - 2026, Antonio Alvarado <tnotstar+copyright@gmail.com>

@setlocal enableextensions
@setlocal disabledelayedexpansion

@net session > NUL 2>&1
@if %errorlevel% neq 0 (
	@echo Error: Please, execute this script as Administrator.
	@pause
	@exit /b
)

@echo Info: Checking upgradable packages...

@echo Info: Upgrading `winget`-installed packages at `machine` scope...
@winget upgrade --all --silent --accept-package-agreements --accept-source-agreements --disable-interactivity --scope machine

@echo:
@echo Info: Upgrading `winget`-installed packages at `user` scope...
@winget upgrade --all --silent --accept-package-agreements --accept-source-agreements --disable-interactivity --scope user

@echo:
@echo Info: Packages upgrade successful.

@goto :eof
@endlocal

:eof
pause