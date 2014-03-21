@echo off
rem
rem Copyright (c) 2014 Antonio Alvarado Hernández - All rights reserved
rem
rem   Licensed under the Apache License, Version 2.0 (the "License");
rem   you may not use this file except in compliance with the License.
rem   You may obtain a copy of the License at
rem
rem       http://www.apache.org/licenses/LICENSE-2.0
rem
rem   Unless required by applicable law or agreed to in writing, software
rem   distributed under the License is distributed on an "AS IS" BASIS,
rem   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem   See the License for the specific language governing permissions and
rem   limitations under the License.
rem


setlocal enableextensions
setlocal enabledelayedexpansion

set NAME=%~n0
set BASE=%~dp0

set SETUP_PROGRAM="%~f1"
set SETUP_RESPONSE="%BASE%..\etc\innosetup\R-unattended.inf"
set SETUP_OPTIONS=/VERYSILENT /LOADINF=%SETUP_RESPONSE%

if not exist %SETUP_PROGRAM% goto :syntax
if not exist %SETUP_RESPONSE% goto :syntax

:execute
start /wait "" %SETUP_PROGRAM% %SETUP_OPTIONS%
goto :eof

:syntax
echo. 1>&2
echo Fatal: invalid command line arguments 1>&2
echo. 1>&2
echo   Syntax: %NAME% ^<setup-filename^> 1>&2
echo. 1>&2
goto :eof

endlocal
:eof