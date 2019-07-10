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

@if "%1" == "start" goto :start
@if "%1" == "stop" goto :stop
@if "%1" == "list" goto :list
@goto :usage

:usage
@echo Oops: invalid command line arguments %* :(
@echo;
@echo Syntax:
@echo     %~n0 start    to start the default VirtualBox machine
@echo     %~n0 stop     to stop the default VirtualBox machine
@echo     %~n0 list     to show a list of running virtual machines, if any
@echo;
@echo Note:
@echo     Default virtual machine must be set up in the VBOX_DEFAULT_VM
@echo     environment variable
@goto :eof

:start
@VBoxManage startvm "%VBOX_DEFAULT_VM%" -type headless
@if not errorlevel 1 @goto :eof
@echo Oops: VirtualBox manager failed to start with exit code %ERRORLEVEL%
@goto :eof

:stop
@VBoxManage controlvm "%VBOX_DEFAULT_VM%" acpipowerbutton
@if not errorlevel 1 @goto :eof
@echo Oops: VirtualBox manager failed to stop with exit code %ERRORLEVEL%
@goto :eof

:list
@VBoxManage list runningvms
@if not errorlevel 1 @goto :eof
@echo Oops: VirtualBox manager failed to stop with exit code %ERRORLEVEL%
@goto :eof

:eof