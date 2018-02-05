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

@if "%1" == "eject" goto :eject

:help
@echo Show some Windows' UI dialogs from the command line
@echo.
@echo     %~nx0 eject
@echo.
@goto :eof

:eject
@start rundll32 shell32.dll,Control_RunDLL hotplug.dll
@goto :eof

:eof