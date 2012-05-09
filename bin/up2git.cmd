@echo off
rem ----------------------------------------------------------------------------
rem Copyright (c) 2011, 2012 Antonio Alvarado Hernández - All rights reserved
rem ----------------------------------------------------------------------------
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
rem ----------------------------------------------------------------------------
rem $Id$
rem ----------------------------------------------------------------------------


setlocal enableextensions

set NAME=%~n0
shift /0

if [%0] == [] goto syntax
set GIT_DWLDURL=%0
shift /0

set GIT_TMPFILE=%TEMP%\UG%RANDOM%.bin

set GIT_HOMEDIR=
for /f %%f in ('which git') do @(
    for /f %%d in ('cmd /c "pushd %%~dpf.. && cd"') do @set GIT_HOMEDIR=%%d
)
if not exist "%GIT_HOMEDIR%" goto :errhome

set WGET_PROGRAM=wget
set WGET_OPTIONS="-O%GIT_TMPFILE%"

set UZIP_PROGRAM=7z
set UZIP_OPTIONS=x -y "-o%GIT_HOMEDIR%"

:download
echo Info: Downloading archive from %GIT_DWLDURL%... 1>&2
%WGET_PROGRAM% %WGET_OPTIONS% "%GIT_DWLDURL%"
if not errorlevel 0 goto :errdown
echo.

:extract
echo Info: Extracting files from %GIT_TMPFILE%... 1>&2
%UZIP_PROGRAM% %UZIP_OPTIONS% "%GIT_TMPFILE%"
if not errorlevel 0 goto :errxtrac
echo.

echo Info: git updated successfully! 1>&2
goto :eof

:syntax
echo. 1>&2
echo Fatal: invalid number of arguments 1>&2
echo. 1>&2
echo   Syntax: %NAME% ^<download-url^> 1>&2
goto :eof

:errhome
echo. 1>&2
echo Fatal: Unable to guess the git home directory 1>&2
echo. 1>&2
goto :eof

:errdown
echo. 1>&2
echo Fatal: Can't download binary tarball from %GIT_DWLDURL% 1>&2
echo. 1>&2
goto :eof

:errxtrac
echo. 1>&2
echo Fatal: Can't extract files from the %GIT_TMPFILE% archive 1>&2
echo. 1>&2
goto :eof

endlocal

:eof