@echo off
rem Copyright 2026, Antonio Alvarado <tnotstar@gmail.com>

if "%1" == ":exports" goto :exports

sudo "%~f0" :exports
exit

:exports
@netsh int ipv4 show excludedportrange protocol=tcp
@net stop winnat
@net start winnat
@netsh int ipv4 show excludedportrange protocol=tcp
@netsh int ipv4 add  excludedportrange protocol=tcp startport=9050 numberofports=1
pause
exit