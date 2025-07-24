@rem
@rem Copyright (c) 2011-2025 Antonio Alvarado Hernández <tnotstar@gmail.com>
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


@setlocal enableextensions disabledelayedexpansion

@set NAME=%~n0
@shift

@set SSH_PROGRAM=plink
@set SSH_OPTIONS=-A -t -X -agent -ssh

:while_more_options
@set _opt_=%~0
@if "%_opt_:~0,1%" == "-" (
	@set SSH_OPTIONS=%SSH_OPTIONS% %_opt_%
	@shift
	@goto :while_more_options
)

@if "%0" == "" @goto :syntax
@set SSH_TARGET=%0
@shift

@if "%0" == "" @goto :syntax
@set SSH_COMMAND=%0
@shift

@if exist "%SSH_COMMAND%" @set SSH_ISFILE=-m

:execute
@chcp 65001 > nul
@echo Info: Executing %SSH_COMMAND% on host %SSH_HOST%... 1>&2
%SSH_PROGRAM% %SSH_OPTIONS% %SSH_TARGET% %SSH_ISFILE% %SSH_COMMAND% %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
@echo.
@echo Info: Program exited with code %ERRORLEVEL% 1>&2
@goto :eof

:syntax
@echo. 1>&2
@echo Fatal: invalid number of arguments 1>&2
@echo. 1>&2
@echo Syntax: %NAME% ^<user@host^> ^<command^> [^<arg1^>...] 1>&2
@goto :eof

@endlocal

:eof