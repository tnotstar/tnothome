@rem -*- coding: utf-8 -*-
@rem
@rem Copyright (c) 2019 Antonio Alvarado Hernández - All rights reserved
@rem
@rem Licensed under the Apache License, Version 2.0 (the "License");
@rem you may not use this file except in compliance with the License.
@rem You may obtain a copy of the License at
@rem
@rem     http://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.
@rem

@setlocal enableExtensions
@setlocal disableDelayedExpansion

@set NAME=%~n0 && @shift

@if [%0] == [] @goto :syntax
@set OWNER=%0 && @shift

@if [%0] == [] @goto :syntax
@set OBJECT=%0 && @shift

@set SUBINACL=subinacl.exe
@for /f %%p in ('where %SUBINACL%') do @set SUBINACL=%%p
@if not exist "%SUBINACL%" @goto :subinacl

:execute
@%SUBINACL% /file %OBJECT% /setowner=%OWNER%
@if %errorlevel% geq 1 @goto :fatal

@%SUBINACL% /subdirectories %OBJECT% /setowner=%OWNER%
@if %errorlevel% geq 1 @goto :fatal
@goto :eof

:syntax
@echo. 1>&2
@echo Fatal: invalid command line arguments 1>&2
@echo. 1>&2
@echo Syntax: %NAME% ^<owner^> ^<file_or_directory_path^>
@goto :eof

:subinacl
@echo. 1>&2
@echo Fatal: required command "subinacl.exe", not found 1>&2
@echo. 1>&2
@echo Please, install missing file and add it to the PATH variable 1>&2
@goto :eof

@endlocal

:eof