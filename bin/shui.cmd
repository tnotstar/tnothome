@rem -*- coding: utf-8 -*-
@rem
@rem Copyright (c) 2012-2026, Antonio Alvarado <tnotstar+copyright@gmail.com>
@rem All rights reserved.
@rem
@rem Redistribution and use in source and binary forms, with or without
@rem modification, are permitted provided that the following conditions are met:
@rem
@rem 1. Redistributions of source code must retain the above copyright notice, this
@rem    list of conditions and the following disclaimer.
@rem
@rem 2. Redistributions in binary form must reproduce the above copyright notice,
@rem    this list of conditions and the following disclaimer in the documentation
@rem    and/or other materials provided with the distribution.
@rem
@rem 3. Neither the name of the copyright holder nor the names of its
@rem    contributors may be used to endorse or promote products derived from
@rem    this software without specific prior written permission.
@rem
@rem THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
@rem AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
@rem IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
@rem DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
@rem FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
@rem DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
@rem SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
@rem CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
@rem OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
@rem OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

@if "%1" == "system" goto :system
@if "%1" == "properties" goto :properties
@if "%1" == "policies" goto :policies
@if "%1" == "services" goto :services
@if "%1" == "networks" goto :networks
@if "%1" == "programs" goto :programs
@if "%1" == "keys" goto :keys
@if "%1" == "user" goto :user
@if "%1" == "users" goto :users
@if "%1" == "devices" goto :devices
@if "%1" == "disks" goto :disks
@if "%1" == "eject" goto :eject
@if "%1" == "sound" goto :sound
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
@echo     %~n0 networks
@echo     %~n0 programs
@echo     %~n0 keys
@echo     %~n0 user
@echo     %~n0 users
@echo     %~n0 devices
@echo     %~n0 disks
@echo     %~n0 eject
@echo     %~n0 sound
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

:networks:
@control.exe ncpa.cpl
@goto :eof

:programs:
@control.exe appwiz.cpl
@goto :eof

:keys
@start rundll32.exe keymgr.dll, KRShowKeyMgr
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

:sound:
@control.exe mmsys.cpl
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
