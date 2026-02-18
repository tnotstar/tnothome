@echo off
rem Copyright 2024-2026, Antonio Alvarado <tnotstar@gmail.com>

where py >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    py "%~dp0up2goes.py" %*
) else (
    python "%~dp0up2goes.py" %*
)
