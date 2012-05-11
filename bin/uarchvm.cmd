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
setlocal disabledelayedexpansion

set NAME=%~n0 && shift

:parseargs
if [%0] == [] goto syntax
goto :execute

:execute
echo Hello, world!
goto :eof

:syntax
echo. 1>&2
echo Fatal: invalid number of arguments 1>&2
echo. 1>&2
echo   Syntax: %NAME% ^<arg1^> [^<arg2^> ...] 1>&2
goto :eof

endlocal

:eof