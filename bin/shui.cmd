@rem -*- coding: utf-8 -*-
@rem
@rem Copyright (c) 2012-2018 Antonio Alvarado Hernández - All rights reserved
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

@if "%1" == "users" goto :users
@if "%1" == "disks" goto :disks
@if "%1" == "devices" goto :devices
@if "%1" == "services" goto :services
@if "%1" == "properties" goto :properties
@if "%1" == "certificates" goto :certificates
@if "%1" == "eject" goto :eject
@if "%1" == "control"  goto :control
@goto :help

:help
@echo Show some Windows' UI dialogs from the command line
@echo.
@echo     %~n0 users
@echo     %~n0 disks
@echo     %~n0 devices
@echo     %~n0 services
@echo     %~n0 properties
@echo     %~n0 certificates
@echo     %~n0 eject
@echo     %~n0 control ^<feature^>
@echo       Available features are:
@echo         - users
@echo         - taskbar
@echo         - troubles
@echo.
@goto :eof

:users
@start lusrmgr.msc
@goto :eof

:disks
@start diskmgmt.msc
@goto :eof

:devices
@start devmgmt.msc
@goto :eof

:services
@start services.msc
@goto :eof

:properties
@control.exe sysdm.cpl
@goto :eof

:certificates
@start certmgr.msc
@goto :eof

:eject
@start rundll32.exe shell32.dll,Control_RunDLL hotplug.dll
@goto :eof

:control
@shift
@if "%1" == "users" goto :control_users
@if "%1" == "taskbar" goto :control_taskbar
@if "%1" == "troubles" goto :control_troubles
@goto :help

:control_users
@control.exe /name Microsoft.UserAccounts
@goto :eof

:control_taskbar
@control.exe /name Microsoft.TaskbarandStartMenu
@goto :eof

:control_troubles
@control.exe /name Microsoft.Troubleshooting
@goto :eof

:eof