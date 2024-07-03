@rem -*- coding: utf-8 -*-
@rem
@rem Copyright 2012-2024, Antonio Alvarado Hernández <tnotstar@gmail.com>
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

@if "%1" == "system" goto :system
@if "%1" == "properties" goto :properties
@if "%1" == "policies" goto :policies
@if "%1" == "services" goto :services
@if "%1" == "programs" goto :programs
@if "%1" == "user" goto :user
@if "%1" == "users" goto :users
@if "%1" == "devices" goto :devices
@if "%1" == "disks" goto :disks
@if "%1" == "eject" goto :eject
@if "%1" == "taskbar" goto :taskbar
@if "%1" == "scheduler" goto :taskschd
@if "%1" == "troubles" goto :troubles
@if "%1" == "certificates" goto :certificates
@goto :help

:help
@echo Show some Windows GUI dialogs from the command line
@echo.
@echo     %~n0 system
@echo     %~n0 properties
@echo     %~n0 policies
@echo     %~n0 services
@echo     %~n0 programs
@echo     %~n0 user
@echo     %~n0 users
@echo     %~n0 devices
@echo     %~n0 disks
@echo     %~n0 eject
@echo     %~n0 taskbar
@echo     %~n0 scheduler
@echo     %~n0 troubles
@echo     %~n0 certificates
@echo.
@goto :eof

:system
@control.exe system
@goto :eof

:properties
@control.exe sysdm.cpl
@goto :eof

:policies:
@start secpol.msc
@goto :eof

:services
@start services.msc
@goto :eof

:programs:
@control.exe appwiz.cpl
@goto :eof

:user
@control.exe /name Microsoft.UserAccounts
@goto :eof

:users
@start lusrmgr.msc
@goto :eof

:devices
@start devmgmt.msc
@goto :eof

:disks
@start diskmgmt.msc
@goto :eof

:eject
@start rundll32.exe shell32.dll,Control_RunDLL hotplug.dll
@goto :eof

:taskbar
@control.exe /name Microsoft.TaskbarandStartMenu
@goto :eof

:taskschd
@start taskschd.msc
@goto :eof

:troubles
@control.exe /name Microsoft.Troubleshooting
@goto :eof

:certificates
@start certmgr.msc
@goto :eof

:eof
