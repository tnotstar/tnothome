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

@if "%1" == "" goto :err_args

@set GS_CMD=gswin64c
@set GS_OPTS=-q -dQUIET -dSAFER -dBATCH -dNOPAUSE -dNOPROMPT
@set GS_OPTS=%GS_OPTS% -r96x96 -sDEVICE=jpeg -dJPEGQ=100 -dUseCIEColor
@set GS_OPTS=%GS_OPTS% -dGridFitTT=2 -dAlignToPixels=0 -dMaxBitmap=536870912
@set GS_OPTS=%GS_OPTS% -dTextAlphaBits=4 -dGraphicsAlphaBits=4

@%GS_CMD% %GS_OPTS% "-sOutputFile=%~n1.jpg" -f"%~n1.pdf"
@if %errorlevel% neq 0 goto :err_exec
@goto :eof

:err_args
@echo Oops: invalid command line arguments
@echo.
@echo Usage:
@echo     %~n0 ^<input-filename^>
@goto :eof

:err_exec
@echo Oops: something is wrong %errorlevel% :(
@goto :eof

:eof